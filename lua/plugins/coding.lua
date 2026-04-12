local function empty_python_notebook()
  return vim.json.encode({
    cells = {},
    metadata = {
      kernelspec = {
        display_name = "Python 3",
        language = "python",
        name = "python3",
      },
      language_info = {
        name = "python",
      },
    },
    nbformat = 4,
    nbformat_minor = 5,
  })
end

local function initialize_blank_notebook(path)
  local filename = vim.fn.resolve(vim.fn.expand(path))
  if vim.fn.filereadable(filename) ~= 1 then
    return
  end

  local size = vim.fn.getfsize(filename)
  if size < 0 then
    return
  end

  if size == 0 then
    vim.fn.writefile({ empty_python_notebook() }, filename)
    return
  end

  if size > 1024 then
    return
  end

  local contents = table.concat(vim.fn.readfile(filename), "\n")
  if contents:match("^%s*$") then
    vim.fn.writefile({ empty_python_notebook() }, filename)
  end
end

local function jupytext_cache_file(filename, extension)
  local resolved = vim.fn.resolve(vim.fn.expand(filename))
  local digest = vim.fn.sha256(resolved)
  local stem = vim.fn.fnamemodify(resolved, ":t:r")
  local cache_dir = vim.fn.stdpath("config") .. "/.jupytext-cache"

  vim.fn.mkdir(cache_dir, "p")

  return string.format("%s/%s-%s.%s", cache_dir, stem, digest, extension)
end

local function setup_jupytext(opts)
  local group = vim.api.nvim_create_augroup("InitBlankIpynb", { clear = true })
  local utils = require("jupytext.utils")

  -- Keep jupytext's working markdown files out of project directories.
  utils.get_jupytext_file = function(filename, extension)
    return jupytext_cache_file(filename, extension)
  end

  -- jupytext.nvim expects existing notebooks to already be valid JSON.
  vim.api.nvim_create_autocmd("BufReadCmd", {
    group = group,
    pattern = "*.ipynb",
    callback = function(ev)
      initialize_blank_notebook(ev.match)
    end,
  })

  require("jupytext").setup(opts)
end

return {

  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
      max_width = 180,
      max_height = 50,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    }
  },

  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    lazy = false,
    init = function()
      vim.g.molten_auto_init_behavior = "raise"
      vim.g.molten_cover_empty_lines = true
      vim.g.molten_auto_open_output = true
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_image_location = "virt"
      vim.g.molten_output_virt_lines = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_wrap_output = true

      -- vim.g.molten_output_win_hide_on_leave = false
    end,
  },

  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    config = function(_, opts)
      setup_jupytext(opts)
    end,
    opts = {
      custom_language_formatting = {
        python = {
          extension = "md",
          style = "markdown",
          force_ft = "markdown",
        },
      },
    },
  },

  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "markdown" },
    opts = {
      lspFeatures = {
        enabled = true,
        -- Let Quarto/Otter treat plain markdown fences like ```python as runnable chunks.
        chunks = "all",
        languages = { "r", "python", "julia", "bash", "html" },
        diagnostics = { enabled = true, triggers = { "BufWritePost" } },
        completion = { enabled = true },
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
  },

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
        insert_mappings = false,
        direction = 'horizontal',
        open_mapping = [[w]],
        persist_size = true,
        float_opts = {
          -- border = 'shadow',
          -- width = function()
          --   return vim.o.columns
          -- end,
          -- height = function()
          --   return vim.o.lines
          -- end,
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
