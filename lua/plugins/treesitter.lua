return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = { "lua", "python", "javascript", "typescript", "vim", "vimdoc", "query" },
                auto_install = true,

                highlight = { enable = true },
                indent = { enable = true },
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "lua", "python", "javascript", "typescript", "vim", "vimdoc", "query" },
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    },
}
