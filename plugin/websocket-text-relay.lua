local wtr = require 'websocket-text-relay.wtr-interface'

vim.api.nvim_create_user_command('WtrEnable', wtr.enable, { nargs = 0 })
vim.api.nvim_create_user_command('WtrDisable', wtr.disable, { nargs = 0 })
vim.api.nvim_create_user_command('WtrToggle', wtr.toggle, { nargs = 0 })
