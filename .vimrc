"colors
if &t_Co >= 256
    set background=dark
    colorscheme inkpot
endif

"basic options
syntax on
set nocompatible
set history=100
set ruler
set fileencodings=ucs-bom,utf8,euc-jp,shift-jis,default,latin1
set ttyfast
set nobackup
set showtabline=2
set hidden
set scrolloff=3
set switchbuf=useopen
set lbr
set number
set numberwidth=4

"save last 1000 jumps and global marks
set viminfo='1000,f1

"allow increment / decrement of single chars
set nrformats=hex,alpha

"toggle yes/no & co.
function s:ToggleYesNo()
  let w=expand("<cword>")
  if     w==#"yes"    | let w="no"
  elseif w==#"no"     | let w="yes"
  elseif w==#"on"     | let w="off"
  elseif w==#"off"    | let w="on"
  elseif w==#"manual" | let w="auto"
  elseif w==#"auto"   | let w="manual"
  elseif w==#"true"   | let w="false"
  elseif w==#"false"  | let w="true"
  elseif w==#"True"   | let w="False"
  elseif w==#"False"  | let w="True"
  else                | let w=""
  endif
  if w!=""
    exec "normal! \"_ciw\<C-R>=w\<CR>\<Esc>b"
  endif
endfunc
nnoremap gy :call <SID>ToggleYesNo()<CR>

"yankring
let g:yankring_min_element_length = 2
let g:yankring_max_display = 70
let g:yankring_manage_numbered_reg = 1
let g:yankring_history_dir = '$HOME/.vim/'
set cpoptions+=y

"line length
set textwidth=80
"t wrap text
"c and comments,
"r comment leader on <Enter>,
"q allow gq,
"n numbered lists,
"m break multi-byte,
"a auto-format
set formatoptions=tcrqnm

"search
set incsearch
set ignorecase
set smartcase
set hlsearch

"indenting
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set backspace=indent,eol,start
filetype plugin indent on

"virtual edit
set virtualedit=all
set mouse=a

"clear search
map <F4> :let @/ = ""<CR>
"disable highlighting
map <F5> :set hls!<bar>set hls?<CR>

"move up and down in wrapped, not real lines
map <Down> gj
map <Up> gk

"automatically make scripts executable
function! FileExecutable (fname)
    execute "silent! ! test -x" a:fname
    return v:shell_error
endfunction
au BufWritePost *.sh if FileExecutable("%:p") | silent !chmod a+x <afile> | endif

"wildmode
set wildmode=longest,full
set wildmenu

"folding, set foldlevel to something high to circumvent starting with closed
"folds
"set foldmethod=indent
set foldlevel=20
nnoremap <space> za
vnoremap <space> zf
au FileType c set foldmethod=syntax
au FileType cpp set foldmethod=syntax
au FileType perl set foldmethod=syntax
au FileType ruby set foldmethod=syntax

"buffer switching with <f1>, <f2> and \h, \g
noremap <f1> :bprev<CR>
noremap <f2> :bnext<CR>
noremap <Leader>h :bprev<CR>
noremap <Leader>g :bnext<CR>
"go to last buffer used
map <Leader>; <C-^>
map <Leader>_ <C-W>w

"vim-explorer
let g:VEConf_showHiddenFiles = 0
let g:VEConf_filePanelSortType = 1

"more useful indent keys
no <C-d> >>
no <C-t> <<

"Jesus saves
cabbr jesus write

"perldo is too long
cabbr pd perldo

"faster writing
map WW :w<CR>
map WA :wa<CR>

"perl stuff
let perl_include_pod = 1
let perl_extended_vars = 1
let perl_fold = 1
"let perl_fold_blocks

"supertab
let g:SuperTabDefaultCompletionType = "context"

"toggle paste with F3
:set pastetoggle=<F3>

"underline with F11 (=) / F12 (-)
nnoremap <F11> yyp<c-v>$r=
inoremap <F11> <Esc>yyp<c-v>$r=o
nnoremap <F12> yyp<c-v>$r-
inoremap <F12> <Esc>yyp<c-v>$r-o
