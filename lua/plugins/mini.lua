return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        require("mini.basics").setup({
            options = { extra_ui = true, win_borders = "double" },
            autocommands = { relnum_in_visual_mode = true },
            mappings = { basic = true, option_toggle_prefix = [[\]] },
        })

        local ai = require("mini.ai")
        ai.setup({
            n_lines = 1000,
            custom_textobjects = {
                -- Using the gen_spec.treesitter helper correctly
                f = ai.gen_spec.treesitter({
                    a = "@function.outer",
                    i = "@function.inner",
                }),
                c = ai.gen_spec.treesitter({
                    a = "@class.outer",
                    i = "@class.inner",
                }),
                -- Your existing 'e' (entire buffer) object is fine
                e = function()
                    local n_lines = vim.api.nvim_buf_line_count(0)
                    return {
                        from = { line = 1, col = 1 },
                        to = { line = n_lines, col = math.max(vim.fn.getline(n_lines):len(), 1) },
                    }
                end,
            },
        })
        require("mini.surround").setup() -- add/change/delete surroundings
        require("mini.jump").setup() -- extend f/t to multiline
        require("mini.comment").setup() -- gc to comment
        require("mini.indentscope").setup() -- indent lines
        require("mini.files").setup({
            mappings = {
                go_in = "<CR>",
                go_out = "<Left>",
                go_up = "<Up>",
                go_down = "<Down>",
                go_in_plus = "<Right>",
            },
        }) -- lightweight file explorer
        require("mini.starter").setup({
            header = [[
,---,---,---,---,---,---,---,---,---,---,---,---,---,-------,
| ~ | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | [ | ] | <-    |
|---'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-----|
| ->| | Q | W | F | P | B | J | L | U | Y | : | / | = |  \  |
|-----',--',--',--',--',--',--',--',--',--',--',--',--'-----|
| Caps | A | R | S | T | G | M | N | E | I | O | ' |  Enter |
|------'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'--------|
|        | Z | X | C | D | V | K | H | , | . | ? |          |
footer = [[

BUILD

  ]],
        })
        local function set_statusline_highlights()
            local function gethl(name, fallback)
                local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
                if ok and hl and hl.foreground then
                    return string.format("#%06x", hl.foreground)
                end
                return fallback
            end
            vim.api.nvim_set_hl(0, "StatusLineMode", { fg = gethl("Constant", "#ea9a97"), bold = true })
            vim.api.nvim_set_hl(0, "StatusLineGit", { fg = gethl("Type", "#f6c177"), bold = true })
            vim.api.nvim_set_hl(0, "StatusLineFile", { fg = gethl("Function", "#9ccfd8"), bold = true })
            vim.api.nvim_set_hl(0, "StatusLineLoc", { fg = gethl("Special", "#e2e9ee"), bold = true })
            vim.api.nvim_set_hl(0, "StatusLineDiagError", { fg = gethl("Error", "#eb6f92"), bold = true })
            vim.api.nvim_set_hl(0, "StatusLineDiagWarn", { fg = gethl("WarningMsg", "#f6c177"), bold = true })
            vim.api.nvim_set_hl(0, "StatusLineDiagInfo", { fg = gethl("Identifier", "#9ccfd8"), bold = true })
            vim.api.nvim_set_hl(0, "StatusLineDiagHint", { fg = gethl("PreProc", "#c4a7e7"), bold = true })
        end
        set_statusline_highlights()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = set_statusline_highlights,
        })

        require("mini.statusline").setup({
            content = {
                active = function()
                    local s = require("mini.statusline")
                    -- Mode icon
                    local mode_icons = {
                        ["Normal"] = "",
                        ["Insert"] = "",
                        ["Visual"] = "",
                        ["V-Line"] = "",
                        ["V-Block"] = "",
                        ["Replace"] = "",
                        ["Command"] = "",
                        ["Terminal"] = "",
                    }
                    local mode = s.section_mode({ trunc_width = 120 })
                    local mode_name = vim.api.nvim_get_mode().mode
                    local mode_text = string.match(mode, "^%w+") or mode_name
                    local icon = mode_icons[mode_text] or ""
                    -- Git branch
                    local git = s.section_git({ trunc_width = 80 })
                    if git ~= "" then
                        git = " %#StatusLineGit# " .. git .. "%*"
                    end
                    local function diag_count(sev)
                        return #vim.diagnostic.get(0, { severity = sev })
                    end
                    local diag = ""
                    local err, warn, info, hint =
                        diag_count(vim.diagnostic.severity.ERROR),
                        diag_count(vim.diagnostic.severity.WARN),
                        diag_count(vim.diagnostic.severity.INFO),
                        diag_count(vim.diagnostic.severity.HINT)
                    if err > 0 then
                        diag = diag .. " %#StatusLineDiagError#" .. err .. "%*"
                    end
                    if warn > 0 then
                        diag = diag .. " %#StatusLineDiagWarn#" .. warn .. "%*"
                    end
                    if info > 0 then
                        diag = diag .. " %#StatusLineDiagInfo#" .. info .. "%*"
                    end
                    if hint > 0 then
                        diag = diag .. " %#StatusLineDiagHint#" .. hint .. "%*"
                    end
                    if #diag > 0 then
                        diag = " " .. diag
                    end
                    -- File info
                    local file = s.section_filename({ trunc_width = 140 })
                    if file ~= "" then
                        file = " %#StatusLineFile# " .. file .. "%*"
                    end
                    -- Show only filetype (not encoding/filesize)
                    local filetype = vim.bo.filetype
                    local fileinfo = ""
                    if filetype and filetype ~= "" then
                        fileinfo = " %#StatusLineFile# " .. filetype .. "%*"
                    end
                    -- Line/column/location group with icons & color
                    local lnum = vim.api.nvim_win_get_cursor(0)[1]
                    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
                    local total = vim.fn.line("$")
                    local location = string.format(" %%#StatusLineLoc#│  %d/%d  %d %%*", lnum, total, col)
                    -- Compose statusline: left %=% right
                    local left = table.concat({
                        "%#StatusLineMode#" .. icon .. " " .. mode .. "%*",
                        git,
                        diag,
                        file,
                        fileinfo,
                    }, " ")
                    local right = location
                    return left .. "%=%" .. right
                end,
            },
        }) -- pretty statusline with icons
        require("mini.move").setup()
        require("mini.operators").setup()
        require("mini.splitjoin").setup()
        require("mini.completion").setup()
        require("mini.tabline").setup()
        require("mini.icons").setup()
        require("mini.bufremove").setup()

        -- Keymaps for mini.completion to use Tab for select and Enter to confirm
        vim.keymap.set("i", "<Tab>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-n>"
            else
                return "<Tab>"
            end
        end, { expr = true, noremap = true })
        vim.keymap.set("i", "<S-Tab>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-p>"
            else
                return "<S-Tab>"
            end
        end, { expr = true, noremap = true })
        vim.keymap.set("i", "<CR>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-y>"
            else
                return "<CR>"
            end
        end, { expr = true, noremap = true })
    end,
}
