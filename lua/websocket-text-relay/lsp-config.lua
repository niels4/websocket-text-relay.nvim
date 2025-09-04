local capabilities = vim.lsp.protocol.make_client_capabilities()

local DEFAULT_UPDATES_PER_SECOND = 31

local server = {
	cmd = { "websocket-text-relay" },
	name = "websocket-text-relay",
	capabilities = capabilities,
	init_options = { label = "websocket-text-relay" },
	flags = {
		debounce_text_changes = math.floor(1000 / DEFAULT_UPDATES_PER_SECOND),
	},
}

return server
