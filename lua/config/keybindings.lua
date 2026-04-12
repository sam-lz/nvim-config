local km = vim.keymap.set


-- command key <D-key>
-- option key <M-key>

vim.keymap.set({"n", "v"} , "<leader><leader>", ":", { noremap = true })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- disable default '/' for search
-- vim.keymap.set({ "n", "x", "o" }, "/", "<Nop>", { noremap = true })

-- rebind search
vim.keymap.set({ "n", "x", "o" }, ";", "/", { noremap = true, silent = true })

vim.keymap.set("n", ".", "za", {silent = true, desc = "Toggle fold"})

km("n", "sa", "ysiw", {remap = true, desc = "Surround word (prompt)"})

vim.keymap.set('n', 'cd', function()
    vim.cmd.tcd(vim.fn.expand('%:p:h'))
    vim.cmd.pwd()
end,
{ desc = 'cd to current file dir'})



vim.keymap.set('n', "<localleader>t", ":TypstPreview<CR>")
vim.keymap.set('n', "<localleader>o", ":Outline<CR>")


-- vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>",
--     { silent = true, desc = "Initialize the plugin" })
-- vim.keymap.set("n", "<localleader><localleader>", ":QuartoSend<CR>", {silent=true})
-- vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>",
--     { silent = true, desc = "run operator selection" })
-- vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>",
--     { silent = true, desc = "re-evaluate cell" })
-- vim.keymap.set("n", "<localleader>rd", ":MoltenDelete<CR>",
--     { silent = true, desc = "molten delete cell" })
-- vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>",
--     { silent = true, desc = "hide output" })
-- vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>",
--     { silent = true, desc = "show/enter output" })

local function notebook_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end

  return vim.fn.fnamemodify(name, ":p:h")
end

local function python_kernel_id(bufnr)
  local kernels = vim.fn.MoltenRunningKernels(true)
  local stored = vim.b[bufnr].molten_python_kernel_id

  if stored and vim.tbl_contains(kernels, stored) then
    return stored
  end

  for _, kernel_id in ipairs(kernels) do
    if kernel_id == "python3" or kernel_id:match("^python") then
      vim.b[bufnr].molten_python_kernel_id = kernel_id
      return kernel_id
    end
  end

  return nil
end

local function sync_python_kernel_to_notebook(bufnr)
  local dir = notebook_dir(bufnr)
  if not dir then
    return true
  end

  local kernel_id = python_kernel_id(bufnr)
  if not kernel_id then
    return true
  end

  if vim.b[bufnr].molten_synced_dir == dir and vim.b[bufnr].molten_synced_kernel_id == kernel_id then
    return true
  end

  local code = string.format(
    "import os,sys; _p=%s; os.chdir(_p); sys.path=[x for x in sys.path if x != _p]; sys.path.insert(0,_p)",
    vim.json.encode(dir)
  )

  vim.api.nvim_buf_call(bufnr, function()
    vim.api.nvim_cmd({
      cmd = "MoltenEvaluateArgument",
      args = { kernel_id, code },
    }, {})
  end)

  vim.b[bufnr].molten_synced_dir = dir
  vim.b[bufnr].molten_synced_kernel_id = kernel_id
  return true
end

local function run_with_notebook_kernel(action)
  local bufnr = vim.api.nvim_get_current_buf()

  local function execute()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    vim.api.nvim_buf_call(bufnr, function()
      sync_python_kernel_to_notebook(bufnr)
      action()
    end)
  end

  if #vim.fn.MoltenRunningKernels(true) == 0 then
    vim.api.nvim_create_autocmd("User", {
      pattern = "MoltenKernelReady",
      once = true,
      callback = function(ev)
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end
          if ev.data and ev.data.kernel_id and ev.data.kernel_id:match("^python") then
            vim.b[bufnr].molten_python_kernel_id = ev.data.kernel_id
          end
          execute()
        end)
      end,
    })

    vim.cmd("MoltenInit python3")
    return
  end

  execute()
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MoltenKernelReady",
  callback = function(ev)
    local bufnr = vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    if ev.data and ev.data.kernel_id and ev.data.kernel_id:match("^python") then
      vim.b[bufnr].molten_python_kernel_id = ev.data.kernel_id
    end

    sync_python_kernel_to_notebook(bufnr)
  end,
})

vim.keymap.set("n", "<localleader><localleader>", function()
  run_with_notebook_kernel(function()
    vim.cmd("QuartoSend")
  end)
end, { silent = true, desc = "Init python3 if needed, then QuartoSend" })

vim.keymap.set("n", "<localleader>l", function()
  run_with_notebook_kernel(function()
    vim.cmd("MoltenEvaluateLine")
  end)
end, { silent = true, desc = "Evaluate line" })

vim.keymap.set("v", "<localleader>r", function()
  run_with_notebook_kernel(function()
    vim.cmd("MoltenEvaluateVisual")
    vim.schedule(function()
      pcall(vim.cmd, "normal! gv")
    end)
  end)
end, { silent = true, desc = "Evaluate visual selection" })

