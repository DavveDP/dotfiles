" ============================================
" Minimal Vim + fzf + ripgrep setup
" ============================================

" -----------------------
" Leader key (space)
" -----------------------
let mapleader=" "

" -----------------------
" Basic settings
" -----------------------
set hidden " helps with switching buffers with unsavd changes
set nocompatible
filetype plugin indent on
set noswapfile
set tabstop=4
set shiftwidth=4
set expandtab
set tags=tags;/
set incsearch
set rnu " relative line numbers

" Automatically change Vim's working directory when opening a netrw buffer
let g:netrw_keepdir = 0

" -----------------------
" Ensure vim-plug is installed
" -----------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" -----------------------
" Plugins
" -----------------------
call plug#begin('~/.vim/plugged')

" Use system fzf
Plug 'junegunn/fzf', {}
Plug 'junegunn/fzf.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'       " optional but handy for auto-detecting clangd
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

" -----------------------
" Completion behavior
" -----------------------

let g:asyncomplete_auto_popup = 1
"set completeopt=menuone,noinsert,noselect

" -----------------------
" Clangd
" -----------------------
" Register clangd with vim-lsp
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '--background-index']},
        \ 'allowlist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" Keybindings (fits your style)
function! s:on_lsp_buffer_enabled() abort
    nnoremap <buffer> gd <plug>(lsp-definition)
    nnoremap <buffer> gr <plug>(lsp-references)
    nnoremap <buffer> gi <plug>(lsp-implementation)
    nnoremap <buffer> <leader>rn <plug>(lsp-rename)
    nnoremap <buffer> <leader>e <plug>(lsp-document-diagnostics)
    nnoremap <buffer> gh <plug>(lsp-hover)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Show diagnostics inline (optional)
let g:lsp_diagnostics_echo_cursor = 1

" -----------------------
" Force fzf.vim to use system fzf (I already have fzf installed system wide)
" -----------------------
let g:fzf_binary = '/usr/bin/fzf'   " adjust if fzf is elsewhere
let g:fzf_preview_window = ['right:50%', 'ctrl-/']  " VS Code style preview

" -----------------------
" Project-wide search mapping (like VS Code Ctrl+Shift+F)
" -----------------------
nnoremap <leader>f :Rg<CR>
nnoremap <leader>F :RG<CR>
nnoremap <leader>p :Files<CR>
nnoremap <leader>s :%s/

" error quick fix
nnoremap J :cn<CR>
nnoremap K :cp<CR>

" switching buffers
nnoremap H :bp<CR>
nnoremap L :bn<CR>
" in terminal too
tnoremap H <C-w>:bp<CR>
tnoremap L <C-w>:bn<CR>
nnoremap <leader>rc :e $MYVIMRC<CR>
nnoremap <leader>z :source $MYVIMRC<CR>
nnoremap <leader>t :tag<space>
nnoremap <leader>r :cexpr system('./build')<CR>
nnoremap <leader>h :cexpr system('./build hot')<CR>
" closing buffer without taking window with it. (will take other windows down
" that are showing the same buffer though...
" https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window
map <leader>q :bp<bar>sp<bar>bn<bar>bd!<CR>
