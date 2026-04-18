local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "css",
  "go",
  "html",
  "java",
  "javascript",
  "json",
  "latex",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "php",
  "python",
  "query",
  "ruby",
  "rust",
  "sql",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local parser_install_dir = vim.fn.stdpath("data") .. "/site"

local function set_textobject_keymaps()
  local select = require("nvim-treesitter-textobjects.select")

  vim.keymap.set({ "x", "o" }, "af", function()
    select.select_textobject("@function.outer", "textobjects")
  end, { desc = "Select around function" })
  vim.keymap.set({ "x", "o" }, "if", function()
    select.select_textobject("@function.inner", "textobjects")
  end, { desc = "Select inside function" })
  vim.keymap.set({ "x", "o" }, "ac", function()
    select.select_textobject("@class.outer", "textobjects")
  end, { desc = "Select around class" })
  vim.keymap.set({ "x", "o" }, "ic", function()
    select.select_textobject("@class.inner", "textobjects")
  end, { desc = "Select inner part of a class region" })
  vim.keymap.set({ "x", "o" }, "as", function()
    select.select_textobject("@local.scope", "locals")
  end, { desc = "Select language scope" })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ok_main, treesitter = pcall(require, "nvim-treesitter")
      if ok_main and type(treesitter.setup) == "function" and type(treesitter.install) == "function" then
        treesitter.setup({
          install_dir = parser_install_dir,
        })
        treesitter.install(ensure_installed)

        local group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          group = group,
          callback = function(args)
            pcall(vim.treesitter.start, args.buf)
          end,
        })

        return
      end

      local ok_legacy, configs = pcall(require, "nvim-treesitter.configs")
      if not ok_legacy then
        return
      end

      configs.setup({
        ensure_installed = ensure_installed,
        auto_install = true,
        parser_install_dir = parser_install_dir,
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "ss",
            node_incremental = "oo",
            node_decremental = "ii",
            scope_incremental = "ss",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
            include_surrounding_whitespace = true,
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
      if not ok or type(textobjects.setup) ~= "function" then
        return
      end

      textobjects.setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
          },
          include_surrounding_whitespace = true,
        },
      })

      set_textobject_keymaps()
    end,
  },
}
