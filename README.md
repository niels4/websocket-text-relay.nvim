# websocket-text-relay.nvim

websocket-text-relay.nvim is a Neovim plugin designed to enhance your live coding experience by leveraging the power of WebSockets and the Language Server Protocol (LSP).
This tool watches for changes to your files and seamlessly relays these updates to the frontend client.
With websocket-text-relay.nvim, you can see your code changes reflected live, without the need to save or refresh your browser.

This repo contains just the neovim client. The server implementation can be found in the [websocket-text-relay repo](https://github.com/niels4/websocket-text-relay)

## First Install the Language Server

**Requirements:** Nodejs

First install the websocket-text-relay language server

```
npm install --global websocket-text-relay@latest
```

## Updating the Language Server

If you already have installed the language server, you can run the same command again to update to the latest version (just be sure to include the `@latest` suffix)

## Install Neovim Plugin

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


## configuration

By default, the http and websocket server will only accept incoming connections from your local machine. If you
wish to allow network access you must set the `allow_network_access` option to true.

```lua
  { 'niels4/websocket-text-relay.nvim', opts = {
      allow_network_access = true
  }},
```

By default, the http and websocket server will only accept connections where the hostname is `localhost`. If you wish
to allow other hosts to connect to the websocket server, you must explicitly allow them using the `allowed_hosts` option.

```lua
  { 'niels4/websocket-text-relay.nvim', opts = {
      allowed_hosts = { "some-allowed-host.test", "some-other-host.test" },
  }},
```

You can override the command used to start the language server using the `cmd` option. This is useful for local
development and debugging the application using the chrome debugger. See the [developer's guide](https://github.com/niels4/websocket-text-relay/blob/main/docs/dev-getting-started.md) for more information.

```lua

local home_dir = vim.fn.resolve(os.getenv("HOME"))

require('lazy').setup {

  { 'niels4/websocket-text-relay.nvim', opts = {
    cmd = { "node", "--inspect",  home_dir .. "/dev/src/websocket-text-relay/start.js" }
  }}

}

```

## License

websocket-text-relay.nvim is released under the [MIT License](LICENSE).
