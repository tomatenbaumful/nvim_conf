vim.g.mapleader = " "
vim.g.have_nerd_font = true

pcall(function()
  vim.api.nvim_exec2("language en_US", {})
end)

-- Move window
vim.keymap.set("", "<C-h>", "<C-w>h", { desc = "Move window (left)" })  -- Left
vim.keymap.set("", "<C-k>", "<C-w>k", { desc = "Move window (up)" })    -- Up
vim.keymap.set("", "<C-j>", "<C-w>j", { desc = "Move window (down)" })  -- Down
vim.keymap.set("", "<C-l>", "<C-w>l", { desc = "Move window (right)" }) -- Right

-- Resize window
vim.keymap.set("n", "<C-w><left>", "<C-w><", { desc = "Resize window (left)" })
vim.keymap.set("n", "<C-w><right>", "<C-w>>", { desc = "Resize window (right)" })
vim.keymap.set("n", "<C-w><up>", "<C-w>+", { desc = "Resize window (up)" })
vim.keymap.set("n", "<C-w><down>", "<C-w>-", { desc = "Resize window (down)" })

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Jumping pages keeps cursor in the middle
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump page down" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump page up" })

-- Keep search terms in the middle of the screen
vim.keymap.set("n", "n", "nzzzv", { desc = "Jump to next search term" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Jump to previous search term" })

-- Pastes copied buffer and keeps it in the register
vim.keymap.set("x", "<leader>0", '"_dP')

-- vim.g.clipboard = {
--   name = 'WslClipboard',
--   copy = {
--     ['+'] = 'clip.exe',
--     ['*'] = 'clip.exe',
--   },
--   paste = {
--     ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--   },
--   cache_enabled = 0,
-- }
-- Copy
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>y", '"+yg_')
vim.keymap.set("n", "<leader>Y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
-- Paste
vim.keymap.set("v", "<leader>p", '"+p')
vim.keymap.set("v", "<leader>P", '"+P')
vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>P", '"+P')


local opts = {
  shiftwidth = 4,
  tabstop = 4,
  expandtab = true,
  wrap = true,
  breakindent = true,
  termguicolors = true,
  number = true,
  relativenumber = true,
  scrolloff = 20,
  signcolumn = "yes",
  hlsearch = true,
  incsearch = true,
  showmode = false,

  undofile = true,

  conceallevel = 0,
  formatoptions = vim.o.formatoptions:gsub("cro", ""),
  updatetime = 50,
  ignorecase = true,
  smartcase = true,
  splitbelow = true,
  splitright = true,
}

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

for opt, val in pairs(opts) do
  vim.o[opt] = val
end

vim.filetype.add({
  extension = {
    postcss = 'css',
    pcss = 'css',
  }
})
