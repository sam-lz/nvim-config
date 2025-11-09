return {
    {
        "kwakzalver/duckytype.nvim",
        opts = {}
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
    {
        "cocopon/iceberg.vim",
    },
    { 'datsfilipe/vesper.nvim' },
    {
        "vague-theme/vague.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other plugins
    },
    {
        "yorumicolors/yorumi.nvim",
    },
    -- Using lazy.nvim
    {
        "cdmill/neomodern.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("neomodern").setup({
                -- optional configuration here
            })
            require("neomodern").load()
        end,
    },
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

    {
        "jwbaldwin/oscura.nvim",
        lazy = false,
        priority = 1000,
    },
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
}
