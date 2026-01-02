return {
  -- {
  --     "jackMort/ChatGPT.nvim",
  --     event = "VeryLazy",
  --     config = function()
  --         require("chatgpt").setup()
  --     end,
  --     dependencies = {
  --         "MunifTanjim/nui.nvim",
  --         "nvim-lua/plenary.nvim",
  --         -- "folke/trouble.nvim", -- optional
  --         "nvim-telescope/telescope.nvim"
  --     }
  -- },

  -- {"zbirenbaum/copilot.lua",
  -- -- { "zbirenbaum/copilot.lua", enabled = false }
  -- -- event = "VeryLazy",
  -- config = function()
  --     require("copilot").setup({
  --         filetypes = {
  --             markdown = false,
  --             org = false,
  --             text = false,
  --             norg = false,
  --         },
  --         suggestion = {
  --             enabled = true,
  --             auto_trigger = true,
  --             debounce = 75,
  --             keymap = {
  --                 accept = "<C-a>",
  --                 accept_word = "<C-w>",
  --                 accept_line = "<C-e>",
  --                 -- next = "<C-]>",
  --                 -- prev = "<C-[>",
  --                 -- dismiss = "<esc>",
  --             },
  --         },
  --         panel = {
  --             enabled = true,
  --             auto_refresh = true,
  --             keymap = {
  --             }
  --           }
  --         })
  --     end,
  -- },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
      show_dirname = false,
    },
  },
  --{
  --  "lukas-reineke/indent-blankline.nvim",
  --  main = "ibl",
  --  ---@module "ibl"
  --  ---@type ibl.config
  --  opts = {
  --    indent = {
  --      char = "│",
  --      highlight = "IblScope",
  --    },
  --    scope = {
  --      enabled = false,
  --      highlight = "IblScope",
  --    },
  --    whitespace = {
  --      highlight = "IblScope",
  --      remove_blankline_trail = true,
  --    },
  --  },
  --},
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>x",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      -- {
      --   "<leader>xX",
      --   "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      --   desc = "Buffer Diagnostics (Trouble)",
      -- },
      -- {
      --   "<leader>cs",
      --   "<cmd>Trouble symbols toggle focus=false<cr>",
      --   desc = "Symbols (Trouble)",
      -- },
      -- {
      --   "<leader>cl",
      --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      --   desc = "LSP Definitions / references / ... (Trouble)",
      -- },
      -- {
      --   "<leader>xL",
      --   "<cmd>Trouble loclist toggle<cr>",
      --   desc = "Location List (Trouble)",
      -- },
      -- {
      --   "<leader>xQ",
      --   "<cmd>Trouble qflist toggle<cr>",
      --   desc = "Quickfix List (Trouble)",
      -- },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
  },
  {
    "tpope/vim-commentary",
  },
  -- {
  --     "tpope/vim-fugitive",
  -- },
  -- {
  --     "vimpostor/vim-tpipeline",
  -- },

  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        start_in_insert = false,
        autochdir = true,
        direction = 'float',
        float_opts = {
          border = 'shadow',
          width = function()
            return vim.o.columns
          end,
          height = function()
            return vim.o.lines
          end,
        },
      })
    end
  },

  { 'Civitasv/cmake-tools.nvim', opts = {} },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
    end
  },

  {
    "S1M0N38/love2d.nvim",
    event = "VeryLazy",
    version = "2.*",
    opts = {},
    -- keys = {
    --   { "<leader>v", ft = "lua", desc = "LÖVE" },
    --   { "<leader>vv", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
    --   { "<leader>vs", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
    -- },
  },




  -- {
  --   "gpanders/nvim-parinfer",
  --   config = function()
  --     vim.g.parinfer_filetypes = {
  --       "dune",
  --       "scheme",
  --       "query",
  --       "racket",
  --     }
  --   end,
  -- },





  -- {
  --   "folke/zen-mode.nvim",
  --   config = function()
  --     require("zen-mode").setup {
  --       window = {
  --         backdrop = 1,
  --         height = 0.9,
  --         width = 0.8,
  --         options = {
  --           number = false,
  --           relativenumber = false,
  --           signcolumn = "no",
  --           list = false,
  --           cursorline = false,
  --         },
  --       },
  --     }

  --     require("twilight").setup {
  --       context = -1,
  --       treesitter = true,
  --     }
  --   end,
  -- },

  -- {
  --   "folke/twilight.nvim",
  --   config = function()
  --     require("twilight").setup {
  --       context = -1,
  --       treesitter = true,
  --     }
  --   end,
  -- },









}
