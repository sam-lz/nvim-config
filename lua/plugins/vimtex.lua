return {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release


    init = function()
        vim.g.vimtex_syntax_enabled = 0
        vim.g.vimtex_view_method = "skim"
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
}
