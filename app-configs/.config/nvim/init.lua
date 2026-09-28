vim.g.mapleader = " "

vim.keymap.set('n', '<Leader>e', ':Ex<CR>', { noremap = true, silent = true, desc = 'Open Netrw' })

-- Use the system clipboard for all yank/delete/paste, so copying in one
-- file and pasting in another (or in another app) just works with y/d/p
vim.opt.clipboard = 'unnamedplus'
vim.opt.swapfile = false

-- Explicit clipboard yank/paste shortcuts (handy if you ever turn the
-- 'unnamedplus' setting above off, or just want to be explicit)
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<Leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from system clipboard' })
vim.keymap.set('n', '<Leader>P', '"+P', { noremap = true, silent = true, desc = 'Paste before from system clipboard' })

require("config.options")
require("config.lazy")

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.opt.laststatus = 0
