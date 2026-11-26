# Neovim Cheatsheet

## General Vim/Neovim Motions & Commands

### Basic Movement & Jump History (Normal Mode)

| Key       | Action                                      |
| :-------- | :------------------------------------------ |
| `h` `j` `k` `l` | Left, Down, Up, Right                       |
| `w`       | Move forward to the start of the next word  |
| `b`       | Move backward to the start of the word      |
| `e`       | Move forward to the end of the word         |
| `ge`      | Move backward to the end of the word        |
| `0`       | Move to the beginning of the line           |
| `^`       | Move to the first non-blank char of the line|
| `$`       | Move to the end of the line                 |
| `gg`      | Move to the first line of the file          |
| `G`       | Move to the last line of the file           |
| `[N]G`    | Move to line number `N`                     |
| `H` `M` `L` | Move to Top, Middle, Bottom of screen     |
| `%`       | Jump to matching parenthesis `()` `{}` `[]` |
| `Ctrl+o`  | Jump back in jump list (e.g., after `gd`)   |
| `Ctrl+i`  | Jump forward in jump list                   |
| `Ctrl+6` / `Ctrl+^` | Toggle back and forth between current & alternate file (`:b #` / `:e #`) |
| `Ctrl+t`  | Pop LSP tag stack (jump straight back to where you pressed `gd`, ignoring in-between jumps) |
| `Ctrl+f`  | Page Down                                   |
| `Ctrl+b`  | Page Up                                     |
| `Ctrl+d`  | Scroll Down half page                       |
| `Ctrl+u`  | Scroll Up half page                         |
| `zz`      | Center the current line on the screen       |
| `zt`      | Put the current line at the top of screen   |
| `zb`      | Put the current line at the bottom of screen|

### Editing & Built-in Commenting

| Key       | Action                                        |
| :-------- | :-------------------------------------------- |
| `i`       | Enter Insert mode *before* cursor             |
| `a`       | Enter Insert mode *after* cursor              |
| `I`       | Enter Insert mode at the start of the line    |
| `A`       | Enter Insert mode at the end of the line      |
| `o`       | Open a new line *below* and enter Insert mode |
| `O`       | Open a new line *above* and enter Insert mode |
| `r{char}` | Replace character under cursor with `{char}`  |
| `R`       | Enter Replace mode                            |
| `s`       | Delete character under cursor, enter Insert mode |
| `S`       | Delete current line, enter Insert mode        |
| `cw`      | Change word (delete word, enter Insert mode)  |
| `caw`     | Change Around Word (incl. space)              |
| `ciw`     | Change Inside Word                            |
| `cc`      | Change line (delete line, enter Insert mode)  |
| `C`       | Change to end of line                         |
| `d{motion}`| Delete text over {motion} (e.g., `dw`, `d$`, `dj`) |
| `dd`      | Delete current line                           |
| `D`       | Delete to end of line                         |
| `x`       | Delete character under cursor                 |
| `X`       | Delete character before cursor                |
| `y{motion}`| Yank (copy) text over {motion} (e.g., `yw`, `y$`) |
| `yy` / `Y`| Yank (copy) current line                      |
| `p`       | Paste yanked/deleted text *after* cursor      |
| `P`       | Paste yanked/deleted text *before* cursor     |
| `gcc`     | Toggle comment on current line (built-in)     |
| `gc{motion}` / `gc` | Toggle comment over motion or Visual selection |
| `u`       | Undo last change                              |
| `Ctrl+r`  | Redo last undone change                       |
| `.`       | Repeat last change                            |

### Visual Mode

| Key       | Action                                        |
| :-------- | :-------------------------------------------- |
| `v`       | Enter Visual mode (character-wise)            |
| `V`       | Enter Visual Line mode                        |
| `Ctrl+v`  | Enter Visual Block mode                       |
| `Esc`     | Exit Visual mode                              |
| `o`       | Move cursor to other end of selection         |
| `>`       | Indent selected text                          |
| `<`       | Un-indent selected text                       |
| `d` or `x`| Delete selected text                          |
| `y`       | Yank (copy) selected text                     |
| `c` or `s`| Change selected text (delete, enter Insert)   |
| `~`       | Switch case of selected text                  |

### Searching

