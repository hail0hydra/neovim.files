require('nvim-treesitter.configs').setup {
    ensure_installed = { 'vim', 'vimdoc', 'lua', 'cpp', 'javascript', 'markdown', 'python', 'c', 'html', 'go', 'json'},

    sync_install = false,

    auto_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },

    indent = { enable = true },
}
