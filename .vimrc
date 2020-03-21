set nocompatible              " be iMproved, required
set number
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/src/github.com/VundleVim/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
" My color theme distinguished
Plugin 'Lokaltog/vim-distinguished'
Plugin 'M4R7iNP/vim-imba'
Plugin 'groenewege/vim-less'
Plugin 'itchyny/lightline.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'majutsushi/tagbar'
Plugin 'maralla/completor.vim'
Plugin 'mattn/emmet-vim'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'powerline/powerline-fonts'
Plugin 'rbong/vim-flog'
Plugin 'rizzatti/dash.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'stephpy/vim-yaml'
Plugin 'ternjs/tern_for_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'wesQ3/vim-windowswap'
Plugin 'yuezk/vim-js'
Plugin 'rust-lang/rust.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'alpertuna/vim-header'
Plugin 'keith/swift.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" vertical line indentation
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '│'

set encoding=utf-8
let loaded_matchparen = 1
let g:js_indent_log = 0
syntax on
" autocmd BufWritePre *.cc,*.c,*.h %s/  *$//eg

map <Down> gj
map <Up>   gk

set tags=tags;/
set bg=dark
set is
set ai
set aw
set noerrorbells
set novisualbell
set ts=8
set sts=2
set sw=2
set et
set modelines=2
set completeopt=preview
set nofoldenable
set mouse=
set cino=:0
set shiftround
set title

" ...
ab helol hello
ab fpritnf fprintf
ab fpitnf  fprintf

map Q :echo "You pressed Q"<CR>

" map  <Esc>xpa
" imap  <Esc>xpa

map  <Esc>:tabnew<CR>
map <F1> 1gt
map <F2> 2gt
map <F3> 3gt
map <F4> 4gt
map <F5> 5gt
map <F6> 6gt
map <F7> 7gt
map <F8> 8gt
map <F9> 9gt
map <F10> 10gt
imap <F1> <Esc>1gta
imap <F2> <Esc>2gta
imap <F3> <Esc>3gta
imap <F4> <Esc>4gta
imap <F5> <Esc>5gta
imap <F6> <Esc>6gta
imap <F7> <Esc>7gta
imap <F8> <Esc>8gta
imap <F9> <Esc>9gta
imap <F10> <Esc>10gta

autocmd BufNewFile,BufReadPost *.md set filetype=markdown

set guioptions=
set guicursor=i:block-Cursor
set guifont=DejaVu\ Sans\ Mono\ 12
highlight Normal     guifg=gray guibg=black

map  :echo "You pressed Ctrl-O"<CR>

autocmd BufWritePre *.{C,cc,cpp,c,java,h} silent! %s/[ \t]\+$//
"autocmd BufRead *.{C,cc,cpp,c,java,h} silent! %s/[ \t]\+$//
autocmd BufNewFile,BufRead *.m set syntax=objc
autocmd BufNewFile,BufRead *.m call GnuIndent()

hi TabLineSel term=reverse ctermfg=white ctermbg=lightblue guifg=white guibg=blue

function! GnuIndent()
  setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  setlocal shiftwidth=2
  setlocal tabstop=8
endfunction

au FileType c,cc call GnuIndent() 


" vdrift
"set sts=8 sw=8 noet cinoptions=
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg guibg=Red
highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg guibg=Red

" To spell check all git commit messages
au BufNewFile,BufRead COMMIT_EDITMSG set spell
"
" " Underline misspelled words
" hi clear SpellBad
" hi SpellBad cterm=underline
set laststatus=2
au BufWritePost *.go !gofmt -w %

" comments imba
let g:NERDCustomDelimiters = { 'imba': { 'left': '# '} }

" default color scheme
if !exists('$TMUX') && isdirectory($HOME ."/.vim/bundle/vim-distinguished")
  colorscheme distinguished
endif

" bar
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

function! LightlineFilename()
  return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype ==# 'unite' ? unite#get_status_string() :
        \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
        \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

silent !mkdir ~/.vim/backup > /dev/null 2>&1

" Use Backup feature so `yarn watch` works in imba source code
"Turn on backup option
set backup

"Where to store backups
set backupdir=~/.vim/backup/

"Make backup before overwriting the current buffer
set writebackup

"Overwrite the original backup file
set backupcopy=yes

"Meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

" Get FZF via ctrl-p
nnoremap <C-p> :Files<Cr>

" Add syntastic defaults
set statusline+=%#warningmsg#
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_rust_checkers = ['rustc']
let g:syntastic_swift_checkers = ['swiftpm', 'swiftlint']
" Enable rustfmt on save
let g:rustfmt_autosave = 1

" Copyright header
let g:header_field_author = 'Alexander Alemayhu'
let g:header_field_author_email = 'alexander@alemayhu.com'
let g:header_auto_add_header = 0
let g:header_field_license_id = 'MIT'

" NERDtree lookalike
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 12
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END
