return {

    { -- comments
        'numToStr/Comment.nvim',
        opts = {},
        config = function()
            require("Comment").setup()
        end
    },

    { -- colorscheme
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,

        -- config = function()
        --     vim.cmd("colorscheme catppuccin-mocha")
        -- end
    },

    {
        "navarasu/onedark.nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('onedark').setup {
                style = 'deep',
                transparent=true;
            }
            -- Enable theme
            -- require('onedark').load()
        end
    },

    {
        "tiagovla/tokyodark.nvim",
        opts = {
            -- custom options here
            transparent_background = false,
        },
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
            vim.cmd [[colorscheme tokyodark]]
        end,
    },

    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        priority = 1000,
        config = function()
            -- vim.cmd("colorscheme kanagawa-wave")
        end
    },

    {
        'kaicataldo/material.vim',
        name = 'material',
        priority = 1000,
        config = function ()
            -- vim.cmd("colorscheme material")
        end
    },

    {
        'ayu-theme/ayu-vim',
        name = 'ayu-vim',
        priority = 1000,
        config = function ()
            -- vim.cmd("colorscheme ayu")
        end
    },

    {
        "bluz71/vim-moonfly-colors",
        lazy = false,
        name = 'moonfly',
        priority = 1000,
        config = function ()
            -- vim.cmd("colorscheme moonfly")
        end
    },

    { "ellisonleao/gruvbox.nvim",
        priority = 1000,
        name="gruvbox",
        config = function ()
            -- vim.cmd("colorscheme ayu")
        end
    },


    { -- lualine
        'nvim-lualine/lualine.nvim',
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("lualine").setup({
                icons_enabled = true,
                theme = 'onedark',
            })
        end,
    },

    -- LSP
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",

    -- completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',

            'hrsh7th/cmp-nvim-lsp',
        },
    },

    -- neodev
    'folke/neodev.nvim',

    -- telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },

    {'xiyaowong/telescope-emoji.nvim'},


    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        priority = 500,
        build = ':TSUpdate',
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },

    'ap/vim-css-color',

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    {
        "ObserverOfTime/nvimcord",
    },

    -- markdown
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

    -- {
    --     "OXY2DEV/markview.nvim",
    --     lazy = false,      -- Recommended
    --     -- ft = "markdown" -- If you decide to lazy-load anyway
    --
    --     priority = 1001,
    --     dependencies = {
    --         -- You will not need this if you installed the
    --         -- parsers manually
    --         -- Or if the parsers are in your $RUNTIMEPATH
    --         -- "nvim-treesitter/nvim-treesitter",
    --
    --         "nvim-tree/nvim-web-devicons"
    --     }
    -- },
    --
    -- notification
    {
        'rcarriga/nvim-notify',
    },

    {
        "folke/noice.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                long_message_to_split = false,
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "single",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                    },
                },
            },
        },
    },

    -- copilot
    -- {
    --     "github/copilot.vim"
    -- },


    -- bufferline
    -- {
    --     'akinsho/bufferline.nvim', version = "*",
    --     config = function()
    --         require("bufferline").setup{}
    --     end
    -- },

    -- tabline, not bufferline
    {
        'nanozuki/tabby.nvim',
        config = function()
            -- configs...
        end,
    },

    -- type `rafce` in a jsx file and see
    {
        'dsznajder/vscode-es7-javascript-react-snippets',
        build = 'yarn install --frozen-lockfile && yarn compile',
    },

    {
        "microsoft/python-type-stubs"
    },


    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup()
            vim.diagnostic.config({ virtual_text = false }) -- Disable default virtual text
        end
    },

    {
        "OXY2DEV/helpview.nvim",
        lazy = false
    },

    { 'nvim-mini/mini.icons', version = '*' },

    -- {"shortcuts/no-neck-pain.nvim", version = "*"},

    { 'dmmulroy/ts-error-translator.nvim' }


}
