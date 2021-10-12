vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_filetype_exclude = {
    "help",
    "terminal",
    "dashboard",
    "packer",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
}

vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guibg=#2c1517 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#3e2e1e gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guibg=#1e2718 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guibg=#27182C gui=nocombine]]


vim.opt.list = true
vim.opt.listchars = {
    space = "⋅",
}

require("indent_blankline").setup {
    char = "⋅",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
    },
    space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
    },
    space_char_blankline_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
    },
    show_trailing_blankline_indent = false,
}