| Key / Command | Action                                        |
| :------------ | :-------------------------------------------- |
| `/pattern`    | Search forward for `pattern`                  |
| `?pattern`    | Search backward for `pattern`                 |
| `n`           | Repeat search in the same direction           |
| `N`           | Repeat search in the opposite direction       |
| `*`           | Search forward for word under cursor          |
| `#`           | Search backward for word under cursor         |
| `:noh` or `Space Space` | Clear search highlighting           |
| `:%s/\<old\>/new/gc` | Replace whole word in current file (with confirm) |
| `*` then `:%s//new/gc` | Replace word under cursor in current file   |
| `Space f g` -> `Ctrl+q` -> `:cfdo %s/\<old\>/new/gc \| update` | Project-wide search & replace across quickfix matches |

### Window & Buffer Management

| Key / Command   | Action                                  |
| :-------------- | :-------------------------------------- |
| `:sp [file]` / `Ctrl+w s`  | Split window horizontally    |
| `:vsp [file]` / `Ctrl+w v` | Split window vertically      |
| `Ctrl+w w`      | Switch to next window                   |
| `Ctrl+w h/j/k/l`| Move to window Left/Down/Up/Right       |
| `Ctrl+w q`      | Close current window                    |
| `Ctrl+w o`      | Close all windows except current one    |
| `Ctrl+w =`      | Make all windows equal size             |
| `Ctrl+w +/-`    | Increase/Decrease height                |
| `Ctrl+w </>`    | Increase/Decrease width                 |
| `:ls`           | List open buffers                       |
| `:b [N]` / `:b [name]` | Switch to buffer                 |
| `[b` / `]b`     | Previous / next buffer *(or `:bp` / `:bn`)* |
| `[q` / `]q`     | Previous / next quickfix item           |
| `[l` / `]l`     | Previous / next location list item      |
| `:bd [N]`       | Delete buffer (close file)              |
| `:e file`       | Open `file` for editing                 |
| `:w` / `:q` / `:wq` / `:q!` | Write / Quit / Write & Quit / Force quit |
| `:wa` / `:qa`   | Write all / Quit all windows            |

### Marks

| Key      | Action                             |
| :------- | :--------------------------------- |
| `m{a-z}` | Set mark `{a}` (lowercase, file-local) |
| `` `{a-z} `` | Jump to exact position of mark `{a}` |
| `'{a-z}` | Jump to beginning of line of mark `{a}`|
| `` `` `` or `''` | Jump to position before last jump  |
| `` `. `` or `'.` | Jump to position of last change    |

### Code Folding

Treesitter folding is used when available (falling back to LSP `foldingRange`, then indent); files open unfolded (`foldlevel=99`).

| Key       | Action                                 |
| :-------- | :------------------------------------- |
| `za`      | Toggle fold under cursor               |
| `zc` / `zo` | Close / open fold under cursor       |
| `zC` / `zO` | Recursively close / open folds under cursor |
| `zM` / `zR` | Close all / open all folds in file   |
| `zj` / `zk` | Jump to next / previous fold         |

---

## Your IDE Setup (`mbp/config/nvim/lua/`)

**Leader:** `Space` *(press `Space` and pause to browse all mappings in `which-key`)*

### General, macOS & Tmux (`config/keymaps.lua`)

| Key           | Mode          | Action                                     |
| :------------ | :------------ | :----------------------------------------- |
| `Ctrl+h/j/k/l`| Normal        | Focus Neovim split / tmux pane (L/D/U/R)   |
| `Ctrl+\`      | Normal        | Focus previous Neovim split / tmux pane    |
| `Ctrl+a Ctrl+l` | Tmux        | Clear terminal screen (`C-l` passthrough)  |
| `Space w w`   | Normal        | Write/Save buffer (`:w`)                   |
| `Space w q`   | Normal        | Quit window (`:q`)                         |
| `Space Space` | Normal        | Clear search highlight (`:nohlsearch`)     |
| `gb` / `gB`   | Normal        | Go back / forward in jump list (`Ctrl+o` / `Ctrl+i`) |
| `Cmd+a`       | Normal        | Select all (`ggVG`) *(GUI / extended keys)*|
| `Cmd+c`       | Visual        | Copy to system clipboard (`"+y`)           |
| `Cmd+/`       | Normal/Visual | Toggle comment (`gcc` / `gc`)              |
| `Space c c`   | Normal/Visual | Send line or selection to Tmux (`tslime`)  |
| `Space c r`   | Normal        | Configure `tslime` Tmux target             |

