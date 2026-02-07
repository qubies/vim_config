return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "diff",
                    "html",
                    "javascript",
                    "jsdoc",
                    "json",
                    "jsonc",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "printf",
                    "python",
                    "query",
                    "regex",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "xml",
                    "yaml",
                },
                auto_install = true,

                highlight = { enable = true },
                indent = { enable = true },
                folds = { enable = true },
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
