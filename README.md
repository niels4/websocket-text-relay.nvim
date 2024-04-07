# websocket-text-relay.nvim

websocket-text-relay.nvim is a Neovim plugin designed to enhance your live coding experience by leveraging the power of WebSockets and the Language Server Protocol (LSP).
This tool watches for changes to your files and seamlessly relays these updates to the frontend client.
With websocket-text-relay.nvim, you can see your code changes reflected live, without the need to save or refresh your browser.

This repo contains just the neovim client. The server implementation can be found in the [websocket-text-relay repo](https://github.com/niels4/websocket-text-relay)

## Installation

**Requirements:** Nodejs

First install the websocket-text-relay language server

```
npm install --global websocket-text-relay
```

websocket-text-relay.nvim can be installed using [lazy.nvim](https://github.com/rockerBOO/lazy.nvim).

Add the following line to your Neovim configuration to install websocket-text-relay.nvim:

```lua
require('lazy').setup {

  { 'niels4/websocket-text-relay.nvim', opts = {} }

}
```

## Usage

Verify the plugin is working by viewing the status UI hosted at [http://localhost:38378](http://localhost:38378)

After installation, continue with step 2 in the [websocket-text-relay README](https://github.com/niels4/websocket-text-relay)
to connect your editor to a front end client and see your updates rendered as you type.

## License

websocket-text-relay.nvim is released under the [MIT License](LICENSE).
