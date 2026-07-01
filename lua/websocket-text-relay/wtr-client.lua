local actions = require('websocket-text-relay.wtr-actions')
local lsp_config = require('websocket-text-relay.lsp-config')

local M = {}

local last_enabled = 0
local enabled = false

M.enable = function()
  local config = lsp_config.get_config()
  enabled = true

  last_enabled = os.time()
  actions.start_client(config)
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
    callback = function()
      if enabled then
        actions.start_client(config)
      end
    end,
  })

  vim.notify('WTR Enabled')
end

M.disable = function()
  enabled = false
  actions.stop_client()
  vim.notify('WTR disabled')
end

M.toggle = function()
  -- prevent toggle from disabling the server immediately after starting up
  if os.time() - last_enabled <= 1 then
    return
  end

  if enabled then
    print('WTR TOggle disable')
    M.disable()
  else
    print('WTR TOggle enable')
    M.enable()
  end
end

return M
