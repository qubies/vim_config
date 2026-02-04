return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      -- Set the colorscheme
      vim.cmd.colorscheme("rose-pine")

      -- Apply transparency after colorscheme
      vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#3E4A5B", fg = "NONE" })


    end,
  },
}