local function insert_python_cell()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local cell = { "```python", "", "```" }
  vim.api.nvim_buf_set_lines(0, row, row, false, cell)
end

local function current_fenced_cell_range()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local start_row = nil

  for i, line in ipairs(lines) do
    if line:match("^```") then
      if start_row == nil then
        start_row = i
      else
        if row >= start_row and row <= i then
          return start_row, i
        end
        start_row = nil
      end
    end
  end
end

local function clear_current_cell_output()
  local ok = pcall(vim.cmd, "MoltenDelete")
  if not ok then
    vim.notify("MoltenDelete is unavailable for this buffer.", vim.log.levels.WARN)
  end
end

local function delete_current_fenced_cell()
  local start_row, end_row = current_fenced_cell_range()
  if not start_row then
    vim.notify("Cursor is not inside a fenced code cell.", vim.log.levels.WARN)
    return
  end

  pcall(vim.cmd, "MoltenDelete")
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, {})
  local target_row = math.min(start_row, vim.api.nvim_buf_line_count(0))
  vim.api.nvim_win_set_cursor(0, { math.max(target_row, 1), 0 })
end

local function export_markdown_to_notebook()
  local markdown = vim.api.nvim_buf_get_name(0)
  if markdown == "" then
    vim.notify("No file is associated with this buffer.", vim.log.levels.WARN)
    return
  end

  if not markdown:match("%.md$") and not markdown:match("%.qmd$") then
    vim.notify("This export binding only works from markdown or quarto files.", vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("jupytext") ~= 1 then
    vim.notify("jupytext is not available on PATH.", vim.log.levels.ERROR)
    return
  end

  if vim.bo.modified then
    vim.cmd("write")
  end

  markdown = vim.fn.resolve(vim.fn.expand(markdown))
  local ipynb = vim.fn.fnamemodify(markdown, ":r") .. ".ipynb"
  local cmd = { "jupytext" }

  if vim.fn.filereadable(ipynb) == 1 then
    table.insert(cmd, "--update")
  end

  vim.list_extend(cmd, {
    "--to",
    "ipynb",
    "--set-kernel",
    "python3",
    "--output",
    ipynb,
    markdown,
  })

  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    local stderr = (result.stderr or ""):gsub("%s+$", "")
    local stdout = (result.stdout or ""):gsub("%s+$", "")
    local detail = stderr ~= "" and stderr or stdout
    if detail == "" then
      detail = "Unknown jupytext error."
    end
    vim.notify("Notebook export failed: " .. detail, vim.log.levels.ERROR)
    return
  end

  if vim.fn.exists("*MoltenRunningKernels") == 1 and #vim.fn.MoltenRunningKernels(true) > 0 then
    local ok, err = pcall(function()
      vim.api.nvim_cmd({
        cmd = "MoltenExportOutput",
        bang = true,
        args = { ipynb },
      }, {})
    end)

    if not ok then
      vim.notify("Notebook exported, but Molten outputs were not written: " .. err, vim.log.levels.WARN)
      return
    end
  end

  vim.notify("Exported notebook: " .. ipynb, vim.log.levels.INFO)
end

local function export_notebook_to_markdown()
  local ipynb = vim.api.nvim_buf_get_name(0)
  if ipynb == "" then
    vim.notify("No file is associated with this buffer.", vim.log.levels.WARN)
    return
  end

  if not ipynb:match("%.ipynb$") then
    vim.notify("This import binding only works from jupyter notebook files.", vim.log.levels.WARN)
    return
  end

  if vim.fn.executable("jupytext") ~= 1 then
    vim.notify("jupytext is not available on PATH.", vim.log.levels.ERROR)
    return
  end

  if vim.bo.modified then
    vim.cmd("write")
  end

  ipynb = vim.fn.resolve(vim.fn.expand(ipynb))
  local markdown = vim.fn.fnamemodify(ipynb, ":r") .. ".md"
  local cmd = {
    "jupytext",
    "--to",
    "md:markdown",
    "--output",
    markdown,
    ipynb,
  }

  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    local stderr = (result.stderr or ""):gsub("%s+$", "")
    local stdout = (result.stdout or ""):gsub("%s+$", "")
    local detail = stderr ~= "" and stderr or stdout
    if detail == "" then
      detail = "Unknown jupytext error."
    end
    vim.notify("Markdown export failed: " .. detail, vim.log.levels.ERROR)
    return
  end

  vim.notify("Exported markdown: " .. markdown, vim.log.levels.INFO)
end

vim.keymap.set("n", "<localleader>=", insert_python_cell,
  { silent = true, desc = "Insert ```python cell" })
vim.keymap.set("n", "<localleader>-", clear_current_cell_output,
  { silent = true, desc = "Clear current cell output" })
vim.keymap.set("n", "<localleader>d", delete_current_fenced_cell,
  { silent = true, desc = "Delete current fenced cell" })
vim.keymap.set("n", "<localleader>w", export_markdown_to_notebook,
  { silent = true, desc = "Export markdown file to ipynb" })
vim.keymap.set("n", "<localleader>i", export_notebook_to_markdown,
  { silent = true, desc = "Export notebook to markdown file" })

-- km("n", "``", "za")

-- yazi bindings
-- km("n", "f", "<cmd>Yazi<cr>")
km("n", "f", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("Yazi cwd")
    return
  end
  vim.cmd("Yazi")
end)

-- km("n", "<leader>dy", "<cmd>Yazi cwd<cr>")
-- neotree bindings
km("n", "<C-f>", function()
  if vim.bo.buftype ~= "" then
    return
  end
  require("neo-tree.command").execute({
    action = "show",
    toggle = true,
    source = "filesystem",
    position = "left",
    reveal = false,
    -- reveal_force_cwd = true,
    -- dir = vim.fn.expand("%:p:h"),
    dir = vim.fn.getcwd(),
  })
end, { desc = "Neo-tree: root at file dir" })


-- km("n", "F", function()
--   if vim.bo.buftype ~= "" then
--     return
--   end
--   require("neo-tree.command").execute({
--     -- action = "show",
--     toggle = false,
--     source = "filesystem",
--     position = "current",
--     reveal = false,
--     dir = vim.fn.getcwd(),
--   })
-- end, { desc = "Neo-tree: root at file dir" })

-- file navigation

-- telescope bindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>o', function() builtin.oldfiles{initial_mode = 'normal'}end, { desc = 'Telescope oldfiles' })
vim.keymap.set('n', '<leader>s', function() builtin.buffers{initial_mode = 'normal'}end, {silent = true, desc = 'Telescope buffers'})
vim.keymap.set('n', '<leader>f', function() builtin.find_files{initial_mode = 'normal'}end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>?', builtin.help_tags, { desc = 'Telescope help tags' })

-- fzf bindings
-- vim.keymap.set('n', '<leader>o', ':History<CR>')
-- vim.keymap.set('n', '<leader>s', ':Buffers<CR>')
-- vim.keymap.set('n', '<leader>f', ':Files<CR>')
-- vim.keymap.set('n', '<leader>g', ':Rg<CR>')
-- vim.keymap.set('n', '<leader>?', ':Helptags<CR>')

vim.keymap.set({"x", "v"}, "<leader>s", [[<esc>:'<,'>s/]], {desc = "Enter substitute mode in selection"})

vim.keymap.set("n", "<C-,>", "25zl")
vim.keymap.set("n", "<C-m>", "25zh")
km({"n", "v"}, "H", "0")
km({"n", "v"}, "L", "$")


vim.keymap.set("x", "ss", function()
  require("nvim-treesitter.incremental_selection").scope_incremental()
end, { silent = true, desc = "TS scope incremental" })

-- window controls
km("n", "+", [[<cmd>vertical resize +16<cr>]])
km("n", "_", [[<cmd>vertical resize -16<cr>]])
km("n", "=", [[<cmd>horizontal resize +6<cr>]])
km("n", "-", [[<cmd>horizontal resize -6<cr>]])

vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Window right" })

vim.keymap.set("n", "<leader>H", "<C-w>H", { silent = true, desc = "Move window far left" })
vim.keymap.set("n", "<leader>J", "<C-w>J", { silent = true, desc = "Move window far down" })
vim.keymap.set("n", "<leader>K", "<C-w>K", { silent = true, desc = "Move window far up" })
vim.keymap.set("n", "<leader>L", "<C-w>L", { silent = true, desc = "Move window far right" })

vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>=", "<C-w>v", { desc = "Split window vertically" })

vim.keymap.set("n", "<leader>d", ":bdelete<CR>", { silent = true })

-- tabs
-- vim.keymap.set("n", "tn", ":tabnew<CR>", { silent = true })
-- vim.keymap.set("n", "td", ":tabclose<CR>", { silent = true })
-- vim.keymap.set("n", "tl", ":tabnext<CR>", { silent = true })
-- vim.keymap.set("n", "th", ":tabprevious<CR>", { silent = true })
vim.keymap.set("n", "tH", ":-tabmove<CR>", { silent = true })
vim.keymap.set("n", "tL", ":+tabmove<CR>", { silent = true })

-- vim.keymap.set("n", "<C-Tab>", ":tabnext<CR>", { silent = true, desc = "Next tab" })
-- vim.keymap.set("n", "<C-S-Tab>", ":tabprevious<CR>", { silent = true, desc = "Previous tab" })

vim.keymap.set("n", "<C-q>", ":tabclose<CR>", { silent = true })
vim.keymap.set("n", "<C-n>", ":tabnew<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", ":tabprevious<CR>", { silent = true })

vim.keymap.set("n", "<S-C-l>", ":-tabmove<CR>", { silent = true })
vim.keymap.set("n", "<S-C-h>", ":+tabmove<CR>", { silent = true })


vim.keymap.set('n', 'tt', function()
  local prev = vim.fn.tabpagenr()
  vim.cmd('tabnew')               -- open an empty tab after the current one
  vim.cmd('tabclose ' .. prev)    -- close the tab you were on before
end, { desc = 'New tab, close previous', silent = true })


vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], {desc='term->normal'})
vim.keymap.set('t', '<Tab>', [[<C-\><C-n>]], {desc='term->normal'})

