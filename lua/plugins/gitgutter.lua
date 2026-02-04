return {
  'airblade/vim-gitgutter',
  init = function()
    vim.g.gitgutter_diff_base = 'develop'
    vim.g.gitgutter_sign_added = '|'
    vim.g.gitgutter_sign_modified = '|'
    vim.g.gitgutter_sign_removed = '|'
    vim.g.gitgutter_sign_removed_first_line = '|'
    vim.g.gitgutter_sign_modified_removed = '|'
  end,
  config = function()
    vim.cmd [[
      highlight! GitGutterAdd    guifg=#00ff44 guibg=NONE
      highlight! GitGutterChange guifg=#00ccff guibg=NONE
      highlight! GitGutterDelete guifg=#ff0066 guibg=NONE
    ]]
    -- TIP: If you see marker overlap with LSP, try :set signcolumn=auto:2
  end,
}
