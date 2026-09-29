# Install dotfiles

```
./dotfiles.sh
```

---

## Platform Support

These dotfiles are intended for Apple Silicon Macs only (M1/M2/M3 and newer). They are not supported on Intel-based Macs.

---

# macOS

In the *macos* folder there are scripts to install Homebrew packages, standalone AI CLIs, mise-managed development tools, and apply `macOS` defaults.

```
./macos/install.sh
```

To install only the tools configured in `mise/config.toml`:

```
./macos/mise.sh
```

To install the standalone Codex and Cursor CLIs:

```
./macos/ai-cli.sh
```

# Interactive Steps and Permissions

- The macOS defaults script may request administrator privileges (e.g., to change visibility of `/Volumes`). Be ready to enter your password when prompted.
- If Xcode Command Line Tools are not installed, `brew.sh` may require them. You can install them with `xcode-select --install`.

# Xcode configuration

```
./macos/xcode/copy.sh
```

---

## Repository Location and DOTFILES Resolution

- Recommended clone path: `~/Developer/dotfiles`.
- During installation, `dotfiles.sh` creates a symlink from the repo’s `zshrc` to `~/.zshrc`. The shell configuration then derives the repository path via that symlink and exports it as `DOTFILES`.
  - In other words, `DOTFILES` resolves automatically as “the directory containing the file that `~/.zshrc` links to”, so the repository can live anywhere as long as `~/.zshrc` is linked by `./dotfiles.sh install`.
  - If you choose not to symlink `~/.zshrc`, set `DOTFILES` manually in your environment to the repo root so custom scripts on your `PATH` (e.g., `bin/*`) are available: `export DOTFILES=~/Developer/dotfiles && export PATH="$DOTFILES/bin:$PATH"`.
- Fastfetch configuration is managed through `fastfetch/config.jsonc`, which `dotfiles.sh` links to `~/.config/fastfetch/config.jsonc`.
- Ghostty configuration is managed through `ghostty/config.ghostty`, which `dotfiles.sh` links to `~/.config/ghostty/config.ghostty`.
- Prompt configuration is managed through `starship.toml`, which `dotfiles.sh` links to `~/.config/starship.toml`.
- `zsh/prompt.zsh` only initializes Starship; prompt layout and custom segments live in `starship.toml`.

## Neovim

Neovim 0.12+ config starts in [`nvim/init.lua`](nvim/init.lua) and uses the built-in
`vim.pack` package manager. Packages are declared in
[`nvim/lua/plugins/init.lua`](nvim/lua/plugins/init.lua), which loads the individual
plugin configurations. Mason, LSP, and Treesitter each have their own file under
`nvim/lua/plugins/`. The enabled mini.nvim modules each have a configuration under
[`nvim/lua/plugins/mini/`](nvim/lua/plugins/mini/), with extra pickers alongside mini.pick.

The bundled `xcode` colorscheme uses Xcode Default syntax and editor colors,
with light and dark variants selected by `:set background=light` or
`:set background=dark`. It includes Treesitter, LSP, and mini.nvim highlights.
Colorizer previews color literals directly in files; use `:ColorizerToggle`
to toggle it for the current buffer. Its setup is in `lua/plugins/colorizer.lua`.

Space is the leader key. Use `-` to browse the current working directory or
`<leader>-` to reveal the current file. In the explorer, Enter opens an entry,
`L` opens it and closes the explorer when it is a file, `h`/`H` navigate upward,
`q` closes the explorer, and `=` applies file edits after confirmation.
Use `<leader>pf` to find files, `<leader>ps` to search the word under the cursor,
`<leader>pg` for live text search, and `<leader>vh` for help.
Use `<leader>xx` for diagnostics and `<leader>pk` to search keymaps.
mini.clue shows available keys after pausing on Space, `g`, `z`, Ctrl-w, `[` or `]`.
mini.statusline shows mode, diagnostics, and filename on the left, with LSP,
Git branch and diff counts, file information, and cursor position on the right.
mini.git supplies the branch information;
mini.pairs automatically closes brackets and quotes while typing.
Use `<leader>f` to format the file, or the selection in Visual mode, with Conform.
Formatting is manual. Install its external tools with `:MasonInstall stylua prettier ruff`:
StyLua handles Lua, Prettier handles JS/TS and web/document formats, and Ruff handles Python.
Swift formatting uses `xcrun swift-format` from Xcode. Other filetypes fall back to
an attached LSP formatter when available. Use `:ConformInfo` to inspect formatter availability.
Use `<leader>u` to toggle Neovim's bundled undo tree. Moving with `j`/`k` in
the tree restores the selected editing state; `u` and Ctrl-r retain normal undo/redo.

Use `:Mason` to install language servers, then enable their nvim-lspconfig names
with `vim.lsp.enable(...)` in `lua/plugins/lsp.lua`. Lua, TypeScript/JavaScript, Python,
and Swift are enabled. Install the first three servers with
`:MasonInstall lua-language-server typescript-language-server pyright`.
Swift uses SourceKit-LSP from the selected Xcode toolchain through `xcrun`.
Treesitter installs the parser list in `lua/plugins/treesitter.lua` automatically
and enables highlighting when a parser is available, including in buffers opened
before installation finishes. Parser updates run after nvim-treesitter updates
through `vim.pack`. Use `:TSInstall <language>` for extra parsers or `:TSUpdate`
for a manual update. Parser compilation requires tree-sitter-cli 0.26.1+ and a C compiler.

Add plugin specifications in `lua/plugins/init.lua` to `vim.pack.add({ ... })` and restart Neovim to install
them. Track the generated `nvim/nvim-pack-lock.json` with the configuration.
Run `:lua vim.pack.update()` to review updates, then `:write` to apply them or
`:quit` to discard them. See `:help vim.pack` for details.

Link it with `./dotfiles.sh install nvim`, then open `nvim .` (or `vim .`).

## Yazi

The Yazi configuration shows Git status indicators beside files and directories
using the official [Git plugin](https://github.com/yazi-rs/plugins/tree/main/git.yazi).
After installing Yazi, link its configuration and restore the locked plugin version:

```sh
./dotfiles.sh install yazi
ya pkg install
```

Restart Yazi after setup. Plugin versions are tracked in `yazi/package.toml`;
downloaded plugins are ignored by Git. Run `ya pkg upgrade` to update them and
review the resulting manifest changes.

## Skill-managed maintenance

Defaults drift/audit and Swift completion refresh are handled through repository skills under `.agents/skills/`:

- `$dotfiles-defaults-sync` — audit/sync macOS defaults drift against `macos/defaults.sh`
- `$dotfiles-swift-completion-update` — refresh `zsh/completions/_swift` when Swift changes

## Setup SSH

You need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain.

`touch ~/.ssh/config`

```
Host *
  UseKeychain yes
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
```

Add your SSH private key to the ssh-agent and store your passphrase in the keychain.

```
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

```

More info can be found here:

- [Connecting to Github with ssh](https://help.github.com/en/articles/connecting-to-github-with-ssh)
- [Generating a new ssh key and adding it to the ssh agent](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [Managing multiple github SSH keys on mac](https://samwize.com/2022/04/06/managing-multiple-github-ssh-keys-on-mac/)
