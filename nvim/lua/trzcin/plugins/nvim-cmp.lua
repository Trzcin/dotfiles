local cmp_status, cmp = pcall(require, 'cmp')
if not cmp_status then
    print('nvim-cmp not found')
    return
end

local luasnip_status, luasnip = pcall(require, 'luasnip')
if not luasnip_status then
    print('luasnip not found')
    return
end

local lspkind_status, lspkind = pcall(require, 'lspkind')
if not lspkind_status then
    print('lspkind not found')
    return
end

require('luasnip/loaders/from_vscode').lazy_load()

vim.opt.completeopt = 'menu,menuone,noselect'

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<tab>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- lsp
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
      -- configure lspkind for vs-code like icons
      formatting = {
        format = lspkind.cmp_format({
         maxwidth = 50,
          ellipsis_char = "...",
        }),
      },
})
