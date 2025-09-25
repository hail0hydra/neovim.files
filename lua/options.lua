local set = vim.opt

set.expandtab = true
set.tabstop = 4
set.smarttab = true
set.shiftwidth = 4

set.wrap = true

set.splitbelow = true
set.splitright = true

set.number = true
set.relativenumber = true
set.scrolloff = 5

set.ignorecase = true
set.cursorline = true

set.termguicolors = true
set.mouse = 'a'


vim.cmd([[
set winbar=%=%m\ %f


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


" For colorschemes that mess-up in guibg=None
" autocmd BufEnter * highlight EndOfBuffer guibg=None ctermbg=NONE

"NOTE: try to find the transparent option in the implementation of the colorscheme in .local/share/nvim/{colorscheme} 
" you might not need the above line

" Copy & Paste From System Clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy
]])


--  cmake colorscheme
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "cmake",
--   callback = function()
--     vim.cmd("colorscheme unokai")
--   end,
-- })


-- set autoindent
-- " set smartindent
-- set background=dark
-- set softtabstop=4
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

