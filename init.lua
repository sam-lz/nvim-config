require("config.options")
require("config.lazy.lazy")
require("config.keybindings")

vim.opt.signcolumn = "no"

vim.cmd.colorscheme("vague")

-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#8a8a8a" })
-- vim.cmd("hi! StatusLine guifg=#000000 ctermfg=0 gui=bold cterm=bold")

-- highlight: 188 188 188
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
-- vim.api.nvim_set_hl(0, "Visual", { bg = "#bcbcbc", fg = "#000000" })







if vim.g.neovide then
  vim.o.guifont = "OverpassM Nerd Font Mono SemBd:h16"
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_scroll_animation_length = 0.0
  vim.g.neovide_fullscreen = false
end
