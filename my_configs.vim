" 定义函数的地方
silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return  (has('win32') || has('win64'))
endfunction

" 定义backup文件，swap文件，views文件和undo文件的存储位置
" Initialize directories {
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    " To specify a different directory in which to place the vimbackup,
    " vimviews, vimundo, and vimswap files/directories, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_consolidated_directory = <full path to desired directory>
    "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
    if exists('g:spf13_consolidated_directory')
        let common_dir = g:spf13_consolidated_directory . prefix
    else
        let common_dir = parent . '/.' . prefix
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }

" 设置区
set nocompatible

" 映射快捷键代替使用<Esc>退出插入模式
inoremap jk <ESC>

" 窗口切换快捷键
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 避免按键误操作
inoremap <F1> <ESC>
nnoremap <F1> <ESC>

" 文件类型判断
filetype on
filetype plugin on
filetype indent on

" 语法高亮开
syntax on

" 使能鼠标
set mouse=a
" 输入时隐藏鼠标
set mousehide

" ???
" scriptencoding utf-8
" 不使用系统粘贴板clipboard=unnamed
" 使用unnamedplus后，yy再p，无法使用
" set clipboard=unnamedplus

" 命令历史纪录
set history=1000

" 使能文件备份
set backup
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

" 最大标签页个数
set tabpagemax=15

" 显示当前模式
set showmode

au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
" 高亮当前行
set cursorline cursorcolumn
" highlight clear SignColum
" highlight clear LineNr
if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    " 显示命令
    set showcmd                 " Show partial commands in status line and
                " Selected characters/lines in visual mode
endif

" 提示信息和命令返回信息设置为英文
let $LANG='en'
language message en_US.UTF-8
" 设置菜单为英文，否则在中文系统会显示乱码
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

if LINUX() && has("gui_running")
    set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
elseif OSX() && has("gui_running")
    set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
elseif WINDOWS() && has("gui_running")
    set guifont=YaHei\ Consolas\ Hybrid:h11,Microsoft\ YaHei\ Mono:h11.5,Andale_Mono:h11,Menlo:h11,Consolas:h11,Courier_New:h12
endif

" 打开文件时，解码顺序，中文
set encoding=utf-8
"let &termencoding=&encoding
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set termencoding=gbk

" 打开命令行自动补全，按TAB后，弹出补全内容
set wildmenu
" 设置最长的
set wildmode=list:longest,list:full ",full  " Command <Tab> completion, list matches, then longest common part, then all.
" 忽略一些补全文件
set wildignore=*.o,*.pyc

if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ 0x%B\ %p%%  " Right aligned file nav info
endif

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set numberwidth=5
set showmatch                   " Show matching brackets/parenthesis
" set matchtime=5
" 边输入边查找
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search

set autoindent                  " Indent at the same level of the previous line
set smartcase                   " Case sensitive when uc present
set cindent

set nowrap                      " Do not wrap long lines
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
" 修改expandtab和noexpandtab后，执行%retab整理当前文件格式
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)

set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current

set winminheight=0              " Windows can be 0 line high
set textwidth=80
set colorcolumn=+1
"set columns=540
"set lines=999
" winpos 540 0

"
set report=0

set scrolloff=3
" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" 设置‘空’字符显示
set list
" 设置tab为>-格式,用行结尾为$, 结尾前空格显示为·,，后面两个没懂
set listchars=tab:>-,eol:$,trail:·,extends:#,nbsp:.

set matchpairs+=<:>
au FileType c,cpp,java set matchpairs+==:;
" 一些特殊字符占位为2个ASCII字符宽，和
"set ambiwidth=double

" 设置自动格式化
set formatoptions=tcrqn
" 自动识别Unix和MS-dos格式文件
set fileformats=unix,dos,mac

" Set to auto read when a file is changed from the outside
set autoread

" 打开文件时自动切换到文件所在路径
set autochdir

" 退出时未保存提示
set confirm

" 关闭英文语法拼写
set nospell

set foldenable
set foldlevel=9
set foldmethod=manual

" 设置Python执行快捷键
" nnoremap <buffer> <F9> :exec '!C:\Python3\Lib\idlelib\idle.bat -r' @%<cr>

" 启动默认最大化窗口
" au GUIEnter * simalt ~x
" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
" map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" 设置前导字符
let mapleader = ","
let g:mapleader = ","
nnoremap ; :

" 设分割的窗口等大小
map <Leader>= <C-w>=
" 在调试期间比较有用
" map <leader>e :vsplit! ~/OneDrive/MyConfigs/vim/.vimrc<cr>

" 取消高亮, 放弃c关键字，因为nerdcommenter使用<leader>c作为开始
" noremap <leader>c :nohl<cr>
noremap <leader><space> :nohl<cr>
" noremap <leader><cr> :nohl<cr>
nnoremap <tab> %
vnoremap <tab> %
noremap <silent> <leader>/ :set invhlsearch<CR>
" nnoremap <leader><leader> <c-^>

nnoremap <leader>w :w!<CR>

"autocmd! bufwritepost .vimrc source ~/OneDrive/MyConfigs/vim/.vimrc

set background=dark
" 解决putty登陆时，行号和背景黑色重合的显示异常
highlight LineNr ctermfg=grey

"colorscheme evening
" colorscheme solarized
" colorscheme molokai
" colorscheme phd

" 禁止光标闪烁
set gcr=a:block-blinkon0

" 设置状态主题风格
" let g:Powerline_colorscheme='solarized256'

"if filereadable(expand("~/OneDrive/MyConfigs/vim/.vimrc.bundles"))
"    source ~/Onedrive/MyConfigs/vim/.vimrc.bundles
"endif

