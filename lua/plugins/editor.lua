return {
    {
        "sylvanfranklin/omni-preview.nvim",
        opts = {}
    },
    {
        "norcalli/nvim-colorizer.lua",
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

     { 'glacambre/firenvim', build = ":call firenvim#install(0)" },

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
                    ["core.defaults"] = {},                 -- sensible defaults
                    ["core.concealer"] = {},                -- better-looking headings/bullets
                    ["core.esupports.indent"] = {},         -- Treesitter-aware indentation
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




    },
};
