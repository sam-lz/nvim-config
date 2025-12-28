require("config.options")
require("config.lazy.lazy")
require("config.keybindings")


vim.cmd.colorscheme("ymir")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

-- require("e-ink").setup()
-- vim.cmd.colorscheme("e-ink")

-- choose light mode or dark mode
-- vim.opt.background = "dark"
-- vim.opt.background = "light"
--
-- or do
-- :set background=dark
-- :set background=light
-- transparency
-- local set_hl = vim.api.nvim_set_hl
-- local mono = require("e-ink.palette").mono()

-- -- transparent only when `:set background=dark`
-- if vim.o.background == "dark" then
--    set_hl(0, "Normal", { fg = mono[12], bg = "NONE" })
-- end

if vim.g.neovide then
  vim.o.guifont = "OverpassM Nerd Font Mono SemBd:h16"
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_scroll_animation_length = 0.0
  vim.g.neovide_fullscreen = false
end
