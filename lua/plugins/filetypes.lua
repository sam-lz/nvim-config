return {
  {
    "sylvanfranklin/omni-preview.nvim",
    opts = {}
  },
  {
    -- "norcalli/nvim-colorizer.lua",
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    opts = {
      render = "background",
      enable_hex = true,
      enable_short_hex = true,
      enable_rgb = true,
      enable_hsl = true,
      enable_hsl_without_function = true,
      enable_ansi = true,
      enable_var_usage = true,
      enable_tailwind = true,
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "hedyhli/outline.nvim",
    opts = {},
  },

  {
    "brianhuster/live-preview.nvim",
  },

  -- { 'glacambre/firenvim', build = ":call firenvim#install(0)" },

  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    config = function()
      ---@diagnostic disable-next-line: undefined-global
      require('orgmode').setup({
        mappings = {
          disable_all = true,
        },
      })
    end,


  },
  {
    "nvim-neorg/neorg",
    -- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    ft = "norg",
    version = "*", -- Pin Neorg to the latest stable release
    -- config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},         -- sensible defaults
          ["core.concealer"] = {},        -- better-looking headings/bullets
          ["core.esupports.indent"] = {}, -- Treesitter-aware indentation
          -- ["core.dirman"] = { config = {
          --     workspaces = { notes = "~/notes" },
          --     default_workspace = "notes",
          -- }},
        },
      })
    end,
  },
  {
    "hat0uma/csvview.nvim",
    ft = { "csv" },
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },

    config = function(_, opts)
      local csvview = require("csvview")
      csvview.setup(opts)

      -- auto-enable whenever a csv buffer is opened
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "csv",
        callback = function()
          csvview.enable()
          -- or: vim.cmd.CsvViewEnable()
        end,
      })
    end,


  },


  {
    'chomosuke/typst-preview.nvim',
    lazy = false, -- or ft = 'typst'
    version = '1.*',
    opts = {},    -- lazy.nvim will implicitly calls `setup {}`
  },


  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release


    init = function()
      vim.g.vimtex_syntax_enabled = 0
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_view_automatic = 1
      vim.g.vimtex_compiler_latexmk = {
        build_dir = ".",
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-aux-directory=build",
        },
      }
    end
  },

  -- {
  --   "epwalsh/obsidian.nvim",
  --   version = "*",
  --   lazy = true,
  --   ft = "markdown",
  --   -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  --   -- event = {
  --   --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   --   -- refer to `:h file-pattern` for more examples
  --   --   "BufReadPre path/to/my-vault/*.md",
  --   --   "BufNewFile path/to/my-vault/*.md",
  --   -- },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   opts = {
  --     workspaces = {
  --       {
  --         name = "personal",
  --         path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal",
  --       },
  --       {
  --         name = "professional",
  --         path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/professional",
  --       },
  --       {
  --         name = "legal-financial",
  --         path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/legal-financial",
  --       },
  --       {
  --         name = "misc_personal",
  --         path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/misc_personal",
  --       },
  --     },
  --   },
  -- },
  -- {
  -- "GCBallesteros/jupytext.nvim",
  -- config = true,
  -- -- lazy=true,
  -- },


  -- {
  --     "vhyrro/luarocks.nvim",
  --     priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
  --     config = true,
  -- },
  -- {
  --     {
  --         "quarto-dev/quarto-nvim",
  --         dependencies = {
  --             "jmbuhr/otter.nvim",
  --             "nvim-treesitter/nvim-treesitter",
  --         },
  --         ft = { "quarto", "markdown" },
  --         opts = {
  --             lspFeatures = {
  --                 enabled = true,
  --                 languages = { "r", "python", "julia", "bash", "html" },
  --                 diagnostics = { enabled = true, triggers = { "BufWritePost" } },
  --                 completion = { enabled = true },
  --             },
  --             codeRunner = {
  --                 enabled = true,
  --                 default_method = "molten",
  --             },
  --         },
  --     },


  -- },
}
