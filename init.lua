require("config.options")
require("config.lazy.lazy")
require("config.keybindings")

vim.opt.signcolumn = "no"

vim.cmd.colorscheme("flexoki")

-- flexoki-dark
-- yellowbeans
-- vague

-- transparency 
-- vim.cmd('hi Normal guibg=NONE ctermbg=NONE')


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



vim.api.nvim_create_autocmd("User", {
  pattern = "MoltenOutput",
  callback = function()
    vim.schedule(function()
      vim.cmd("redrawstatus")
    end)
  end,
})

-- local function to_rgb_osc(color)
--   local r = math.floor(color / 0x10000) % 0x100
--   local g = math.floor(color / 0x100) % 0x100
--   local b = color % 0x100
--   return string.format("rgb:%02x/%02x/%02x", r, g, b)
-- end

-- local terminal_bg_group = vim.api.nvim_create_augroup("SyncTerminalBackground", { clear = true })
-- local terminal_bg_state = {
--   applied = nil,
-- }

-- local function has_stdout_tty()
--   for _, ui in ipairs(vim.api.nvim_list_uis()) do
--     if ui.stdout_tty then
--       return true
--     end
--   end

--   return false
-- end

-- local function term_write(seq)
--   if vim.g.neovide then
--     return false
--   end

--   if not has_stdout_tty() then
--     return false
--   end

--   if vim.env.TMUX then
--     seq = "\x1bPtmux;" .. seq:gsub("\x1b", "\x1b\x1b") .. "\x1b\\"
--   end

--   local ok = pcall(function()
--     io.stdout:write(seq)
--     io.stdout:flush()
--   end)

--   return ok
-- end

-- local function write_osc(code)
--   return term_write("\x1b]" .. code .. "\x07")
-- end

-- local function get_bg(name)
--   local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
--   if ok and hl and hl.bg then
--     return hl.bg
--   end

--   ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
--   if ok and hl and hl.bg then
--     return hl.bg
--   end
-- end

-- local function current_terminal_bg()
--   return get_bg("Normal")
-- end

-- local function set_terminal_bg(bg)
--   return write_osc("11;" .. to_rgb_osc(bg))
-- end

-- local function reset_terminal_bg()
--   terminal_bg_state.applied = nil
--   return write_osc("111")
-- end

-- local function sync_terminal_bg()
--   local bg = current_terminal_bg()
--   if not bg then
--     reset_terminal_bg()
--     return
--   end

--   if terminal_bg_state.applied == bg then
--     return
--   end

--   if set_terminal_bg(bg) then
--     terminal_bg_state.applied = bg
--   end
-- end

-- local function schedule_terminal_bg_sync()
--   vim.schedule(sync_terminal_bg)
-- end

-- vim.api.nvim_create_autocmd({ "UIEnter", "VimEnter", "ColorScheme" }, {
--   group = terminal_bg_group,
--   callback = schedule_terminal_bg_sync,
-- })

-- vim.api.nvim_create_autocmd("OptionSet", {
--   group = terminal_bg_group,
--   pattern = "background",
--   callback = schedule_terminal_bg_sync,
-- })

-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   group = terminal_bg_group,
--   callback = reset_terminal_bg,
-- })

if vim.g.neovide then
  -- vim.cmd.colorscheme("vague")
  vim.o.guifont = "OverpassM Nerd Font Mono SemBd:h16"
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_scroll_animation_length = 0.0
  vim.g.neovide_fullscreen = false
end
