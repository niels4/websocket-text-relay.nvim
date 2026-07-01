local actions = require('websocket-text-relay.wtr-actions')
local lsp_config = require('websocket-text-relay.lsp-config')

local M = {}

M.enable = function()
  local config = lsp_config.get_config()

  actions.start_client(config)
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    callback = function()
      actions.start_client(config)
    end,
  })

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
