vim.api.nvim_create_augroup('setIndent', { clear = true })

vim.api.nvim_create_autocmd('BufRead', {
  pattern = { '*.h' },
  callback = function()
    vim.bo.filetype = 'objc'
  end
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = { '*.m' },
  callback = function()
    vim.bo.filetype = 'objc'
  end
})

vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'c' },
  command = 'setlocal shiftwidth=2 tabstop=2'
})

vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'cpp' },
  command = 'setlocal shiftwidth=4 tabstop=4'
})

vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'fsharp' },
  command = 'setlocal shiftwidth=4 tabstop=4'
})

vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'objc', 'objcpp' },
  command = 'setlocal shiftwidth=4 tabstop=4'
})

vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'cs' },
  command = 'setlocal shiftwidth=4 tabstop=4'
})

vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'zig' },
  command = 'setlocal shiftwidth=4 tabstop=4'
})

vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'go' },
  command = 'setlocal shiftwidth=8 tabstop=8'
})


vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'odin' },
  command = 'setlocal shiftwidth=8 tabstop=8'
})

vim.api.nvim_create_autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'ada' },
  command = 'setlocal shiftwidth=3 tabstop=3'
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { bg = '#161621' })
  end,
})
vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { bg = '#161621' })
