return {
    {
        "nvim-tree/nvim-web-devicons",
    },
    {

        "sphamba/smear-cursor.nvim",
        opts = {

            stiffness = 0.95,
            trailing_stiffness = 0.99,
            distance_stop_animating = 0.45,
            damping = 0.9,

        },

    },
-- {
-- 		"rcarriga/nvim-notify",
-- 		opts = {
-- 			timeout = 5000,
-- 		},
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
          -- separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = false,
        },
      },
    },

    {
        "tpope/vim-commentary",
    },
    {
        "sam-lz/yorumi-dusk.nvim",
        -- "/Users/saml./Library/Mobile Documents/com~apple~CloudDocs/Coding/misc/yorumi-dusk.nvim",
    },
    {
        "yorumicolors/yorumi.nvim",
    },
    {
		"craftzdog/solarized-osaka.nvim",
		lazy = true,
		priority = 1000,
		opts = function()
			return {
				transparent = true,
			}
		end,
        -- opts = {},
    },
    {
      "vague-theme/vague.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        transparent = true
      }
    },
    {
      "killitar/obscure.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        transparent = true,
      }
    },
    -- {
    --     "vimpostor/vim-tpipeline",
    -- },

    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      opts = {
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = { left = '|', right = '|'},
          section_separators = { left = '', right = ''},
          refresh = {
            statusline = 100,
            tabline    = 100,
            winbar     = 100,
          },
        },
        sections = {
          lualine_a = {},
          lualine_b = {'branch'},
          -- 'diff', 'diagnostics',
          -- {function()
            -- return vim.fn.fnamemodify(vim.fn.getcwd(), ":t:h")
            -- end,
            lualine_c = {{function()
              local cwd = vim.fn.getcwd()
              local dir    = vim.fn.fnamemodify(cwd, ":t")   -- current dir
              local parent = vim.fn.fnamemodify(cwd, ":h:t") -- parent dir
              if parent ~= "" then
                return parent .. "/" .. dir
              else
                return dir
              end
            end, }, {'filename', path = 1, shorting_target = 80}},
            lualine_x = {{'location', padding = { left = 1, right = 1 }},{'filetype', padding = {left = 1, right = 1}}, {'encoding', padding = {left = 1, right = 1}}, {'fileformat', padding = {left = 1, right = 1}}, },
            lualine_y = {            {
              function()
                return os.date("%H:%M")
              end,
            },
},
            lualine_z = {},
          },
        },
      },

      {
        "b0o/incline.nvim",
        dependencies = { "craftzdog/solarized-osaka.nvim" },
        event = "BufReadPre",
        priority = 1200,
        config = function()
          local colors = require("solarized-osaka.colors").setup()
          require("incline").setup({
            highlight = {
              groups = {
                InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
                InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
              },
            },
            window = { margin = { vertical = 0, horizontal = 1 } },
            hide = {
              cursorline = true,
              only_win = true,
              focused_win = false,
            },
            render = function(props)
              local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
              if vim.bo[props.buf].modified then
                filename = "[+] " .. filename
              end

              local icon, color = require("nvim-web-devicons").get_icon_color(filename)
              return { { icon, guifg = color }, { " " }, { filename } }
            end,
          })
        end,
      },
      -- {
        --     "ptdewey/monalisa-nvim",
    --     priority = 1000,
    -- },
    -- {
    --     "cocopon/iceberg.vim",
    -- },
    -- { 'datsfilipe/vesper.nvim' },
    --
    -- { "fcpg/vim-fahrenheit", },
    --
    -- Using lazy.nvim
    -- {
    --     "cdmill/neomodern.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require("neomodern").setup({
    --             -- optional configuration here
    --         })
    --         require("neomodern").load()
    --     end,
    -- },
    -- {
    --     "gabrielfrimodig/seashell.nvim",
    --     lazy = false,
    --     priority = 1000,
    -- },
    -- {
    --     "thesimonho/kanagawa-paper.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    -- },

    -- {
    --     "jwbaldwin/oscura.nvim",
    --     lazy = false,
    --     priority = 1000,
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
    -- "zaldih/themery.nvim",
    -- lazy = false,
    -- config = function()
    --   require("themery").setup({
    --     themes = {"kanagawa-dragon",
    --     "yorumi",
    --     "seashell",
    --     "kanagawa-paper",
    --     "iceberg",
    --     "vesper",
    --     "monalisa"},
    --     livePreview = true,
    --   })
    -- end
  -- },
  -- Lazy





-- default config 
-- require('lualine').setup {
  -- options = {
  --   icons_enabled = true,
  --   theme = 'auto',
  --   component_separators = { left = '', right = ''},
  --   section_separators = { left = '', right = ''},
  --   disabled_filetypes = {
  --     statusline = {},
  --     winbar = {},
  --   },
  --   ignore_focus = {},
  --   always_divide_middle = true,
  --   always_show_tabline = true,
  --   globalstatus = false,
  --   refresh = {
  --     statusline = 1000,
  --     tabline = 1000,
  --     winbar = 1000,
  --     refresh_time = 16, -- ~60fps
  --     events = {
  --       'WinEnter',
  --       'BufEnter',
  --       'BufWritePost',
  --       'SessionLoadPost',
  --       'FileChangedShellPost',
  --       'VimResized',
  --       'Filetype',
  --       'CursorMoved',
  --       'CursorMovedI',
  --       'ModeChanged',
  --     },
  --   }
  -- },
  -- sections = {
  --   lualine_a = {'mode'},
  --   lualine_b = {'branch', 'diff', 'diagnostics'},
  --   lualine_c = {'filename'},
  --   lualine_x = {'encoding', 'fileformat', 'filetype'},
  --   lualine_y = {'progress'},
  --   lualine_z = {'location'}
  -- },
  -- inactive_sections = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = {'filename'},
  --   lualine_x = {'location'},
  --   lualine_y = {},
  --   lualine_z = {}
  -- },
  -- tabline = {},
  -- winbar = {},
  -- inactive_winbar = {},
  -- extensions = {}
-- }















}
