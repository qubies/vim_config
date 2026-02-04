return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        telescope.setup({
            defaults = {
                vimgrep_arguments = {
                    'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'
                },
                file_ignore_patterns = { "node_modules", ".git/" },
                layout_strategy = "flex",
                layout_config = {
                  flex = { flip_columns = 140 },
                  horizontal = { preview_width = 0.55 },
                  vertical = { preview_height = 0.4 },
                  width = 0.95,
                  height = 0.65,
                  prompt_position = "top",
                },
                sorting_strategy = "ascending",
                borderchars = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },
                prompt_prefix = "   ",
                selection_caret = " ",
                entry_prefix = "  ",
                results_title = "",
                prompt_title = "",
                preview_title = "",
                winblend = 8,
                color_devicons = true,
            },
            pickers = {
                find_files = {
                    find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix' },
                },
                buffers = {
                  sort_mru = true,
                  previewer = false,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })


        pcall(telescope.load_extension, 'fzf')
        -- Keymaps
        local map = vim.keymap.set
        map('n', '<leader>fa', require('telescope.builtin').find_files, { desc = 'Find Files (fd)' })
        map('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Grep with rg' })
        map('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Buffers' })
        map('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help Tags' })
        map('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = 'Recent Files' })
        map('n', '<leader>fm', require('telescope.builtin').marks, { desc = 'Marks' })
        map('n', '<leader>fk', require('telescope.builtin').keymaps, { desc = 'Keymaps' })
        map('n', '<leader>ff', require('telescope.builtin').git_files, { desc = 'Git Files' })
map('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = 'Diagnostics (Telescope)' })
    end
}
