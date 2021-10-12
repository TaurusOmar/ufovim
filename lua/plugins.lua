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
1
return {
2
  -- Packer can manage itself as an optional plugin
3
  { "wbthomason/packer.nvim" },
4
  { "neovim/nvim-lspconfig" },
5
  { "tamago324/nlsp-settings.nvim" },
6
  { "jose-elias-alvarez/null-ls.nvim" },
7
  { "antoinemadec/FixCursorHold.nvim" }, -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
8
  {
9
    "williamboman/nvim-lsp-installer",
10
  },
11
​
12
  { "nvim-lua/popup.nvim" },
13
  { "nvim-lua/plenary.nvim" },
14
  -- Telescope
15
  {
16
    "nvim-telescope/telescope.nvim",
17
    config = function()
18
      require("core.telescope").setup()
19
    end,
20
    disable = not ufovim.builtin.telescope.active,
21
  },
22
    -- Telescope Project
23
    {
24
      "nvim-telescope/telescope-project.nvim",
25
        require("core.telescope").setup()
26
    },
27
  -- Install nvim-cmp, and buffer source as a dependency
28
  {
29
    "hrsh7th/nvim-cmp",
30
    config = function()
31
      require("core.cmp").setup()
32
    end,
33
    requires = {
34
      "L3MON4D3/LuaSnip",
35
      "saadparwaiz1/cmp_luasnip",
36
      "hrsh7th/cmp-buffer",
37
      "hrsh7th/cmp-nvim-lsp",
38
      "hrsh7th/cmp-path",
39
      "hrsh7th/cmp-nvim-lua",
40
    },
41
    run = function()
42
      -- cmp's config requires cmp to be installed to run the first time
43
      if not ufovim.builtin.cmp then
44
        require("core.cmp").config()
45
      end

    "nvim-telescope/telescope.nvim",
    config = function()
      require("core.telescope").setup()
    end,
    disable = not ufovim.builtin.telescope.active,
  },
    -- Telescope Project
    {
      "nvim-telescope/telescope-project.nvim",
        require("core.telescope").setup()
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
