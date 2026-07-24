require 'nvim-web-devicons'.setup {
  strict = true,
  override_by_extension = {
    ["re"] = {
      icon = "",
      color = "#DC4C39",
      name = "ReasonML"
    },
    ["rei"] = {
      icon = "",
      color = "#B8383C",
      name = "ReasonMLInterface"
    }
  },
}

require 'nvim-tree'.setup {
  git = {
    ignore = false
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = 24,
    adaptive_size = true,
    float = {
      quit_on_focus_loss = true,
      enable = true
    }
  }
}

vim.keymap.set('n', '<C-n>', vim.cmd.NvimTreeToggle)
vim.keymap.set('n', '<leader>ff', vim.cmd.NvimTreeFindFile)
