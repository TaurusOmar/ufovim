local M = {}
M.config = function()
  ufovim.builtin.lualine = {
    active = true,
    style = "ufovim",
    options = {
      icons_enabled = nil,
      component_separators = nil,
      section_separators = nil,
      theme = nil,
      disabled_filetypes = nil,
    },
    sections = {
      lualine_a = nil,
      lualine_b = nil,
      lualine_c = nil,
      lualine_x = nil,
      lualine_y = nil,
      lualine_z = nil,
    },
    inactive_sections = {
      lualine_a = nil,
      lualine_b = nil,
      lualine_c = nil,
      lualine_x = nil,
      lualine_y = nil,
      lualine_z = nil,
    },
    tabline = nil,
    extensions = nil,
    on_config_done = nil,
  }
end

M.setup = function()
  require("core.lualine.styles").update()
  require("core.lualine.utils").validate_theme()

  local lualine = require "lualine"
  lualine.setup(ufovim.builtin.lualine)

  if ufovim.builtin.lualine.on_config_done then
    ufovim.builtin.lualine.on_config_done(lualine)
  end
end

return M
