
-- general
ufovim.log.level = "warn"
ufovim.format_on_save = true
ufovim.colorscheme = "github_dark_default"

-- keymappings [view all the defaults by pressing <leader>Lk]
ufovim.leader = "space"
-- add your own keymapping
ufovim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- ufovim.keys.normal_mode["<C-Up>"] = ""


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen ufovim, Run :PackerInstall :PackerCompile
ufovim.builtin.dashboard.active = true
ufovim.builtin.terminal.active = true
ufovim.builtin.nvimtree.setup.view.side = "left"
ufovim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
ufovim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
}

ufovim.builtin.treesitter.ignore_install = { "haskell" }
ufovim.builtin.treesitter.highlight.enabled = true


-- Additional Plugins Example
-- ufovim.plugins = {
--     {"userGit/pluyginExample.nvim"},
--     {"folke/tokyonight.nvim"},

