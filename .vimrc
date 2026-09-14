set number
set list
set title
set belloff=all
set laststatus=2
set ruler
syntax on
let mapleader = "\<Space>"
set fenc=utf-8
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set listchars=tab:¦\ ,eol:↲,trail:_,extends:»,precedes:«,nbsp:%
set autoindent
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
set mouse=a
vnoremap < <gv
vnoremap > >gv
noremap x "_x
noremap X "_X
noremap c "_c
noremap C "_C
noremap s "_s
noremap S "_S
xnoremap <expr> p 'pgv"'.v:register.'y`>'
set ignorecase
set smartcase
set hlsearch
nnoremap <Leader>q :nohlsearch<CR>
set incsearch
set history=100
set clipboard=unnamed
set noswapfile
set autoread
set showcmd
set ambiwidth=double
set autochdir
nnoremap tm :belowright :terminal<CR>
