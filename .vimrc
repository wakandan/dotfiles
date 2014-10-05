set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'https://github.com/kien/ctrlp.vim.git'
Plugin 'https://github.com/mattn/emmet-vim.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'jiangmiao/auto-pairs'
Plugin 'Valloric/YouCompleteMe'

" track the engine
Plugin 'sirver/ultisnips'
"
" " Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

Plugin 'digitaltoad/vim-jade'

Plugin 'moll/vim-node'

"multiple cursor in vim 
Plugin 'terryma/vim-multiple-cursors'

"help commenting 
Plugin 'scrooloose/nerdcommenter'

"nice status line for vim
Plugin 'Lokaltog/powerline'

"navigate to function defs
Plugin 'tacahiroy/ctrlp-funky'

Plugin 'python-rope/ropevim'

"View pydoc for python
Plugin 'fs111/pydoc.vim'


"move between buffers
"map bh :bp<cr>
"map bl :bn<cr>
"
"" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

" Mapping for vim multiple cursor
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-S-p>'
let g:multi_cursor_skip_key='<C-S-x>'
let g:multi_cursor_quit_key='<Esc>'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

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

" omni completion for ctrl+n
set omnifunc=syntaxcomplete#Complete

" supposed to enable auto indent
set cindent
set smartindent
set autoindent
set expandtab
set number
set list
set listchars=tab:>-,trail:.,extends:#,nbsp:.

" resolve conflict between YouCompleteMe & UltiSnip
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-e>"
" this mapping Enter key to <C-y> to chose the current highlight item 
" and close the selection list, same as other IDEs.
" CONFLICT with some plugins like tpope/Endwise
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

let g:ctrlp_extensions = ['funky']
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>

" use f2 to toggle pating with auto-indentation 
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"enable vim solarized
syntax enable
set background=dark
colorscheme solarized

set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

" Always show statusline
set laststatus=2
"
" " Use 256 colours (Use this setting only if your terminal supports 256
" colours)
set t_Co=256"
