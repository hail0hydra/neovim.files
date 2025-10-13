-- LSP configuration
-- local remap = require("me.util").remap

-- Register Treesitter lang for asm
vim.treesitter.language.register('nasm', 'asm')

-- diagnostics {FALSE}
vim.diagnostic.config({ virtual_text = false })
local diagnostics_active = false
-- using tiny-diagnostics so turned above thing off



vim.keymap.set("n", "<leader>dq", function()
    diagnostics_active = not diagnostics_active
    vim.diagnostic.config({ virtual_text = diagnostics_active })
    print("Diagnostics virtual_text: " .. (diagnostics_active and "ON" or "OFF"))
end, { desc = "Toggle diagnostics virtual text" })



-- on_attach function
local on_attach = function(_, bufnr)
    local bufmap = function(keys, func)
        vim.keymap.set('n', keys, func, { buffer = bufnr })
    end

    bufmap('<leader>gr', require('telescope.builtin').lsp_references)
    -- bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
    bufmap('<leader>s', require('fzf-lua').lsp_document_symbols)
    -- bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)
    bufmap('<leader>S', require('fzf-lua').lsp_live_workspace_symbols)
    bufmap('<leader>r', vim.lsp.buf.rename)
    bufmap('<leader>a', vim.lsp.buf.code_action)
    bufmap('gd', vim.lsp.buf.definition)
    bufmap('gD', vim.lsp.buf.declaration)
    bufmap('<leader>gi', vim.lsp.buf.implementation)
    bufmap('<space>D', vim.lsp.buf.type_definition)
    bufmap('K', vim.lsp.buf.hover)

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
        vim.lsp.buf.format()
    end, {})
end

-- capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end


-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls", "pyright", "clangd", "asm_lsp", "marksman", "vimls", "ts_ls", "emmet_ls", "ruff", "jsonls","gopls","rust_analyzer",
    },
})

local old_lspconfig = require("lspconfig")
local lspconfig = vim.lsp.config

-- Lua LS
-- require("neodev").setup()
-- lspconfig("lua_ls",{
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         Lua = {
--             workspace = { checkThirdParty = false },
--             telemetry = { enable = false },
--         },
--     },
--     filetype = {"lua"},
--     root_dir = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
-- })
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})


-- Pyright
lspconfig("pyright",{
    on_attach = on_attach,
    before_init = function(_, config)
        config.settings.python.analysis.stubPath = vim.fs.joinpath(vim.fn.stdpath "data", "lazy", "python-type-stubs")
    end,
    capabilities = capabilities,
    filetypes = { "python" },
    settings = {
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { '*' },
            },
        },
    },
})


-- ruff : linter & formatter for python
lspconfig("ruff",{
    on_attach = on_attach,
    -- before_init = function(_, config)
    --     config.settings.python.analysis.stubPath = vim.fs.joinpath(vim.fn.stdpath "data", "lazy", "python-type-stubs")
    -- end,
    capabilities = capabilities,
    filetypes = { "python" },
    cmd = { "ruff", "server" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    settings = {logLevel = 'debug',},
})

-- Clangd
lspconfig("clangd",{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    single_file_support = true,
})

-- ASM LSP
lspconfig("asm_lsp",{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "asm-lsp" },
    filetypes = { "asm", "nasm" },
    root_dir = old_lspconfig.util.root_pattern(".git", "*.asm"),
})


-- typescript language server
lspconfig("ts_ls",{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    flags = { debounce_text_changes = 300 },
})

-- Marksman
lspconfig("marksman",{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    root_dir = old_lspconfig.util.root_pattern(".git", ".marksman.toml", "*.md"),
    single_file_support = true,
})



-- cmake
lspconfig("cmake",{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "cmake-language-server" },
    filetypes = { "cmake"},
    init_options = { buildDirectory = "build" },
    single_file_support = true,
    root_markers = { "CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake" },
})


-- maybe latex
lspconfig("ltex",{
    on_attach = on_attach,
    capabilities = capabilities,
    -- filetypes = { "bib", "markdown", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc" },
    filetypes = { "bib", "org", "plaintex", "rst", "rnoweb", "tex", "pandoc" },
    settings = {
        ltex = {
            language = "en-CA",
        }
    }
})


-- go maybe
lspconfig("gopls",{
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        analyses = {
            unusedparams = true,
        },
        staticcheck = true,
    },
})


-- rust analyzer
lspconfig("rust_analyzer", {
    on_attach = on_attach,
    capabilities = capabilities
})


lspconfig("jdtls", {
    on_attach = on_attach,
    capabilities = capabilities
})



-- Vim Language Server
lspconfig("vimls",{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    init_options = {
        diagnostic = {
            enable = true
        },
        indexes = {
            count = 3,
            gap = 100,
            projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
            runtimepath = true
        },
        isNeovim = true,
        iskeyword = "@,48-57,_,192-255,-#",
        runtimepath = "",
        suggest = {
            fromRuntimepath = true,
            fromVimruntime = true
        },
        vimruntime = ""
    },
    single_file_support = true,
})


--emmet-ls
-- lspconfig.emmet_ls.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
--     -- filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
--     filetypes = { "css", "eruby", "html",  "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
--     init_options = {
--         html = {
--             options = {
--                 -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
--                 ["bem.enabled"] = true,
--             },
--         },
--     },
--     single_file_support = true,
-- })

-- Filetype override: treat .asm files as "asm"




vim.filetype.add({
    extension = {
        asm = "asm",
    },
})



-- jsonls
-- --Enable (broadcasting) snippet capability for completion
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig("jsonls",{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    init_options = { provideFormatter = true },
    single_file_support = true,
    root_markers = { ".git" },
})

-- local function command_factory(client, bufnr, cmd)
--   return client:exec_cmd({
--     title = ('Markdown-Oxide-%s'):format(cmd),
--     command = 'jump',
--     arguments = { cmd },
--   }, { bufnr = bufnr })
-- end

-- on_attach = function(client, bufnr)
--     for _, cmd in ipairs({ 'today', 'tomorrow', 'yesterday' }) do
--       vim.api.nvim_buf_create_user_command(bufnr, 'Lsp' .. ('%s'):format(cmd:gsub('^%l', string.upper)), function()
--         command_factory(client, bufnr, cmd)
--       end, {
--         desc = ('Open %s daily note'):format(cmd),
--       })
--     end
--   end,
--
--
-- lspconfig.markdown_oxide.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
--     cmd = { "markdown-oxide" },
--     filetypes = { "markdown"},
--     root_markers = { '.git', '.obsidian', '.moxide.toml' },
--     single_file_support = true,
-- })

require("ts-error-translator").setup()




-- enable them all

vim.lsp.enable({"pyright", "ts_ls", "jsonls", "cmake", "lua_ls", "vimls", "clangd", "asm_lsp", "marksman", "rust_analyzer", "gopls", "ltex", "marksman"})
