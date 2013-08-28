" source /etc/vimrc

syntax on
set number
set highlight=on
set scrolloff=10
set hlsearch

" swp file
set directory=/tmp
set directory+=~/.vim/tmp
set directory+=.

" backup file
set backupdir=/tmp
set backupdir+=~/.vim/tmp
set backupdir+=.

" indent
set autoindent
set tabstop=4
set expandtab
set shiftwidth=4
set shiftround

" for white-space detection
set list
set listchars=tab:>-,trail:-,nbsp:-,extends:>,precedes:<,
" 行頭のスペースの連続をハイライトさせる
" Tab文字も区別されずにハイライトされるので、区別したいときはTab文字の表示を別に
" 設定する必要がある。
function! SOLSpaceHilight()
    syntax match SOLSpace "^\s\+" display containedin=ALL
    highlight SOLSpace term=underline ctermbg=LightGray
endf
" 全角スペースをハイライトさせる。
function! JISX0208SpaceHilight()
    syntax match JISX0208Space "　" display containedin=ALL
    highlight JISX0208Space term=underline ctermbg=LightCyan
endf
" syntaxの有無をチェックし、新規バッファと新規読み込み時にハイライトさせる
if has("syntax")
"    syntax on
        augroup invisible
        autocmd! invisible
        "autocmd BufNew,BufRead * call SOLSpaceHilight()
        autocmd BufNew,BufRead * call JISX0208SpaceHilight()
    augroup END
endif

" Enable mouse support.
set mouse=a

" For screen.
if &term =~ "^screen"
    augroup MyAutoCmd
        autocmd VimLeave * :set mouse=
     augroup END

    " screenでマウスを使用するとフリーズするのでその対策
    set ttymouse=xterm2
endif

if has('gui_running')
    " Show popup menu if right click.
    set mousemodel=popup

    " Don't focus the window when the mouse pointer is moved.
    set nomousefocus
    " Hide mouse pointer on insert mode.
    set mousehide
endif

" Esc
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>

" backspace
noremap  
noremap!  
noremap <BS> 
noremap! <BS> 

" search from current word
nnoremap * *N
nnoremap # #N

" save
nnoremap ; :w<CR>

" window & tab
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <Space> <C-w>

" color scheme
colorscheme slate

" 文字コードの自動認識
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,ucs-bom,euc-jp,eucjp-ms,cp932
set fileencoding=utf-8

""" unite.vim
" unite prefix key
nnoremap [unite] <Nop>
nmap <Space>u [unite]

let g:unite_source_history_yank_enable =1 "history/yankの有効化
let g:unite_cursor_line_highlight = 'TabLineSel' "highlight color

" unite mappings
nnoremap [unite]f :<C-u>Unite file file/new<CR>
nnoremap [unite]b :<C-u>Unite buffer tab<CR>
nnoremap [unite]t :<C-u>Unite tab<CR>
nnoremap [unite]a :<C-u>Unite file file/new buffer tab<CR>
nnoremap [unite]h :<C-u>Unite file_mru<CR>
nnoremap [unite]s :<C-u>Unite file_rec<CR>
nnoremap [unite]l :<C-u>Unite line<CR>
nnoremap [unite]y :<C-u>Unite history/yank<CR>
nnoremap [unite]r :<C-u>UniteResume<CR>
nnoremap [unite]bd :<C-u>UniteWithBufferDir file file/new<CR>
nnoremap [unite]cd :<C-u>UniteWithCurrentDir file file/new<CR>
nnoremap <expr> [unite]% ':<C-u>Unite file file/new -input=' . expand('%:p') . '<CR>'

" for operator replace
map _ <Plug>(operator-replace)

" alignta
vnoremap <silent> => :Align @1 =><CR>
vnoremap <silent> = :Align @1 =<CR>
vnoremap <silent> ? :Align @1 ?<CR>
vnoremap <silent> : :Align @1 :<CR>

" jump2pm
noremap fg :call Jump2pm('vne')<ENTER>
noremap ff :call Jump2pm('e')<ENTER>
noremap fd :call Jump2pm('sp')<ENTER>
noremap ft :call Jump2pm('tabe')<ENTER>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" NeoBundle
set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/neobundle.vim.git

  call neobundle#rc(expand('~/.bundle'))
endif

" GitHubから取得する場合
" NeoBundle 'ユーザ名/リポジトリ名'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'hotchpotch/perldoc-vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-textobj-between.git'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'h1mesuke/vim-alignta.git'
NeoBundle 'h1mesuke/textobj-wiw.git'
NeoBundle 'vimtaku/vim-textobj-sigil'
NeoBundle 'nakatakeshi/jump2pm.vim.git'

" vim-scripts 上のリポジトリから取得する場合
" NeoBundle 'スクリプト名'
NeoBundle 'surround.vim'
NeoBundle 'sudo.vim'

" それ以外のgitリポジトリから取得する場合
" NeoBundle 'git://URI'

filetype plugin on
filetype indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" perl dumper util
" HOW TO USE: yank perl variable, then type ",z"

function! DataDumper()
   let l:use_str = 'use Data::Dumper;'
   let l:yanked = getreg('""')
   let l:currow = getpos(".")[1]
   let l:escaped_yanked = escape(escape(escape(l:yanked, '$'), '@'), '%')
   let l:str = 'warn "{XXX DEBUG ['.bufname('').'] L'.l:currow. '} '. l:escaped_yanked .' is below.";'
   call append(l:currow, l:use_str)
   call append(l:currow+1, l:str)
   call append(l:currow+2, 'warn Dumper '.l:yanked.';')
   let l:pos = getpos(".")
   let l:list = l:pos[1:3]
   let l:list[0] = l:list[0] + 1
   call cursor(l:list)
endf
augroup Dumpers
   :au!
   au Filetype perl noremap ,z :call DataDumper()<CR>
   au Filetype javascript noremap ,z o<ESC>p_iconsole.debug(<ESC>A);<ESC>yypkf(a'<ESC>$F)ha='<ESC>=j
   au Filetype c noremap ,z o<ESC>p_iprintf("<ESC>A\n");<ESC>==;
aug END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set history must come after set no compatible statement
set history=1000
