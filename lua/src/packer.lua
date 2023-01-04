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

end)
