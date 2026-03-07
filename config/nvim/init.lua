--:: options
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 10
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 250
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.swapfile = false
--::keymaps
vim.g.mapleader = " "
local keymap = vim.keymap.set
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>e", ":Ex<CR>", { desc = "Explorer" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>x", ":bdelete<CR>", { desc = "Quit" })
keymap("i", "jk", "<Esc>", { desc = "Quit" })
keymap("n", "<Tab>", ":bnext<CR>")
keymap("n", "<S-Tab>", ":bprevious<CR>")
--::
--::floating terminal
local term_buf = nil
local term_win = nil
function _G.toggle_bottom_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end
  if term_buf == nil or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true)
  end
  local stats = vim.api.nvim_list_uis()[1]
  local padding = 1
  local width = stats.width - (padding * 4) -- Hampir selebar layar
  local height = 12
  local row = stats.height - height - 3
  local col = padding * 2
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = "  Terminal ",
    title_pos = "left",
  }
  term_win = vim.api.nvim_open_win(term_buf, true, opts)
  if vim.bo[term_buf].buftype ~= "terminal" then
    vim.cmd("terminal")
    vim.bo[term_buf].buflisted = false
  end
  vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t" }, "<leader>t", "<CMD>lua toggle_bottom_terminal()<CR>", { noremap = true, silent = true })
--:

--::disable auto comment on new line
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
--:: hightlight cursor
vim.api.nvim_set_hl(0, "SearchMatch", { bg = "#3e4452", fg = "NONE", underline = true })
local highlight_group = vim.api.nvim_create_augroup("BufferHighlight", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = highlight_group,
    callback = function()
        if vim.w.current_match_id then
            pcall(vim.fn.matchdelete, vim.w.current_match_id)
            vim.w.current_match_id = nil
        end
        local word = vim.fn.expand("<cword>")
        if word ~= "" and word:match("^[a-zA-Z0-9_]+$") then
            -- Gunakan pola regex agar hanya kata yang pas yang kena highlight
            local pattern = [[\<]] .. word .. [[\>]]
            -- Terapkan highlight ke seluruh buffer
            vim.w.current_match_id = vim.fn.matchadd("SearchMatch", pattern, -1)
        end
    end,
})
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = highlight_group,
    callback = function()
        if vim.w.current_match_id then
            pcall(vim.fn.matchdelete, vim.w.current_match_id)
            vim.w.current_match_id = nil
        end
    end,
})
--: auto pairs
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local char_pairs = {
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['"'] = '"',
    ["'"] = "'",
    ['`'] = '`',
}
for open, close in pairs(char_pairs) do
    keymap('i', open, function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local char_before = line:sub(col, col)
        local char_after = line:sub(col + 1, col + 1)
        if open == close and char_after == close then
            if char_before == open then
                return open .. close .. '<Left>'
            end
            return '<Right>'
        end
        return open .. close .. '<Left>'
    end, { expr = true, noremap = true })
end
