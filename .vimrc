
" Syntax highlight
syntax enable
filetype plugin indent on
colorscheme slate
set t_Co=256
set matchpairs+=<:>


" Show line numbers
set number
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Show whitespaces
set list listchars=tab:\|\
highlight Whitespace cterm=underline gui=underline ctermbg=NONE guibg=NONE ctermfg=grey guifg=grey
autocmd ColorScheme * highlight Whitespace gui=underline ctermbg=NONE guibg=NONE ctermfg=grey guifg=grey
match Whitespace /  \+/


" Line brake by words
set linebreak
set dy=lastline


" General options
"vsplit
set noswapfile
set mouse=a
set showcmd
set ruler
set showmatch
set showtabline=2
set title
set titlestring=%t%(\ %m%)%(\ %r%)%(\ %h%)%(\ %w%)%(\ (%{expand(\»%:p:~:h\»)})%)\ -\ VIM
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %b\ 0x%B\ %l,%c%V\ %P
"set statusline=%F%m%r%h%w\ [%{&ff}]\ %=\ %l,%v\ %P
set visualbell
set hidden
set cursorline
set autoread
set completeopt=longest,menuone
set nocp
set redraw
set laststatus=2


" Show line numbers when scrolling
set scrolloff=3


" Wrap long lines
set wrap


" Autocomplete
set showmatch
imap [ []<left>
imap ( ()<left>
imap < <><left>
imap { {}<left>

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType tt2html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType cpp set omnifunc=cppcomplete#Complete
autocmd FileType objc set omnifunc=objcomplete#Complete


" Set folding
set foldmethod=manual
set foldlevelstart=1
set foldnestmax=2


" Set a latin keyboard layout by default
set iminsert=0
set imsearch=0


"Search
set ignorecase

" Loop search
"set nowrapscan


set hlsearch
set smartcase
set incsearch
set imsearch=-1
set history=128
set undolevels=1000
set infercase


"Encoding
set encoding=utf-8
set termencoding=utf-8
set fileformat=unix
set ffs=unix,mac,dos
set fileencodings=utf-8,koi8-r,cp1251
set noendofline binary


" Enable russian layout
set iskeyword=@,48-57,_,192-255


"set guifont=courier_new:h10:cRUSSIAN


" Set tabulation
"set ts=4
set tabstop=4
set softtabstop=4
set smarttab
set expandtab
set smartindent " May conflict with paste mode!
set autoindent
set shiftwidth=4
set backspace=indent,eol,start
set noet|retab!


" Paste copied text without auto-formatting
set clipboard=unnamed
set paste!


" cmd + v for inset mode
" imap <D-v> ^O:set paste<Enter>^R+^O:set nopaste<Enter>
imap <D-V> ^O"+p


" save file
" imap <F2> <Esc>:w<CR>
" map <F2> <Esc>:w<CR>


" open new tab
" imap <F4> <Esc>:browse tabnew<CR>
" map <F4> <Esc>:browse tabnew<CR>


" close vim
" set wildmenu
" set wcm=<Tab>
" menu Exit.quit     :quit<CR>
" menu Exit.quit!    :quit!<CR>
" menu Exit.save     :exit<CR>
" map <F10> :emenu Exit.<Tab>


" enable russian keys

" window / linux
" set langmap=ёйцукенгшщзхъфывапролджэячсмитьбю;`qwertyuiop[]asdfghjkl\;'zxcvbnm\,.,ЙЦУКЕHГШЩЗХЪФЫВjАПРОЛДЖЭЯЧСМИТЬБЮ;QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>

" mac os
" set langmap=йцукенгшщзхъфывапролджэячсмитьбю/ЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ/;qwertyuiop[]asdfghjkl;'zxcvbnm,./QWERTYUIOP[]ASDFGHJKL:'ZXCVBNM,./


" autocomplete
function! InsertTabWrapper(direction)
    let col = col('.') - 1

    if !col || getline('.')[col - 1] !~ '\k'
         return "\<tab>"
    elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>


function! InsertStatuslineColor(mode)
	if a:mode == 'i'
		hi statusline guibg=magenta
	elseif a:mode == 'r'
		hi statusline guibg=blue
	else
		hi statusline guibg=red
	endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=green

" default the statusline to green when entering Vim
hi statusline guibg=green


" Protect large files from sourcing and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
	let my_auto_commands_loaded = 1
	" Large files are > 10M
	" Set options:
	" eventignore+=FileType (no syntax highlighting etc
	" assumes FileType always on)
	" noswapfile (save copy of file)
	" bufhidden=unload (save memory when other file is viewed)
	" buftype=nowritefile (is read-only)
	" undolevels=-1 (no undo possible)

	let g:LargeFile = 1024 * 1024 * 10
	augroup LargeFile
	autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
	augroup END
endif