-- vim.keymap.set("n", "<leader>v", function()
--   vim.cmd("split")
--   -- local dir = vim.fn.expand("%:p:h")
--   -- if dir == "" then dir = vim.loop.cwd() end
--   -- vim.cmd("lcd " .. vim.fn.fnameescape(dir))
--   vim.cmd("resize -18")
--   vim.cmd("terminal")
--   vim.cmd("startinsert")
-- end, { silent = true, noremap = true })
-- km("n", "<leader>e", ":terminal<CR>")

-- workspace.nvim bindings
-- switch workspaces
-- km("n", "<leader>dw", function() require("telescope").extensions.workspaces.workspaces() end, {desc = "Workspace: switch"})
vim.keymap.set("n", "<leader>cc", function()
  require("telescope").extensions.workspaces.workspaces()
  vim.schedule(function() vim.cmd("stopinsert") end)  -- leave insert as soon as picker opens
end, { desc = "Workspace: switch" })


-- lock/unlock current buffer (nomodifiable, readonly)
local function lock_buf()
  vim.bo.modifiable = false
  vim.bo.readonly   = true
  vim.notify("Buffer locked (nomodifiable, readonly)")
end

local function unlock_buf()
  vim.bo.readonly   = false
  vim.bo.modifiable = true
  vim.notify("Buffer unlocked")
