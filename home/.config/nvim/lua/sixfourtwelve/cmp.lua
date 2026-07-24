local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert',
    autocomplete = {
      require('cmp.types').cmp.TriggerEvent.TextChanged,
    },
  },
  sources = {
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip',  priority = 750 },
    { name = 'buffer',   priority = 500 },
    { name = 'path',     priority = 250 },
    { name = 'nvim_lua', priority = 100 },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-u>']     = cmp.mapping.scroll_docs(-4),
    ['<C-d>']     = cmp.mapping.scroll_docs(4),
    ['<C-f>']     = cmp.mapping(function() luasnip.jump(1) end, { 'i', 's' }),
    ['<C-b>']     = cmp.mapping(function() luasnip.jump(-1) end, { 'i', 's' }),
    ['<C-e>']     = cmp.mapping.abort(),
    ['<CR>']      = cmp.mapping.confirm({ select = false }),
    ['<C-x>']     = cmp.mapping.confirm({ select = true }),
  }),
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, item)
      local icon, hl = require('mini.icons').get('lsp', item.kind)
      item.kind = icon .. ' ' .. item.kind
      item.kind_hl_group = hl
      item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip  = '[Snip]',
        buffer   = '[Buf]',
        path     = '[Path]',
        nvim_lua = '[Lua]',
      })[entry.source.name] or ''
      return item
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- Let Copilot handle Tab for accepting suggestions
-- cmp completion only via C-x
vim.g.copilot_no_tab_map = false

require('nvim-autopairs').setup({})
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
