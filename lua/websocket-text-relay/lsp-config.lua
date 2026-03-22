local actions = require('websocket-text-relay.wtr-actions')
local options = require('websocket-text-relay.options')
local opts = options.opts

local lsp_name = actions.lsp_name

local M = {}

M.get_config = function()
  ---@diagnostic disable-next-line: assign-type-mismatch
  local cmd = type(opts.cmd) == 'table' and opts.cmd or { opts.cmd } ---@type string[]

  if vim.fn.executable(cmd[1]) == 0 then
    vim.notify('WTR: Executable ' .. cmd[1] .. ' not found in PATH. Install with `npm install -g websocket-text-relay`', vim.log.levels.ERROR)
  end

  ---@type vim.lsp.Config
  return {
    name = lsp_name,
    cmd = cmd,
    init_options = { label = 'websocket-text-relay' },
    flags = {
      exit_timeout = 0,
      debounce_text_changes = math.floor(1000 / opts.updates_per_second),
    },
    on_init = function()
      vim.notify('wtr init', vim.log.levels.INFO)
    end,
    handlers = {
      ['wtr/update-active-files'] = actions.update_active_files,
    },
  }
end

return M
