if os.getenv "UFOVIM_RUNTIME_DIR" then
  local path_sep = vim.loop.os_uname().version:match "Windows" and "\\" or "/"
  vim.opt.rtp:append(os.getenv "UFOVIM_RUNTIME_DIR" .. path_sep .. "ufovim")
end

require("bootstrap"):init()

local config = require "config"
-- config:init()
config:load()

local plugins = require "plugins"
require("plugin-loader"):load { plugins, ufovim.plugins }

local Log = require "core.log"
Log:debug "Starting UfoVim"

vim.g.colors_name = ufovim.colorscheme

local commands = require "core.commands"
commands.load(commands.defaults)

require("keymappings").setup()

require("lsp").setup()
