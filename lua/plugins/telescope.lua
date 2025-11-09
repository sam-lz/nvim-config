return {


    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                              , branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
        defaults = {
            -- mappings = {
            --    i = { ["<C-p>"] = actions.layout.toggle_preview },
            --    n = { ["<C-p>"] = actions.layout.toggle_preview },
            -- },
            path_display = { "truncate" },
            layout_strategy = 'horizontal',
            layout_config = {
                width = 0.9,
                horizontal = {
                    preview_cutoff = 100,
                    preview_width = 0.4,
                    results_width = 0.65,
                },
            },
            -- sorting_strategy = 'ascending',
        },
    },
   },



}
