return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- Load on these events so parsers are ready when you open a file
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- The New Way: Direct setup on the main module
            require("nvim-treesitter").setup({
                -- This is what you asked for: Automatic installation
                ensure_installed = { "lua", "python", "javascript", "typescript", "vim", "vimdoc", "query" },
                auto_install = true,

                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
}