end

local function toggle_lock()
  if vim.bo.modifiable then lock_buf() else unlock_buf() end
end

vim.keymap.set("n", "<leader>bl", toggle_lock, { desc = "Toggle buffer lock" })


-- vim.keymap.set("n", "<D-s>", ":source<CR>", { desc = "Source file" })
-- vim.keymap.set("n", "<M-s>", ":write<CR>", { desc = "Save file" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzv")
vim.keymap.set("n", "N", "Nzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

-- vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("n", "<leader>y", "\"+Y")

-- Undoable "revert to last written state" (keeps cursor/view)
local function revert_undoable()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    vim.notify("No file associated with this buffer.", vim.log.levels.WARN)
    return
  end
  local stat = vim.uv and vim.uv.fs_stat or vim.loop.fs_stat
  if not stat(name) then
    vim.notify("File not found on disk: " .. name, vim.log.levels.ERROR)
    return
  end

  local ok, lines = pcall(vim.fn.readfile, name)
  if not ok then
    vim.notify("Failed to read file from disk: " .. name, vim.log.levels.ERROR)
    return
  end

  local view = vim.fn.winsaveview()
  -- Replace buffer text in one change (undoable)
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
  -- The buffer is now identical to disk; clear the modified flag.
  vim.bo.modified = false
  vim.fn.winrestview(view)
end

vim.keymap.set("n", "<leader>ro", revert_undoable, { desc = "Revert buffer (undoable)" })

-- disabling some annoying keybindings
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "K", "<nop>")
vim.keymap.set("n", "q/", "<nop>")
vim.keymap.set("n", "q?", "<nop>")
vim.keymap.set("n", "s", "<nop>")
vim.keymap.set("n", "gQ", "<nop>")
vim.keymap.set("n", "qq", "<nop>")

km("n","'", "<nop>")
km("n","''", "<nop>")
km("n","')", "<nop>")
km("n","'(", "<nop>")
km("n","'{", "<nop>")
km("n","'}", "<nop>")
km("n","'[", "<nop>")
km("n","']", "<nop>")
km("n","'<", "<nop>")
km("n","'>", "<nop>")
km("n","'.", "<nop>")
km("n","'`", "<nop>")
km("n","'^", "<nop>")

km("n","`", "<nop>")
km("n","`'", "<nop>")
km("n","`)", "<nop>")
km("n","`(", "<nop>")
km("n","`{", "<nop>")
km("n","`}", "<nop>")
km("n","`[", "<nop>")
km("n","`]", "<nop>")
km("n","`<", "<nop>")
km("n","`>", "<nop>")
km("n","`.", "<nop>")
km("n","``", "<nop>")
km("n","`^", "<nop>")

-- km({"n", "v", "x"},".", "<nop>")

pcall(vim.keymap.del, "n", "`")
pcall(vim.keymap.del, "n", "'")
pcall(vim.keymap.del, "n", [[``]])
pcall(vim.keymap.del, "n", [['']])


-- km("n", "`", ":ToggleTerm<CR>")
--
km("n", [[``]], "<Nop>", { silent = true, nowait = true })
km("n", [['']], "<Nop>", { silent = true, nowait = true })

vim.keymap.set('n', '<tab>', '<C-^>')
-- km("n", "`", "<cmd>ToggleTerm<CR>", { silent = true, nowait = true })
-- km("n", "'", "<cmd>ToggleTerm<CR>", { silent = true, nowait = true })

-- km("n", "w", "<cmd>ToggleTerm<CR>", { silent = true, nowait = true })
km("n", "<C-e>", "<cmd>TermSelect<CR>", { silent = true, nowait = true })

-- km({"n", "v"}, "'", "w")

-- local tt = require("toggleterm.terminal")

-- local function toggle_last_or_count()
--   if vim.v.count > 0 then
--     vim.cmd(vim.v.count .. "ToggleTerm")
--     return
--   end

--   local term = tt.get_last_focused()
--   if term then
--     term:toggle()
--     return
--   end

--   local all = tt.get_all()
--   if #all > 0 then
    -- all[1]:toggle()
  -- else
  --   vim.cmd("TermNew")
  -- end
-- end

-- require("toggleterm").setup({
--   open_mapping = nil,
--   insert_mappings = false,
--   terminal_mappings = false,
-- })

-- vim.keymap.set("n", "w", toggle_last_or_count, { silent = true, desc = "Toggle last terminal" })
-- vim.keymap.set("n", "<leader>tn", "<cmd>TermNew<CR>",    { silent = true, desc = "New terminal" })
-- vim.keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", { silent = true, desc = "Select terminal" })






for _,m in ipairs({'n','v','x','o','i','c','t','s'}) do for _,km in ipairs(vim.api.nvim_get_keymap(m)) do if (km.lhs or ''):sub(1,1) == 'q' then pcall(vim.keymap.del, m, km.lhs) end end end
for _,m in ipairs({'n','v','x','o','i','c','t','s'}) do for _,km in ipairs(vim.api.nvim_get_keymap(m)) do if (km.lhs or ''):sub(1,1) == '`' then pcall(vim.keymap.del, m, km.lhs) end end end

vim.keymap.set("n", "<leader>q", "<C-w>o", { silent = true, desc = "Close other windows" })
vim.keymap.set("n", "q", ":q<CR>", { silent = true, desc = "Close window" })

local map = vim.keymap.set

map({'n', 'v'}, 'm', function() vim.cmd('normal! ' .. (vim.v.count > 0 and vim.v.count or 15) .. 'j') end, {silent=true})
map({'n', 'v'}, ',', function() vim.cmd('normal! ' .. (vim.v.count > 0 and vim.v.count or 15) .. 'k') end, {silent=true})

-- map({'n', 'v'}, 'M', function() vim.cmd('normal! ' .. (vim.v.count > 0 and vim.v.count or 15) .. 'j') end, {silent=true})
-- map({'n', 'v'}, '<', function() vim.cmd('normal! ' .. (vim.v.count > 0 and vim.v.count or 15) .. 'k') end, {silent=true})
-- map({ 'n', 'x' }, 'J', "v:count ? v:count . 'j' : '5j'", { expr = true, silent = true })
-- map({ 'n', 'x' }, 'K', "v:count ? v:count . 'k' : '5k'", { expr = true, silent = true })

-- vim.keymap.set('n', 'J', '<C-d>', { noremap = true, silent = true, desc = 'Scroll down' })
-- vim.keymap.set('n', 'K', '<C-u>', { noremap = true, silent = true, desc = 'Scroll up' })

-- vim.keymap.set({'n', 'v'}, 'm', '<C-d>', { noremap = true, silent = true, desc = 'Scroll down' })
-- vim.keymap.set({'n', 'v'}, ',', '<C-u>', { noremap = true, silent = true, desc = 'Scroll up' })




-- code editor bindings

vim.keymap.set('n', 'K', vim.lsp.buf.hover) --definition on hover
vim.keymap.set('n', '<leader>cs', vim.lsp.buf.signature_help, {desc = "signature"})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {desc = "rename variable"})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = "code action"})
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.references, {desc = "references"})
vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, {desc = "format code"})
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, {desc = "open diagnostics"})
vim.keymap.set('n', '<leader>cp', vim.diagnostic.get_prev, {desc = "previous diagnostic"})
vim.keymap.set('n', '<leader>cn', vim.diagnostic.get_next, {desc = "next diagnostic"})

