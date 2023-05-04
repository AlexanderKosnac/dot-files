" makes it so some keys are more intuitive (arrow keys, backspace, ...)
set nocompatible

" allow backspacing over everything in insert mode
set bs=indent,eol,start

" configures autocompletion of commands
set wildchar=<tab>
set wildmode=longest,list,full
set wildmenu

" set a colorscheme you can read on a white-on-black terminal
colorscheme evening

filetype plugin on
syntax on

" show line and column number (ruler)
set statusline+=%F\ %l\:%c
set ruler

set number

" set tab width
set tabstop=4
set shiftwidth=4
