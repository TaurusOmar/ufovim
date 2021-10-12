return {
  -- Packer can manage itself as an optional plugin
  { "wbthomason/packer.nvim" },
  { "neovim/nvim-lspconfig" },
  { "tamago324/nlsp-settings.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "antoinemadec/FixCursorHold.nvim" }, -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  {
    "williamboman/nvim-lsp-installer",
  },

  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("core.telescope").setup()
    end,
    disable = not ufovim.builtin.telescope.active,
  },
    -- Telescope Project
    {
      "nvim-telescope/telescope-project.nvim",
    },
  -- Install nvim-cmp, and buffer source as a dependency
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("core.cmp").setup()
    end,
    requires = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
    },
    run = function()
      -- cmp's config requires cmp to be installed to run the first time
      if not ufovim.builtin.cmp then
        require("core.cmp").config()
      end
    end,
  },
  {
    "rafamadriz/friendly-snippets",
    -- event = "InsertCharPre",
    -- disable = not ufovim.builtin.compe.active,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    -- event = "InsertEnter",
    after = "nvim-cmp",
    config = function()
      require("core.autopairs").setup()
    end,
    disable = not ufovim.builtin.autopairs.active,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "0.5-compat",
    -- run = ":TSUpdate",
    config = function()
      require("core.treesitter").setup()
    end,
  },

  -- NvimTree
  {
    "kyazdani42/nvim-tree.lua",
    -- event = "BufWinOpen",
    -- cmd = "NvimTreeToggle",
    -- commit = "fd7f60e242205ea9efc9649101c81a07d5f458bb",
    config = function()
      require("core.nvimtree").setup()
    end,
    disable = not ufovim.builtin.nvimtree.active,
  },

  {
    "lewis6991/gitsigns.nvim",

    config = function()
      require("core.gitsigns").setup()
    end,
    event = "BufRead",
    disable = not ufovim.builtin.gitsigns.active,
  },

  -- Whichkey
  {
    "folke/which-key.nvim",
    config = function()
      require("core.which-key").setup()
    end,
    event = "BufWinEnter",
    disable = not ufovim.builtin.which_key.active,
  },

  -- Comments
  {
    "terrortylor/nvim-comment",
    event = "BufRead",
    config = function()
      require("core.comment").setup()
    end,
    disable = not ufovim.builtin.comment.active,
  },

  -- project.nvim
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("core.project").setup()
    end,
    disable = not ufovim.builtin.project.active,
  },

  -- Icons
  { "kyazdani42/nvim-web-devicons" },

  -- Status Line and Bufferline
  {
    -- "hoob3rt/lualine.nvim",
    "shadmansaleh/lualine.nvim",
    -- "ufovim/lualine.nvim",
    config = function()
      require("core.lualine").setup()
    end,
    disable = not ufovim.builtin.lualine.active,
  },

  {
    "romgrk/barbar.nvim",
    config = function()
      require("core.bufferline").setup()
    end,
    event = "BufWinEnter",
    disable = not ufovim.builtin.bufferline.active,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    -- event = "BufWinEnter",
    config = function()
      require("core.dap").setup()
    end,
    disable = not ufovim.builtin.dap.active,
  },

  -- Debugger management
  {
    "Pocco81/DAPInstall.nvim",
    -- event = "BufWinEnter",
    -- event = "BufRead",
    disable = not ufovim.builtin.dap.active,
  },

  -- Dashboard
  {
    "glepnir/dashboard-nvim",
    event = "BufWinEnter",
    config = function()
      require("core.dashboard").setup()
    end,
    disable = not ufovim.builtin.dashboard.active,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    event = "BufWinEnter",
    config = function()
      require("core.terminal").setup()
    end,
    disable = not ufovim.builtin.terminal.active,
  },

-- Ranger
  {
    "kevinhwang91/rnvimr",
  },

-- Blankline
{
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require "core.blankline"
  end,
},

-- Colorizer
{
  "norcalli/nvim-colorizer.lua",
  require'colorizer'.setup() 

},

-- Codi
{
  "metakirby5/codi.vim", 
},

-- theme
{
  "sainnhe/gruvbox-material", 

},

-- AnyJump
{
  "pechorin/any-jump.vim",
},

-- Calendar
{
  "itchyny/calendar.vim",
},

}
