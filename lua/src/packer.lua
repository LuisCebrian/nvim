-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Fuzzy finder
  use {
      "nvim-telescope/telescope.nvim",
      requires = {
          { "nvim-lua/plenary.nvim" },
          { "nvim-telescope/telescope-live-grep-args.nvim" },
      }
  }

  -- Theme
  use 'folke/tokyonight.nvim'

  -- Treesitter
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

  -- Git
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  -- Tree view
  use {
      'nvim-tree/nvim-tree.lua',
      requires = {
          'nvim-tree/nvim-web-devicons', -- optional, for file icons
      },
  }

  -- Tmux
  use 'christoomey/vim-tmux-navigator'

  -- Start screen
  use {
      'goolord/alpha-nvim',
      requires = { 'nvim-tree/nvim-web-devicons' },
      config = function ()
          require'alpha'.setup(require'alpha.themes.startify'.config)
      end
  }

  -- Status bar
  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Utility
  use 'phaazon/hop.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-abolish'
  use 'tpope/vim-unimpaired'
  use 'windwp/nvim-autopairs'

  -- Comments
  use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }

  -- Languages: Markdown
  use({
      "iamcco/markdown-preview.nvim",
      run = "cd app && npm install",
      ft = "markdown",
      config = function()
          vim.g.mkdp_auto_close = 0
      end,
  })

end)
