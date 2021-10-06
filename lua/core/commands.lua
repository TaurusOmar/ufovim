local M = {}

M.defaults = {
  [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
  ]],
  -- :UfovimInfo
  [[command! UfovimInfo lua require('core.info').toggle_popup(vim.bo.filetype)]],
  [[ command! UfovimCacheReset lua require('bootstrap').reset_cache() ]],
  [[ command! UfovimUpdate lua require('bootstrap').update() ]],
}

M.load = function(commands)
  for _, command in ipairs(commands) do
    vim.cmd(command)
  end
end

return M
