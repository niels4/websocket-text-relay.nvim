local capabilities = vim.lsp.protocol.make_client_capabilities()

local server = {
	cmd = { "websocket-text-relay" },
	name = "websocket-text-relay",
	capabilities = capabilities,
	init_options = { label = "websocket-text-relay" },
}

return server
