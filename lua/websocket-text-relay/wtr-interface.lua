local lsp_config = require('websocket-text-relay.lsp-config')
local lsp_name = lsp_config.lsp_name

local get_open_files = function()
  local buf_names = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].buflisted and #name ~= 0 then
      table.insert(buf_names, name)
    end
  end
  return buf_names
end

local update_open_file_list = function()
  local files = get_open_files()
  print('Updating files: ' .. vim.inspect(files))
end

local augroup = vim.api.nvim_create_augroup('WebsocketTextRelay', { clear = true })

local M = {}

M.enable = function()
  vim.lsp.start(lsp_config.get_config())
  vim.lsp.enable(lsp_name)
  update_open_file_list()

  vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufFilePost', 'BufWipeout' }, {
    group = augroup,
    pattern = '*',
    callback = update_open_file_list,
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
