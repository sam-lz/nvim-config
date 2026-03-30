vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, buffer = true })

vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, buffer = true })
