set nocompatible              " be iMproved, required
set mouse=a
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Git plugin not hosted on GitHub
Plugin 'https://github.com/kien/ctrlp.vim.git'

Plugin 'https://github.com/mattn/emmet-vim.git'

Plugin 'jiangmiao/auto-pairs'

Plugin 'digitaltoad/vim-jade'

Plugin 'moll/vim-node'

"multiple cursor in vim 
Plugin 'terryma/vim-multiple-cursors'

Plugin 'fholgado/minibufexpl.vim'

"help commenting 
Plugin 'scrooloose/nerdcommenter'

"Nerd tree
Plugin 'scrooloose/nerdtree'

"navigate to function defs
Plugin 'tacahiroy/ctrlp-funky'

"View pydoc for python
Plugin 'fs111/pydoc.vim'

Bundle 'Shougo/neosnippet'
Bundle 'Shougo/neosnippet-snippets'

" Comment stuff out with gc<motion>
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-markdown'

" Ag for quick grep
Plugin 'rking/ag.vim'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

" Optional:
Plugin 'honza/vim-snippets'

" Mapping for vim multiple cursor
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-S-p>'
let g:multi_cursor_skip_key='<C-S-x>'
let g:multi_cursor_quit_key='<Esc>'

syntax enable
" Put your non-Plugin stuff after this line
"
let mapleader = "\<Space>"
set background=dark
set number
set t_Co=256
set softtabstop=2
set backspace=indent,eol,start
set incsearch             " But do highlight as you type your search.
set hlsearch
set ignorecase            " Make searches case-insensitive.
set laststatus=2          " last window always has a statusline"
set smarttab              " use tabs at the start of a line, spaces elsewhere"
set smartindent
set clipboard+=unnamed
set nobackup     " turn backup off, since most stuff is in vcs
set nowb
set encoding=utf-8

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set tabstop=4
set shiftwidth=4
filetype plugin on

" supposed to enable auto indent
set cindent
set smartindent
set autoindent
set expandtab
set number
set list
set listchars=tab:>-,trail:.,extends:#,nbsp:.

let g:ctrlp_extensions = ['funky']
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

" use f2 to toggle pating with auto-indentation 
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Always show statusline
set laststatus=2
"
" " Use 256 colours (Use this setting only if your terminal supports 256
" colours)
set t_Co=256"

"Toggle nerdtree
map <F3> <ESC>:NERDTreeToggle<RETURN>

"=======================file specific options===================
" Ruby
function! RUBYSET()
  set autoindent!
  set noexpandtab!
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab
  set autoindent

  " I prefer using same highlight for Ruby string and Ruby symbol
  hi clear rubySymbol
  hi link  rubySymbol String

  " Some simple highlight for Capybara
  syn keyword rubyRailsTestMethod feature scenario before after 
  hi link rubyRailsTestMethod Function

 nnoremap <buffer> <F9> :exec '!clear;ruby' shellescape(@%, 1)<cr>
 nnoremap <buffer> <F8> :exec '!clear;rspec' shellescape(@%, 1)<cr>
endfunction

autocmd FileType ruby   call RUBYSET()

" Python
function! PYTHONSET()
  set autoindent!
  set noexpandtab!
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
  set expandtab
  set autoindent

 nnoremap <buffer> <F9> :w<cr>:exec '!clear;python' shellescape(@%, 1)<cr>
endfunction

autocmd FileType python call PYTHONSET()

"use F4 to search for word under cursor for all files
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>




"====================for searching in vim==========================
"override for silver search 
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
"end/====================for searching in vim==========================




"====================for buffers vim==========================
"go to previous buffer
nnoremap gp :bp<CR> 

"go to next buffer
nnoremap gn :bn<CR> 

"press f5 to select buffer by number
nnoremap <F5> :buffers<CR>:buffer<Space>
"end/====================for buffers vim==========================
