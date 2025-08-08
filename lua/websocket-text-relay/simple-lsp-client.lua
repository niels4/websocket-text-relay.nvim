local M = {}

local client_id = nil
local client = nil

M.start = function(configIn)
	if client_id ~= nil then
		return
	end
	local config = vim.tbl_extend("force", configIn, { on_exit = M.on_exit })
	local id = vim.lsp.start_client(config)
	if not id then
		print("ERROR: " .. config.name .. " LSP server was not able to start. Is the package installed?")
		print("CMD: " .. vim.inspect(config.cmd))
		return
	end
	client_id = id
	client = vim.lsp.get_client_by_id(client_id)
end

M.send_file_open_notification = function(files)
	if client == nil then
		return
	end
	local params = {
		files = files,
	}
	client.notify("wtr/update-open-files", params)
end

M.buf_attach = function(buf)
	if client_id == nil then
		return
	end
	vim.lsp.buf_attach_client(buf, client_id)
end

M.buf_detach = function(buf)
	if client_id == nil then
		return
	end
	vim.lsp.buf_detach_client(buf, client_id)
end

M.buf_is_attached = function(buf)
	if client_id == nil then
		return false
	end
	return vim.lsp.buf_is_attached(buf, client_id)
end

M.on_exit = function()
	client_id = nil
	client = nil
end

return M
