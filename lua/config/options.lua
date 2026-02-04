-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- vim.g.lazyvim_python_lsp = "pyright"
vim.o.title = true
vim.opt.clipboard = "" -- turn off clipboard copy
vim.opt.relativenumber = false

vim.opt.swapfile = false

-- Python debugging
-- vim.g.python3_host_prog = "~/.virtualenvs/debugpy/bin/python"

-- Always show two sign columns for LSP and gitgutter
vim.opt.signcolumn = "auto:5"

-- Disable LSP diagnostic signs in signcolumn, use Trouble.nvim for diagnostics UI
vim.diagnostic.config({
  signs = false,
  underline = true,
  virtual_text = true,
  update_in_insert = false,
})

