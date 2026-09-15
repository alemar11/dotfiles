# Classic Vim

A small configuration for learning Vim, with two plugins:

- [vim-lsp](https://github.com/prabirshrestha/vim-lsp): definitions, references,
  hover, diagnostics, rename, and completion through language servers.
- [vim-which-key](https://github.com/liuchengxu/vim-which-key): press Space and
  pause to see a shortcut menu at the bottom.

[vim-plug](https://github.com/junegunn/vim-plug) installs and updates these plugins.
Vim itself provides buffers, splits, tab pages, search, syntax highlighting, and
the netrw file browser. The configuration is [`../vimrc`](../vimrc), symlinked to
`~/.vimrc`; this `vim/` folder contains the installer and documentation.

## Install

Use the classic Vim included with current macOS (Vim 9.1 here). The setup needs
Vim with `+job`, `+channel`, and `+timers`, plus Git, curl, mise, and ripgrep from
the dotfiles' usual prerequisites. Full Xcode supplies Swift's language server.

From the repository root:

```sh
./vim/install.sh
```

The installer links only `vimrc` and the mise configuration, installs Node and
the three language-tool packages, downloads vim-plug if missing, and runs
`:PlugInstall`. Existing unrelated Vim/mise configuration is preserved; back it
up before replacing it with the corresponding `./dotfiles.sh` links.
Vim startup itself does not download anything. Plugins live in `~/.vim/plugged`;
undo, swap, and backup files stay under `~/.vim`.

Open a new terminal so mise refreshes PATH, then start at a project's root:

```sh
cd path/to/project
vim .
# Or open files directly:
vim main.py README.md
```

To link just the configuration without installing plugins/tools:

```sh
./dotfiles.sh install vimrc
```

## Languages

| Files | Server | Installed by |
| --- | --- | --- |
| TypeScript/TSX, JavaScript/JSX | typescript-language-server + TypeScript 6 | mise |
| Python | Pyright | mise |
| Swift | SourceKit-LSP | project's mise Swift toolchain, or selected Xcode via `xcrun` |

The fallback TypeScript installation stays on major 6 because this server needs its JavaScript `tsserver`;
this follows the [server's installation instructions](https://github.com/typescript-language-server/typescript-language-server#installing).
The server prefers a compatible TypeScript installation from the project and
uses the mise-managed version when the project has none. This does not change
your project's package dependencies. Both activated mise shells and mise shims
are supported.

Language servers find their root by walking up from the opened file to the
nearest matching project marker:

| Language | Project markers |
| --- | --- |
| TypeScript/JavaScript | `tsconfig.json`, `jsconfig.json`, `package.json`, `.git` |
| Python | `pyrightconfig.json`, `pyproject.toml`, `setup.py`, `setup.cfg`, `.git` |
| Swift | `Package.swift`, `buildServer.json`, `.git` |

Without a marker, they use Vim's current directory. Root detection does not
change `:pwd` or the directory used for file finding and project search. A server
selects its root when it starts; start a new Vim session when switching to an
unrelated project using the same language.

Pyright uses an explicitly activated Python environment first, then automatically
uses `.venv/bin/python` in the detected project root when it exists. Otherwise,
it uses Python from PATH. A project's `.venv` does not need manual activation
before opening Vim; environments elsewhere can be activated before launch or
configured in Pyright. Restart Vim after creating or changing the environment.
This selects the interpreter for Pyright; shell commands still use their shell
environment.

A `.venv` holds the project's installed Python packages in
`lib/pythonX.Y/site-packages`, executables and activation scripts in `bin`, and
interpreter details in `pyvenv.cfg`. Its `bin/python` may link to mise's Python.
Keep source code outside `.venv` and keep `.venv` out of Git; dependency tools
such as `uv sync` recreate it from the project's dependency definitions.

For Swift, Vim resolves `mise which sourcekit-lsp` from the detected project
root. If the selected mise toolchain provides an installed executable, Vim uses
it; otherwise it runs `xcrun sourcekit-lsp` from the active Xcode. Using mise for
tools such as SwiftLint or XcodeGen alone does not select a Swift language server.
Vim does not install or switch Swift toolchains.

For Swift packages, open the package root and build it with `swift build` when
needed. Xcode app projects need additional build-server integration for complete
cross-file language support; this setup does not configure that. Use Xcode for
iOS builds, signing, simulators, previews, and debugging.

Use `:LspStatus` to check the server. Completion is manual: in Insert mode press
**Ctrl+X, then Ctrl+O**, use Ctrl+N/Ctrl+P to choose, and Ctrl+Y to accept.
There is no formatting on save. The language menu appears after a server is
running and shows its supported actions. `Space l f` is available only when the
server supports formatting; it is absent for Pyright. Markdown and other files
without a configured language server have no language submenu.

## Shortcuts

Press Esc first to enter Normal mode. Space sequences are pressed one key at a
time; Ctrl+W means hold Ctrl and press W, then release before the next key.
The menu describes our Space mappings, not every built-in Vim command.

| Action | Keys / command |
| --- | --- |
| Show shortcut menu | Space, pause |
| Find a file | Space Space, type a name, Tab to complete, Enter |
| File browser | Space e or `:Explore`; Enter opens, `-` goes up |
| Search this file | `/pattern`, Enter; `n` / `N` next / previous |
| Search project | Space /, type a pattern, Enter; uses ripgrep and quickfix |
| Next / previous search result | `:cnext` / `:cprevious` |
| Clear search highlighting | Space h |
| List / next / previous buffer | Space b b / Space b n / Space b p |
| Close buffer | Space b d |
| Split right / below | Ctrl+W v / Ctrl+W s, or Space w v / Space w s |
| Move between panes | Ctrl+W h/j/k/l, or Space w h/j/k/l |
| Equal pane sizes | Ctrl+W = or Space w = |
| Set pane width / height | `:vertical resize 100` / `:resize 20` |
| Close pane | Ctrl+W c or Space w c |
| Definition | `gd` in LSP buffers |
| References / implementation | Space l r / Space l i |
| Go back after a jump | Ctrl+O |
| Hover documentation | Shift+K in LSP buffers |
| Code action / rename | Space l a / Space l R (Shift+R) |
| Diagnostics / next / previous | Space l d / Space l n / Space l p |
| Format / server status | Space l f (when supported) / Space l s |
| Save / quit | `:w` / `:q` |
| Start the built-in tutorial | Run `vimtutor` from the shell |

File finding uses Vim's path completion, with common dependency/build folders
excluded by `wildignore`. It does not read `.gitignore`, so files such as ignored
build outputs may still appear in completion. Project search uses ripgrep's
ignore rules, including `.gitignore`. Quote patterns containing spaces, for
example `:grep 'hello world'`.

`gi` retains Vim's command to resume Insert mode at the last insertion position;
`gr` retains its virtual-replace command. Other language actions are shown only
when supported by the current server.

All source characters remain visible, including Markdown backticks and JSON
quotes (`conceallevel=0`). No Markdown renderer, debugger UI, file-tree plugin,
or automatic completion popup is installed. This Vim setup uses no Alt mappings
and does not require changing Ghostty's Option-key behavior.

## Update

Inside Vim:

```vim
:PlugUpdate
:PlugDiff
```

Use `:PlugUpgrade` to update vim-plug itself. Plugins are not pinned; before a
larger update, `:PlugSnapshot ~/.vim/plugin-snapshot.vim` saves a restore script
for the currently installed revisions.

Update just the language tools from the shell:

```sh
mise upgrade npm:typescript npm:typescript-language-server npm:pyright
```

The macOS-provided Vim updates with macOS; SourceKit-LSP updates with its selected
Swift toolchain or Xcode.
Restart Vim after tool/plugin updates. Re-running `./vim/install.sh` installs
missing components; it does not replace `:PlugUpdate` for plugin updates.

## Checks

From the repository root:

```sh
bash -n vim/install.sh dotfiles.sh macos/brew.sh
shellcheck vim/install.sh dotfiles.sh macos/brew.sh
python3 tests/dotfiles-scoped.py
python3 tests/vim-lsp.py
```

The Vim integration checks require the installed plugins, mise language tools,
and Xcode's SourceKit-LSP. They use temporary projects and do not edit user files.
