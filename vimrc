" Switch from the default Vi-compatibility
set nocompatible

" Turn on syntax highlighting.
syntax on

" Show matching braces when text indicator is over them.
set showmatch

" Disable the default Vim startup message.
set shortmess+=I

" Show relative line numbers.
set number
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings
nmap Q <Nop>
map <C-s> <Nop>

" Disable audible bell
set noerrorbells visualbell t_vb=

" Enable mouse support.
set mouse+=a

" Make the navigation between the split windows easier.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Set tab width to 4 columns and replace by spaces
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Set the leader key to space
let mapleader = " "

" Set colorscheme
colorscheme ron

" Vertical lines at 80 and 100 characters
:set colorcolumn=80,100
highlight ColorColumn ctermbg=0

" ctrlp.vim

" Easymotion
let g:EasyMotion_smartcase = 1
map <Leader> <Plug>(easymotion-prefix)

" NERDtree
nnoremap <Leader>nt :NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
