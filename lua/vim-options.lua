vim.g.mapleader = " "
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.cmd("set nu")
vim.cmd("setlocal spell spelllang=en_us")
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { remap = true })

