return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd.colorscheme("rose-pine")

            -- Apply transparency
            vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
            -- Change the visual highlight color to be more obvious
            vim.api.nvim_set_hl(0, "Visual", { bg = "orange", fg = "black" })
        end,
    },
}
