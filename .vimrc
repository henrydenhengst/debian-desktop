" ~/.vimrc

" Basic settings
set nocompatible            " Use Vim defaults
set number                  " Show line numbers
set relativenumber          " Relative line numbers for quick movement
set cursorline              " Highlight current line
set showcmd                 " Show command in bottom bar
set showmode                " Show current mode
set ruler                   " Show the cursor position
set hidden                  " Allow background buffers
set mouse=a                 " Enable mouse support
set clipboard=unnamedplus   " Use system clipboard
set encoding=utf-8

" Indentation
set tabstop=4               " Tab = 4 spaces
set shiftwidth=4            " Indent = 4 spaces
set softtabstop=4
set expandtab               " Use spaces instead of tabs
set autoindent
set smartindent

" Searching
set ignorecase              " Case-insensitive search
set smartcase               " ... unless uppercase used
set incsearch               " Show match while typing
set hlsearch                " Highlight matches

" Appearance
syntax on                   " Enable syntax highlighting
set background=dark         " Good for terminal themes
colorscheme desert          " Change to a preferred scheme (e.g., elflord, slate, murphy)
set termguicolors           " Enable true color support (if terminal supports it)

" Status and command bar
set laststatus=2            " Always show status line
set wildmenu                " Enhanced command completion
set wildmode=longest:full,full

" File handling
set backupdir=~/.vim/tmp//
set directory=~/.vim/tmp//
set undodir=~/.vim/undo//
set backup
set writebackup
set swapfile
set undofile                " Persistent undo

" Key mappings
nnoremap <Space> :noh<CR>   " Space clears search highlight
nnoremap <C-s> :w<CR>       " Ctrl+S to save
inoremap jk <Esc>           " 'jk' to exit insert mode

" Enable true color (needed for proper Nerd Font rendering)
if has("termguicolors")
  set termguicolors
endif

" System admin quick open
command! Vbash :e ~/.bashrc
command! Vvim :e ~/.vimrc

" Plugin system (optional starter)
" Uncomment below if you want to start using plugins later with vim-plug
"
" call plug#begin('~/.vim/plugged')
" Plug 'tpope/vim-sensible'
" Plug 'preservim/nerdtree'
" Plug 'airblade/vim-gitgutter'
" Plug 'vim-airline/vim-airline'
" call plug#end()

" End of ~/.vimrc