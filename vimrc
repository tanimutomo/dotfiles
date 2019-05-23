set encoding=utf-8
scriptencoding utf-8
" ↑1行目は読み込み時の文字コードの設定
" ↑2行目はVim Script内でマルチバイトを使う場合の設定
" Vim scritptにvimrcも含まれるので、日本語でコメントを書く場合は先頭にこの設定が必要になる

"----------------------------------------------------------
" NeoBundle
"----------------------------------------------------------
if has('vim_starting')
    " 初回起動時のみruntimepathにNeoBundleのパスを指定する
    set runtimepath+=~/.vim/bundle/neobundle.vim/

    " NeoBundleが未インストールであればgit cloneする・・・・・・①
    if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
        echo "install NeoBundle..."
        :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" インストールするVimプラグインを以下に記述
" NeoBundle自身を管理
NeoBundleFetch 'Shougo/neobundle.vim'
" カラースキームsolarized
"NeoBundle 'altercation/vim-colors-solarized'
" カラースキーム neodark
NeoBundle 'KeitaNakamura/neodark.vim'
" ステータスラインの表示内容強化
NeoBundle 'itchyny/lightline.vim'
" インデントの可視化
NeoBundle 'Yggdroot/indentLine'
" 構文エラーチェック
NeoBundle 'scrooloose/syntastic'
" プロジェクトに入ってるESLintを読み込む
NeoBundle 'pmsorhaindo/syntastic-local-eslint.vim'
" NERDTree
NeoBundle 'scrooloose/nerdtree'
" git plugin for NERDTree
NeoBundle 'Xuyuanp/nerdtree-git-plugin'
" display git diff at the left of row number
NeoBundle "airblade/vim-gitgutter"
" git diff on code
NeoBundle "tpope/vim-fugitive"
" emmet
" NeoBundle 'mattn/emmet-vim'
" Vimpyter
" NeoBundle 'szymonmaszke/vimpyter'

" vimのlua機能が使える時だけ以下のVimプラグインをインストールする
if has('lua')
    " コードの自動補完
    " NeoBundle 'Shougo/neocomplete.vim'
    " スニペットの補完機能
    " NeoBundle 'Shougo/neosnippet'
    " スニペット集
    " NeoBundle 'Shougo/neosnippet-snippets'
endif

call neobundle#end()

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

" 未インストールのVimプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
NeoBundleCheck

"----------------------------------------------------------
" カラースキーム
"----------------------------------------------------------
syntax enable
set background=dark
colorscheme neodark

"----------------------------------------------------------
" 文字
"----------------------------------------------------------
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題を解決

"----------------------------------------------------------
" ステータスライン
"----------------------------------------------------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの位置を表示する

"----------------------------------------------------------
" コマンドモード
"----------------------------------------------------------
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

"----------------------------------------------------------
" insert mode
"----------------------------------------------------------
inoremap  ha
inoremap  la
if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif

"----------------------------------------------------------
" タブ・インデント
"----------------------------------------------------------
" set expandtab " タブ入力を複数の空白入力に置き換える
" set tabstop=4 " 画面上でタブ文字が占める幅
" set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
" set autoindent " 改行時に前の行のインデントを継続する
" set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
" set shiftwidth=4 " smartindentで増減する幅

set autoindent          "改行時に前の行のインデントを計測
set smartindent         "改行時に入力された行の末尾に合わせて次の行のインデントを増減する 
set cindent             "Cプログラムファイルの自動インデントを始める
set smarttab            "新しい行を作った時に高度な自動インデントを行う
set expandtab           "タブ入力を複数の空白に置き換える 

set tabstop=2           "タブを含むファイルを開いた際, タブを何文字の空白に変換するか
set shiftwidth=2        "自動インデントで入る空白数
set softtabstop=0       "キーボードから入るタブの数

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "ファイルタイプに合わせたインデントを利用
  filetype indent on
  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType js          setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType css         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scss        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sass        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType javascript  setlocal sw=2 sts=2 ts=2 et
endif

"----------------------------------------------------------
" 文字列検索
"----------------------------------------------------------
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト

" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"----------------------------------------------------------
" カーソル
"----------------------------------------------------------
set number " 行番号を表示
set cursorline
"set cursorcolumn

nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk
nnoremap ; :


" バックスペースキーの有効化
set backspace=indent,eol,start

"----------------------------------------------------------
" カッコ・タグの対応
"----------------------------------------------------------
set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する

"----------------------------------------------------------
" マウスでカーソル移動とスクロール
"----------------------------------------------------------
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

"----------------------------------------------------------
" クリップボードからのペースト
"----------------------------------------------------------
" 挿入モードでクリップボードからペーストする時に自動でインデントさせないようにする
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

"----------------------------------------------------------
" clipboardと連携
"----------------------------------------------------------
set clipboard+=unnamed

"----------------------------------------------------------
" neocomplete・neosnippetの設定
"----------------------------------------------------------
if neobundle#is_installed('neocomplete.vim')
    " Vim起動時にneocompleteを有効にする
    let g:neocomplete#enable_at_startup = 1
    " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " 3文字以上の単語に対して補完を有効にする
    let g:neocomplete#min_keyword_length = 3
    " 区切り文字まで補完する
    let g:neocomplete#enable_auto_delimiter = 1
    " 1文字目の入力から補完のポップアップを表示
    let g:neocomplete#auto_completion_start_length = 1
    " バックスペースで補完のポップアップを閉じる
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

    " エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定
    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
    " タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ
    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
endif

"----------------------------------------------------------
" Syntastic
"----------------------------------------------------------
" 構文エラー行に「>>」を表示
let g:syntastic_enable_signs = 1
" 他のVimプラグインと競合するのを防ぐ
let g:syntastic_always_populate_loc_list = 1
" 構文エラーリストを非表示
let g:syntastic_auto_loc_list = 0
" ファイルを開いた時に構文エラーチェックを実行する
let g:syntastic_check_on_open = 1
" 「:wq」で終了する時も構文エラーチェックする
let g:syntastic_check_on_wq = 1

" Javascript用. 構文エラーチェックにESLintを使用
let g:syntastic_javascript_checkers=['eslint']
" Javascript以外は構文エラーチェックをしない
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['javascript'],
                           \ 'passive_filetypes': [] }

"----------------------------------------------------------
" NERDTree
"----------------------------------------------------------
"nnoremap <silent><C-e> :NERDTreeToggle<CR>
"nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTree<CR>

"引数なしでvimを開いたらNERDTreeを起動、
"引数ありならNERDTreeは起動しない、引数で渡されたファイルを開く。
"How can I open a NERDTree automatically when vim starts up if no files were specified?
"autocmd vimenter * if !argc() | NERDTree | endif
"
"最初からNERDTreeを表示
autocmd VimEnter * execute 'NERDTree'

"起動時はファイルの方にカーソルを合わせる
"function s:MoveToFileAtStart()
"  call feedkeys("\<Space>")
"  call feedkeys("\s")
"  call feedkeys("\l")
"endfunction
"
"- autocmd VimEnter * execute 'NERDTree'
"+ autocmd VimEnter * NERDTree | call s:MoveToFileAtStart() 


"他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる。
"How can I close vim if the only window left open is a NERDTree?
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"NERDChristmasTree カラー表示する。
"Defaultでカラー表示、カラースキーマを設定しているとそちらが優先される？
"Values: 0 or 1.
"Default: 1.
"let g:NERDChristmasTree=0
"let g:NERDChristmasTree=1

"ファイルオープン後の動作
"0 : そのままNERDTreeを開いておく。
"1 : NERDTreeを閉じる。
"Values: 0 or 1.
"Default: 0
let g:NERDTreeQuitOnOpen=0
"let g:NERDTreeQuitOnOpen=1

"NERDTreeIgnore 無視するファイルを設定する。
"'\.vim$'ならばfugitive.vimなどのファイル名が表示されない。
"\ エスケープ記号
"$ ファイル名の最後
let g:NERDTreeIgnore=['\.clean$', '\.swp$', '\.bak$', '\~$']
"let g:NERDTreeIgnore=['\.vim$', '\.clean$']
"let g:NERDTreeIgnore=['\.vim$', '\~$']
"let g:NERDTreeIgnore=[]

