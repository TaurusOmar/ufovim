local a = require "plenary.async_lib.tests"

a.describe("initial start", function()
  local uv = vim.loop
  local home_dir = uv.os_homedir()
  local ufovim_config_path = get_config_dir() or home_dir .. "/.config/ufovim"
  local UFOVIM_RUNTIME_path = get_runtime_dir() or home_dir .. "/.local/share/ufovim"

  a.it("shoud be able to detect test environment", function()
    assert.truthy(os.getenv "UFOVIM_TEST_ENV")
    assert.falsy(package.loaded["impatient"])
  end)

  a.it("should not be reading default neovim directories in the home directoies", function()
    local rtp_list = vim.opt.rtp:get()
    assert.falsy(vim.tbl_contains(rtp_list, vim.fn.stdpath "config"))
  end)

  a.it("should be able to read ufovim directories", function()
    local rtp_list = vim.opt.rtp:get()
    assert.truthy(vim.tbl_contains(rtp_list, UFOVIM_RUNTIME_path .. "/ufovim"))
    assert.truthy(vim.tbl_contains(rtp_list, UFOVIM_config_path))
  end)

  a.it("should be able to run treesitter without errors", function()
    assert.truthy(vim.treesitter.highlighter.active)
  end)
end)
