return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        refresh = {
          statusline = 100,
          tabline    = 100,
          winbar     = 100,
        },
      },
      sections = {
        lualine_a = {
          -- {'branch'},
        },
        lualine_b = {
          -- {'branch'},

        },
        -- 'diff', 'diagnostics',
        -- {function()
        -- return vim.fn.fnamemodify(vim.fn.getcwd(), ":t:h")
        -- end,
        lualine_c = {
          { 'branch' },
          {'diagnostics'},
          -- {'diff'},
          { function()
          local cwd    = vim.fn.getcwd()
          local dir    = vim.fn.fnamemodify(cwd, ":t")   -- current dir
          local parent = vim.fn.fnamemodify(cwd, ":h:t") -- parent dir
          if parent ~= "" then
            return parent .. "/" .. dir
          else
            return dir
          end
        end, }, { 'filename', path = 1, shorting_target = 80 } },
        lualine_x = { { 'location', padding = { left = 1, right = 1 } },
          { 'filetype',   padding = { left = 1, right = 1 } },
          { 'encoding',   padding = { left = 1, right = 1 } },
          { 'fileformat', padding = { left = 1, right = 1 } },
          {
            function()
              return os.date("%H:%M")
            end,
          },

        },
        lualine_y = {

          -- {
          --   function()
          --     return os.date("%H:%M")
          --   end,
          -- },

        },
        lualine_z = {

          -- {
          --   function()
          --     return os.date("%H:%M")
          --   end,
          -- },

        },
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
  },


  -- {
  --   "sphamba/smear-cursor.nvim",
  --   opts = {
  --     stiffness = 0.95,
  --     trailing_stiffness = 0.99,
  --     distance_stop_animating = 0.45,
  --     damping = 0.9,
  --   },
  -- },


  -- {
  -- 		"rcarriga/nvim-notify",
  -- 		opts = {
  --       timeout = 5000,
  --       fps = 60,
  --       background_colour = "#000000",
  --       stages = "fade",
  --       render = "compact",
  --     },
  --     config = function(_, opts)
  --       local notify = require("notify")
  --       notify.setup(opts)
  --       vim.notify = notify
  --     end,
  -- 	},

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      -- { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      -- { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        separator_style = "thin",
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = false,
      },
    },
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        transparent = false,
      }
    end,
    -- opts = {},
  },
  {
    "Ronxvier/ymir.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd("colorscheme ymir")
    -- end,
  },
  {
    "vague-theme/vague.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
    }
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },
      })
    end
  },
  { "rebelot/kanagawa.nvim", },
  { "yorumicolors/yorumi.nvim", },
  {
    "killitar/obscure.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        booleans = { italic = true, bold = true }
      },
      transparent = false,
    }
  },
  {
    "ptdewey/monalisa-nvim",
    priority = 1000,
  },
  --
  -- { "fcpg/vim-fahrenheit", },
  --

  -- {
  --   "b0o/incline.nvim",
  --   dependencies = { "craftzdog/solarized-osaka.nvim" },
  --   event = "BufReadPre",
  --   priority = 1200,
  --   config = function()
  --     local colors = require("solarized-osaka.colors").setup()
  --     require("incline").setup({
  --       -- highlight = {
  --       --   groups = {
  --       --     InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
  --       --     InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
  --       --   },
  --       -- },
  --       window = { margin = { vertical = 0, horizontal = 1 } },
  --       hide = {
  --         cursorline = false,
  --         only_win = true,
  --         focused_win = false,
  --       },
  --       render = function(props)
  --         local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
  --         if vim.bo[props.buf].modified then
  --           filename = "[+] " .. filename
  --         end

  --         local icon, color = require("nvim-web-devicons").get_icon_color(filename)
  --         return { { icon, guifg = color }, { " " }, { filename } }
  --       end,
  --     })
  --   end,
  -- },
  -- {
  --     "vague2k/huez.nvim",
  --     -- if you want registry related features, uncomment this
  --     import = "huez-manager.import",
  --     branch = "stable",
  --     event = "UIEnter",
  --     config = function()
  --         require("huez").setup({})
  --     end,
  -- },
  -- {
  --   "zaldih/themery.nvim",
  --   lazy = false,
  --   config = function()
  --     require("themery").setup({
  --       livePreview = true,
  --       themes = {"wisteria", "flexoki", "oasis", "obscure",
  --       "rose-pine", "tokyonight-night", "vague", "seashell",
  --     },

  --     })
  --   end
  -- },

  {
    "Eandrju/cellular-automaton.nvim",
  },


  -- {
  --   "folke/drop.nvim",
  --   opts = {
  --   }
  -- },





}
