-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
--
--

-- vim.o.title = true
vim.o.winblend = 0
vim.o.pumblend = 0

vim.o.cursorline = true
vim.o.cursorlineopt = "line"
local grp = vim.api.nvim_create_augroup("CursorLineActiveOnly", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = grp,
  callback = function() vim.wo.cursorline = true end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  group = grp,
  callback = function() vim.wo.cursorline = false end,
})

vim.o.title = true

vim.opt.cmdheight = 1
-- if vim.fn.has("nvim-0.8") == 1 then
-- 	vim.opt.cmdheight = 0
-- end

vim.o.winborder = "rounded"
-- vim.o.winblend = 10
-- vim.o.scroll = 15
-- vim.opt_global.scroll = 6

vim.o.foldmethod = 'indent'
vim.o.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.o.number = true
vim.o.relativenumber = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.wrap = false

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.opt.smarttab = true
vim.o.smartindent = true
vim.opt.breakindent = true

-- synchronizes system clipboard
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

vim.o.scrolloff = 999     -- 15

-- place cursor where there is no text
vim.o.virtualedit = "block"

vim.o.inccommand = "split"

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true

vim.o.shortmess = "ltToOCFI"

vim.o.mouse = 'a'

vim.o.undofile = true

vim.o.confirm = true

vim.o.wrap = false

vim.o.hlsearch = false
vim.o.incsearch = true

-- vim.o.updatetime = 50
-- vim.o.colorcolumn = "80"

vim.diagnostic.config({

    -- virtual_lines = true,
    virtual_text = true,

})

vim.o.conceallevel = 2

vim.o.showmode = false


vim.o.laststatus = 3
-- vim.o.statusline = " %{%mode(1)%} %f%m %= %y %p%% %l:%c "
-- vim.o.statusline = " %{%mode(1)%} %f%m %= %y %l:%c "
--
-- vim.o.statusline = " %f%m %= %y %l:%c "
-- vim.o.statusline = " %f%m %= %{&ff} %y %l:%c "
-- vim.o.statusline = " %f%m %= %{&fenc != '' ? &fenc : &enc}%{&bomb?'+BOM':''} %{&ff} %y %l:%c "


-- vim.o.statusline = " %f%m %= %y %{&fenc != '' ? &fenc : &enc}%{&bomb?'+BOM':''} %{&ff} %l:%c "
-- vim.o.statusline = " %{fnamemodify(getcwd(),':h:t').'/'.fnamemodify(getcwd(),':t')} %f%m %= %y %{&fenc != '' ? &fenc : &enc}%{&bomb?'+BOM':''} %{&ff} %l:%c "
vim.o.statusline = " %{get(b:,'gitsigns_head','') != '' ? (b:gitsigns_head.' ') : ''}%{fnamemodify(getcwd(),':h:t').'/'.fnamemodify(getcwd(),':t')} %f%m %= %y %{&fenc != '' ? &fenc : &enc}%{&bomb?'+BOM':''} %{&ff} %l:%c "

-- branch for *current working directory* (not current buffer)
_G._stl_cwd = nil
_G._stl_cwd_branch = ""

_G.update_cwd_branch = function()
  local cwd = vim.fn.getcwd()
  if cwd == _G._stl_cwd then return end
  _G._stl_cwd = cwd

  local out = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" })
  if vim.v.shell_error == 0 and out[1] and out[1] ~= "" and out[1] ~= "HEAD" then
    _G._stl_cwd_branch = out[1] .. " "
  else
    _G._stl_cwd_branch = ""
  end

  vim.cmd("redrawstatus")
end

_G.stl_cwd_branch = function()
  return _G._stl_cwd_branch
end

-- vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
--   callback = function() _G.update_cwd_branch() end,
-- })

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "FocusGained", "TermClose" }, {
  callback = function() _G.update_cwd_branch() end,
})

vim.api.nvim_create_autocmd({ "ShellCmdPost" }, {
  callback = function() _G.update_cwd_branch() end,
})


vim.o.statusline = " %{%v:lua.stl_cwd_branch()%}%{fnamemodify(getcwd(),':h:t').'/'.fnamemodify(getcwd(),':t')} %f%m %= %y %{&fenc != '' ? &fenc : &enc}%{&bomb?'+BOM':''} %{&ff} %l:%c "
-- vim.o.statusline = " %f%m %= %y %{&fenc != '' ? &fenc : &enc}%{&bomb?'+BOM':''} %{&ff} %l:%c %{strftime('%H:%M')} "