### Buffer Tabs: `bufferline.nvim` (`plugins/ui.lua`, `config/keymaps.lua`)

Switches buffers inside the focused window while keeping `NvimTree`, AI sidebars, and split layouts intact.

| Key / Command   | Mode     | Action                                              |
| :-------------- | :------- | :-------------------------------------------------- |
| `Shift+h` / `Shift+l` | Normal | Previous / next buffer tab (`<S-h>` / `<S-l>`)  |
| `Space b d`     | Normal   | Delete current buffer (keep split layout)           |
| `Space b p`     | Normal   | Pin / unpin buffer tab                              |
| `Space b o`     | Normal   | Close other buffer tabs                             |
| `:qo` / `:qo!`  | Command  | Close other buffers (`:quitother` / `:QuitOther[!]`) |
| `:wqo`          | Command  | Save modified other buffers, then close them (`:wquitother`) |

### Telescope & NvimTree (`plugins/editor.lua`)

| Key           | Action                                      |
| :------------ | :------------------------------------------ |
| `Space f f`   | Find files across project (`rg --files`)    |
| `Space f g`   | Live grep (search text across all files)    |
| `Space f b`   | Find open buffers                           |
| `Space f o`   | Find old/recent files                       |
| `Space f d`   | Search diagnostics                          |
| `Space f h`   | Help tags                                   |
| `Space g s`   | Git status                                  |
| `Space g b`   | Git branches (checkout / create / delete / rebase / merge) |
| `Space g c`   | Git commits                                 |
| `Space e`     | Toggle NvimTree file explorer               |
| `Space o`     | Toggle NvimTree & locate current file       |

### Completion: `blink.cmp` (`plugins/completion.lua`, Insert Mode)

Signature help popup opens automatically while typing arguments.

| Key              | Action                                         |
| :--------------- | :--------------------------------------------- |
| `Ctrl+Space`     | Show completion / toggle documentation         |
| `Ctrl+k`         | Toggle signature help popup                    |
| `Ctrl+e`         | Close completion menu                          |
| `Enter` (`<CR>`) | Accept selected completion item                |
| `Tab`            | Next item / jump forward in snippet            |
| `Shift+Tab`      | Previous item / jump backward in snippet       |
| `Ctrl+n` / `Ctrl+p` | Select next / previous item                 |
| `Ctrl+b` / `Ctrl+f` | Scroll completion documentation Up / Down   |

### LSP, Diagnostics & Formatting (`config/autocmds.lua`, `plugins/lsp.lua`)

After `gd`: use `gb` / `gB` (or `Ctrl+o` / `Ctrl+i`) to step back/forward in the jump list, `Ctrl+6` / `Ctrl+^` to toggle between the two files, or `Ctrl+t` to pop back out of the tag stack.

| Key               | Mode          | Action                                     |
| :---------------- | :------------ | :----------------------------------------- |
| `gd`              | Normal        | Go to Definition                           |
| `gD`              | Normal        | Go to Declaration                          |
| `gi`              | Normal        | Go to Implementation                       |
| `Space D`         | Normal        | Go to Type Definition                      |
| `gr`              | Normal        | Find References across project (Telescope) |
| `K`               | Normal        | Show Hover Documentation                   |
| `Space k`         | Normal        | Show Signature Help                        |
| `Space d s`       | Normal        | Search Document Symbols (Telescope)        |
| `Space w s`       | Normal        | Search Workspace Symbols (Telescope)       |
| `Space r n`       | Normal        | Rename Symbol across project (run `:wa` to save all modified buffers) |
| `Space c a`       | Normal/Visual | Code Actions                               |
| `Space c f`       | Normal/Visual | Format buffer / selection (`conform.nvim` / LSP) |
| `Space u f`       | Normal        | Toggle format-on-save                      |
| `Space u a`       | Normal        | Toggle auto-save on buffer / focus leave   |
| `Space u h`       | Normal        | Toggle LSP inlay hints (global, on by default) |
| `Space d d` / `gl` / `Ctrl+w d` | Normal | Open line diagnostics float (press again to focus float) |
| `Space q`         | Normal        | Open diagnostics in loclist                |
| `[d` / `]d`       | Normal        | Previous / Next diagnostic                 |
| `Space w a/r/l`   | Normal        | Add / Remove / List workspace folders      |
| `:checkhealth vim.lsp` | Command  | Inspect active LSP clients & health        |

