set nocompatible              " be iMproved, required
set number
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/src/github.com/VundleVim/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'doki-theme/doki-theme-vim'
Plugin 'M4R7iNP/vim-imba'
Plugin 'itchyny/lightline.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'majutsushi/tagbar'
Plugin 'maralla/completor.vim'
Plugin 'mattn/emmet-vim'
Plugin 'rbong/vim-flog'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'wesQ3/vim-windowswap'
Plugin 'vim-syntastic/syntastic'
Plugin 'alpertuna/vim-header'
Plugin 'sheerun/vim-polyglot'
Plugin 'preservim/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-endwise'
Plugin 'yegappan/lsp'
Plugin 'rishi-opensource/vim-claude-code'
Plugin 'unisonweb/unison', { 'branch': 'trunk', 'rtp': 'editor-support/vim' }

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

" Java: make sure Vim sees the JDK sdkman has selected, even if the shell
" that launched Vim never sourced sdkman's init script (e.g. launched from
" a GUI/menu, or a non-interactive shell). sdkman keeps a stable `current`
" symlink per candidate; mvn is installed via apt (not sdkman) and picks
" its JDK via $JAVA_HOME, so exporting that here is enough to make it use
" the same release as an sdkman-initialized terminal would.
let s:sdkman_java = expand('~/.sdkman/candidates/java/current')
if isdirectory(s:sdkman_java)
  let $JAVA_HOME = s:sdkman_java
  if stridx($PATH, s:sdkman_java . '/bin') != 0
    let $PATH = s:sdkman_java . '/bin:' . $PATH
  endif
endif

" Java: wire :make to Maven so build errors land in the quickfix list on
" demand. (syntastic's own javac checker is disabled above for java: it
" blocks on `mvn dependency:build-classpath` on every open, and can't see
" sibling source files without a prior build.) Finds the nearest pom.xml
" above the current file so :make works regardless of vim's cwd.
function! s:JavaMavenRoot()
  let pom = findfile('pom.xml', expand('%:p:h') . ';')
  return pom ==# '' ? '' : fnamemodify(pom, ':p:h')
endfunction

