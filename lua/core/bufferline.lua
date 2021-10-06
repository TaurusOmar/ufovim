local M = {}

M.config = function()
  ufovim.builtin.bufferline = {
    active = true,
    on_config_done = nil,
    keymap = {
      normal_mode = {
        ["<S-l>"] = ":BufferNext<CR>",
        ["<S-h>"] = ":BufferPrevious<CR>",
      },
    },
  }
end

M.setup = function()
  local keymap = require "keymappings"
  keymap.append_to_defaults(ufovim.builtin.bufferline.keymap)

  if ufovim.builtin.bufferline.on_config_done then
    ufovim.builtin.bufferline.on_config_done()
  end
end

return M
