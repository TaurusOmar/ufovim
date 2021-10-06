local M = {}

function M.config()
  ufovim.builtin.comment = {
    active = true,
    on_config_done = nil,
    -- Linters prefer comment and line to have a space in between markers
    marker_padding = true,
    -- should comment out empty or whitespace only lines
    comment_empty = false,
    -- Should key mappings be created
    create_mappings = true,
    -- Normal mode mapping left hand side
    line_mapping = "gcc",
    -- Visual/Operator mapping left hand side
    operator_mapping = "gc",
    -- Hook function to call before commenting takes place
    hook = nil,
  }
end

function M.setup()
  local nvim_comment = require "nvim_comment"

  nvim_comment.setup(ufovim.builtin.comment)
  if ufovim.builtin.comment.on_config_done then
    ufovim.builtin.comment.on_config_done(nvim_comment)
  end
end

return M
