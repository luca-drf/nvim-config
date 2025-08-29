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

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Settings loading immediately
now(function()
  vim.g.mapleader = " "
  vim.o.hlsearch = false
  vim.o.incsearch = true
  vim.o.cursorline = true
  vim.o.termguicolors = true
  vim.opt.tabstop = 4        -- Display width of a tab character
  vim.opt.shiftwidth = 4     -- Number of spaces inserted for indentation
  vim.opt.softtabstop = 4    -- Number of spaces a <Tab> counts for in insert mode
  vim.opt.expandtab = true   -- Insert spaces when <Tab> is pressed
end)

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)

now(function()
  add('sainnhe/sonokai')
  vim.g.sonokai_enable_italic = true
  vim.cmd('colorscheme sonokai')
end)

now(function() require('mini.icons').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)
now(function()
-- Disable autocompletion for text files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "text",
    callback = function(args)
      vim.b[args.buf].minicompletion_disable = true
      vim.b[args.buf].miniindentscope_disable = true
    end
  })
end)

now(function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "javascript", "json" },
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
    end,
  })
end)


-- Settings loading in a later loop
later(function() require('mini.basics').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.completion').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function()
  require('mini.indentscope').setup({
    draw = {
      animation = require('mini.indentscope').gen_animation.none()
    }
  })
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  -- Possible to immediately execute code which depends on the added plugin
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    highlight = { enable = true },
  })
end)

