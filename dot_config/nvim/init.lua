-- Set leader key before lazy.nvim loads
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
