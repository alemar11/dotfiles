# Neovim code browser

LazyVim with lazy.nvim, Neo-tree, Snacks picker, and filename buffer tabs.
The browsing interactions are inspired by [Dave Ebbelaar's guide](https://learn.datalumina.com/docs/herdr/neovim).
This configuration keeps the repository's Ghostty shortcuts and Starship-derived
dark/light palette. Vim and the shell's `EDITOR=vim` remain independent.

## Install

Use this setup on an Apple Silicon Mac after cloning dotfiles to its permanent
location (normally `~/Developer/dotfiles`). Homebrew and the normal dotfiles shell
setup should already be available. Install Xcode and select its developer
directory for Swift support; `xcrun --find sourcekit-lsp` should resolve a binary.

Before linking, back up any existing `~/.config/nvim`, `~/.local/share/nvim`,
`~/.local/state/nvim`, and `~/.cache/nvim` directories under unique timestamped
names. The link manager skips an existing target; it never overwrites that target.
Keep the permanent configuration linked to the permanent clone.

Install the dependencies and link this configuration:

```sh
cd ~/Developer/dotfiles
brew install neovim ripgrep fd tree-sitter-cli mise
./macos/mise.sh node python
./dotfiles.sh install nvim
nvim .
```

The link is `~/.config/nvim` -> this repository's `nvim/` directory.
`init.lua` loads `lua/config/lazy.lua`, which downloads **lazy.nvim** when missing
and installs **LazyVim** and the declared plugins. This is the LazyVim installation
step; the bootstrap is already part of these dotfiles.

Neovim needs LuaJIT, Git, a C compiler, curl, and a Nerd Font-capable terminal.
The Homebrew manifest owns Neovim, fd, ripgrep, and tree-sitter-cli. Xcode provides
Clang and SourceKit-LSP. Node/npm and Python are managed through mise. The
`tree-sitter` library alone does not provide the required `tree-sitter` CLI.

Confirm `node`, `npm`, and `python3` are available in the shell launching Neovim.
First startup needs network access to download plugins, Mason tools, and
Tree-sitter parsers. Wait for installation to finish, then run `:Lazy restore`
to use the versions saved in `lazy-lock.json`. Open a TypeScript, Python, and
Swift file to load their language support, and use `:Mason` to check tool
installation progress. Restart Neovim and run `:LazyHealth`.

Plugins and Mason tools live under `~/.local/share/nvim`; logs and editor history
use Neovim's standard state/cache directories. None of these belong in the
dotfiles repository.

## Browse

Run `nvim .` in the exact checkout or worktree you want to inspect. Running
`nvim path/to/file` opens that file directly. The explorer starts at the requested
directory; search and the standard explorer toggle use LazyVim's detected project
root. `Space f F` searches files from the current working directory instead.

In Normal mode (press Escape first), keys separated by spaces are sequential:

| Action | Input |
| --- | --- |
| Toggle explorer | `Space e` |
| Preview a file, keeping focus in the tree | Single click, or `j` / `k` in the tree |
| Retain a file | Double click |
| Retain a file and focus its editor | Enter or `l` in the tree |
| Find files | `Ctrl+P` or `Space Space` |
| Search project contents | `/`, `Ctrl+Shift+F`, or `Space /` |
| Search within the file | `g/` |
| Open/focus terminal | `Ctrl+7` or `Space f t` |
| Definition / hover / references | `gd` / `K` / `gr` |
| Definition at mouse position | Ctrl-click or Cmd-click, if delivered by the terminal |
| Return from definition | `Ctrl+O` or Ctrl-right-click |
| Switch filename buffers | `Shift+H` / `Shift+L` |
| Choose Python environment manually | `Space c v` |
| Switch dark/light background manually | `Space u b` |
| Quit all windows | `:qa` |

`/` replaces Vim's forward-search mapping in Normal and Visual modes. Use `g/`
in Normal mode for ordinary in-file search and `n` / `N` to repeat it. Operator
search motions keep Vim's native behavior. `Ctrl+Shift+F` and modified mouse
events depend on keyboard/mouse protocol forwarding; the leader and `gd`
bindings are available without those modified events.

`Ctrl+7` also hides the current Snacks terminal in Terminal mode, keeping its
process running. It aliases the existing `Ctrl+/` mapping; the original
`Ctrl+/` and `Ctrl+_` bindings remain available.

In Ghostty, Left Option acts as Alt for LazyVim and Snacks shortcuts. Use Right
Option for Italian symbols and accents. This Option behavior applies to all
programs running inside Ghostty.

One unmodified preview is replaced in each editor window. Preview filenames have
a `(preview)` suffix. Double-clicking, pressing Enter, or starting an edit retains
the buffer. Files already open through another command or displayed in another
split are retained. This preview retention is independent of Bufferline's own
"pin to the left" feature.

Format-on-save is disabled. Neovim still permits deliberate edits and asks about
unsaved changes. Filesystem changes are handled by the upstream explorer watcher
and Neovim/LazyVim reload behavior; modified buffers are not discarded.

Ghostty owns its existing Cmd shortcuts. Herdr's lazygit popup is `Ctrl+B`, then
`g`; its session navigator is `Ctrl+B`, then `d`. These are custom bindings that
swap the navigator's default `g` with the previous LazyGit `d` binding.
No Go, Rust, or automatic Herdr-title tooling is required here.

## Languages

- **TypeScript / JavaScript:** the LazyVim TypeScript extra uses VTSLS, with the
  project's dependency/type information. The extra also installs js-debug-adapter.
- **Python:** Pyright provides navigation and Ruff provides linting. Pyright type
  checking is off for browsing. Each Pyright client selects `.venv/bin/python` or
  `venv/bin/python` at its project root if available. Interpreter selection is
  per project; it does not activate or modify the parent shell. venv-selector is
  available for other environment layouts.
- **Swift:** `xcrun sourcekit-lsp` follows the selected Xcode toolchain, with a Swift
  Tree-sitter parser. SwiftPM projects need their dependencies and build/index
  information available. Xcode apps may need a project-specific Build Server
  Protocol bridge/configuration and a recent build for cross-file navigation.
  Detecting an `.xcodeproj` alone does not establish full navigation support.
- **JSON / TOML / Markdown:** JSON language server + SchemaStore, Taplo, and
  Marksman; Markdown also includes rendering, browser preview, markdownlint-cli2,
  and markdown-toc.

Markdown rendering keeps code fences (triple backticks) and their language labels
visible, along with syntax highlighting and code backgrounds. `Space u m` toggles
Markdown rendering.

Mason owns the language tools, plus LazyVim's base Lua language server, StyLua,
and shfmt. SourceKit-LSP is explicitly excluded from Mason.

## Update

Keep `lazy-lock.json` and `lazyvim.json` in version control. The language extras
are declared in `lua/config/lazy.lua`; edit that list intentionally instead of
adding a second set of extras through `:LazyExtras`.

### Upgrade to newer versions

Start from a saved, working configuration so there is a known version to restore.
The setup has several independently managed parts:

| Part | Update procedure |
| --- | --- |
| Neovim and command-line dependencies | In the shell: `brew update`, then `brew upgrade neovim ripgrep fd tree-sitter-cli` |
| LazyVim, lazy.nvim, and plugins | In Neovim: `:Lazy update`; wait for completion |
| Mason language servers, linters, and formatters | Run `:MasonUpdate`, wait, then open `:Mason`; use `u` on one outdated package or `U` for all outdated packages |
| Tree-sitter syntax parsers | Run `:TSUpdate` and wait for compilation to finish |
| Swift's SourceKit-LSP | Update/select Xcode; the server comes from `xcrun sourcekit-lsp` |

`:MasonUpdate` refreshes the package registry; the `u` / `U` actions install the
tool updates. Node/npm and Python follow the repository's separate mise setup.
The configured lazy.nvim background checker checks for updates; installation
happens when you request an update.

Restart Neovim, run `:LazyHealth`, and repeat the [validation checks](#validation).
Then review the configuration and generated lockfile changes from the repo root:

```sh
git diff -- nvim
```

Save the reviewed configuration, `nvim/lazy-lock.json`, and `nvim/lazyvim.json`
changes in Git together. `:Lazy update` includes LazyVim itself and records the
installed plugin revisions in the lockfile.

### Apply the saved versions on another machine

After pulling the reviewed dotfiles changes, restart Neovim. Run `:Lazy install`
if newly declared plugins are missing, then `:Lazy restore` to apply the
repository's saved plugin revisions. Run `:TSUpdate` if Tree-sitter changed,
wait for installations to finish, restart, and run `:LazyHealth`.

The existing symlink picks up configuration changes automatically; relinking is
only needed when the link is missing or the permanent clone has moved.

See the upstream [lazy.nvim commands](https://lazy.folke.io/usage),
[lockfile guide](https://lazy.folke.io/usage/lockfile), and
[Mason commands](https://github.com/mason-org/mason.nvim#commands).

## Rollback

Restore the last working configuration and lockfile from Git, preserving any
local edits first. Restart Neovim and run `:Lazy restore` to apply those plugin
revisions. Rebuild parsers with `:TSUpdate` when restoring Tree-sitter versions.

`lazy-lock.json` records plugin revisions. Mason binaries, generated parsers,
Homebrew packages, and Xcode are managed separately; record their versions and
preserve Neovim data backups when a complete environment rollback matters.

To disable this setup, quit Neovim and run this from the same permanent clone:

```sh
./dotfiles.sh remove nvim
```

This removes only the managed Neovim symlink. Archive any newly created Neovim
data/state/cache directories before restoring earlier backups to their original
paths. Keep packages that were already installed or used by other tools.

## Validation

```sh
bash -n dotfiles.sh macos/brew.sh
shellcheck dotfiles.sh macos/brew.sh
python3 tests/dotfiles-scoped.py
nvim --headless -u NONE -i NONE -l nvim/tests/preview.lua
git diff --check
```

Then run `:LazyHealth` and check real terminal behavior: startup with a directory
and a file; preview replacement; double-click and edit retention; modified files;
multiple splits; file/content search; definition/back navigation in each language;
external file updates; both background styles; and Herdr's lazygit popup. Do not
treat headless success as proof of keyboard/mouse forwarding in Herdr.
