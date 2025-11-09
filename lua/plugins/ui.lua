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