### Trouble Drawer (`plugins/ui.lua`)

| Key           | Action                                  |
| :------------ | :-------------------------------------- |
| `Space x x`   | Toggle workspace diagnostics            |
| `Space x X`   | Toggle current-buffer diagnostics       |
| `Space x s`   | Toggle document symbols outline         |
| `Space x L`   | Toggle location list                    |
| `Space x Q`   | Toggle quickfix list                    |

### Git: `gitsigns.nvim` & `vim-fugitive` (`plugins/ui.lua`)

`:G` / `:Git` forwards any subcommand directly to `git` with Tab completion for subcommands, branches, and remotes.

| Key / Command   | Mode          | Action                                 |
| :-------------- | :------------ | :------------------------------------- |
| `]c` / `[c`     | Normal        | Next / Previous git hunk               |
| `Space h s`     | Normal/Visual | Stage hunk                             |
| `Space h r`     | Normal/Visual | Reset hunk                             |
| `Space h p`     | Normal        | Preview hunk diff                      |
| `Space h b`     | Normal        | Blame line (full commit)               |
| `Space h d`     | Normal        | Diff current file against index        |
| `Space g g` / `:Git` / `:G` | Normal / Command | Open Fugitive Git status (`-`/`s`/`u`/`=`/`cc`/`ca`/`cz`) |
| `:Gdiffsplit` / `:Gvdiffsplit` | Command | Horizontal / vertical Git diff split |
| `:Gwrite` / `:Gread` | Command  | Stage (`git add %`) / Revert (`git checkout %`) |
| `:G fetch` / `:G fetch --all --prune` | Command | Fetch from remotes |
| `:G switch <branch>` | Command | Switch to an existing branch |
| `:G switch -c <new-branch>` | Command | Create and switch to a new branch |
| `:G checkout <branch>` / `:G checkout -b <new>` | Command | Checkout / create branch |
| `:G checkout -- %` *(or `:Gread`)* | Command | Discard unstaged changes in current file |
| `:G pull` / `:G push` | Command | Pull / push current branch |
| `:G branch` / `:G stash` / `:G rebase ...` | Command | Any other Git subcommand |

**Fugitive Command Shortcuts (`config/keymaps.lua`):**

| Shortcut | Expands To |
| :------- | :--------- |
| `:gstat` | `:G` (Fugitive status) |
| `:gfetch` | `:G fetch` |
| `:gpull` | `:G pull` |
| `:gp` | `:G push` |
| `:gpwl` | `:G push --force-with-lease` |
| `:gad <files>` | `:G add <files>` |
| `:gcom "<msg>"` | `:G commit -m "<msg>"` |
| `:gcheck <args>` | `:G checkout <args>` |
| `:gsw <branch>` | `:G switch -c <branch>` |
| `:grmain` | `:G rebase main` |
| `:grest <args>` | `:G restore <args>` |
| `:grestH` | `:G reset --hard @{u}` |

### Debugging / LLDB (`plugins/dap.lua`: `codelldb`, Apple `lldb-dap`, `debugpy`)

Inside `dapui` panels: `Enter` jumps to stack frame/breakpoint, `o` expands, `e` edits value/watch, `d` deletes watch/breakpoint, `t` toggles breakpoint. The UI stays open on exit so you can read Console/REPL output — close with `Space d u`.

| Key                  | Action                                      |
| :------------------- | :------------------------------------------ |
| `F5` / `Space d c`   | Start / Continue debugging                  |
| `Space d C`          | Run to cursor                               |
| `F10` / `Space d o`  | Step Over                                   |
| `F11` / `Space d i`  | Step Into                                   |
| `F12` / `Space d O`  | Step Out                                    |
| `Space d k` / `Space d j` | Stack frame up / down                  |
| `Space d b`          | Toggle Breakpoint                           |
| `Space d B`          | Set Conditional Breakpoint                  |
| `Space d L`          | Set Logpoint (log without pausing)          |
| `Space d x`          | Clear all breakpoints                       |
| `Space d e`          | Eval expression under cursor / Visual selection (press again to focus float) |
| `Space d w`          | Add word under cursor to Watches            |
| `Space d r`          | Toggle DAP/LLDB REPL (run `bt`, `p`, etc.)  |
| `Space d u`          | Toggle DAP UI                               |
| `Space d l`          | Run Last debug configuration                |
| `Space d n`          | New debug session (`:DapNew` — includes `"Attach to application (codelldb)"` filtered to `/Applications`) |
| `Space d t`          | Terminate debug session                     |

