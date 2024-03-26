" line numbers
set nu
set relativenumber

" tab & indent
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent

" line wrapping
set nowrap

" smart searching
set ignorecase
set smartcase
set incsearch

" cursorline
set cursorline
set scrolloff=999

" split
set splitright
set splitbelow

" highlighting
syntax on

let g:mapleader=" "

imap <silent> jk <esc>
imap <c-s> <esc>:w!<cr>

nmap <c-s> :w!<cr>
nmap <leader>q :q!<cr>

