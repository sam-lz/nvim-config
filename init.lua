require("config.options")
require("config.lazy.lazy")
require("config.keybindings")

-- vim.schedule(function()
--   vim.notify = function() end
-- end)



-- set theme 
vim.cmd.colorscheme("yorumi-dusk")
-- solarized-osaka
-- iceclimber
-- kanagawa-paper
-- yorumi
-- gyokuro
-- hojicha
-- iceclimber
-- monalisa
--

-- vim.cmd([[
  -- cnoreabbrev git Git
  -- cnoreabbrev gdiffsplit Gdiffsplit
  -- cnoreabbrev gblame Git blame
-- ]])



-- vim.api.nvim_create_autocmd('VimEnter', {
--   once = true,
--   callback = function()
--     if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == '' then
--       vim.opt_local.modifiable = false
--       vim.opt_local.readonly = true
--       vim.bo.buftype = 'nofile'
--       vim.bo.bufhidden = 'wipe'
--       vim.bo.swapfile = false

--       local b = 0
--       vim.b.is_intro = true
--       for _, k in ipairs({ 'i','I','a','A','o','O','s','S','c','C','r','R' }) do
--           vim.keymap.set('n', k, '<Nop>', { buffer = b, silent = true, nowait = true })
--       end
--       vim.api.nvim_create_autocmd('InsertEnter', {
--           buffer = b,
--           callback = function()
--               if vim.b.is_intro then vim.cmd('stopinsert') end
--           end,
--       })

--     end
--   end,
-- })




local function plain_pum()
  -- vim.o.pumblend = 20
  -- vim.o.winblend = 20
  vim.cmd([[
  hi! clear PmenuSbar
  hi! clear PmenuThumb]])
  vim.api.nvim_set_hl(0, "Pmenu",       { bg = "NONE" })
  -- vim.api.nvim_set_hl(0, "PmenuSel",    { bg = "NONE", reverse = true })
  -- vim.api.nvim_set_hl(0, "PmenuSbar",   { bg = "NONE", fg = "NONE" })
  -- vim.api.nvim_set_hl(0, "PmenuThumb",  { bg = "NONE", fg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

  -- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "NONE", bg = "NONE" })
  -- for _, g in ipairs({
  --   "CmpBorder", "NoicePopupBorder", "TelescopeBorder",
  --   "LspInfoBorder", "WhichKeyBorder",
  -- }) do
  --   vim.api.nvim_set_hl(0, g, { fg = "NONE", bg = "NONE" })
  -- end
end

plain_pum()
vim.api.nvim_create_autocmd("ColorScheme", { callback = plain_pum })
