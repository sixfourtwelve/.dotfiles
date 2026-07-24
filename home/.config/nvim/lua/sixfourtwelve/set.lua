vim.o.number = true
vim.o.laststatus = 0
vim.o.numberwidth = 1
vim.o.relativenumber = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.mouse = "a"
vim.o.wrap = true

vim.o.signcolumn = "yes:1"
vim.o.syntax = "on"
vim.o.termguicolors = true

vim.opt.smartindent = false

vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 250

local function fix_sign_column()
  vim.defer_fn(function()
    vim.api.nvim_set_hl(0, "SignColumn", { link = "Normal" })
  end, 100)
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  pattern = "*",
  callback = fix_sign_column,
})
