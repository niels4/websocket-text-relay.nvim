local actions = require('websocket-text-relay.wtr-actions')
local lsp_config = require('websocket-text-relay.lsp-config')

local M = {}

M.enable = function()
  actions.start_client(lsp_config.get_config())
  vim.notify('WTR Enabled')
end

M.disable = function()
  actions.stop_client()
  vim.notify('WTR disabled')
end

M.toggle = function()
  if vim.lsp.is_enabled(actions.lsp_name) then
    M.disable()
  else
    M.enable()
  end
end

return M
