local set = vim.opt
local g = vim.g
local home = os.getenv("HOME")
local set_global = vim.opt_global


-- disable langauge provider support (use lua and vimscript only)
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0


-- disable unused stuff
g.loaded = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_matchit = 1 -- use vim-matchup
g.loaded_matchpattern = 1 -- use vim-matchup


-- basic settings

g.completeopt = { "menuone", "noinsert", "noselect" }
set_global.shortmess:remove("F")
set.encoding = "utf-8"
set.backspace = "indent,eol,start" -- backspace works on every character in insert mode
-- set.history = 1000
set.startofline = true
-- set.clipboard = 'unnamedplus'
set.textwidth = 73




-- wait time
set.timeoutlen = 300
set.ttimeout = true
set.ttimeoutlen = 100


-- display
set.showmatch = true -- show matching brackets
set.scrolloff = 3
set.synmaxcol = 300 -- stop syntax highligh after x lines for performance
set.laststatus = 2 -- always show 2 status line

set.list = false -- do not display white characters
set.foldenable = false
set.foldlevel = 4 -- limit folding to 4 levels
set.foldmethod = 'syntax' -- use language syntax to generate folds
set.wrap = false -- do not wrap lines even if very long
set.eol = false -- show if there is not eol
set.showbreak='↪' -- character to show when a line is broken
set.termguicolors = true

set.splitbelow = true
set.splitright = true
set.cursorline = true
set.mouse = 'a'


-- sidebar
set.number = true
set.numberwidth = 3 -- always reserve 3 spaces for line number
set.signcolumn = 'yes' -- keep 1 column for ?? coc.nvim check ?? bruh no
set.modelines = 0
set.showcmd = true -- display a command line in the bottom

set.relativenumber = true


-- search
set.incsearch = true -- starts search as soon as typing, without enter needed
set.ignorecase = true -- ignore the letter case when searching
set.smartcase = true -- case insensitive unless capitals used in search


-- backup and undo
set.backup = true
set.swapfile = false
set.backupdir = home .. '/.config/nvim/.backup'
set.directory = home .. '/.config/nvim/.swp'
set.undodir = home .. '/.config/nvim/.undo'
set.undofile = true
-- set.undolevels = 1000
-- set.undoreload = 10000


-- text format
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop= 4
set.cindent = true
set.autoindent = true
set.smartindent = true
set.expandtab = true
set.smarttab = true

vim.cmd([[
set winbar=%=%m\ %f


filetype plugin on


" Making it transparent background
" autocmd BufEnter * highlight Normal guibg=none ctermbg=NONE
" hi Normal guibg=NONE ctermbg=NONE
" autocmd BufEnter * highlight
" autocmd BufEnter *.c colorscheme moonfly
" autocmd BufEnter *.cc colorscheme material
" autocmd BufEnter *.cc colorscheme moonfly
" autocmd BufEnter *.md colorscheme moonfly
autocmd BufEnter *.bin colorscheme wildcharm
autocmd BufEnter *.hex colorscheme wildcharm
autocmd BufEnter *.sh colorscheme moonfly
" autocmd BufEnter * highlight Normal guibg=none ctermbg=NONE
" autocmd BufEnter * highlight Normal


" for hex | xxd
au BufReadPost *.hex set ft=xxd
au BufReadPost *.bin set ft=xxd

" cursor on windows :)
:au VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q")


" nnoremap <leader>p :lua require("nabla").popup()<CR> " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`
" For colorschemes that mess-up in guibg=None
" autocmd BufEnter * highlight EndOfBuffer guibg=None ctermbg=NONE

"NOTE: try to find the transparent option in the implementation of the colorscheme in .local/share/nvim/{colorscheme}
" you might not need the above line

" Copy & Paste From System Clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy


"-- use as <C-k>ns and <C-k>nS for ₙ and ⁿ respectively

execute "digraphs as " . 0x2090
execute "digraphs es " . 0x2091
execute "digraphs hs " . 0x2095
execute "digraphs is " . 0x1D62
execute "digraphs js " . 0x2C7C
execute "digraphs ks " . 0x2096
execute "digraphs ls " . 0x2097
execute "digraphs ms " . 0x2098
execute "digraphs ns " . 0x2099
execute "digraphs os " . 0x2092
execute "digraphs ps " . 0x209A
execute "digraphs rs " . 0x1D63
execute "digraphs ss " . 0x209B
execute "digraphs ts " . 0x209C
execute "digraphs us " . 0x1D64
execute "digraphs vs " . 0x1D65
execute "digraphs xs " . 0x2093


execute "digraphs aS " . 0x1d43
execute "digraphs bS " . 0x1d47
execute "digraphs cS " . 0x1d9c
execute "digraphs dS " . 0x1d48
execute "digraphs eS " . 0x1d49
execute "digraphs fS " . 0x1da0
execute "digraphs gS " . 0x1d4d
execute "digraphs hS " . 0x02b0
execute "digraphs iS " . 0x2071
execute "digraphs jS " . 0x02b2
execute "digraphs kS " . 0x1d4f
execute "digraphs lS " . 0x02e1
execute "digraphs mS " . 0x1d50
execute "digraphs nS " . 0x207f
execute "digraphs oS " . 0x1d52
execute "digraphs pS " . 0x1d56
execute "digraphs rS " . 0x02b3
execute "digraphs sS " . 0x02e2
execute "digraphs tS " . 0x1d57
execute "digraphs uS " . 0x1d58
execute "digraphs vS " . 0x1d5b
execute "digraphs wS " . 0x02b7
execute "digraphs xS " . 0x02e3
execute "digraphs yS " . 0x02b8
execute "digraphs zS " . 0x1dbb

execute "digraphs AS " . 0x1D2C
execute "digraphs BS " . 0x1D2E
execute "digraphs DS " . 0x1D30
execute "digraphs ES " . 0x1D31
execute "digraphs GS " . 0x1D33
execute "digraphs HS " . 0x1D34
execute "digraphs IS " . 0x1D35
execute "digraphs JS " . 0x1D36
execute "digraphs KS " . 0x1D37
execute "digraphs LS " . 0x1D38
execute "digraphs MS " . 0x1D39
execute "digraphs NS " . 0x1D3A
execute "digraphs OS " . 0x1D3C
execute "digraphs PS " . 0x1D3E
execute "digraphs RS " . 0x1D3F
execute "digraphs TS " . 0x1D40
execute "digraphs US " . 0x1D41
execute "digraphs VS " . 0x2C7D
execute "digraphs WS " . 0x1D42


]])


--  cmake colorscheme
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "cmake",
--   callback = function()
--     vim.cmd("colorscheme unokai")
--   end,
-- })


-- set background=dark
-- local ft = vim.api.nvim_buf_get_option(0, 'filetype')
-- if ft == 'vim' then
-- vim.cmd('colorscheme PaperColor')
    -- vim.cmd('highlight Normal guibg=none')
-- end



vim.g.markview_config = {
  experimental = {
    check_rtp = false, -- completely disable the check (not just hide the message)
  }
}

