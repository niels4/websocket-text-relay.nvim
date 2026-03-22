local options = require('websocket-text-relay.options')

local M = {}

---@param user_opts WtrOptions
M.setup = function(user_opts)
  user_opts = user_opts and user_opts or {}
  options.set_opts(user_opts)

  if user_opts.enabled then
    vim.notify('WTR Enabled', vim.log.levels.INFO)
  end
end

return M
