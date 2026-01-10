require("config.options")
require("config.lazy.lazy")
require("config.keybindings")

vim.opt.signcolumn = "no"

vim.cmd.colorscheme("yorumi")

-- vim.cmd("hi! StatusLine gui=bold cterm=bold")

-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#8a8a8a" })
-- vim.cmd("hi! StatusLine guifg=#000000 ctermfg=0 gui=bold cterm=bold")
-- highlight: 188 188 188
-- vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
-- vim.api.nvim_set_hl(0, "Visual", { bg = "#bcbcbc", fg = "#000000" })

-- fixes yazi looking ugly(use terminal colors)
for i = 0, 15 do
  vim.g["terminal_color_" .. i] = nil
end

-- yazi fix reloading on coloscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for i = 0, 15 do
      vim.g["terminal_color_" .. i] = nil
    end
  end,
})



if vim.g.neovide then
  -- vim.cmd.colorscheme("vague")
  vim.o.guifont = "OverpassM Nerd Font Mono SemBd:h16"
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_scroll_animation_length = 0.0
  vim.g.neovide_fullscreen = false
end
