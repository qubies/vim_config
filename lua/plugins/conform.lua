return {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- Runs before the buffer is written
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                -- Use specific formatters for different filetypes (e.g., stylua for lua)
                lua = { "stylua" },
                python = { "black", "isort" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true, -- Fallback to LSP formatting if no other formatter is found
            },
        })
    end,
}

