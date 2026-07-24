---@diagnostic disable: undefined-global
---
vim.g.mapleader = " "
vim.g.maplocalleader = ","

return require("lazy").setup({
  { "catppuccin/nvim",   name = "catppuccin", priority = 1000 },
  { "github/copilot.vim" },
  {
    "seblyng/roslyn.nvim",
    opts = {},
  },
  { "Decodetalkers/csharpls-extended-lsp.nvim" },
  {
    "folke/noice.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        cmdline   = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            cmdline     = { icon = ">" },
            search_down = { icon = "/" },
            search_up   = { icon = "?" },
            filter      = { icon = "$" },
            lua         = { icon = "" },
            help        = { icon = "?" },
          },
        },
        messages  = { enabled = true },
        popupmenu = { enabled = true, backend = "nui" },
        notify    = { enabled = true },
        lsp       = {
          progress  = { enabled = false },
          hover     = { enabled = false },
          signature = { enabled = false },
          message   = { enabled = true },
        },
        presets   = {
          bottom_search         = false,
          command_palette       = false,
          long_message_to_split = true,
          inc_rename            = false,
        },
      })
    end,
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()

      local options = { buffer = bufnr, remap = false }
      metals_config.on_attach = function(client, bufnr)
        vim.keymap.set('n', 'gd', '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>',
          options)
        -- vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, options)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, options)
        vim.keymap.set("n", "bh", function() vim.lsp.buf.hover() end, options)
        vim.keymap.set("n", "ca", function() vim.lsp.buf.code_action() end, options)
        vim.keymap.set("n", "cr", function() vim.lsp.buf.rename() end, options)
        vim.keymap.set("n", "gv", function() vim.lsp.buf.signature_help() end, options)
        vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, options)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, options)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, options)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },
  { "reasonml-editor/vim-reason-plus" },
  {
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.icons').setup({ style = 'glyph' })
      MiniIcons.mock_nvim_web_devicons()
      -- require('mini.tabline').setup()
      require('mini.statusline').setup({
        use_icons = true,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git           = MiniStatusline.section_git({ trunc_width = 75 })
            local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
            local filetype      = vim.bo.filetype
            local location      = string.format('%d:%d', vim.fn.line('.'), vim.fn.col('.'))
            return MiniStatusline.combine_groups({
              { hl = mode_hl,                 strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
              '%<',
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=',
              { hl = 'MiniStatuslineFileinfo', strings = { filetype } },
              { hl = mode_hl,                  strings = { location } },
            })
          end,
        },
      })
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      -- vim.cmd("colorscheme catppuccin-mocha")
      vim.cmd("colorscheme tokyonight-moon")
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.defer_fn(function()
        for _, group in ipairs({
          "DiagnosticUnderlineError",
          "DiagnosticUnderlineWarn",
          "DiagnosticUnderlineInfo",
          "DiagnosticUnderlineHint",
        }) do
          local hl = vim.api.nvim_get_hl(0, { name = group })
          hl.undercurl = false
          hl.underline = true
          hl.bold = false
          vim.api.nvim_set_hl(0, group, hl)
        end
      end, 50)
    end
  },
  { 'dmmulroy/ts-error-translator.nvim', ft = { "typescript", "typescriptreact" }, opts = {} },
  {
    'Olical/conjure',
    ft = { "clojure", "fennel", "racket", "scheme", "lisp" },
    lazy = true,
  },
  { "ocaml-mlx/ocaml_mlx.nvim" },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "OXY2DEV/markview.nvim" }
  },
  -- { "nvim-treesitter/playground" },
  { "tpope/vim-fugitive",    cmd = { "Git", "G" } },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
          untracked    = { text = "▎" },
        },
      })
    end,
  },
  { "chrisbra/Colorizer",    cmd = "ColorToggle" },
  { "j-hui/fidget.nvim",     event = "LspAttach" },
  { 'windwp/nvim-autopairs', event = "InsertEnter" },
  { 'neovim/nvim-lspconfig' },
  {
    'williamboman/mason.nvim',
  },
  { 'williamboman/mason-lspconfig.nvim' },

  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lua' },

  { 'L3MON4D3/LuaSnip' },
  { 'rafamadriz/friendly-snippets' },

  { 'kyazdani42/nvim-tree.lua',         cmd = { "NvimTreeToggle", "NvimTreeFindFile" }, keys = { "<C-n>", "<leader>ff" } },
  { 'nvim-telescope/telescope.nvim',    cmd = { "Telescope" },                          keys = { "<leader>pf", "<C-p>", "<C-f>" }, dependencies = { { 'nvim-lua/plenary.nvim' } } },
  { "mbbill/undotree",                  cmd = "UndotreeToggle" },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        javascript      = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript      = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        css             = { "prettier" },
        html            = { "prettier" },
        json            = { "prettier" },
        yaml            = { "prettier" },
        markdown        = { "prettier" },
        lua             = { "stylua" },
        go              = { "goimports", "gofmt" },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",          desc = "Diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>",         desc = "Close diff" },
    },
  },
}, opts)
