-- Register Treesitter lang for asm
vim.treesitter.language.register('nasm', 'asm')


-- diagnostics
vim.diagnostic.config({ virtual_text = true })


local diagnostics_active = true

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
    bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
    bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)
    bufmap('<leader>r', vim.lsp.buf.rename)
    bufmap('<leader>a', vim.lsp.buf.code_action)
    bufmap('<leader>gd', vim.lsp.buf.definition)
    bufmap('<leader>gD', vim.lsp.buf.declaration)
    bufmap('<leader>gi', vim.lsp.buf.implementation)
    bufmap('<leader>D', vim.lsp.buf.type_definition)
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
        "lua_ls", "pyright", "clangd", "asm_lsp", "marksman", "vimls", "ts_ls", "emmet_ls", "ruff", "jsonls",
    },
})

local lspconfig = require("lspconfig")

-- Lua LS
require("neodev").setup()
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
    root_dir = lspconfig.util.root_pattern(".git", "init.lua", "lua"),
})

-- Pyright
lspconfig.pyright.setup({
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
lspconfig.ruff.setup({
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
lspconfig.clangd.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    single_file_support = true,
})

-- ASM LSP
lspconfig.asm_lsp.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "asm-lsp" },
    filetypes = { "asm", "nasm" },
    root_dir = lspconfig.util.root_pattern(".git", "*.asm"),
})


-- typescript language server
lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
})

-- Marksman
lspconfig.marksman.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    root_dir = lspconfig.util.root_pattern(".git", ".marksman.toml", "*.md"),
    single_file_support = true,
})



-- cmake
lspconfig.cmake.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "cmake-language-server" },
    filetypes = { "cmake"},
    init_options = { buildDirectory = "build" },
    single_file_support = true,
    root_markers = { "CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake" },
})





-- Vim Language Server
lspconfig.vimls.setup({
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

lspconfig.jsonls.setup({
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
