" BASE SETTINGS {{{
set nocompatible
language messages en_US.UTF-8
let $LANG = 'en_US.UTF-8'

if has('multi_byte')
  set encoding=utf-8
  scriptencoding utf-8
  set fileencodings=ucs-bom,utf-8,cp1251,cp866,koi8-r
endif
" }}}

" HELPERS {{{
function s:GetBasePath(dir)
  if has('win32') || has('win64')
    let l:defaultpath='$HOME/vimfiles'
  elseif has('unix')
    let l:defaultpath='$HOME/.vim'
  else
    echoerr 'Error! Your system is not supported!'
    finish
  endif
  return expand(l:defaultpath.a:dir)
endfunction

let g:basepath = s:GetBasePath('')

function ChangeSpellLang()
  if &spelllang =~ "en_us"
    setlocal spelllang=ru_yo spell
    echo "spelllang: ru_yo"
  elseif &spelllang =~ "ru_yo"
    setlocal spelllang=
    setlocal nospell
    echo "spelllang: off"
  else
    setlocal spelllang=en_us spell
    echo "spelllang: en"
  endif
endfunction

function OpenFileWithEncoding()
  if &fileencoding == 'utf-8'
    :e ++encoding=cp1251
  elseif &fileencoding == 'cp1251'
    :e ++encoding=cp866
  elseif &fileencoding == 'cp866'
    :e ++encoding=koi8-r
  else
    :e
  endif
endfunction

function OpenFileWithFileFormat()
  if &fileformat == 'unix'
    :e ++fileformat=dos
  elseif &fileformat == 'dos'
    :e ++fileformat=mac
  elseif &fileformat == 'mac'
    :e ++fileformat=unix
  endif
endfunction

function ChangeFileFormat()
  if &fileformat == 'unix'
    set fileformat=dos
  elseif &fileformat == 'dos'
    set fileformat=mac
  else
    set fileformat=unix
  endif
endfunction

function QfMakeConv()
  let qflist = getqflist()
  for i in qflist
    let i.text = iconv(i.text, "cp1251", "utf-8")
  endfor
  call setqflist(qflist)
endfunction
" }}}

" COLORSCHEME SETTINGS {{{
syntax on
set background=dark
colorscheme desert
highlight ColorColumn ctermbg=8 guibg=Grey30
set cursorline
set colorcolumn=80,120

if has("gui_running")
  set guioptions-=T
  set guioptions+=cbe
  set guioptions-=m
  set lines=40
  set columns=150
endif
" }}}

" COMMON SETTINGS {{{
set number
let mapleader="\\"
let maplocalleader=","
set wildmenu
set wildmode=list:full,full
set wildcharm=<Tab>
set backspace=indent,eol,start
set splitright
set scrolloff=5
set sidescroll=1
set sidescrolloff=30
set matchpairs+=<:>
set showmatch
set matchtime=1
set nolist
set linebreak
set nowrap
set display+=lastline,uhex
set autoread
set autowrite
set autochdir
set browsedir=buffer
set confirm
set complete-=i
set completeopt+=longest,menuone
set virtualedit=block
set showcmd
set noerrorbells
set maxmem=2000000
set maxmemtot=2000000
set maxmempattern=2000000
set laststatus=2
set statusline=%<%F
set statusline+=\ %w%h%m%r%=
set statusline+=%1*\ %*%{&fileencoding}\[%{&fileformat}]
set statusline+=%1*\ %*enc=%{&encoding}
set statusline+=%1*\ %*%04.(%{&filetype}%)
set statusline+=%1*\ %*%012.(%b(0x%04B)%)
set statusline+=%1*\ %*%015.(L:%l/%L%)\ %-5.(C:%v%)
set statusline+=%1*\ %*%P
set nottyfast
set hidden
set lazyredraw
set foldlevel=5
set fileformats+=mac
highlight clear conceal
set conceallevel=2
set formatoptions+=jn
set formatoptions-=o
set mousefocus
set clipboard=exclude:.*
set exrc
set secure
set foldmethod=syntax
" TAB SETTINGS {{{
set tabstop=2
set shiftwidth=2
set autoindent
set expandtab
set smartindent
" }}}
" KEYBOARD LANG SETTINGS {{{
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
" }}}
" HISTORY & UNDO SETTINGS {{{
set history=2000
set undofile
set undolevels=1000
set undoreload=10000
" https://coderwall.com/p/sdhfug/vim-swap-backup-and-undo-files
function s:CreateDirIfNotExists(dir)
  if isdirectory(a:dir) == 0
    call mkdir(a:dir)
  endif
