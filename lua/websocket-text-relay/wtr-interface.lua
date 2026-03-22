local lsp_config = require 'websocket-text-relay.lsp-config'
local lsp_name = lsp_config.lsp_name

local M = {}

M.enable = function()
  vim.lsp.start(lsp_config.get_config())
  vim.lsp.enable(lsp_name)
  vim.notify 'WTR Enabled'
end

M.disable = function()
  vim.lsp.enable(lsp_name, false)
  vim.notify 'WTR disabled'
end

M.toggle = function()
  if vim.lsp.is_enabled(lsp_name) then
    M.disable()
  else
    M.enable()
  end
end

return M
