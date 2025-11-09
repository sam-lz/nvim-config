return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
    {
        "mason-org/mason.nvim",
        opts = {},
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            {"neovim/nvim-lspconfig"},
        },
        config = function()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup{
                handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,
              },
            }
        end,
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'L3MON4D3/LuaSnip',


        },
        version = '1.*',

        opts = {
            keymap = {
                preset = 'none',
                ['<C-Space>'] = { 'show' },
                -- ['<C-h>']     = { 'hide' },
                ['<CR>']      = { 'accept', 'fallback' },
                ['<C-n>']     = { 'select_next', 'snippet_forward', 'fallback' },
                ['<C-p>']     = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<C-b>']     = { 'scroll_documentation_up' },
                ['<C-f>']     = { 'scroll_documentation_down' },
            },
            appearance = {
                nerd_font_variant = 'mono'
            },
            completion = { documentation = { auto_show = true} },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.defaul" },

        config = function(_, opts)
            require('blink.cmp').setup(opts)

            -- enabled = function()
            --     return not vim.tbl_contains({ "markdown", "org", "text" , "norg"}, vim.bo.filetype)
            -- end,


            -- hide Copilot inline suggestions while Blink's menu is open
            -- local aug = vim.api.nvim_create_augroup('BlinkCopilotBridge', { clear = true })

            vim.api.nvim_create_autocmd('User', {
                group = aug,
                pattern = 'BlinkCmpMenuOpen',
                callback = function()
                    vim.b.copilot_suggestion_hidden = true
                end,
            })

            vim.api.nvim_create_autocmd('User', {
                group = aug,
                pattern = 'BlinkCmpMenuClose',
                callback = function()
                    vim.b.copilot_suggestion_hidden = false
                end,
            })
        end,




    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

},
}