function! s:SetupJavaMake()
  let root = s:JavaMavenRoot()
  if root !=# ''
    execute 'setlocal makeprg=mvn\ -q\ -f\ ' . escape(root, ' \') . '\ compile'
  endif
endfunction

autocmd FileType java call s:SetupJavaMake()
autocmd FileType java setlocal errorformat=%E[ERROR]\ %f:[%l\\,%c]\ %m,%-G%.%#
autocmd QuickFixCmdPost make cwindow

" comments imba
let g:NERDCustomDelimiters = { 'imba': { 'left': '# '} }

" default color scheme: pick a random Doki Theme colorscheme every time Vim
" starts. rand() auto-seeds per process (verified: even 8 vim processes
" launched concurrently each land on a different theme), so this isn't a
" randomness problem. The reason it didn't *feel* random: without
" termguicolors, every theme gets flattened to the same 256-color
" approximation, so many of the (mostly dark) variants render almost
" identically even though a different one really is picked each time.
" Only enable true 24-bit color outside tmux: there's no ~/.tmux.conf here
" enabling RGB passthrough, so termguicolors inside tmux would render
" wrong/garbled instead of just looking similar.
if &t_Co < 256
  set t_Co=256
endif
if has('termguicolors') && !exists('$TMUX')
  set termguicolors
endif

let s:doki_dir = $HOME . '/.vim/bundle/doki-theme-vim'
if isdirectory(s:doki_dir)
  let s:doki_colors = map(glob(s:doki_dir . '/colors/*.vim', 0, 1), 'fnamemodify(v:val, ":t:r")')
  if len(s:doki_colors) > 0
    let s:doki_theme = s:doki_colors[rand() % len(s:doki_colors)]
    execute 'colorscheme ' . s:doki_theme
    " Every Doki colorscheme sets Normal's fg only (by design, so
    " transparent terminals show through), which is why the background
    " never visibly changed. Each theme still carries its own background
    " color internally via <name>#GetColors() - pull it out and apply it
    " ourselves so the bg actually varies along with everything else.
    let s:doki_bg = function(s:doki_theme . '#GetColors')().textEditorBackground
    execute 'highlight Normal guibg=' . s:doki_bg.gui . ' ctermbg=' . s:doki_bg.cterm
  endif
endif

" bar
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
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

" Disable syntastic for python
" Also disable for java: syntastic's javac checker shells out to `mvn
" dependency:build-classpath` synchronously on every open (slow), and
" without a build (`target/classes`) it can't see sibling source files,
" causing false "cannot find symbol" / "package does not exist" errors.
" Run :SyntasticCheck manually (ideally after `mvn compile`) when needed.
let g:syntastic_mode_map = { 'passive_filetypes': ['python', 'java'] }

" LSP (yegappan/lsp): only register a server if its binary is actually
" installed, so :LspShowAllServers doesn't list dead entries and the
" plugin doesn't try (and fail) to spawn something missing on $PATH.
" As of this writing only rust-analyzer (via `rustup`/cargo) is installed;
" the others are left here commented out as ready-to-enable recipes once
" the corresponding tool is installed:
"   Java:       sdk install java <version>-tem, then use the jdt.ls wrapper
"               (jdtls) - not sdkman-installable directly, needs manual setup
"   Go:         go install golang.org/x/tools/gopls@latest
"   TypeScript: npm install -g typescript-language-server typescript
"   Python:     pip install --user pyright  (or python-lsp-server for pylsp)
"   C/C++:      apt install clangd
" Vundle adds bundle/lsp to 'runtimepath' inside this vimrc, but Vim only
" auto-sources plugin/*.vim from 'runtimepath' *after* the whole vimrc has
" been read - so plugin/lsp.vim (and its g:LspAddServer/g:LspOptionsSet
" functions) don't exist yet at this point, even though they will by the
" time Vim finishes starting. The plugin fires a `User LspSetup` autocmd
" from its own VimEnter handler for exactly this race (see its README's
" vim-plug section - Vundle hits the same ordering issue), so defer our
" setup to that event instead of calling these functions directly here.
function! s:SetupLsp() abort
  let servers = []

  let rust_analyzer = trim(system('command -v rust-analyzer 2>/dev/null'))
  if v:shell_error == 0 && rust_analyzer !=# ''
    call add(servers, #{
          \ name: 'rust-analyzer',
          \ filetype: ['rust'],
          \ path: rust_analyzer,
          \ args: [],
          \ syncInit: v:true,
          \ })
  endif

  " " Java (jdtls) - uncomment once jdtls is installed and on $PATH
  " call add(servers, #{
  "       \ name: 'jdtls',
  "       \ filetype: ['java'],
  "       \ path: '/path/to/jdtls',
  "       \ args: [],
  "       \ })

  " " Go (gopls) - uncomment once `go install golang.org/x/tools/gopls@latest`
  " call add(servers, #{
  "       \ name: 'gopls',
  "       \ filetype: ['go', 'gomod'],
  "       \ path: '/path/to/gopls',
  "       \ args: ['serve'],
  "       \ syncInit: v:true,
  "       \ })

  " " TypeScript/JavaScript - uncomment once typescript-language-server is installed
  " call add(servers, #{
  "       \ name: 'typescriptlang',
  "       \ filetype: ['javascript', 'typescript'],
  "       \ path: '/path/to/typescript-language-server',
  "       \ args: ['--stdio'],
  "       \ })

  if len(servers) > 0
    call LspAddServer(servers)
  endif

  call LspOptionsSet(#{
        \ autoHighlightDiags: v:true,
        \ showDiagWithSign: v:true,
        \ showDiagOnStatusLine: v:true,
        \ semanticHighlight: v:true,
        \ })
endfunction

autocmd User LspSetup call s:SetupLsp()

" Claude Code integration (rishi-opensource/vim-claude-code). Defaults are
" sane: right split, <C-\> toggle, git-root aware. Run :Claude doctor after
" install to confirm the `claude` CLI, git, and +terminal are all detected.
let g:claude_code_diff_preview = 1