-- vim.keymap.set('n', '<leader>sd', vim.lsp.buf.definition, opts)
-- vim.keymap.set('n', 'sD', vim.lsp.buf.declaration, opts)
-- vim.keymap.set('n', 'si', vim.lsp.buf.implementation, opts)
-- vim.keymap.set('n', 'sr', vim.lsp.buf.references, opts)
-- vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, opts)
-- vim.keymap.set("n", "<leader>cf", function() require("conform").format() end, { desc = "Format" })












vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("w") -- save file first

  -- expand and escape paths safely
  local file       = vim.fn.expand("%:p")
  vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.fnamemodify(file, ":p:h")))
  local file_esc   = vim.fn.shellescape(file)
  local root       = vim.fn.expand("%:p:r")
  local root_esc   = vim.fn.shellescape(root)
  local exe_name   = vim.fn.fnamemodify(root, ":t")
  local exe_esc    = vim.fn.shellescape("./" .. exe_name)

  -- decide run command by filetype (path-safe)
  local ft = vim.bo.filetype
  local cmd
  if ft == "python" then
    -- cmd = "PYTHONUNBUFFERED=1 python3 " .. file_esc
    cmd = "python " .. file_esc
  elseif ft == "lua" then
    cmd = "lua " .. file_esc
  elseif ft == "c" then
    cmd = "gcc " .. file_esc .. " -o " .. root_esc .. " && " .. exe_esc
  elseif ft == "cpp" then
    cmd = "g++ " .. file_esc .. " -o " .. root_esc .. " && " .. exe_esc
  elseif ft == "sh" then
    cmd = "bash " .. file_esc
  elseif ft == "javascript" then
    cmd = "node " .. file_esc
  elseif ft == "go" then
    cmd = "go run " .. file_esc
  elseif ft == "java" then
    cmd = "javac " .. file_esc .. " && java " .. vim.fn.shellescape(exe_name)
  elseif ft == "rust" then
    cmd = "cargo run"
  else
    print("No run command set for filetype: " .. ft)
    return
  end

  local cur_win = vim.api.nvim_get_current_win()
  local user_shell = (vim.o.shell ~= "" and vim.o.shell) or (vim.env.SHELL or "bash")

  local function shrink_current_window_by(amount)
    local win = vim.api.nvim_get_current_win()
    local h = vim.api.nvim_win_get_height(win)
    vim.api.nvim_win_set_height(win, math.max(1, h - amount))
  end

  local function open_persistent_in_window(winid, command)
    vim.api.nvim_set_current_win(winid)
    vim.cmd("terminal " .. user_shell .. " -c " .. vim.fn.shellescape(command .. "; exec " .. user_shell))
    vim.b.runner_owned = true
  end

  -- recursive helper to get the window directly below current (unchanged logic)
  local function find_below(layout)
    if layout[1] == "row" then
      for _, child in ipairs(layout[2]) do
        local found = find_below(child)
        if found then return found end
      end
    elseif layout[1] == "col" then
      for i, child in ipairs(layout[2]) do
        if child[1] == "leaf" and child[2] == cur_win then
          local nxt = layout[2][i+1]
          if nxt and nxt[1] == "leaf" then
            local buf = vim.api.nvim_win_get_buf(nxt[2])
            if vim.bo[buf].buftype == "terminal" then
              return nxt[2]
            end
          end
        else
          local found = find_below(child)
          if found then return found end
        end
      end
    end
    return nil
  end

  local term_win = find_below(vim.fn.winlayout())

  if term_win then
    -- terminal exists below: reuse only if it's ours and idle; otherwise open a new split
    local buf = vim.api.nvim_win_get_buf(term_win)
    local owned = false
    do
      local ok, val = pcall(vim.api.nvim_buf_get_var, buf, "runner_owned")
      owned = ok and val or false
    end

    local chan = nil
    do
      local ok, val = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
      chan = ok and val or nil
    end

    if owned and chan and vim.fn.jobwait({ chan }, 0)[1] == -1 then
      vim.api.nvim_chan_send(chan, cmd .. "\n")
      return
    end

    -- not owned or not running: open fresh persistent shell in a NEW split
    vim.cmd("belowright split")
    shrink_current_window_by(15)          -- make the new terminal 15 lines smaller
    open_persistent_in_window(vim.api.nvim_get_current_win(), cmd)
    return
  end

  -- no terminal below: create one and keep it open
  vim.cmd("belowright split")
  shrink_current_window_by(15)            -- make the new terminal 15 lines smaller
  open_persistent_in_window(vim.api.nvim_get_current_win(), cmd)
