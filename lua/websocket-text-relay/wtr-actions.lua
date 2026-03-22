local util = require('websocket-text-relay.util')

local lsp_name = 'websocket_text_relay'

---@type vim.lsp.Client | nil
local client
---@type table<string, boolean>
local open_files = {}

local send_open_files0 = function()
  if client == nil then
    return
  end

  local params = {
    files = vim.tbl_keys(open_files),
  }
  client:notify('wtr/update-open-files', params)
end

local send_open_files = util.debounce(send_open_files0, 50)

local reset_open_files = function()
  open_files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].buflisted and #name ~= 0 then
      open_files[name] = true
    end
  end
end

local on_new_file = function(ev)
  local name = ev.file
  if #name == 0 or not vim.bo[ev.buf].buflisted then
    return
  end
  open_files[name] = true
  send_open_files()
end

local on_remove_file = function(ev)
  local name = ev.file
  if #name == 0 or not vim.bo[ev.buf].buflisted then
    return
  end
  open_files[name] = nil
  send_open_files()
end

local augroup = vim.api.nvim_create_augroup('WebsocketTextRelay', { clear = true })

local M = {}

M.lsp_name = lsp_name

---@param lsp_config vim.lsp.Config
M.start_client = function(lsp_config)
  local client_id = vim.lsp.start(lsp_config)
  assert(client_id, 'Could not start lsp for WTR')
  client = vim.lsp.get_client_by_id(client_id)
  vim.lsp.enable(lsp_name)

  reset_open_files()
  send_open_files()

  vim.api.nvim_create_autocmd('BufAdd', {
    group = augroup,
    callback = on_new_file,
  })

  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = augroup,
    callback = on_remove_file,
  })
end

M.stop_client = function()
  if client == nil then
    return
  end
  client = nil
  vim.lsp.enable(lsp_name, false)
  vim.api.nvim_clear_autocmds({ group = augroup })
end

M.update_active_files = function(_, params)
  print('Got active files!')
  P(params.files)
end

return M
