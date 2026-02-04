return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        position = "left",
        width = 32,
      },
      filesystem = {
        follow_current_file = { enabled = true }
      },
      buffers = { follow_current_file = true },
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      enable_git_status = true,
      enable_diagnostics = true,
    })
    local map = vim.keymap.set
    map('n', '<leader>fe', '<cmd>Neotree toggle left<cr>', { desc = 'File Explorer (neo-tree)' })
  end,
}
