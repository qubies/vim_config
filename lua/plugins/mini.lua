return {
'nvim-mini/mini.nvim', version = false, 
config = function()
    -- Recommended: basics & performance
    require("mini.basics").setup({
      options = { extra_ui = true, win_borders = "double" },
      autocommands = { relnum_in_visual_mode = true },
      mappings = { basic = true, option_toggle_prefix = [[\]] },
    })

    require("mini.ai").setup({ n_lines = 500 })
    require("mini.surround").setup()        -- add/change/delete surroundings
    require("mini.comment").setup()         -- gc to comment
    require("mini.files").setup({
      mappings = {
        go_in  = "<CR>",
        go_out = "<Left>",
        go_up  = "<Up>",
        go_down = "<Down>",
        go_in_plus = "<Right>",
      }
    })           -- lightweight file explorer
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
|------,-',--'--,'---'---'---'---'---'---'-,-'---',--,------|
| ctrl |  | alt |                          | alt  |  | ctrl |
'------'  '-----'--------------------------'------'  '------'
                      WUt wE Do?!
  ]],
  footer = [[

Type :q to quit, or <Space> to open menu!
Have a great day hacking!

  ]],
})
    -- Function to set highlights, using rose-pine palette if present
    local function set_statusline_highlights()
      local function gethl(name, fallback)
        local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
        if ok and hl and hl.foreground then
          return string.format("#%06x", hl.foreground)
        end
        return fallback
      end
      vim.api.nvim_set_hl(0, "StatusLineMode", { fg = gethl('Constant', '#ea9a97'), bold = true })
      vim.api.nvim_set_hl(0, "StatusLineGit", { fg = gethl('Type', '#f6c177'), bold = true })
      vim.api.nvim_set_hl(0, "StatusLineFile", { fg = gethl('Function', '#9ccfd8'), bold = true })
      vim.api.nvim_set_hl(0, "StatusLineLoc", { fg = gethl('Special', '#e2e9ee'), bold = true })
      vim.api.nvim_set_hl(0, "StatusLineDiagError", { fg = gethl('Error', '#eb6f92'), bold = true })
      vim.api.nvim_set_hl(0, "StatusLineDiagWarn", { fg = gethl('WarningMsg', '#f6c177'), bold = true })
      vim.api.nvim_set_hl(0, "StatusLineDiagInfo", { fg = gethl('Identifier', '#9ccfd8'), bold = true })
      vim.api.nvim_set_hl(0, "StatusLineDiagHint", { fg = gethl('PreProc', '#c4a7e7'), bold = true })
    end
    set_statusline_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = set_statusline_highlights,
    })

    require("mini.statusline").setup({
      content = {
        active = function()
          local s = require('mini.statusline')
          -- Mode icon
          local mode_icons = {
            ['Normal']   = '',
            ['Insert']   = '',
            ['Visual']   = '',
            ['V-Line']   = '',
            ['V-Block']  = '',
            ['Replace']  = '',
            ['Command']  = '',
            ['Terminal'] = '',
          }
          local mode = s.section_mode({ trunc_width = 120 })
          local mode_name = vim.api.nvim_get_mode().mode
          local mode_text = string.match(mode, '^%w+') or mode_name
          local icon = mode_icons[mode_text] or ''
          -- Git branch
          local git = s.section_git({ trunc_width = 80 })
          if git ~= '' then
            git = ' %#StatusLineGit# ' .. git .. '%*'
          end
          -- Diagnostics: build each count (errors, warnings, info, hints) with highlights and icons
          -- Robust diagnostics count for all Neovim versions
          local function diag_count(sev) return #vim.diagnostic.get(0, { severity = sev }) end
          local diag = ''
          local err, warn, info, hint = diag_count(vim.diagnostic.severity.ERROR), diag_count(vim.diagnostic.severity.WARN), diag_count(vim.diagnostic.severity.INFO), diag_count(vim.diagnostic.severity.HINT)
          if err > 0 then diag = diag .. ' %#StatusLineDiagError#' .. err .. '%*' end
          if warn > 0 then diag = diag .. ' %#StatusLineDiagWarn#' .. warn .. '%*' end
          if info > 0 then diag = diag .. ' %#StatusLineDiagInfo#' .. info .. '%*' end
          if hint > 0 then diag = diag .. ' %#StatusLineDiagHint#' .. hint .. '%*' end
          if #diag > 0 then diag = ' ' .. diag end
          -- File info
          local file = s.section_filename({ trunc_width = 140 })
          if file ~= '' then file = ' %#StatusLineFile# ' .. file .. '%*' end
          -- Show only filetype (not encoding/filesize)
          local filetype = vim.bo.filetype
          local fileinfo = ''
          if filetype and filetype ~= '' then fileinfo = ' %#StatusLineFile# ' .. filetype .. '%*' end
          -- Line/column/location group with icons & color
          local lnum = vim.api.nvim_win_get_cursor(0)[1]
          local col = vim.api.nvim_win_get_cursor(0)[2] + 1
          local total = vim.fn.line('$')
          local location = string.format(' %%#StatusLineLoc#│  %d/%d  %d %%*', lnum, total, col)
          -- Compose statusline: left %=% right
          local left = table.concat({
            '%#StatusLineMode#' .. icon .. ' ' .. mode .. '%*',
            git,
            diag,
            file,
            fileinfo
          }, ' ')
          local right = location
          return left .. '%=%' .. right
        end,
      },
    })      -- pretty statusline with icons
    require("mini.move").setup()
    require("mini.operators").setup()
    require("mini.splitjoin").setup()
    require("mini.completion").setup()
    require("mini.tabline").setup()

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

    -- Optional: icons (if you want glyphs in mini.files, etc.)
    -- require("mini.icons").setup()

    -- Example keymaps you might like:
    local map = vim.keymap.set
    map("n", "-", function() require("mini.files").open(vim.api.nvim_buf_get_name(0)) end,
      { desc = "MiniFiles (directory of current file)" })
    map("n", "<leader>e", function() require("mini.files").open() end, { desc = "MiniFiles (cwd)" })

    -- LSP operations with <leader>c keys
    map('n', '<leader>cr', require('telescope.builtin').lsp_references, { desc = 'LSP: References (calls to symbol)' })
    map('n', '<leader>cd', require('telescope.builtin').lsp_definitions, { desc = 'LSP: Definition' })
    map('n', '<leader>ci', require('telescope.builtin').lsp_implementations, { desc = 'LSP: Implementation' })
    map('n', '<leader>ct', require('telescope.builtin').lsp_type_definitions, { desc = 'LSP: Type Definition' })
    map('n', '<leader>cn', vim.lsp.buf.rename, { desc = 'LSP: Rename Symbol' })
    map('n', '<leader>ch', vim.lsp.buf.hover, { desc = 'LSP: Hover Doc' })
    map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: Code Action' })

    -- Buffer operations with <leader>b keys
    map('n', '<leader>bb', '<cmd>buffer #<cr>', { desc = 'Switch to last buffer' })
    map('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
    map('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
    map('n', '<leader>bl', function()
      require('telescope.builtin').buffers {
        sort_mru = true,
        sort_lastused = true,
        previewer = false,
        ignore_current_buffer = false,
        entry_maker = function(entry)
          local bufname = vim.fn.bufname(entry.bufnr)
          local basename = vim.fn.fnamemodify(bufname, ':t')
          if basename == "" then basename = "[No Name]" end
          return {
            value = entry,
            ordinal = tostring(entry.bufnr) .. " " .. basename,
            display = tostring(entry.bufnr) .. " " .. basename,
            bufnr = entry.bufnr,
          }
        end,
      }
    end, { desc = 'List and jump to buffer (Telescope: no flags)' })
    map('n', '<leader>bk', function() require('mini.bufremove').delete(0, false) end, { desc = 'Kill (close) buffer' })
    map('n', '<leader>bd', function()
      local cur = vim.api.nvim_get_current_buf()
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if b ~= cur and vim.api.nvim_buf_is_loaded(b) then
          require('mini.bufremove').delete(b, false)
        end
      end
    end, { desc = 'Delete all but current buffer' })

  end,
}

