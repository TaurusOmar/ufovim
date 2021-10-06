local M = {}
local utils = require "utils"

M.config = function(config)
  ufovim.builtin.dashboard = {
    active = false,
    on_config_done = nil,
    search_handler = "telescope",
    disable_at_vim_enter = 0,
    session_directory = utils.join_paths(get_cache_dir(), "sessions"),
    custom_header = {
      " *       .       .    )        .           .        +      '",  
      "   .       +             .         .            *           ",
      "                 .                      .    ,     '    +   ",
      " .     .   '        .'     .      .            .          . ",   
      "              _.---._   .      .     .     +      '         ",  
      " .   *      .'       '.      *                .         *   ",     
      "        _.-~===========~-._     .                 .      '  ",     
      ".   +  (___________________)       .   +     .            . ",    
      " '    '      \\_______/                                +    ",         
      " . ██╗   ██╗ ███████╗  █████╗ .██╗   ██╗ ██╗ ███╗*  ███╗ .  ",
      "   ██║ * ██║ ██╔════╝ ██╔══██╗ ██║ ' ██║ ██║ ████╗ ████║ .  ",
      "'  ██║   ██║ █████╗  '██║ *██║ ╚██╗ ██╔╝ ██║ ██╔████╔██║    ",
      "  .██║'  ██║ ██╔══╝'  ██║' ██║  ╚████╔╝  ██║ ██║╚██╔╝██║  ' ",
      " * ╚██████╔╝ ██║ *    ╚█████╔╝ . ╚██╔╝ ' ██║ ██║ ╚═╝ ██║    ",
      "    ╚═════╝ '╚═╝    '  ╚════╝*    ╚═╝    ╚═╝ ╚═╝  '  ╚═╝*   ",
      "'  *  '    .       .    *        .    +      .        *    .",  
      "   .       +             .         .            *           ", 
    },

    custom_section = {
      a = {
        description = { "  Find File          " },
        command = "Telescope find_files",
      },
      b = {
        description = { "  Recent Projects    " },
        command = "Telescope projects",
      },
      c = {
        description = { "  Recently Used Files" },
        command = "Telescope oldfiles",
      },
      d = {
        description = { "  Find Word          " },
        command = "Telescope live_grep",
      },
      e = {
        description = { "  Configuration      " },
        command = ":e " .. config.path,
      },
    },

    footer = { "ufovim.org" },
  }
end

M.setup = function()
  vim.g.dashboard_disable_at_vimenter = ufovim.builtin.dashboard.disable_at_vim_enter

  vim.g.dashboard_custom_header = ufovim.builtin.dashboard.custom_header

  vim.g.dashboard_default_executive = ufovim.builtin.dashboard.search_handler

  vim.g.dashboard_custom_section = ufovim.builtin.dashboard.custom_section

  ufovim.builtin.which_key.mappings[";"] = { "<cmd>Dashboard<CR>", "Dashboard" }

  vim.g.dashboard_session_directory = ufovim.builtin.dashboard.session_directory

  local ufovim_site = "ufovim.org"
  local ufovim_version = get_version "short"
  local num_plugins_loaded = #vim.fn.globpath(get_runtime_dir() .. "/site/pack/packer/start", "*", 0, 1)

  local footer = {
    "ufovim loaded " .. num_plugins_loaded .. " plugins ",
    "",
    ufovim_site,
  }

  if ufovim_version then
    table.insert(footer, 2, "")
    table.insert(footer, 3, "v" .. ufovim_version)
  end

  local text = require "interface.text"
  vim.g.dashboard_custom_footer = text.align_center({ width = 0 }, footer, 0.49) -- Use 0.49 as  counts for 2 characters

  require("core.autocmds").define_augroups {
    _dashboard = {
      -- seems to be nobuflisted that makes my stuff disappear will do more testing
      {
        "FileType",
        "dashboard",
        "setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= ",
      },
      {
        "FileType",
        "dashboard",
        "set showtabline=0 | autocmd BufLeave <buffer> set showtabline=" .. vim.opt.showtabline._value,
      },
      { "FileType", "dashboard", "nnoremap <silent> <buffer> q :q<CR>" },
    },
  }

  if ufovim.builtin.dashboard.on_config_done then
    ufovim.builtin.dashboard.on_config_done()
  end
end

return M
