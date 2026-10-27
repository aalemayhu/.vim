# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is Alexander Alemayhu's personal Vim configuration (`~/.vim`), managed with [Vundle](https://github.com/VundleVim/Vundle.vim). It is a dotfiles repo, not an application: the only "source" that matters is `.vimrc`, plus a small helper script (`refresh.imba`) used to regenerate `.gitmodules` from the plugins checked out under `bundle/`.

Repo layout:
- `.vimrc` — the entire Vim configuration: plugin list (`Plugin '...'` lines via Vundle), key mappings, indentation/whitespace settings, colorscheme, lightline/syntastic config, backup settings, filetype autocommands.
- `bundle/` — Vundle plugin checkouts (each is its own git repo/submodule). This directory is **gitignored** (see `.gitignore`), so plugin code itself is not committed directly to this repo's tree — it was historically tracked via `.gitmodules` submodule entries instead.
- `syntax/` — a couple of standalone syntax files (e.g. `cocci.vim`) not managed via Vundle.
- `refresh.imba` — an [Imba](https://imba.io) script that scans `bundle/*/. git/config` for each plugin's remote URL and prints `.gitmodules`-formatted submodule blocks to stdout.
- `Makefile` — thin wrapper around submodule/plugin maintenance tasks.
- `backup/` — Vim backup files directory (created at runtime by `.vimrc`'s `set backupdir`), gitignored.

## Common commands

Run these from the repo root (`~/.vim`).

- Install/update plugin submodules already listed in `.gitmodules`:
  ```
  make
  ```
  (equivalent to `git submodule update --init && git submodule foreach git pull origin master`)

- Regenerate `.gitmodules` from whatever is currently checked out in `bundle/` (requires `imba` installed, e.g. `npm i -g imba`):
  ```
  make refresh
  ```

- Full workflow for adding a new plugin:
  1. Add a `Plugin '...'` line to `.vimrc` (in the Vundle block between `vundle#begin()` and `vundle#end()`).
  2. Run `make add-new`, which does:
     ```
     vim +PluginInstall +qa   # installs the new plugin into bundle/
     make                     # git submodule update/pull
     make refresh             # regenerate .gitmodules
     ```
  3. Commit the updated `.vimrc` and `.gitmodules`.

- Inside Vim itself (Vundle commands, useful when iterating manually):
  - `:PluginList` — list configured plugins
  - `:PluginInstall` — install plugins; `:PluginInstall!` or `:PluginUpdate` to update
  - `:PluginSearch foo` — search for a plugin; `:PluginSearch! foo` to refresh local cache
  - `:PluginClean` — remove plugins no longer listed in `.vimrc`

There is no build, lint, or test suite in this repo — changes are validated by opening Vim and confirming the config loads/behaves as expected.

## Notes when editing `.vimrc`

- Plugins are declared as `Plugin 'user/repo'` (or with `{ 'dir': ..., 'do': ... }` / `{ 'branch': ..., 'rtp': ... }` options) inside the `vundle#begin() ... vundle#end()` block near the top of the file. Keep new plugin declarations inside that block, before the `call vundle#end()` line.
- Settings/mappings/autocommands go after `filetype plugin indent on`, under the "Put your non-Plugin stuff after this line" comment.
- **Gotcha: Vundle plugin functions aren't callable inline in `.vimrc`.** Vundle only adds `bundle/*` to `'runtimepath'`; Vim doesn't auto-source `plugin/*.vim` from `runtimepath` until *after* the whole `.vimrc` has been read. So calling a plugin's setup function directly at the point its `Plugin '...'` line appears (or anywhere else in `.vimrc`) can throw `E117: Unknown function`, even though the function exists once Vim finishes starting. Fix: defer the call to an autocommand that fires later (`VimEnter`, or a plugin-specific event like `yegappan/lsp`'s `User LspSetup` — see the `s:SetupLsp()` pattern in `.vimrc`). Plain global-variable config (`let g:foo = ...`) doesn't have this problem since it's just read later.
- Vim is version 9.1, **not** Neovim (`has('nvim')` is false), built `+terminal +popupwin +python3` but **`-clientserver`** (no `--remote`/instant-diff support — anything relying on clientserver, e.g. vim-claude-code's diff preview, silently falls back to polling instead).
- No `~/.tmux.conf` exists, so `.vimrc` only enables `set termguicolors` outside tmux (`!exists('$TMUX')` guard) — inside tmux it would render wrong without RGB passthrough configured.
- **Colorscheme**: `doki-theme-vim` colorscheme is picked at random on every startup (`rand() % len(...)` over `bundle/doki-theme-vim/colors/*.vim`). Doki colorschemes intentionally only set `Normal`'s `fg` (so transparent terminals show through), so `.vimrc` separately pulls each theme's background out of its `<name>#GetColors().textEditorBackground` autoload function and applies it via `highlight Normal guibg=... ctermbg=...` — if this looks redundant, it isn't; removing it makes every theme look like the same dark background.
- Backups are enabled (`set backup`, `backupdir=~/.vim/backup/`, `backupcopy=yes`) specifically so that external file watchers (e.g. `yarn watch` on Imba source) see consistent file replacement semantics — don't remove this without checking that comment in `.vimrc`.
- `au BufWritePre * let &bex = '@' . strftime(...)` gives every backup file a timestamp suffix; this is why `backup/` can accumulate many files over time.

## Java support

- `.vimrc` exports `$JAVA_HOME`/`$PATH` from sdkman's `~/.sdkman/candidates/java/current` symlink unconditionally at startup, independent of whatever the launching shell sourced. This exists because Vim/mvn need a JDK on `$PATH` even when Vim is launched from a context that never ran sdkman's shell init (GUI launcher, non-interactive shell, etc).
- syntastic's `javac` checker is disabled for Java (`g:syntastic_mode_map.passive_filetypes` includes `'java'`) because it shells out to `mvn dependency:build-classpath` synchronously on every file open (slow) and can't see sibling source files without a prior build, causing false "cannot find symbol"/"package does not exist" errors. Run `:SyntasticCheck` manually (ideally after `mvn compile`) if you want it.
- `:make` is wired to Maven instead: `s:JavaMavenRoot()` walks up from the current file to find the nearest `pom.xml`, and `s:SetupJavaMake()` sets `makeprg` to `mvn -q -f <root> compile` for that buffer, with a matching `errorformat` for `[ERROR] file:[line,col] message`. `QuickFixCmdPost make cwindow` auto-opens the quickfix window with results.
- ctags is expected to be Universal Ctags (via `update-alternatives`, not GNU Emacs's `ctags.emacs` shim) — needed for reasonable Java tag generation. `set tags=tags;/` searches upward for a `tags` file from cwd.

## LSP (`yegappan/lsp`)

- Native Vim9-script LSP client (no Node/Python runtime needed), configured via `s:SetupLsp()` deferred to the `User LspSetup` autocmd (see the Vundle gotcha above for why).
- Only registers a server if its binary is actually found on `$PATH` (checked with `system('command -v ...')`), so `:LspShowAllServers` doesn't list dead entries. As of this writing **only `rust-analyzer`** is installed; entries for jdtls (Java), gopls (Go), and typescript-language-server are left commented out in `.vimrc` as ready-to-enable recipes — install the binary, uncomment the block, done.
- Key commands: `:LspGotoDefinition`, `:LspHover`, `:LspDiag show`, `:LspRename`, `:LspCodeAction`, `:LspFormat`. Full list in `:help lsp` (`bundle/lsp/doc/lsp.txt`).

## Claude Code integration (`rishi-opensource/vim-claude-code`)

- Requires the `claude` CLI on `$PATH` (confirmed installed at `~/.local/bin/claude`) and Vim's `+terminal` (present). Diff preview additionally wants `python3` (present) and ideally `+clientserver` (**not** present here — falls back to polling, which is fine but not instant).
- `<C-\>` toggles a Claude terminal split at the git root; `:Claude <Tab>` shows the ~22 sub-commands (`explain`, `fix`, `test`, `commit`, `review`, `plan`, etc). Run `:Claude doctor` after any Vim/plugin update to sanity-check dependencies.
- `g:claude_code_diff_preview = 1` is set in `.vimrc` so diff-preview polling auto-starts every session; run `:Claude preview install` once per project to register the hooks in `.claude/settings.local.json`.

## Statusline (lightline + fugitive)

- The git branch segment calls `FugitiveHead()` (capital H, no `#`) — **not** `fugitive#head`, which was fugitive's old (now-removed) autoload API and throws `E117` if you ever see it reappear. `vim-fugitive` itself must be declared as a `Plugin` for this to work at all (it previously wasn't, despite `bundle/vim-fugitive` existing on disk from an old checkout, which broke the statusline silently until the `Plugin` line was restored).
