-- Restore visual selection for CodeCompanion inline prompt
do
  local group = vim.api.nvim_create_augroup("CodeCompanionSelectionRestore", {})
  local saved_visual = nil
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionInlineStarted",
    group = group,
    callback = function()
      if vim.fn.mode():find("[vV\x16]") then
        saved_visual = { vim.fn.getpos("'<"), vim.fn.getpos("'>") }
      else
        saved_visual = nil
      end
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionInlineFinished",
    group = group,
    callback = function()
      if saved_visual then
        vim.fn.setpos("'<", saved_visual[1])
        vim.fn.setpos("'>", saved_visual[2])
        vim.cmd("normal! gv")
        saved_visual = nil
      end
    end,
  })
end

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      interactions = {
        chat = {
          adapter = "opencode",
        },
        cmd = {
          adapter = "opencode",
        },
        inline = {
          adapter="copilot", 
          keymaps = {
            accept_change = {
              modes = { n = "gda" }, -- Remember this as DiffAccept
            },
            reject_change = {
              modes = { n = "gdr" }, -- Remember this as DiffReject
            },
            always_accept = {
              modes = { n = "gdy" }, -- Remember this as DiffYolo
            },
          },
        },
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gpt-4.1",
              },
            },
          })
        end,
        opencode = function()
          return require("codecompanion.adapters").extend("opencode", {})
        end,
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
        },
        chat = {
          window = {
            layout = "vertical",
          },
          show_reasoning = true,
          fold_reasoning = false,
        },
        diff = {
          enabled = true,
          provider = "inline",
        },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "Code Companion Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Code Companion Chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>",            mode = { "n", "v" }, desc = "Code Companion Inline" },
      { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>",    mode = "v",          desc = "Add to Code Companion Chat" },
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
  },
}
