# Neovim Cheatsheet

## General Vim/Neovim Motions & Commands

### Basic Movement (Normal Mode)

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
| `%`       | Jump to matching parenthesis `()` `{} `[]`   |
| `Ctrl+f`  | Page Down                                   |
| `Ctrl+b`  | Page Up                                     |
| `Ctrl+d`  | Scroll Down half page                       |
| `Ctrl+u`  | Scroll Up half page                         |
| `zz`      | Center the current line on the screen       |
| `zt`      | Put the current line at the top of screen   |
| `zb`      | Put the current line at the bottom of screen|

### Editing (Normal Mode to Insert/Replace)

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
| `yy`      | Yank (copy) current line                      |
| `Y`       | Yank (copy) current line (like `yy`)          |
| `p`       | Paste yanked/deleted text *after* cursor      |
| `P`       | Paste yanked/deleted text *before* cursor     |
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

| Key       | Action                                        |
| :-------- | :-------------------------------------------- |
| `/pattern`| Search forward for `pattern`                  |
| `?pattern`| Search backward for `pattern`                 |
| `n`       | Repeat search in the same direction           |
| `N`       | Repeat search in the opposite direction       |
| `*`       | Search forward for word under cursor          |
| `#`       | Search backward for word under cursor         |
| `:noh` or `:nohlsearch` | Clear search highlighting       |

### Window Management

| Key           | Action                              |
| :------------ | :---------------------------------- |
| `:sp [file]`  | Split window horizontally           |
| `:vsp [file]` | Split window vertically             |
| `Ctrl+w s`    | Split window horizontally           |
| `Ctrl+w v`    | Split window vertically             |
| `Ctrl+w w`    | Switch to next window               |
| `Ctrl+w h/j/k/l` | Move to window Left/Down/Up/Right |
| `Ctrl+w q`    | Close current window                |
| `Ctrl+w o`    | Close all windows except current one|
| `Ctrl+w =`    | Make all windows equal size         |
| `Ctrl+w +/-`  | Increase/Decrease height            |
| `Ctrl+w </>`  | Increase/Decrease width             |

### Buffer Management

| Command   | Action                          |
| :-------- | :------------------------------ |
| `:ls`     | List open buffers               |
| `:b [N]`  | Go to buffer number `N`         |
| `:b [name]`| Go to buffer matching `name`    |
| `:bn`     | Go to next buffer               |
| `:bp`     | Go to previous buffer           |
| `:bd [N]` | Delete buffer `N` (close file)  |
| `:e file` | Open `file` for editing         |
| `:w`      | Write (save) current buffer     |
| `:q`      | Quit current window/buffer      |
| `:wq`     | Write and quit                  |
| `:q!`     | Quit without saving             |
| `:wa`     | Write all changed buffers       |
| `:qa`     | Quit all windows                |

### Marks

| Key      | Action                             |
| :------- | :--------------------------------- |
| `m{a-z}` | Set mark `{a}` (lowercase, file-local) |
| `` ` ``{a-z}` | Jump to exact position of mark `{a}` |
| `'{a-z}` | Jump to beginning of line of mark `{a}`|
| `` ` `` ` `` or `''` | Jump to position before last jump  |
| `` ` ``. ` or `'.` | Jump to position of last change    |


## Your Custom Mappings (`init.lua`)

**Leader:** `Space`

### Telescope (Normal Mode)

| Key           | Action                          |
| :------------ | :------------------------------ |
| `Space f f`   | Find Files                      |
| `Space f g`   | Live Grep (Search File Content) |
| `Space f b`   | Find Buffers                    |
| `Space f h`   | Find Help Tags                  |
| `Space f o`   | Find Old Files (Recent)         |
| `Space g s`   | Git Status                      |

### NvimTree (Normal Mode)

| Key           | Action                                    |
| :------------ | :---------------------------------------- |
| `Space e`     | Toggle NvimTree File Explorer             |
| `Space o`     | Toggle NvimTree & Find Current File       |

### Completion: nvim-cmp / LuaSnip (Insert Mode)

| Key             | Action                                         |
| :-------------- | :--------------------------------------------- |
| `Ctrl+b`        | Scroll completion documentation Up             |
| `Ctrl+f`        | Scroll completion documentation Down           |
| `Ctrl+Space`    | Trigger completion menu                        |
| `Ctrl+e`        | Abort/Close completion menu                    |
| `Enter` (`<CR>`) | Confirm selected completion item               |
| `Tab`           | Select next item / Expand or Jump Snippet      |
| `Shift+Tab`     | Select previous item / Jump back in Snippet    |
*Note: Tab/Shift+Tab behavior depends on context (menu open vs. snippet active)*

### LSP: Language Server Protocol (Normal Mode - Buffer Local)

| Key               | Action                                     |
| :---------------- | :----------------------------------------- |
| `gD`              | Go to Declaration                          |
| `gd`              | Go to Definition                           |
| `K` (Shift+k)     | Show Hover Documentation/Info              |
| `gi`              | Go to Implementation                       |
| `Ctrl+k`          | Show Signature Help (function parameters)  |
| `Space w a`       | Add Workspace Folder                       |
| `Space w r`       | Remove Workspace Folder                    |
| `Space w l`       | List Workspace Folders                     |
| `Space D` (Shift+d)| Go to Type Definition                     |
| `Space r n`       | Rename Symbol                              |
| `Space c a`       | Show Code Actions (Normal & Visual Mode)   |
| `gr`              | Find References                            |
| `Space f`         | Format Buffer                              |

