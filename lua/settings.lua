-- ~/.config/nvim/lua/settings.lua
local opt = vim.opt

-- General settings for my Neovim configuration
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.expandtab = true -- Uses spaces instead of tabs
opt.shiftwidth = 2 -- Size of indents
opt.tabstop = 2 -- Number of spaces tabs count for
opt.smartindent = true -- Insert indents automatically
opt.wrap = true -- Enable line wraps
opt.swapfile = false -- Don't use swapfiles
opt.backup = false -- Don't create backup files
opt.undofile = true -- Enable persistent undo
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show search matches as you type
opt.termguicolors = true -- True color support
opt.background = "dark" -- colorschemes that can be light or dark will be dark by default
opt.signcolumn = "yes" -- show sign column so that text doesn't shift
opt.sidescrolloff = 8 -- Columns of text
opt.scrolloff = 999 -- keep the cursor line vertically centered (lower to e.g. 10 for just top/bottom padding)
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
opt.autoindent = true -- copy indent from current line when starting a new one
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-insensitive
opt.cursorline = true -- highlight the current cursor line
opt.mousefocus = true -- focus follows mouse: hovering a split activates it
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions" -- what sessions capture; tabpages matters for the telescope tab-drop workflow

-- Folding: treesitter-driven, but files open fully unfolded (za/zc to fold)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- buffers without a parser fold nothing
opt.foldlevelstart = 99
opt.foldtext = "" -- keep the first line of a closed fold syntax-highlighted
