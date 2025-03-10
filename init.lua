-- General settings
vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.termguicolors = true
vim.o.wrap = true
vim.o.showtabline = 2
vim.o.syntax = "on"
vim.cmd("set noswapfile")
vim.cmd("set undofile")

-- Folding settings
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Syntax & loader
vim.cmd('syntax on')
vim.loader.enable()

-- ALE settings
vim.cmd("set omnifunc=ale#completion#OmniFunc")
vim.cmd("let g:ale_completion_enabled = 1")
vim.cmd("let g:ale_completion_autoimport = 1")

-- User command
vim.api.nvim_create_user_command('Files', 'lua MiniFiles.open()', {})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" }, { "\nPress any key to exit..." } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    {"echasnovski/mini.nvim", version = false},
    {"mhinz/vim-sayonara"},
    {"williamboman/mason.nvim"},
    {"ellisonleao/glow.nvim", config = true, cmd = "Glow"},
    {"mhartington/formatter.nvim"},
    {"tpope/vim-sleuth"},
    {"tpope/vim-fugitive"},
    {"nullromo/go-up.nvim", opts = {}, config = function(_, opts) require('go-up').setup(opts) end},
    {"dstein64/nvim-scrollview"},
    {"pocco81/auto-save.nvim"},
    {"nvim-treesitter/nvim-treesitter", config = true},
    {"mhinz/vim-startify"},
    {"prichrd/netrw.nvim", opts = {}},
    {"nguyenvukhang/nvim-toggler", config = true},
    {"ryanoasis/vim-devicons"},
    {"lewis6991/gitsigns.nvim", config = true},
    {"kevinhwang91/nvim-hlslens", config = true},
    {'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' }},
    {"kevinhwang91/nvim-ufo", dependencies = {"kevinhwang91/promise-async"}},
    {"ahmedkhalf/project.nvim", dependencies = {"nvim-telescope/telescope.nvim"}},
    {"norcalli/nvim-colorizer.lua"},
    {"folke/flash.nvim", event = "VeryLazy", opts = {}, keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    }},
    {"folke/which-key.nvim", event = "VeryLazy", opts = {}, keys = {
      { "<leader>?", function() require("which-key").show({ global = true }) end, desc = "Buffer Local Keymaps (which-key)" }
    }},
    {"folke/drop.nvim", opts = {}},
    {"akinsho/toggleterm.nvim", version = "*", config = true},
    {"roxma/nvim-yarp"},
    {"dense-analysis/ale"},
    {"dundalek/lazy-lsp.nvim", dependencies = {"neovim/nvim-lspconfig", {"VonHeikemen/lsp-zero.nvim", branch = "v3.x"}, "hrsh7th/cmp-nvim-lsp", "hrsh7th/nvim-cmp"}, config = function()
      if os.getenv("OS") ~= "Windows_NT" then
        local lsp_zero = require("lsp-zero")
        lsp_zero.on_attach(function(client, bufnr)
          lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })
        end)
        require("lazy-lsp").setup {}
      end
    end},
    {"nanozuki/tabby.nvim"},
    {"justinhj/battery.nvim", dependencies = {"nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim"}},
    {'nvim-lualine/lualine.nvim', dependencies = {'nvim-tree/nvim-web-devicons'}},
    {"michaelb/sniprun"},
    {"lukas-reineke/headlines.nvim", dependencies = "nvim-treesitter/nvim-treesitter", config = true},
    {"rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "folke/lazydev.nvim"}},
    {"SmiteshP/nvim-navbuddy", dependencies = {"neovim/nvim-lspconfig", "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim", "numToStr/Comment.nvim", "nvim-telescope/telescope.nvim"}, config = function()
      local navbuddy = require("nvim-navbuddy")
      navbuddy.setup({ lsp = { auto_attach = true } })
    end, cmd = "Navbuddy"},
    {'numToStr/Comment.nvim', opts = {}},
    {'stevearc/oil.nvim', opts = {}, dependencies = { { "echasnovski/mini.icons", opts = {} } }, lazy = false},
    {"folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {}},
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- Setup colorscheme
vim.cmd[[colorscheme tokyonight]]

-- Plugin configurations
require("project_nvim").setup()
require('telescope').load_extension('projects')
require('Comment').setup()
require("toggleterm").setup()
require("netrw").setup({})
require("oil").setup()
require("mini.icons").setup()
require("mini.completion").setup()
require("mini.files").setup()
require("mini.align").setup()
require("mini.clue").setup()
require("mini.git").setup()
require("mini.hipatterns").setup()
require("mini.map").setup()
require("mini.move").setup()
require("mini.notify").setup()
require("mini.snippets").setup()
require("mini.tabline").setup()
require("mini.indentscope").setup()
require('mini.pairs').setup()
require('mini.ai').setup()
require('mini.cursorword').setup()
require('mini.surround').setup()
require("formatter").setup()
require("mason").setup()
require("auto-save").setup()

-- LSP settings
require("lazydev").setup({ library = { "nvim-dap-ui" } })
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- Nvim-navbuddy setup
local navic = require("nvim-navic")
navic.setup({ lsp = { auto_attach = true } })

-- Ufo folding setup
require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Scrollview setup
require('scrollview').setup({
  excluded_filetypes = {'nerdtree', 'fugitive', 'man'},
})

-- Git signs setup
require('gitsigns').setup({
  current_line_blame = true,
})

-- ALE (Asynchronous Linting and Fixing) setup
vim.g.ale_linters_explicit = 1

require("battery").setup({})
local colors = {
  bg       = '#202329',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}
local nvimbattery = {
  function()
    return require("battery").get_status_line()
  end,
  color = { fg = colors.violet, bg = colors.bg },
}
local ostime = {
  function()
    return os.date("%H:%M:%S")
  end
}
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diagnostics'},
    lualine_c = {'filesize', 'filename'},
    lualine_x = {nvimbattery, ostime},
    lualine_y = {'encoding', 'filetype'},
    lualine_z = {'progress', 'location'},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'location'}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})

local theme = {
  fill = 'TabLineFill',
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}

require('tabby').setup({
  line = function(line)
    return {
      {
        { '  ', hl = theme.head },
        line.sep('', theme.head, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep('', hl, theme.fill),
          tab.is_current() and '' or '󰆣',
          tab.number(),
          tab.name(),
          tab.close_btn(''),
          line.sep('', hl, theme.fill),
          hl = hl,
          margin = ' ',
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return {
          line.sep('', theme.win, theme.fill),
          win.is_current() and '' or '',
          win.buf_name(),
          line.sep('', theme.win, theme.fill),
          hl = theme.win,
          margin = ' ',
        }
      end),
      {
        line.sep('', theme.tail, theme.fill),
        { '  ', hl = theme.tail },
      },
      hl = theme.fill,
    }
  end,
  -- option = {}, -- setup modules' option,
})