"NERDTreeShowHidden 隠しファイルを表示するか？
"f コマンドの設定値
"0 : 隠しファイルを表示しない。
"1 : 隠しファイルを表示する。
"Values: 0 or 1.
"Default: 0.
"let g:NERDTreeShowHidden=0
let g:NERDTreeShowHidden=1

"NERDTreeのツリーの幅
"Default: 31.
let g:NERDTreeWinSize=25

"NERDTreeStatusline NERDtreeウィンドウにステータスラインを表示。
"Values: Any valid statusline setting.
"Default: %{b:NERDTreeRoot.path.strForOS(0)}
"
" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction
call NERDTreeHighlightFile('py',     'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('md',     'blue',    'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml',    'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('config', 'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('conf',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('json',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('html',   'yellow',  'none', 'yellow',  '#151515')
call NERDTreeHighlightFile('styl',   'cyan',    'none', 'cyan',    '#151515')
call NERDTreeHighlightFile('css',    'cyan',    'none', 'cyan',    '#151515')
call NERDTreeHighlightFile('rb',     'Red',     'none', 'red',     '#151515')
call NERDTreeHighlightFile('js',     'Red',     'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php',    'Magenta', 'none', '#ff00ff', '#151515')

let g:NERDTreeNodeDelimiter = "\u00a0"

"----------------------------------------------------------
" New window
"----------------------------------------------------------
set splitbelow
"set lines=20
"set columns=50

"----------------------------------------------------------
" Terminal
"----------------------------------------------------------
nnoremap <C-t> :term<CR><C-w>:res -10<CR>
nnoremap <C-e> <C-w>w
tnoremap <C-e> <C-w>w
tnoremap <C-t> <C-w>:q!<CR>
"Open terminal window from the beginning
"autocmd VimEnter * execute 'terminal'
" Close teminal when you file close.
autocmd bufenter * if (winnr("$") == 1 && exists("b:terminal") && b:terminal.isTabTree()) | q | endif

" vital-palette-keymapping
" <A-w> みたいなのを \<A-w> にして feedkeys() で呼び出せるようにするためのエスケープ関数
"function! s:escape_special_key(key)
"   " Workaround : <C-?> https://github.com/osyo-manga/vital-palette/issues/5
"    if a:key ==# "<^?>"
"        return "\<C-?>"
"    endif
"    execute 'let result = "' . substitute(escape(a:key, '\"'), '\(<.\{-}>\)', '\\\1', 'g') . '"'
"    return result
"endfunction
"
"
"" キーマッピングの設定
"set termkey=<C-r>
"if exists(":tmap")
"    tnoremap <C-r> <C-w><C-w>
"endif
"
"
"function! s:bufnew()
"    if &buftype == "terminal" && &filetype == ""
"        set filetype=terminal
"    endif
"endfunction
"
"
"function! s:filetype()
"   " set filetype=terminal のタイミングでは動作しなかったので
"   " timer_start() で遅延して設定する
"    call timer_start(0, { -> feedkeys(s:escape_special_key(&termkey) . "\<S-n>") })
"endfunction
"
"
"augroup my-terminal
"    autocmd!
"    autocmd BufNew * call timer_start(0, { -> s:bufnew() })
"    autocmd FileType terminal call s:filetype()
"augroup END
"
"
"function! s:open(args) abort
"    if empty(term_list())
"        execute "terminal" a:args
"    else
"        let bufnr = term_list()[0]
"        execute term_getsize(bufnr)[0] . "new"
"        execute "buffer + " bufnr
"    endif
"endfunction


" すでに :terminal が存在していればその :terminal を使用する
command! -nargs=*
\   Terminal call s:open(<q-args>)


"----------------------------------------------------------
" Auto Start Terminal
"----------------------------------------------------------
" function! s:open_memo()
"   rightbelow vsplit ~/_vimrc
"   wincmd p
" endfunction
" 
" augroup OpenMemo
"  au!
"  autocmd VimEnter * call s:open_memo()
" augroup END
" 
" if has('vim_starting')
"   call s:vimrc_local(getcwd(), '.init.vimrc')
" endif


" Vimpyter
" autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
" autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
" autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>