end, { noremap = true, silent = true, desc = "Run current file (safe reuse below)" })












-- vs-code bindings with vscode-neovim plugin 
if not vim.g.vscode then return end

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local function V(id) return '<Cmd>call VSCodeNotify("' .. id .. '")<CR>' end
local function VW(id) return '<Cmd>call VSCodeCall("' .. id .. '")<CR>' end

map("n", "f", "<nop>")
map("n", "F", "<nop>")
map("n", "T", "<nop>")
map("n", "<leader>f", "<nop>")
map("n", "<leader>g", "<nop>")
map("n", "<leader>?", "<nop>")
map("n", "<leader>r", "<nop>")
map("n", "<leader>d", "<nop>")
map("n", "<leader>o", "<nop>")
map("n", "<leader>;", "<nop>")
map("n", "<leader>c", "<nop>")
map("n", "<leader>b", "<nop>")
map("n", "<leader>t", "<nop>")
map("n", "<leader>y", "<nop>")
-- map("n", "/", "<nop>")

-- map("n", "/", '<Cmd>call VSCodeNotify("flash-vscode.jump")<CR>')

-- vim.keymap.set("n", "<leader>", '<Cmd>call VSCodeNotify("whichkey.show")<CR>', {silent=true})
-- map("n", ";", "<nop>")
-- map("n", "F", V("workbench.action.toggleSidebarVisibility"))

  -- vim.keymap.set(
  --   "n",
  --   "<leader><leader>",
  --   '<Cmd>call VSCodeNotify("workbench.action.showCommands")<CR>',
  --   { noremap = true, silent = true }
  -- )
  map("n", "zz",        V("editor.toggleFold"),                  opts)

  vim.keymap.set("n", "tn",
  '<Cmd>call VSCodeNotify("workbench.action.files.newUntitledFile")<CR>',
  { noremap = true, silent = true })
map("n", "tl",   V("workbench.action.nextEditor"),    opts)                     -- next tab
map("n", "th",   V("workbench.action.previousEditor"),opts)


