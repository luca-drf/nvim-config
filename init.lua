local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end


vim.g.mapleader = " "

require('mini.basics').setup()
vim.cmd.colorscheme('miniautumn')
vim.o.hlsearch = false
vim.o.incsearch = true
require('mini.icons').setup()
require('mini.statusline').setup()
require('mini.tabline').setup()
require('mini.git').setup()
require('mini.diff').setup()
require('mini.completion').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.notify').setup()
require('mini.trailspace').setup()
require('mini.indentscope').setup({
  draw = {
    animation = require('mini.indentscope').gen_animation.none()
  }
})

-- Disable autocompletion for text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "text",
  callback = function(args)
    vim.b[args.buf].minicompletion_disable = true
    vim.b[args.buf].miniindentscope_disable = true
  end
})

