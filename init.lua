require("config.options")
require("config.lazy.lazy")
require("config.keybindings")



vim.cmd.colorscheme("ymir")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })


-- local function plain_pum()
--   vim.cmd([[
--   hi! clear PmenuSbar
--   hi! clear PmenuThumb]])
--   vim.api.nvim_set_hl(0, "Pmenu",       { bg = "NONE" })
--   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
-- end

-- plain_pum()
-- vim.api.nvim_create_autocmd("ColorScheme", { callback = plain_pum })


if vim.g.neovide then
    vim.o.guifont = "OverpassM Nerd Font Mono SemBd:h17"

    vim.g.neovide_cursor_animation_length = 0.0
    vim.g.neovide_scroll_animation_length = 0.0

    vim.g.neovide_fullscreen = false

    -- 4. MacOS Specific: Option Key Behavior
    -- If true, Option key acts as "Meta/Alt" (useful for keybinds).
    -- If false, it types special characters (e.g., £, ™).
    -- vim.g.neovide_input_macos_alt_is_meta = true
end
