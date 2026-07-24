require('nvim-treesitter.configs').setup {
  sync_install = false,
  auto_install = true,
  indent = {
    enable = false,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
      if lang == "python" then
        return true
      end
    end,
  },
}

vim.g.ts_highlight_lua = false
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
for lang, _ in pairs(parser_config) do
  vim.treesitter.query.set(lang, "injections", "")
end

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 4
