local lsp_config = require('websocket-text-relay.lsp-config')
local simple_lsp_client = require('websocket-text-relay.simple-lsp-client')

local M = {}

local watchedFiles = {}

local is_watching = function(file)
  for _, file_name in ipairs(watchedFiles) do
    if (file == file_name) then
      return true
    end
  end
  return false
end

local update_buf_watcher = function(buf)
  local file = vim.api.nvim_buf_get_name(buf)
  if (file == "") then return end
  local should_attach = is_watching(file)
  local is_attached = simple_lsp_client.buf_is_attached(buf)
  if (should_attach and not is_attached) then
    simple_lsp_client.buf_attach(buf)
   elseif (is_attached and not should_attach) then
    simple_lsp_client.buf_detach(buf)
  end
end

local update_all_buf_watchers = function()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    update_buf_watcher(buf)
  end
end

local get_all_buffer_names = function ()
  local buf_names = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if (string.len(name) > 0) then
      table.insert(buf_names, name)
    end
  end
  return buf_names
end

local update_open_file_list = function()
  local files = get_all_buffer_names()
  simple_lsp_client.send_file_open_notification(files)
end

lsp_config.handlers = {
  ["websocketTextRelay/updateWatchedFiles"] = function(_, params)
    watchedFiles = params.files
    update_all_buf_watchers()
  end,
  ["wtr/update-active-files"] = function(_, params)
    watchedFiles = params.files
    update_all_buf_watchers()
  end
}

M.setup = function(options)
  options = options or {}
  lsp_config.cmd = options.cmd or lsp_config.cmd
  lsp_config.init_options.allowedHosts = options.allowed_hosts
  lsp_config.init_options.allowNetworkAccess = options.allow_network_access
  simple_lsp_client.start(lsp_config)

  local augroup = vim.api.nvim_create_augroup("WebsocketTextRelay", { clear = true })

  -- register autocommands for open and rename
  vim.api.nvim_create_autocmd("BufRead", {
    group = augroup,
    pattern = "*",
    callback = update_open_file_list
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    group = augroup,
    pattern = "*",
    callback = update_open_file_list
  })
end

return M
