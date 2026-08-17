# nvim-config

Personal Neovim configuration. Lazy.nvim-managed, treesitter `main` branch,
mason-lspconfig v2, tokyonight.

## Setup on a new machine

```sh
# prerequisites (macOS)
brew install neovim tree-sitter-cli ripgrep
xcode-select --install   # C compiler for parser/fzf builds

git clone git@github.com:JustSomeContent/nvim-config.git ~/.config/nvim

# install plugins at the exact locked versions, then parsers
nvim --headless "+Lazy! restore" +qa
nvim --headless "+TSUpdate" +qa
```

Mason installs language servers and formatters on first launch
(`:checkhealth mason` to verify). Language toolchains are expected on the
machine for the languages you actually use — e.g. Elixir/Erlang for
elixir-ls and `mix format`, a JDK for jdtls, Node for the web servers.

Keymap discovery: press `<space>` and wait for the which-key menu, or
`:Telescope keymaps`. Conventions and architecture notes live in
[CLAUDE.md](CLAUDE.md).
