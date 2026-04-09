local M = {}

local uv = vim.uv or vim.loop

local function resolve(path)
  return vim.fn.resolve(vim.fn.expand(path))
end

local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

local function sibling_markdown(ipynb_path)
  return vim.fn.fnamemodify(ipynb_path, ":r") .. ".md"
end

local function sibling_ipynb(markdown_path)
  return vim.fn.fnamemodify(markdown_path, ":r") .. ".ipynb"
end

local function stat(path)
  return uv.fs_stat(path)
end

local function is_newer(lhs, rhs)
  local lhs_stat = stat(lhs)
  local rhs_stat = stat(rhs)
  if not lhs_stat then
    return false
  end
  if not rhs_stat then
    return true
  end

  if lhs_stat.mtime.sec ~= rhs_stat.mtime.sec then
    return lhs_stat.mtime.sec > rhs_stat.mtime.sec
  end

  return (lhs_stat.mtime.nsec or 0) > (rhs_stat.mtime.nsec or 0)
end

local function ensure_jupytext()
  if vim.fn.executable("jupytext") == 1 then
    return true
  end

  vim.notify("jupytext is not available on PATH.", vim.log.levels.ERROR)
  return false
end

local function run_jupytext(args)
  if not ensure_jupytext() then
    return false
  end

  local cmd = { "jupytext" }
  vim.list_extend(cmd, args)

  local result = vim.system(cmd, { text = true }):wait()
  if result.code == 0 then
    return true
  end

  local stderr = (result.stderr or ""):gsub("%s+$", "")
  local stdout = (result.stdout or ""):gsub("%s+$", "")
  local detail = stderr ~= "" and stderr or stdout
  if detail == "" then
    detail = "Unknown jupytext error."
  end

  vim.notify("jupytext failed: " .. detail, vim.log.levels.ERROR)
  return false
end

local function is_markdown_notebook(path)
  return path:match("%.md$") ~= nil or path:match("%.qmd$") ~= nil
end

local function notebook_paths(bufnr)
  local name = resolve(vim.api.nvim_buf_get_name(bufnr))
  if name == "" then
    return nil
  end

  if name:match("%.ipynb$") then
    return {
      markdown = sibling_markdown(name),
      ipynb = name,
    }
  end

  if is_markdown_notebook(name) then
    return {
      markdown = name,
      ipynb = vim.b[bufnr].notebook_ipynb_path or sibling_ipynb(name),
    }
  end

  return nil
end

local function remember_paths(paths)
  local bufnr = vim.api.nvim_get_current_buf()
  vim.b[bufnr].notebook_markdown_path = paths.markdown
  vim.b[bufnr].notebook_ipynb_path = paths.ipynb
end

local function open_markdown_notebook(ipynb_path, force_reimport)
  local ipynb = resolve(ipynb_path)
  local markdown = sibling_markdown(ipynb)

  if file_exists(ipynb) then
    local should_refresh = force_reimport or not file_exists(markdown) or is_newer(ipynb, markdown)
    if should_refresh then
      local ok = run_jupytext({
        "--to",
        "md:markdown",
        "--output",
        markdown,
        ipynb,
      })
      if not ok then
        return
      end
    end
  end

  vim.cmd("keepalt edit " .. vim.fn.fnameescape(markdown))
  remember_paths({
    markdown = resolve(vim.api.nvim_buf_get_name(0)),
    ipynb = ipynb,
  })
end

local function export_current_notebook(clean_export)
  local paths = notebook_paths(0)
  if not paths or not is_markdown_notebook(paths.markdown) then
    vim.notify("Notebook export expects a markdown notebook buffer.", vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    vim.cmd("write")
  end

  local args = {}
  if file_exists(paths.ipynb) and not clean_export then
    table.insert(args, "--update")
  end

  vim.list_extend(args, {
    "--to",
    "ipynb",
    "--set-kernel",
    "python3",
    "--output",
    paths.ipynb,
    paths.markdown,
  })

  if not run_jupytext(args) then
    return
  end

  remember_paths(paths)

  if vim.fn.exists("*MoltenRunningKernels") == 1 and #vim.fn.MoltenRunningKernels(true) > 0 then
    local ok, err = pcall(function()
      vim.api.nvim_cmd({
        cmd = "MoltenExportOutput",
        bang = true,
        args = { paths.ipynb },
      }, {})
    end)

    if not ok then
      vim.notify(
        "Notebook exported, but Molten outputs were not written: " .. err,
        vim.log.levels.WARN
      )
      return
    end
  end

  vim.notify("Exported notebook: " .. paths.ipynb, vim.log.levels.INFO)
end

local function import_outputs_for_current_notebook()
  local paths = notebook_paths(0)
  if not paths or not file_exists(paths.ipynb) then
    vim.notify("No sibling .ipynb file was found for this notebook.", vim.log.levels.WARN)
    return
  end

  if vim.fn.exists("*MoltenRunningKernels") == 0 or #vim.fn.MoltenRunningKernels(true) == 0 then
    vim.notify("Start a Molten kernel before importing notebook outputs.", vim.log.levels.WARN)
    return
  end

  local ok, err = pcall(function()
    vim.api.nvim_cmd({
      cmd = "MoltenImportOutput",
      args = { paths.ipynb },
    }, {})
  end)

  if not ok then
    vim.notify("MoltenImportOutput failed: " .. err, vim.log.levels.ERROR)
  end
end

function M.setup()
  if (vim.g.notebook_workflow or "markdown") ~= "markdown" then
    return
  end

  local group = vim.api.nvim_create_augroup("MarkdownNotebookWorkflow", { clear = true })

  vim.api.nvim_create_autocmd("BufReadCmd", {
    group = group,
    pattern = "*.ipynb",
    callback = function(ev)
      open_markdown_notebook(ev.match, false)
    end,
  })

  vim.api.nvim_create_autocmd("BufNewFile", {
    group = group,
    pattern = "*.ipynb",
    callback = function(ev)
      local ipynb = resolve(ev.match)
      local markdown = sibling_markdown(ipynb)
      vim.cmd("keepalt edit " .. vim.fn.fnameescape(markdown))
      remember_paths({
        markdown = resolve(vim.api.nvim_buf_get_name(0)),
        ipynb = ipynb,
      })
    end,
  })

  vim.api.nvim_create_user_command("NotebookOpen", function(opts)
    local target = opts.args ~= "" and opts.args or vim.api.nvim_buf_get_name(0)
    if target == "" then
      vim.notify("NotebookOpen needs an .ipynb path.", vim.log.levels.WARN)
      return
    end

    if target:match("%.md$") or target:match("%.qmd$") then
      target = sibling_ipynb(target)
    end

    if not target:match("%.ipynb$") then
      vim.notify("NotebookOpen expects an .ipynb path.", vim.log.levels.WARN)
      return
    end

    open_markdown_notebook(target, opts.bang)
  end, {
    bang = true,
    nargs = "?",
    complete = "file",
  })

  vim.api.nvim_create_user_command("NotebookExport", function(opts)
    export_current_notebook(opts.bang)
  end, {
    bang = true,
    nargs = 0,
  })

  vim.api.nvim_create_user_command("NotebookImportOutput", function()
    import_outputs_for_current_notebook()
  end, {
    nargs = 0,
  })

  vim.keymap.set("n", "<localleader>w", "<cmd>NotebookExport<cr>", {
    silent = true,
    desc = "Export markdown notebook to ipynb",
  })

  vim.keymap.set("n", "<localleader>W", "<cmd>NotebookExport!<cr>", {
    silent = true,
    desc = "Rebuild ipynb from markdown notebook",
  })
end

return M
