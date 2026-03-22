local options = require('websocket-text-relay.options')
local wtr = require('websocket-text-relay.wtr-client')

local M = {}

---@param user_opts WtrOptions
M.setup = function(user_opts)
  user_opts = user_opts and user_opts or {}
  options.set_opts(user_opts)

  if user_opts.enabled then
    wtr.enable()
  end
end

return M
