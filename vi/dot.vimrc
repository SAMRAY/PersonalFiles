"--------------------
" 基本的な設定
"--------------------
"vi互換を無効
set nocompatible

"新しい行のインデントを現在行と同じにする
set autoindent
 
"バックアップファイルのディレクトリを指定する
set backupdir=$HOME/.vimbackup
"set nobackup

"スワップファイル用のディレクトリを指定する
set directory=$HOME/.vimbackup
"set noswapfile

"変更中のファイルでも、保存しないで他のファイルを表示する
set hidden

"インクリメンタルサーチを行う
set incsearch
 
"行番号を表示する
set number

"閉括弧が入力された時、対応する括弧を強調する
set showmatch

"新しい行を作った時に高度な自動インデントを行う
set smarttab

" インデントとタブ表示設定
set smartindent
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
" ソフトタブ
set noexpandtab

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78
    autocmd! FileType javascript setlocal shiftwidth=4 tabstop=2 softtabstop=2
    "set colorcolumn=80
    " set shiftround
    "set expandtab
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

    augroup END

else
    " always set autoindenting on
    set autoindent

endif   " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" 文字コードの自動認識
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
" iconvがeucJP-msに対応しているかをチェック
if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
	let s:enc_euc = 'eucjp-ms'
	let s:enc_jis = 'iso-2022-jp-3'
" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
" fileencodingsを構築
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
	if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
		let &fileencoding=&encoding
	endif
endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
	set ambiwidth=double
endif

set fileformats=unix,dos,mac
if exists('&ambiwidth')
	set ambiwidth=double
endif

" ステータスラインを常に２行にする
set laststatus=2    " See :help laststatus
" ステータスラインに文字コードと改行文字を常に表示しておく
set statusline =%<%F\ %m%r%h%w
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}
set statusline+=%=%l,%c%V%8P

"-----------------------------------------------------------------------------
" Binary editor mode: vim -b or *.bin to boot
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r | endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END

set backspace=2     " 'Backspace' can delete indent and CR/LF
set wrapscan
set showmatch
set wildmenu        " See :help wildmenu
set formatoptions+=mM
let format_allow_over_tw=1


"---------------------------------------------------------------------------
set noignorecase
set smartcase
set nowrap
set ruler
set list
set listchars=tab:\|-,extends:<,eol:$
set cmdheight=2
set showcmd
set title

set viminfo=
set autoread

set wildmode=longest,list,full

abbr RULER \|----\|----\|----\|----\|----\|----\|----\|----\|----\|----\|----\|----\|----\|----\|----\|
abbr HLINE ----------------------------------------------------------------------------
abbr ULINE ____________________________________________________________________________
abbr ILINE ############################################################################
abbr SLINE ////////////////////////////////////////////////////////////////////////////
abbr PLINE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
abbr 4LINE dnl ########################################################################

" map <F2> :r!date +\%F
" map <F2> a<C-R>=strftime("%F %T %z")<CR><Esc>
map  <F1> <ESC>
imap <F1> <ESC>
map  <F2> a<C-R>=strftime("%a, %e %b %Y %T %z (%Z)")<CR><Esc>
map  <F3> :r!cat ~/.myaddr

nnoremap j gj
nnoremap k gk
map <kPlus> <C-W>+
map <kMinus> <C-W>-
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" http://www.e2esound.com/wp/2010/11/07/add_vimrc_settings/
" imap {} {}<Left>
" imap [] []<Left>
" imap () ()<Left>
" imap <> <><Left>

" Do not load the following plug-ins.
let loaded_gzip = 0                 " plugin/gzip.vim
let loaded_getscriptPlugin = 0      " plugin/getScriptPlugin.vim
let loaded_matchparen = 0           " plugin/matchparen.vim
let loaded_netrwPlugin = 255        " plugin/netrwPlugin.vim
let loaded_rrhelper = 255           " plugin/rrhelper.vim
let loaded_spellfile_plugin = 255   " plugin/spellfile.vim
let loaded_tarPlugin = 255          " plugin/tarPlugin.vim
let TOhtml = 255                    " plugin/tohtml.vim
"let loaded_vimballPlugin = 0       " plugin/vimballPlugin.vim
let loaded_zipPlugin = 255          " plugin/zipPlugin.vim

" lightline.vim
" https://github.com/itchyny/lightline.vim
let g:lightline = { 'colorscheme': 'wombat' }

" Language libraries for Kaoriya
" See http://code.google.com/p/macvim-kaoriya/wiki/Readme
if has('kaoriya')
    let $PERL_DLL = ''
    let $PYTHON_DLL = ''
    let $RUBY_DLL = ''
endif

