local util = require('websocket-text-relay.util')
local lsp_config = require('websocket-text-relay.lsp-config')
local lsp_name = lsp_config.lsp_name

local open_files = {}

local send_open_files0 = function()
  local files = vim.tbl_keys(open_files)
  vim.notify('Relay synced: ' .. #files)
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

M.enable = function()
  vim.lsp.start(lsp_config.get_config())
  vim.lsp.enable(lsp_name)
  reset_open_files()
  send_open_files0()

  vim.api.nvim_create_autocmd('BufAdd', {
    group = augroup,
    callback = on_new_file,
  })

  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufWipeout' }, {
    group = augroup,
    callback = on_remove_file,
  })

  vim.notify('WTR Enabled')
end

M.disable = function()
  vim.lsp.enable(lsp_name, false)
  vim.api.nvim_clear_autocmds({ group = augroup })
  vim.notify('WTR disabled')
end

M.toggle = function()
  if vim.lsp.is_enabled(lsp_name) then
    M.disable()
  else
    M.enable()
  end
end

return M