### General Mappings (Normal Mode)

| Key             | Action                                       |
| :-------------- | :------------------------------------------- |
| `Ctrl+h`        | Focus window Left                            |
| `Ctrl+j`        | Focus window Down                            |
| `Ctrl+k`        | Focus window Up                              |
| `Ctrl+l`        | Focus window Right                           |
| `Space w q`     | Quit window/Neovim (`:q`)                    |
| `Space w w`     | Write/Save buffer (`:w`)                     |
| `Space Space`   | Clear Search Highlight (`:nohlsearch`)       |

### tslime.vim (Integration with Tmux)

| Key           | Mode    | Action                               |
| :------------ | :------ | :----------------------------------- |
| `Space c c`   | Visual  | Send selection to Tmux               |
| `Space c c`   | Normal  | Send current line/block to Tmux      |
| `Space c r`   | Normal  | Configure tslime Tmux target         |

## Plugin Defaults & Commands

### NvimTree (Defaults within NvimTree Window)

| Key        | Action                               |
| :--------- | :----------------------------------- |
| `Enter`/`o`| Open file/folder                     |
| `v`        | Open in Vertical Split               |
| `s` or `x` | Open in Horizontal Split             |
| `t`        | Open in New Tab                      |
| `a`        | Add file/directory                   |
| `d`        | Delete file/directory (confirm)      |
| `r`        | Rename file/directory                |
| `x`        | Cut file/directory                   |
| `c`        | Copy file/directory                  |
| `p`        | Paste file/directory                 |
| `y`        | Copy Name                            |
| `Y`        | Copy Relative Path                   |
| `gy`       | Copy Absolute Path                   |
| `I`        | Toggle Hidden Files (`.` files)      |
| `H`        | Collapse node / Go to parent         |
| `L`        | Expand node / Enter directory        |
| `.`        | Run command on node                  |
| `R`        | Refresh tree                         |
| `?`        | Toggle Help/Mappings                 |
| `q`        | Close NvimTree window                |

### Fugitive (Git Integration)

* **Common Commands:**
    * `:Git` or `:G`: Open Git status window (like `git status`)
    * `:Gstatus`: Same as `:Git`
    * `:Gdiff [file]`: Open diff view for `[file]` (or current file if omitted)
    * `:Gvdiff [file]`: Vertical diff view
    * `:Ghdiff [file]`: Horizontal diff view
    * `:Gblame`: Open Git blame view
    * `:Gcommit [args]`: Run `git commit [args]`
    * `:Gpush [args]`: Run `git push [args]`
    * `:Gpull [args]`: Run `git pull [args]`
    * `:Glog`: Show Git log
    * `:Gwrite`: Stage the current file (`git add %`)
    * `:Gread`: Revert changes in current buffer (`git checkout %`)
* **In Status Window (`:Git` / `:Gstatus`):**
    * `-` : Stage/Unstage file or hunk under cursor
    * `s`: Stage file/hunk under cursor
    * `u`: Unstage file/hunk under cursor
    * `X`: Discard change under cursor (hunk)
    * `=` : Toggle inline diff view for file under cursor
    * `Enter`/`o`: Open file under cursor
    * `dd` / `dv` / `ds` : Open diff split (default/vertical/horizontal) for file under cursor
    * `cc`: Commit staged changes
    * `ca`: Amend previous commit
    * `P`: Push
    * `F`: Pull

### Emmet (HTML/CSS Expansion)

| Key           | Mode    | Action                          |
| :------------ | :------ | :------------------------------ |
| `<C-y>,`      | Insert  | Expand Emmet abbreviation       |
*(Ctrl+y followed by comma)*

### vim-rspec (RSpec Runner)

* **Common Commands (Often Mapped):**
    * `:RunNearestSpec`: Run spec nearest to cursor (often mapped to `<leader>t`)
    * `:RunSpecFile`: Run all specs in the current file (often mapped to `<leader>s`)
    * `:RunLastSpec`: Re-run the last spec command (often mapped to `<leader>l`)
*Check `vim-rspec` documentation for its default mappings if any.*

### fzf.vim (Fuzzy Finder - alternative/supplement to Telescope)

* **Common Commands:**
    * `:Files [path]`: Fuzzy find files
    * `:GFiles[!]`: Fuzzy find Git files (respects `.gitignore`, `!` includes modified)
    * `:Buffers`: Fuzzy find open buffers
    * `:Lines`: Fuzzy find lines in current buffer
    * `:BLines`: Fuzzy find lines in all open buffers
    * `:History`: Fuzzy find command history
    * `:Commits`: Fuzzy find Git commits
    * `:BCommits`: Fuzzy find Git commits for current buffer
    * `:Ag [pattern]`: Fuzzy search file contents using Ripgrep/Ag

### LSP Diagnostics (Default Neovim Bindings)

| Key      | Mode   | Action                               |
| :------- | :----- | :----------------------------------- |
| `[d`     | Normal | Go to previous diagnostic (error/warn) |
| `]d`     | Normal | Go to next diagnostic (error/warn)     |
| `[c`     | Normal | Go to previous diff change (built-in)  |
| `]c`     | Normal | Go to next diff change (built-in)      |
| `:LspInfo`| Command| Show info about active LSP clients   |
| `:TroubleToggle` | Command | (If trouble.nvim installed) Toggle diagnostics panel |
