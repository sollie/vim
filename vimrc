set nocompatible
filetype off
set colorcolumn=90

let g:plug_threads = 32

if !filereadable($HOME . '/.vim/lastupdate')
  silent! execute("!bash -c \"touch " . $HOME . "/.vim/lastupdate\"")
endif

if isdirectory($HOME . '/.vim/plugged') == 0
  silent! mkdir ~/.vim/backup
  silent! mkdir ~/.vim/autoload
  silent! mkdir ~/.vim/swap
  silent! mkdir ~/.vim/undo
  let time = [localtime()]
  silent! call writefile(time, glob($HOME . '/.vim/lastupdate'), 'b')
  silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>&1
  autocmd VimEnter * PlugInstall --sync | q
endif

if (localtime() - getftime($HOME . '/.vim/lastupdate') > 604800)
  let time = [localtime()]
  silent! call writefile(time, glob($HOME . '/.vim/lastupdate'), 'b')
  autocmd VimEnter * PlugUpdate --sync | q
  redraw!
endif

call plug#begin('~/.vim/plugged')

Plug 'VundleVim/Vundle.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'saltstack/salt-vim'
Plug 'Glench/Vim-Jinja2-Syntax'
if v:version > 800
    Plug 'fatih/vim-go'
endif
Plug 'scrooloose/nerdtree'
Plug 'Shougo/unite.vim'
Plug 'scrooloose/syntastic'
Plug 'roman/golden-ratio'
Plug 'majutsushi/tagbar'
Plug 'sirtaj/vim-openscad'
Plug 'airblade/vim-gitgutter'

Plug 'josuegaleas/jay'
Plug 'nsf/gocode', {'rtp': 'vim/'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'chr4/nginx.vim'
Plug 'ekalinin/dockerfile.vim'

Plug 'vim-airline/vim-airline'       " UI statusbar niceties
Plug 'vim-airline/vim-airline-themes'

call plug#end()

set updatetime=100

if (v:version == 704 && has('patch2201')) || v:version >= 800
  set signcolumn=yes
endif

set laststatus=2               " enable airline even if no splits
let g:go_metalinter_command = 'golangci-lint'
if !exists("g:pluginname_setting")
let g:airline_symbols = {}
"let g:airline_theme='jay'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#syntastic#enabled=1
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '␊ '
let g:airline_symbols.linenr = '␤ '
let g:airline_symbols.linenr = '¶ '
let g:airline_symbols.branch = '⎇ '
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline#extensions#tabline#enabled = 0
let g:airline_mode_map = {
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'REPLACE',
      \ 'v' : 'VISUAL',
      \ 'V' : 'V-LINE',
      \ 'c' : 'CMD   ',
      \ ' ': 'V-BLCK',
      \ }
endif

filetype plugin on

" change the mapleader from \ to ,
let mapleader=","

set completeopt=menu
" Autocomplete
inoremap <leader>, <C-x><C-o>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

set encoding=utf-8
scriptencoding utf-8
set hidden

set laststatus=2

set list
set listchars=tab:•\ ,trail:•,extends:»,precedes:«

set nowrap        " don't wrap lines
set tabstop=2     " a tab is two spaces
set expandtab
set backspace=indent,eol,start
" allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=2  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
"    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
"    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep

set nobackup
set noswapfile

set whichwrap=b,s,h,l,<,>,[,]

filetype plugin indent on

if &term !~ 'xterm'
  set termguicolors
endif

if &t_Co >= 256 || has("gui_running")
  set background=dark
  silent! colorscheme jay
endif

if &t_Co > 2 || has("gui_running")
  " switch syntax highlighting on, when the terminal has colors
  syntax on
endif

fun! AllIndent()
  let oldLine=line('.')
  normal(gg=G)
  execute ':' . oldLine
endfun
map -- :call AllIndent()<cr>

vmap Q gq
nmap Q gqap
nmap <silent> ,/ :nohlsearch<CR>
cmap w!! w !sudo tee % >/dev/null

set pastetoggle=<F2>

let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
"let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
"let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'errcheck']

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }

set noshowmode
nmap <F8> :TagbarToggle<CR>

nnoremap <silent> <Leader>m :Unite -buffer-name=recent -winheight=10 file_mru<cr>
nnoremap <Leader>b :Unite -buffer-name=buffers -winheight=10 buffer<cr>
nnoremap <Leader>f :Unite grep:.<cr>

" CtrlP search
silent! call unite#filters#matcher_default#use(['matcher_fuzzy'])
silent! call unite#filters#sorter_default#use(['sorter_rank'])
silent! call unite#custom#source('file_rec/async','sorters','sorter_rank')
" replacing unite with ctrl-p
nnoremap <silent> <C-p> :Unite -start-insert -buffer-name=files -winheight=10 file_rec/async<cr>

noremap <Leader>n :NERDTreeToggle<cr>
""" Vim environment handling tweaks ====
""""" BACKUP / TMP FILES
" taken from
" http://stackoverflow.com/questions/4331776/change-vim-swap-backup-undo-file-name
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo='10,\"100,:20,%,n~/.vim/viminfo

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
