local default_capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('*', { capabilities = default_capabilities })

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{2718}",
      [vim.diagnostic.severity.WARN]  = "\u{26a0}",
      [vim.diagnostic.severity.INFO]  = "\u{2139}",
      [vim.diagnostic.severity.HINT]  = "\u{25cb}",
    },
  },
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.lsp.inlay_hint.enable(false)

vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded", max_width = 80 }) end)
vim.keymap.set("n", "bh", function() vim.lsp.buf.hover({ border = "rounded", max_width = 80 }) end)

local lsp_attach = function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "ca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "cr", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "gv", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      lsp_attach(client, args.buf)
    end
    if client.name == 'clangd' then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'eslint_lsp' then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        command = "EslintFixAll",
      })
    end
  end,
})

vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    print("No LSP clients attached to this buffer")
    return
  end
  for _, client in ipairs(clients) do
    print(string.format("Client: %s (id: %d)", client.name, client.id))
  end
end, {})

vim.api.nvim_create_user_command('LspRestart', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    local name = client.name
    vim.lsp.stop_client(client.id)
    vim.defer_fn(function() vim.cmd('edit') end, 500)
    print("Restarted " .. name)
  end
end, {})

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd('edit ' .. vim.lsp.get_log_path())
end, {})

require('mason').setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',
  },
  handlers = {
    function(server_name)
      vim.lsp.enable(server_name)
    end,
    ts_ls = function()
      vim.lsp.config('ts_ls', {
        root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
      })
      vim.lsp.enable('ts_ls')
    end,
    lua_ls = function()
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = { diagnostics = { globals = { 'vim' } } }
        }
      })
      vim.lsp.enable('lua_ls')
    end,
    clangd = function()
      vim.lsp.config('clangd', {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--function-arg-placeholders',
        },
      })
      vim.lsp.enable('clangd')
    end,
  }
})

vim.lsp.config('ada_language_server', {
  cmd = { 'ada_language_server' },
  filetypes = { 'ada', 'adb', 'ads' },
  root_markers = { 'alire.toml', '*.gpr' },
  single_file_support = false,
})

vim.lsp.enable('ada_language_server')

vim.lsp.config('roslyn', {
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

vim.lsp.config('eslint_lsp', {
  experimental = { useFlatConfig = true },
  filetypes = {
    "javascript", "javascriptreact", "javascript.jsx",
    "typescript", "typescriptreact", "typescript.tsx",
    "vue", "html", "markdown", "json", "jsonc", "yaml",
    "toml", "xml", "gql", "graphql", "astro", "svelte",
    "css", "less", "scss", "pcss", "postcss"
  },
})

vim.lsp.commands["editor.action.showReferences"] = function(command, ctx)
  local locations = command.arguments[3]
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if locations and #locations > 0 then
    local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
    vim.fn.setloclist(0, {}, " ", { title = "References", items = items, context = ctx })
    vim.api.nvim_command("lopen")
  end
end
