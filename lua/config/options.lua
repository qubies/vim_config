vim.o.title = true
vim.opt.clipboard = "" -- turn off clipboard copy
vim.opt.relativenumber = false -- dont like relative
vim.opt.swapfile = false -- swapfiles are dumb
vim.opt.signcolumn = "auto:5" -- make signs column wider if needed
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

-- Disable LSP diagnostic signs in signcolumn
vim.diagnostic.config({
    signs = false,
    underline = true,
    virtual_text = true,
    update_in_insert = false,
})
