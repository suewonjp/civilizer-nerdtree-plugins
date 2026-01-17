# Civilizer NERDTree Plugins

A collection of three essential plugins for [NERDTree](https://github.com/preservim/nerdtree) that enhance navigation, previewing, and path manipulation.

This repository consists of 3 distinct NERDTree plugins:

1. [Bookmark & Root History Utils](#1-bookmark--root-history-utils)
2. [Netrw-style Preview](#2-netrw-style-preview)
3. [Path Utils](#3-path-utils)

---

## 1. Bookmark & Root History Utils

This plugin enhances NERDTree's bookmarking system and introduces a history of recently visited roots, making it easier to navigate between different project contexts.

### Key Functionality
- **Auto-Incrementing Bookmarks**: Quickly add bookmarks with unique numeric IDs. (0 to 9)
- **Direct Access**: Jump to numbered bookmarks with simple key combinations.
- **Root History**: Track every time the tree root changes and navigate back and forth through your "root history," similar to a browser's back/forward buttons.
    - The plugin automatically tracks root changes from standard NERDTree operations like `C` or `e` (Change Root), `u` (Up Dir), `CD` (Change to CWD), etc.

### Key Mappings Provided By The Plugin
| Key | Description |
| :--- | :--- |
| `g<CR>` | Add a bookmark with an available numeric ID |
| `g0` - `g9` | Move cursor to bookmark with ID 0 to 9 |
| `gk` | Go backward in root history |
| `gj` | Go forward in root history |
| `Sh` | Show the complete root history in the message area |

### Standard NERDTree Bookmark Mappings
| Key | Description |
| :--- | :--- |
| `B` | Toggle whether the bookmark table is displayed |
| `D` | Delete the currently selected bookmark (only when cursor is in the bookmark table) |
| `o` | Open in the previous window |
| `t` | Open in a new tab |
| `i` | Open in the previous window |
| `s` | Open in the previous window |

*Note: Standard NERDTree "Open" mappings (like `o`, `t`, `i`, `s`) also work on bookmarks when the bookmark table is visible.*

| Key | Description |
| :--- | :--- |
| `o` | Open in the previous window |
| `t` | Open in a new tab |
| `i` | Open in a new split window (vertical or horizontal depending on state) |
| `s` | Open in a vertical window |

---

## 2. Netrw-style Preview

Inspired by Netrw's preview functionality, this plugin allows you to peek into files directly from NERDTree without permanently leaving the tree or manually managing windows.

### Key Functionality
- **Dynamic Preview**: Open a vertical split previewing the selected file.
- **Synchronized Navigation**: Move up and down the tree while the preview window automatically updates with the content of the currently selected file.

### Key Mappings
| Key | Description |
| :--- | :--- |
| `pr` | Open Netrw-style preview (keep focus on NERDTree) |
| `Pr` | Open Netrw-style preview and move focus to the preview window |
| `<C-w>p` | Move to the previous file in NERDTree and update the preview window |
| `<C-w>n` | Move to the next file in NERDTree and update the preview window |
| `<C-w>z` | Close the preview window |

---

## 3. Path Utils

A comprehensive set of utilities for yanking various formats of file and directory paths to your registers or system clipboard.

### Key Functionality
- **Multiple Formats**: Yank absolute paths, relative paths, or tilde-expanded paths (`~/...`).
- **Quoting Support**: Automatically wrap yanked paths in single or double quotes for easy pasting into code or shell commands.
- **Clipboard Integration**: Direct mappings to yank to the system clipboard (`*` or `+`).

### Key Mappings
| Key | Description |
| :--- | :--- |
| `aa` | Yank absolute path |
| `a+` | Yank absolute path to system clipboard |
| `a"` | Yank absolute double-quoted path |
| `a'` | Yank absolute single-quoted path |
| `~~` | Yank absolute tilde-expanded path |
| `~+` | Yank absolute tilde-expanded path to system clipboard |
| `rr` | Yank relative path |
| `r+` | Yank relative path to system clipboard |
| `r"` | Yank relative double-quoted path |
| `r'` | Yank relative single-quoted path |
| `tt` | Yank path tail (filename/last directory) |
| `t+` | Yank path tail to system clipboard |
| `t"` | Yank double-quoted path tail |
| `t'` | Yank single-quoted path tail |

### Commands
- `:Cnr`: Yank the current NERDTree root path to the system clipboard.

---

## Installation

### Unix/Linux/macOS
Place the files in `nerdtree_plugin/` into `~/.vim/nerdtree_plugin/`

### Windows
Place the files in `nerdtree_plugin` into `~/vimfiles/nerdtree_plugin/`

### Using a Plugin Manager
#### [vim-plug](https://github.com/junegunn/vim-plug)
Add the following to your `init.vim` or `.vimrc`:

```vim
Plug 'suewonjp/civilizer-nerdtree-plugins'
```

#### [Pathogen](https://github.com/tpope/vim-pathogen)
Run the following command in your terminal:

```bash
git clone https://github.com/suewonjp/civilizer-nerdtree-plugins.git ~/.vim/bundle/civilizer-nerdtree-plugins
```

#### Other Plugin Managers
Fallow guidelines per each plugin manager.

*Note: Ensure [NERDTree](https://github.com/preservim/nerdtree) is also installed.*

## License
Distributed under the same terms as Vim itself. See `LICENSE.txt` for details.
