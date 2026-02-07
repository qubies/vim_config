return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    opts = {
        automatic_enable = true,
        ensure_installed = { "cspell_ls" },
    },
    config = function(_, opts)
        require("mason-lspconfig").setup(opts)

        if vim.lsp.config then
            vim.lsp.config("cspell_ls", {
                -- Force the LSP to attach even if there's no .git folder
                root_markers = { ".git", ".cspell.json", "package.json", "." },
                filetypes = { "lua", "python", "javascript", "typescript", "rust", "go" },
                settings = {
                    includeRegExpList = { "Everything" },
                    words = { "neovim", "renwickt", "ollama", "aerospace" },
                },
            })
            vim.lsp.enable("cspell_ls")
        end
    end,
}
