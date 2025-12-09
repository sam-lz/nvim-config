require("config.options")
require("config.lazy.lazy")
require("config.keybindings")

-- vim.schedule(function()
--   vim.notify = function() end
-- end)



-- set theme 
vim.cmd.colorscheme("vague")
-- solarized-osaka
-- vague


-- enable transparency (set before colorscheme)
-- vim.g.adventure_transparent = true

-- -- load theme
vim.cmd.colorscheme("adventure")

vim.cmd.colorscheme("vague")
-- apply lualine theme
require("lualine").setup {
    options = {
        theme = _G.adventure_lualine,
    }
}
vim.api.nvim_set_hl(0, "Visual",   { fg = "#feffff", bg = "#606060" })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#040404", bg = "#97d7ef" })



local function plain_pum()
  vim.cmd([[
  hi! clear PmenuSbar
  hi! clear PmenuThumb]])
  vim.api.nvim_set_hl(0, "Pmenu",       { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
end

plain_pum()
vim.api.nvim_create_autocmd("ColorScheme", { callback = plain_pum })
