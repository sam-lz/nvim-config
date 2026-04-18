return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
    {
      "mason-org/mason.nvim",
      opts = {},
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {},
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        { "neovim/nvim-lspconfig" },
      },
      config = function()
        require("mason-lspconfig").setup {
          ensure_installed = { "clangd", "pyright", "lua_ls", "tinymist" },
          handlers = {
            function(server_name)
              require("lspconfig")[server_name].setup({
                  require("coq").lsp_ensure_capabilities({})
              })
            end,

            -- ["clangd"] = function()
            --   require("lspconfig").clangd.setup({
            --     cmd = {
            --       "clangd",
            --       "--header-insertion=never",
            --       "--diagnostic-cleaner-interval=0",
            --     },
            --   })
            -- end,

          },
        }
      end,
    },
    -- {
    --   'saghen/blink.cmp',
    --   dependencies = {
    --     'rafamadriz/friendly-snippets',
    --     'L3MON4D3/LuaSnip',
    --   },
    --   version = '1.*',
    --   opts = {
    --     keymap = {
    --       preset        = 'none',
    --       ['<C-Space>'] = { 'show' },
    --       -- ['<C-h>']     = { 'hide' },
    --       ['<CR>']      = { 'accept', 'fallback' },
    --       ['<C-n>']     = { 'select_next', 'snippet_forward', 'fallback' },
    --       ['<C-p>']     = { 'select_prev', 'snippet_backward', 'fallback' },
    --       ['<C-b>']     = { 'scroll_documentation_up' },
    --       ['<C-f>']     = { 'scroll_documentation_down' },
    --     },
    --     appearance = {
    --       nerd_font_variant = 'mono'
    --     },
    --     completion = { documentation = { auto_show = true } },
    --     sources = {
    --       default = { 'lsp', 'path', 'snippets', 'buffer' },
    --     },
    --     fuzzy = { implementation = "prefer_rust_with_warning" }
    --   },
    --   opts_extend = { "sources.default" },

    --   config = function(_, opts)
    --     require('blink.cmp').setup(opts)
    --     -- enabled = function()
    --     --     return not vim.tbl_contains({ "markdown", "org", "text" , "norg"}, vim.bo.filetype)
    --     -- end,

    --     -- hide Copilot inline suggestions while Blink's menu is open
    --     local aug = vim.api.nvim_create_augroup('BlinkCopilotBridge', { clear = true })

    --     vim.api.nvim_create_autocmd('User', {
    --       group = aug,
    --       pattern = 'BlinkCmpMenuOpen',
    --       callback = function()
    --         vim.b.copilot_suggestion_hidden = true
    --       end,
    --     })

    --     vim.api.nvim_create_autocmd('User', {
    --       group = aug,
    --       pattern = 'BlinkCmpMenuClose',
    --       callback = function()
    --         vim.b.copilot_suggestion_hidden = false
    --       end,
    --     })
    --   end,
    -- },

    {
      "ms-jpq/coq_nvim",
      branch = "coq",
      -- event = "InsertEnter",
      dependencies = {
        { "ms-jpq/coq.artifacts", branch = "artifacts" },
        { "ms-jpq/coq.thirdparty", branch = "3p" },
      },
      init = function()
        vim.g.coq_settings = {
          auto_start = "shut-up",
          display = {
            pum = {
              fast_close = false,
            },
            ghost_text = {
              enabled = false,
            },
          },
          -- vim.api.nvim_set_keymap('i', '<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true }),
          vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true }),
          vim.api.nvim_set_keymap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true }),
          vim.api.nvim_set_keymap(
            "i",
            "<CR>",
            [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
            { expr = true, silent = true }
          ),
          vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true }),
          vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<BS>"]], { expr = true, silent = true }),
          keymap = {
            recommended = false,       -- 1. Uses default keys: <Enter> to accept, <Esc> to close
            -- jump_to_mark = "<C-j>",   -- 2. Jumps to the next "gap" in a code snippet
            -- bigger_preview = "<C-k>", -- 3. Expands the documentation window (focuses it)
          },
          -- preview = {
          --   resolve_timeout = 500, -- Only show docs if you hover for 500ms
          --   position = "east",     -- Force position to avoid layout shifts
          -- },
          match = {
            max_results = 15,
          },
          clients = {
            paths = { enabled = true },
            snippets = { enabled = true },
          },
        }
      end,
      config = function()
        vim.keymap.set("i", "<C-Space>", function() vim.cmd("COQnow") end, { desc = "Trigger Completion" })
        -- vim.keymap.set('i', '<CR>', function()
        --   return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
        -- end, { expr = true, noremap = true })

        -- ESC: If menu is open, close it (<C-e>) then Esc. If not, just Esc.
        -- vim.keymap.set('i', '<Esc>', function()
        --   return vim.fn.pumvisible() == 1 and "<C-e><Esc>" or "<Esc>"
        -- end, { expr = true, noremap = true })

        -- -- BACKSPACE: Standard backspace (Coq listens to text changes automatically)
        -- vim.keymap.set('i', '<BS>', '<BS>', { noremap = true })
      end,
    },

    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },

}
