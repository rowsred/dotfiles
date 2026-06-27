vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
    vim.opt.clipboard = "unnamedplus" -- Share system clipboard
    vim.opt.ignorecase = true         -- Case-insensitive searching
    vim.opt.smartcase = true          -- Case-sensitive if uppercase used
    local function vscode_call(cmd)
        return function()
            require('vscode').call(cmd)
        end
    end
    vim.keymap.set('n', '<leader>w', vscode_call('workbench.action.files.save'))  -- Write / Save file
    vim.keymap.set('n', '<leader>e', vscode_call('workbench.view.explorer'))     -- File Explorer
    vim.keymap.set('n', '<leader>ff', vscode_call('workbench.action.quickOpen'))  -- Find Files

    vim.keymap.set('i', '<C-n>', vscode_call('editor.action.triggerSuggest'))
    vim.keymap.set('i', '<C-p>', vscode_call('editor.action.triggerSuggest'))
    vim.keymap.set('i', '<C-y>', vscode_call('acceptSelectedSuggestion'))
else
end