map("n", "<leader>h", V("workbench.action.focusLeftGroup"),  opts)
map("n", "<leader>j", V("workbench.action.focusBelowGroup"), opts)
map("n", "<leader>k", V("workbench.action.focusAboveGroup"), opts)
map("n", "<leader>l", V("workbench.action.focusRightGroup"), opts)


map("n", "<leader>=", V("workbench.action.splitEditorRight"), opts)
map("n", "<leader>-", V("workbench.action.splitEditorDown"),  opts)
map("n", "<leader>H", V("workbench.action.moveEditorToLeftGroup"),  opts)
map("n", "<leader>L", V("workbench.action.moveEditorToRightGroup"), opts)
map("n", "<leader>J", V("workbench.action.moveEditorToBelowGroup"), opts)
map("n", "<leader>K", V("workbench.action.moveEditorToAboveGroup"), opts)


-- ######## FILES / EDITORS ########
-- map("n", "<leader>w",  V("workbench.action.files.save"),                opts)
-- map("n", "<leader>W",  V("workbench.action.files.saveAll"),            opts)
map("n", "<leader>q",  V("workbench.action.closeActiveEditor"),        opts)
-- map("n", "<leader>qa", V("workbench.action.closeAllEditors"),          opts)
-- map("n", "<leader>qo", V("workbench.action.closeEditorsInOtherGroups"),opts)
map("n", "tl",         V("workbench.action.nextEditor"),               opts)
map("n", "th",         V("workbench.action.previousEditor"),           opts)
-- map("n", "<leader>bn", V("workbench.action.openNextRecentlyUsedEditorInGroup"), opts)
-- map("n", "<leader>bp", V("workbench.action.openPreviousRecentlyUsedEditorInGroup"), opts)
map("n", "<leader>nf", V("workbench.action.files.newUntitledFile"),    opts)
-- map("n", "<leader>re", V("workbench.files.action.revealActiveFileInExplorer"), opts)

-- -- ######## EXPLORER / UI TOGGLES ########
-- map("n", "<leader>f",  V("workbench.view.explorer"),             opts)
-- map("n", "<leader>s",  V("workbench.action.toggleSidebarVisibility"), opts)
-- map("n", "<leader>p",  V("workbench.action.togglePanel"),        opts)
-- map("n", "<leader>z",  V("workbench.action.toggleZenMode"),      opts)
-- map("n", "<leader>cn", V("notifications.showList"),              opts)

-- -- ######## SEARCH ########
-- map("n", "<leader>ff", V("workbench.action.quickOpen"),          opts) -- file picker
-- map("n", "<leader>fg", V("workbench.action.findInFiles"),        opts)
-- map("n", "<leader>fr", V("workbench.action.replaceInFiles"),     opts)
-- map("n", "<leader>fb", V("workbench.action.showAllEditors"),     opts)
-- map("n", "<leader>fs", V("workbench.action.files.saveAll"),      opts)

-- -- In-buffer find/replace (VS Code)
-- map({ "n", "x" }, "<leader>/",  V("actions.find"),                          opts)
-- map("n",          "<leader>?",  V("editor.action.startFindReplaceAction"),   opts)

-- -- ######## LSP-LIKE NAV / REFACTOR ########
-- map("n", "gd", V("editor.action.revealDefinition"),            opts)
-- map("n", "gD", V("editor.action.peekDefinition"),              opts)
-- map("n", "gr", V("editor.action.referenceSearch.trigger"),     opts)
-- map("n", "gI", V("editor.action.goToImplementation"),          opts)
-- map("n", "gt", V("editor.action.goToTypeDefinition"),          opts)
-- map("n", "K",  V("editor.action.showHover"),                   opts)
-- map("n", "ga", V("editor.action.quickFix"),                    opts)
-- map("n", "gR", V("editor.action.refactor"),                    opts)
-- map("n", "<leader>rn", V("editor.action.rename"),              opts)

-- -- ######## FORMAT / INDENT / FOLD ########
-- map("n", "<leader>=", V("editor.action.formatDocument"),       opts)
-- map("x", "<leader>=", V("editor.action.formatSelection"),      opts)
-- map("n", "zc",        V("editor.fold"),                        opts)
-- map("n", "zo",        V("editor.unfold"),                      opts)
-- map("n", "zM",        V("editor.foldAll"),                     opts)
-- map("n", "zR",        V("editor.unfoldAll"),                   opts)
-- map("n", "<leader>]", V("editor.action.indentLines"),          opts)
-- map("n", "<leader>[", V("editor.action.outdentLines"),         opts)

-- -- ######## PROBLEMS / OUTLINE / OUTPUT ########
-- map("n", "<leader>xx", V("workbench.actions.view.problems"),   opts)
-- map("n", "<leader>xo", V("workbench.action.output.toggleOutput"), opts)
-- map("n", "<leader>xs", V("workbench.action.focusOutline"),     opts)

