return {
    "airblade/vim-gitgutter",
    init = function()
        -- we dont want it to be too distracting
        -- vim.g.gitgutter_diff_base = "develop"
        vim.g.gitgutter_sign_added = "|"
        vim.g.gitgutter_sign_modified = "|"
        vim.g.gitgutter_sign_removed = "|"
        vim.g.gitgutter_sign_removed_first_line = "|"
        vim.g.gitgutter_sign_modified_removed = "|"
    end,
    config = function()
        -- make the colors bright!
        vim.cmd([[
      highlight! GitGutterAdd    guifg=#00ff00 guibg=NONE
      highlight! GitGutterChange guifg=#ffff00 guibg=NONE
      highlight! GitGutterDelete guifg=#ff0000 guibg=NONE
    ]])
    end,
}
