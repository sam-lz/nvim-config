return {
    {
        "nvim-tree/nvim-web-devicons",
    },
    {

        "sphamba/smear-cursor.nvim",
        opts = {

            stiffness = 0.95,
            trailing_stiffness = 0.9,
            distance_stop_animating = 0.4,

        },

    },



    {
        "tpope/vim-commentary",
    },
    -- {
    --     "vimpostor/vim-tpipeline",
    -- },

    { "rebelot/kanagawa.nvim",
    },

    {
        "ptdewey/monalisa-nvim",
        priority = 1000,
    },
    -- {
    --     "cocopon/iceberg.vim",
    -- },
    -- { 'datsfilipe/vesper.nvim' },
    -- {
    --     "vague-theme/vague.nvim",
    --     lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --     priority = 1000, -- make sure to load this before all the other plugins
    -- },
    {
        "sam-lz/yorumi.nvim",
    },
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
    {
        "thesimonho/kanagawa-paper.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- {
    --     "jwbaldwin/oscura.nvim",
    --     lazy = false,
    --     priority = 1000,
    -- },
    {
        "vague2k/huez.nvim",
        -- if you want registry related features, uncomment this
        import = "huez-manager.import",
        branch = "stable",
        event = "UIEnter",
        config = function()
            require("huez").setup({})
        end,
    },
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



    -- {
    --     'nvim-lualine/lualine.nvim',
    --     dependencies = { 'nvim-tree/nvim-web-devicons' },
    --     opts = {
    --         options = {
    --         icons_enabled = false,
    --         theme = 'auto',
    --         component_separators = { left = '', right = ''},
    --         section_separators = { left = '', right = ''},
    --         },
    --         sections = {
    --             lualine_a = {},
    --             lualine_b = {'branch', 'diff', 'diagnostics'},
    --             lualine_c = {'filename'},
    --             lualine_x = {'filetype', 'encoding', 'fileformat', {'location', padding = { left = 0, right = 0 }}},
    --             lualine_y = {},
    --             lualine_z = {},
    --         },
    --    },
    -- },


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
