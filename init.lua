local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--depth=1', 'https://github.com/nvim-mini/mini.nvim', mini_path }
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
  -- Dedicated python venv with pynvim package installed
  vim.g.python3_host_prog = vim.fn.expand('~/.pyenv/versions/pynvim/bin/python')
  vim.o.hlsearch = false
  vim.o.incsearch = true
  vim.o.cursorline = true
  vim.o.termguicolors = true
  vim.opt.tabstop = 4        -- Display width of a tab character
  vim.opt.shiftwidth = 4     -- Number of spaces inserted for indentation
  vim.opt.softtabstop = 4    -- Number of spaces a <Tab> counts for in insert mode
  vim.opt.expandtab = true   -- Insert spaces when <Tab> is pressed
  vim.opt.listchars = { tab = ">-", trail = "~", space = "·", eol = "¬" }
  -- Yank to system clipboard with <leader>y
  vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to system clipboard" })
  vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank selection to system clipboard" })
end)

now(function() require('mini.starter').setup() end)
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
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'text',
    callback = function(args)
      vim.b[args.buf].minicompletion_disable = true
      vim.b[args.buf].miniindentscope_disable = true
    end
  })

  -- Make headers act as borders in Python files (show the function body as scope)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function(args)
      vim.b[args.buf].miniindentscope_config = {
        options = {
          try_as_border = true,
          border = 'top', -- optional: avoids including the trailing blank line after a block
        },
      }
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
later(function() require('mini.surround').setup() end)
later(function() require('mini.pairs').setup() end)
later(function()
  require('mini.completion').setup()

  local imap_expr = function(lhs, rhs)
    vim.keymap.set('i', lhs, rhs, { expr = true })
  end
  imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
  imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

  _G.cr_action = function()
    -- If there is selected item in popup, accept it with <C-y>
    if vim.fn.complete_info()['selected'] ~= -1 then return '\25' end
    -- Fall back to plain `<CR>`. You might want to customize according
    -- to other plugins. For example if 'mini.pairs' is set up, replace
    -- next line with `return MiniPairs.cr()`
    -- return '\r'
    return MiniPairs.cr()
  end

  vim.keymap.set('i', '<CR>', 'v:lua.cr_action()', { expr = true })
end)

later(function() require('mini.comment').setup() end)
later(function() require('mini.trailspace').setup() end)
later(function()
  vim.keymap.set('n', '\\l', ':set list!<CR>', { desc = "Toggle blank characters" })
end)
later(function()
  require('mini.files').setup()
  vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open()<CR>', { desc = "Open file explorer" })
end)

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
    ensure_installed = { 'lua', 'vimdoc', 'python', 'c', 'vim', 'typescript', 'javascript' },
    highlight = { enable = true },
    additional_vim_regex_highlighting = false,
  })
end)

later(function()
  require('mini.trailspace').setup()
  vim.keymap.set('n', '\\t', ':lua MiniTrailspace.trim()<CR>', { desc = "Trim trailing white spaces" })
end)
