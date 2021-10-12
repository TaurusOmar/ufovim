if os.getenv "UFOVIM_RUNTIME_DIR" then
  local path_sep = vim.loop.os_uname().version:match "Windows" and "\\" or "/"
  vim.opt.rtp:append(os.getenv "UFOVIM_RUNTIME_DIR" .. path_sep .. "ufovim")
end

require("ufovim.bootstrap"):init()

require("ufovim.config"):load()

local plugins = require "ufovim.plugins"
require("ufovim.plugin-loader"):load { plugins, ufovim.plugins }

local Log = require "ufovim.core.log"
Log:debug "Starting UfoVim"

vim.g.colors_name = ufovim.colorscheme -- Colorscheme must get called after plugins are loaded or it will break new installs.
vim.cmd("colorscheme " .. ufovim.colorscheme)

local commands = require "ufovim.core.commands"
commands.load(commands.defaults)

require("ufovim.keymappings").setup()

require("ufovim.lsp").setup()
