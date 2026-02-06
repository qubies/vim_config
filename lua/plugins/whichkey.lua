return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function()
        local wk = require("which-key")

        wk.add({
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        })

        wk.add({
            { "<leader>f", group = "Find/Files" },
            { "<leader>fa", require("telescope.builtin").find_files, desc = "Find Files (fd)" },
            { "<leader>ff", require("telescope.builtin").git_files, desc = "Git Files" },
            { "<leader>fg", require("telescope.builtin").live_grep, desc = "Grep with rg" },
            { "<leader>fh", require("telescope.builtin").help_tags, desc = "Help Tags" },
            { "<leader>fe", "<cmd>Neotree toggle left<cr>", desc = "File Explorer (neo-tree)" },
            { "<leader>fb", require("telescope.builtin").buffers, desc = "Buffers" },
            { "<leader>fd", require("telescope.builtin").diagnostics, desc = "Diagnostics (Telescope)" },
            { "<leader>fm", require("telescope.builtin").marks, desc = "Marks" },
            { "<leader>fk", require("telescope.builtin").keymaps, desc = "Keymaps" },
            { "<leader>fr", require("telescope.builtin").oldfiles, desc = "Recent Files" },
        })

        wk.add({
            { "<leader>c", group = "Code/LSP" },
            { "<leader>cr", require("telescope.builtin").lsp_references, desc = "LSP: References" },
            { "<leader>cd", require("telescope.builtin").lsp_definitions, desc = "LSP: Definition" },
            { "<leader>ci", require("telescope.builtin").lsp_implementations, desc = "LSP: Implementation" },
            { "<leader>ct", require("telescope.builtin").lsp_type_definitions, desc = "LSP: Type Definition" },
            { "<leader>cn", vim.lsp.buf.rename, desc = "LSP: Rename Symbol" },
            { "<leader>ch", vim.lsp.buf.hover, desc = "LSP: Hover Doc" },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "LSP: Code Action" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions/References",
            },
            {
                "<leader>cg",
                function()
                    vim.ui.input({ prompt = "Git Base: " }, function(input)
                        if input then
                            vim.g.gitgutter_diff_base = input
                        end
                    end)
                end,
                desc = "Git gutter set base",
            },
        })

        wk.add({
            { "<leader>b", group = "Buffer" },
            { "<leader>bb", "<cmd>buffer #<cr>", desc = "Switch to last buffer" },
            { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous buffer" },
            { "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" },
            {
                "<leader>bl",
                function()
                    require("telescope.builtin").buffers({
                        sort_mru = true,
                        sort_lastused = true,
                        previewer = false,
                        ignore_current_buffer = false,
                        entry_maker = function(entry)
                            local bufname = vim.fn.bufname(entry.bufnr)
                            local basename = vim.fn.fnamemodify(bufname, ":t")
                            if basename == "" then
                                basename = "[No Name]"
                            end
                            return {
                                value = entry,
                                ordinal = tostring(entry.bufnr) .. " " .. basename,
                                display = tostring(entry.bufnr) .. " " .. basename,
                                bufnr = entry.bufnr,
                            }
                        end,
                    })
                end,
                desc = "List and jump to buffer",
            },
            {
                "<leader>bk",
                function()
                    require("mini.bufremove").delete(0, false)
                end,
                desc = "Kill (close) buffer",
            },
            {
                "<leader>bd",
                function()
                    local cur = vim.api.nvim_get_current_buf()
                    for _, b in ipairs(vim.api.nvim_list_bufs()) do
                        if b ~= cur and vim.api.nvim_buf_is_loaded(b) then
                            require("mini.bufremove").delete(b, false)
                        end
                    end
                end,
                desc = "Delete all but current buffer",
            },
        })

        wk.add({
            {
                "-",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0))
                end,
                desc = "MiniFiles (current file dir)",
            },
            {
                "<leader>e",
                function()
                    require("mini.files").open()
                end,
                desc = "MiniFiles (cwd)",
            },
        })

        wk.add({
            { "<leader>x", group = "Trouble/Diagnostics" },
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
        })

        wk.add({
            { "<leader>a", group = "AI/Code Companion" },
            { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "Code Companion Actions", mode = { "n", "v" } },
            { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Code Companion Chat", mode = { "n", "v" } },
            { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "Code Companion Inline", mode = { "n", "v" } },
            { "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to Chat", mode = "v" },
        })
        wk.add({
            { "<leader>G", group = "Git/vcs" },
            {
                "<leader>Gr",
                "<Cmd>lua MiniGit.show_range_history()<CR>",
                desc = "shows how certain line range evolved",
                mode = { "n", "v" },
            },
            {
                "<leader>Gd",
                "<Cmd>lua MiniGit.show_diff_source()<CR>",
                desc = "shows file state as it was at diff entry",
                mode = { "n", "v" },
            },
            {
                "<leader>Gc",
                "<Cmd>lua MiniGit.show_at_cursor()<CR>",
                desc = "shows Git related data depending on context",
                mode = { "n", "v" },
            },
        })
    end,
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