### Testing: `neotest` (`plugins/test.lua`)

Supports Python (`pytest`/`unittest`), Rust (`rustaceanvim`), C++ (`gtest`), and Haskell.

| Key           | Action                             |
| :------------ | :--------------------------------- |
| `Space t n`   | Run nearest test                   |
| `Space t f`   | Run all tests in current file      |
| `Space t d`   | Debug nearest test (DAP)           |
| `Space t s`   | Toggle test summary panel          |
| `Space t o`   | Open test output                   |
| `Space t O`   | Toggle test output panel           |
| `Space t S`   | Stop running test                  |

### SQL / Database: `vim-dadbod-ui` (`plugins/db.lua`)

Supports SQLite files with **any arbitrary extension** (plus Postgres, MySQL, etc.). SQL buffers automatically use `vim-dadbod-completion` via `blink.cmp` for table and column names.

Inside the DBUI drawer: `Enter`/`o` expand or open a table/query, `R` refresh tables, `q` close drawer. Inside a query buffer: `:w` executes the query and shows results.

| Key / Command                | Action                                                      |
| :--------------------------- | :---------------------------------------------------------- |
| `Space s u`                  | Toggle Database UI (`:DBUIToggle`)                          |
| `Space s o` / `:DBOpenSQLite [path]` | Open any SQLite DB file regardless of extension (auto-detects current buffer if it's a SQLite file, otherwise prompts with file completion) |
| `Space s a`                  | Add connection interactively (`:DBUIAddConnection`, e.g. `sqlite:/path/to/file.ext`) |
| `Space s f`                  | Link current SQL buffer to a connection (`:DBUIFindBuffer`) |
| `:DB sqlite:/path/to/file.ext <SQL>` | Run a one-off query without opening the UI          |

---

## Language-Specific Shortcuts

### C / C++ & CMake (`plugins/lang-cpp.lua`, `clangd`, `neocmake`)

| Key / Command                | Action                                         |
| :--------------------------- | :--------------------------------------------- |
| `Space c h`                  | Switch between source and header (`clangd`)    |
| `Space c t`                  | C++ Type Hierarchy                             |
| `Space c g`                  | `:CMakeGenerate` (`-G Ninja`, links `compile_commands.json`) |
| `Space c b`                  | `:CMakeBuild`                                  |
| `Space c x`                  | `:CMakeRun`                                    |
| `Space c d`                  | `:CMakeDebug` (builds & launches `codelldb`)   |
| `Space c s`                  | Stop running CMake build/target (`:CMakeStopRunner` / `:CMakeStopExecutor`) |
| `Space c T`                  | `:CMakeSelectBuildTarget`                      |
| `:CMakeSelectCwd [dir]`      | Point CMake to subfolder containing `CMakeLists.txt` |
| `:CMakeSelectBuildDir [dir]` | Set custom build directory                     |
| `:CMakeSelectBuildType`      | Switch `Debug` / `Release`                     |
| `:CMakeSelectLaunchTarget`   | Choose executable to run/debug                 |
| `:CMakeRunTest`              | Run CTest                                      |
| `:CMakeClean` / `:CMakeSettings` | Clean build / Configure launch args & env  |

### Rust (`plugins/lang-rust.lua`: `rustaceanvim` + `crates.nvim`)

| Key           | Action                                   |
| :------------ | :--------------------------------------- |
| `Space r r`   | Rust Runnables                           |
| `Space r d`   | Rust Debuggables (`codelldb`)            |
| `Space r e`   | Expand macro                             |
| `Space r c`   | Open `Cargo.toml`                        |
| `Space r p`   | Go to parent module                      |
| `Space r k`   | Rust hover actions                       |

### Haskell (`plugins/lang-haskell.lua`: `haskell-tools.nvim`)

| Key           | Action                                   |
| :------------ | :--------------------------------------- |
| `Space l h`   | Hoogle signature search                  |
| `Space l e`   | Evaluate all code lenses (`-- >>>`)      |
| `Space l r`   | Toggle GHCi REPL (package)               |
| `Space l f`   | Toggle GHCi REPL (current buffer)        |
| `Space l q`   | Quit GHCi REPL                           |
| `Space c l`   | Run code lens under cursor               |

### Python (`plugins/lang-python.lua`: `basedpyright` + `ruff` + `debugpy`)

| Key / Command   | Action                                  |
| :-------------- | :-------------------------------------- |
| `Space c v`     | `:VenvSelect` (pick `.venv`/uv/conda)   |

### Markdown (`plugins/markdown.lua`: `render-markdown.nvim`, `image.nvim` + `diagram.nvim`, `live-preview.nvim`)

`render-markdown.nvim` renders headings, tables, code blocks, checkboxes, and callouts inline. In Ghostty, `image.nvim` + `diagram.nvim` render images and Mermaid diagrams directly in-place inside `.md` buffers (requires `mmdc` via `npm install -g @mermaid-js/mermaid-cli`, and `tmux` passthrough enabled in `tmux.conf`). Use `live-preview.nvim` (`Space u p`) as an optional browser fallback.

| Key / Command   | Action                                  |
| :-------------- | :-------------------------------------- |
| `Space u m`     | Toggle in-buffer Markdown rendering (`:RenderMarkdown toggle`) |
| `Space u p`     | Toggle browser live preview with Mermaid/KaTeX (`:LivePreview start` / `close`) |

### AI: CLI Agents, `codecompanion.nvim` & `vim-tabby` (`config/ai_terms.lua`, `plugins/ai.lua`)

CLI agents (`agy`, `pi`, `opencode`) open in a persistent right-hand terminal split and auto-reload modified buffers via `autoread`. Inside an agent terminal, press `Ctrl+h` (or `Ctrl+\ Ctrl+n`) to jump back to your code split while keeping `Esc` free for the agent TUI.

`codecompanion.nvim` is configured for local `llama-server` (`http://127.0.0.1:8088`).

| Key           | Mode          | Action                               |
| :------------ | :------------ | :----------------------------------- |
| `Space a g`   | Normal        | Toggle Antigravity (`agy`) side split |
| `Space a p`   | Normal        | Toggle `pi` agent side split         |
| `Space a o`   | Normal        | Toggle `opencode` side split         |
| `Space a s`   | Normal/Visual | Send file path (or `file:L1-L2`) to active AI CLI |
| `Space a a`   | Normal/Visual | AI Actions palette                   |
| `Space a c`   | Normal/Visual | Toggle AI Chat                       |
| `Space a i`   | Normal/Visual | AI Inline prompt                     |
| `Space a d`   | Visual        | Add selection to active AI Chat      |
| `Ctrl+y`      | Insert        | Accept `vim-tabby` inline suggestion |
| `Ctrl+\`      | Insert        | Trigger / dismiss `vim-tabby` inline suggestion |

---

## Plugin Defaults: NvimTree Window

| Key        | Action                               |
| :--------- | :----------------------------------- |
| `Enter`/`o`| Open file/folder                     |
| `v`        | Open in Vertical Split               |
| `s`        | Open in Horizontal Split             |
| `t`        | Open in New Tab                      |
| `a`        | Add file/directory                   |
| `d`        | Delete file/directory (confirm)      |
| `r`        | Rename file/directory                |
| `x` / `c` / `p` | Cut / Copy / Paste              |
| `y` / `Y` / `gy` | Copy Name / Relative Path / Absolute Path |
| `I`        | Toggle Hidden Files (`.` files)      |
| `H` / `L`  | Collapse node / Expand node          |
| `R`        | Refresh tree                         |
| `?`        | Toggle Help/Mappings                 |
| `q`        | Close NvimTree window                |

---

## Maintenance & Updating

| Task                     | Command                                                |
| :----------------------- | :----------------------------------------------------- |
| Update Neovim            | `brew update && brew upgrade neovim`                   |
| Sync / Update plugins    | `:Lazy sync` / `:Lazy update`                          |
| Update Mason tools       | `:MasonUpdate` (then `:Mason` -> `U` to upgrade)       |
| Update Treesitter parsers| `:TSUpdate`                                            |
| Update Rust / Haskell    | `rustup update` / `ghcup upgrade`                      |
| Full health check        | `:checkhealth`                                         |
