local DEFAULT_UPDATES_PER_SECOND = 31

---@class WtrOptions
---@field enabled? boolean Enabled on startup?
---@field allow_network_access? boolean Allow other computers on local network to access websocket interface.
---@field allowed_hosts? string[] Similar to CORS. Choose which urls are allowed to connect to the websocket interface.
---@field cmd? string|string[] The command to start the LSP. Can be a string or a list of strings.
---@field updates_per_second? number How many times per second to sync text.

---@class WtrOptionsInternal
---@field cmd string|string[]
---@field updates_per_second number
---@field allow_network_access boolean
---@field allowed_hosts string[]

local M = {}

---@type WtrOptionsInternal
M.opts = {
  cmd = 'websocket-text-relay',
  updates_per_second = DEFAULT_UPDATES_PER_SECOND,
  allow_network_access = false,
  allowed_hosts = {},
}

---@param user_opts WtrOptions
M.set_opts = function(user_opts)
  M.opts.cmd = user_opts.cmd or M.opts.cmd
  M.opts.updates_per_second = user_opts.updates_per_second or M.opts.updates_per_second
  M.opts.allow_network_access = user_opts.allow_network_access or M.opts.allow_network_access
  M.opts.allowed_hosts = user_opts.allowed_hosts or M.opts.allowed_hosts
end

return M
