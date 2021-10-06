local path_sep = vim.loop.os_uname().version:match "Windows" and "\\" or "/"

vim.opt.rtp:append(os.getenv "UFOVIM_RUNTIME_DIR" .. path_sep .. "ufovim")

require("bootstrap"):init()

local config = require "config"
-- config:init()
config:load()