-- -- ######## TERMINAL ########
-- map("n", "<leader>t`", V("workbench.action.terminal.toggleTerminal"), opts)
-- map("n", "<leader>tn", V("workbench.action.terminal.new"),            opts)
-- map("n", "<leader>ts", V("workbench.action.terminal.split"),          opts)
-- map("n", "<leader>tf", V("workbench.action.terminal.focus"),          opts)
-- map("n", "<leader>tk", V("workbench.action.terminal.kill"),           opts)
-- map("n", "<leader>tr", V("workbench.action.terminal.runSelectedText"),opts)

-- -- ######## GIT (Core SCM) ########
-- map("n", "<leader>gs", V("workbench.view.scm"),                opts)
-- map("n", "<leader>gc", V("git.commit"),                        opts)  -- opens commit input in SCM
-- map("n", "<leader>gp", V("git.push"),                          opts)
-- map("n", "<leader>gl", V("git.pull"),                          opts)
-- map("n", "<leader>gd", V("git.openChange"),                    opts)  -- if diff available

-- -- ######## DEBUG ########
-- map("n", "<leader>db", V("editor.debug.action.toggleBreakpoint"), opts)
-- map("n", "<leader>dc", V("workbench.action.debug.continue"),      opts)
-- map("n", "<leader>dn", V("workbench.action.debug.stepOver"),      opts)
-- map("n", "<leader>di", V("workbench.action.debug.stepInto"),      opts)
-- map("n", "<leader>do", V("workbench.action.debug.stepOut"),       opts)
-- map("n", "<leader>dr", V("workbench.action.debug.restart"),       opts)
-- map("n", "<leader>dx", V("workbench.action.debug.stop"),          opts)
-- map("n", "<leader>dv", V("workbench.debug.action.toggleRepl"),    opts)

-- -- ######## MISC ########
-- map("n", "<leader>hm", V("workbench.action.showCommands"),        opts) -- Command Palette
-- map("n", "<leader>hk", V("workbench.action.openGlobalKeybindings"), opts)
-- map("n", "<leader>hs", V("workbench.action.openSettingsJson"),    opts)
-- map("n", "<leader>u",  V("workbench.action.toggleCenteredLayout"),opts)


-- -- Create / open
-- map("n", "<leader>tn", V("workbench.action.files.newUntitledFile"), o)      -- new empty tab
-- map("n", "<leader>tr", V("workbench.action.reopenClosedEditor"),    o)      -- reopen closed

-- -- Navigate
-- map("n", "gt",   V("workbench.action.nextEditor"),    o)                     -- next tab
-- map("n", "gT",   V("workbench.action.previousEditor"),o)                     -- prev tab
-- map("n", "<leader>tl", V("workbench.action.nextEditorInGroup"),    o)
-- map("n", "<leader>th", V("workbench.action.previousEditorInGroup"),o)

-- -- Close
-- map("n", "<leader>tc", V("workbench.action.closeActiveEditor"),     o)       -- close
-- map("n", "<leader>tC", V("workbench.action.closeAllEditors"),       o)       -- close all
-- map("n", "<leader>to", V("workbench.action.closeOtherEditors"),     o)       -- close others (this group)
-- map("n", "<leader>tL", V("workbench.action.closeEditorsToTheRight"),o)       -- close right
-- map("n", "<leader>tH", V("workbench.action.closeEditorsToTheLeft"), o)       -- close left
-- map("n", "<leader>tO", V("workbench.action.closeEditorsInOtherGroups"), o)   -- close in other groups

-- -- Move within group (reorder tab)
-- map("n", "<leader>t>", V("workbench.action.moveEditorRightInGroup"), o)
-- map("n", "<leader>t<", V("workbench.action.moveEditorLeftInGroup"),  o)
-- map("n", "<leader>t0", V("workbench.action.moveEditorToFirstSlot"),  o)
-- map("n", "<leader>t9", V("workbench.action.moveEditorToLastSlot"),   o)

-- -- Pin / duplicate
-- map("n", "<leader>tp", V("workbench.action.toggleEditorPin"),    o)          -- pin/unpin
-- map("n", "<leader>td", V("workbench.action.duplicateActiveEditor"), o)

-- -- Split / new group
-- map("n", "<leader>ts", V("workbench.action.splitEditorRight"),   o)          -- split right
-- map("n", "<leader>tS", V("workbench.action.splitEditorDown"),    o)          -- split down

-- -- Move editor to another group
-- map("n", "<leader>twh", V("workbench.action.moveEditorToLeftGroup"),  o)
-- map("n", "<leader>twl", V("workbench.action.moveEditorToRightGroup"), o)
-- map("n", "<leader>twk", V("workbench.action.moveEditorToAboveGroup"), o)
-- map("n", "<leader>twj", V("workbench.action.moveEditorToBelowGroup"), o)

-- -- Lists / switchers
map("n", "<leader>f", V("workbench.action.showAllEditors"),           o)    -- all editors
map("n", "<leader>s", V("workbench.action.showAllEditorsByMostRecentlyUsed"), o)
-- map("n", "<leader>e", V("workbench.action.openEditorsView"),          o)    -- Open Editors view
-- map("n", "<leader>tR", V("workbench.files.action.revealActiveFileInExplorer"), o) -- reveal in explorer
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