endfunction
call s:CreateDirIfNotExists(g:basepath)
call s:CreateDirIfNotExists(g:basepath.'/.undo')
call s:CreateDirIfNotExists(g:basepath.'/.backup')
call s:CreateDirIfNotExists(g:basepath.'/.swp')
let &undodir=g:basepath.'/.undo//'
let &backupdir=g:basepath.'/.backup//'
let &directory=g:basepath.'/.swp//'
set nobackup
set noswapfile
" }}}
" SEARCH SETTINGS {{{
set hlsearch
set incsearch
set ignorecase
set smartcase
nnoremap <silent> <CR> :nohlsearch<CR><CR>
" }}}
" }}}

" KEY MAPPINGS {{{
set pastetoggle=<F2>
map  <F12> :if &guioptions=~'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
map  <S-F12> :e $MYVIMRC<CR>
nmap <Leader>b :bnext<CR>
nmap <Leader>B :bprev<CR>
nmap <Leader>e :enew<CR>
nmap <Leader>q :bd! %<CR>
nmap <LocalLeader>q :w<CR>:bd %<CR>
vnoremap < <gv
vnoremap > >gv
nnoremap Y y$
inoremap { {}<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap ' ''<Esc>i
inoremap " ""<Esc>i
inoremap <C-S> <C-O>:w<CR>
nnoremap <C-S> :w<CR>
vnoremap <C-S>  <Esc>:w<CR>gv
" remove trailing spaces
nnoremap <LocalLeader>ts :<C-u>%s/\s\+$//e<CR>:nohlsearch<CR>
nnoremap <LocalLeader>ff :call OpenFileWithFileFormat()<CR>
" create file under cursor
nnoremap <Leader>cf :call mkdir(expand("<cfile>:h"), "p")<CR>:call writefile([], expand("<cfile>"), "t")<CR>
" format xml (beautify)
nnoremap <LocalLeader>fx vip
      \:j<CR>
      \:%s/>\s*</>\r</ge<CR>
      \:%s/\s\+\(\w\+\s*=\s*".\{-}"\)/\r\1/ge<CR>
      \:set ft=xml<CR>
      \GVgg=<CR>
      \:nohlsearch<CR>
highlight def link _color1 DiffAdd
highlight def link _color2 DiffChange
highlight def link _color3 DiffDelete
nnoremap <LocalLeader>m :call matchadd("_color1", '<C-R>/')<CR>
nnoremap <LocalLeader>j :call matchadd("_color2", '<C-R>/')<CR>
nnoremap <LocalLeader>n :call matchadd("_color3", '<C-R>/')<CR>
nnoremap <LocalLeader>l :call matchadd('Tag', '\%'.line('.').'l')<CR>
nnoremap <LocalLeader>b :call clearmatches()<CR>
" }}}

augroup xml
  autocmd BufNewFile,BufReadPost *.xml setlocal cursorcolumn
augroup END
autocmd FocusGained,BufEnter *.log checktime
" Special menu {{{
menu Special.Gui\ Font.Consolas :set guifont=Consolas<CR>
menu Special.Gui\ Font.-Gui\ Font- :
menu Special.Save\ As\ Encoding.utf-8 :write ++encoding=utf-8<CR>:e ++encoding=utf-8 %<CR>
menu Special.Save\ As\ Encoding.cp1251 :write ++encoding=cp1251<CR>:e ++encoding=cp1251 %<CR>
menu Special.Save\ As\ Encoding.cp866 :write ++encoding=cp866<CR>:e ++encoding=cp866 %<CR>
menu Special.Save\ As\ Encoding.koi8-r :write ++encoding=koi8-r<CR>:e ++encoding=koi8-r %<CR>
menu Special.Save\ As\ Encoding.-Save\ As\ Encoding- :
menu Special.Spell\ Lang.English :setlocal spell spelllang=en_us<CR>
menu Special.Spell\ Lang.Russian :setlocal spell spelllang=en_us,ru_yo<CR>
menu Special.Spell\ Lang.English\ +\ Russian :setlocal spell spelllang=en_us,ru_yo<CR>
menu Special.Spell\ Lang.Off :setlocal nospell spelllang=<CR>
menu Special.Spell\ Lang.-Spell\ Lang- :
menu Special.ReOpen\ with\ File\ format<TAB>,ff :call OpenFileWithFileFormat()<CR>
nnoremap <Leader>ms :emenu Special.<Tab>
" }}}

" Modelines: {{{
" vim: set foldmarker={{{,}}} foldlevel=0 foldcolumn=1 foldmethod=marker:
" }}}

