# websocket-text-relay.nvim

With `websocket-text-relay.nvim`, you can see your code changes reflected live, without the need to save or refresh your browser.

`websocket-text-relay.nvim` is a Neovim plugin designed to enhance your live coding experience by leveraging the power of WebSockets and the Language Server Protocol (LSP).
This tool watches for changes to your files and seamlessly relays these updates to the frontend client.

This repo contains just the neovim client. The server implementation can be found in the [websocket-text-relay repo](https://github.com/niels4/websocket-text-relay)

## First Install the Language Server

**Requirements:** Nodejs

First install the websocket-text-relay language server

```
npm install -g websocket-text-relay
```

## Updating the Language Server

If the language server is already installed, you can run the same command again to update to the latest version.

## Install Neovim Plugin

websocket-text-relay.nvim can be installed using [lazy.nvim](https://github.com/rockerBOO/lazy.nvim).

### With Lazy
Add the following lines to your Neovim configuration to install websocket-text-relay.nvim and configure `<M-w>` to toggle the language server on and off:

```lua
require('lazy').setup {

  { 'niels4/websocket-text-relay.nvim', 
    keys = {
      { mode = 'n', '<M-w>', '<cmd>WtrToggle<cr>', desc = '[w]tr toggle' },
    },
  }

}
```

### Without Lazy

Use any package manager you like to install the plugin in the github repo `niels4/websocket-text-relay.nvim`

### Commands

Once installed 3 commands become available: `WtrToggle`, `WtrEnable`, and `WtrDisable`

#### Map with standard keymap.set
```lua
vim.keymap.set('n', '<M-w>', '<cmd>WtrToggle<cr>', { 
  desc = '[w]tr toggle',
  silent = true 
})
```

## Usage

Once the plugin is installed, enable it with your hotkey <M-w> or enter the command `:WtrEnable` to start the language server and websocket interface.

Verify the plugin is working by viewing the status UI hosted at [http://localhost:38378](http://localhost:38378)

Test your setup is working with a simple vanillajs app: [github.com/niels4/live-demo-vanillajs](https://github.com/niels4/live-demo-vanillajs)

```sh
git clone https://github.com/niels4/live-demo-vanillajs.git
cd live-demo-vanillajs
npx serve
```

If you use `npx serve`, the url:port will be copied to your clipboard. Just open a browser and paste the location.

Now open up nvim, enable WTR with your hotkey or the `WtrEnable` command. Start editing the h1 tag in `live-pages/main.html`. You should see the text in the header update instantly.

Open `live-pages/main.css`, edit the `hsl` values that define the color for the h1 tag. You should see the color of the header change instantly.

Visit [niels4/websocket-text-relay](https://github.com/niels4/websocket-text-relay) for more information on usage and development.

## configuration

```lua
---@class WtrOptions
---@field enabled? boolean Enabled on startup?
---@field allow_network_access? boolean Allow other computers on local network to access websocket interface.
---@field allowed_hosts? string[] Similar to CORS. Choose which urls are allowed to connect to the websocket interface.
---@field cmd? string|string[] The command to start the LSP. Can be a string or a list of strings.
---@field updates_per_second? number How many times per second to sync text.


---@param user_opts WtrOptions
M.setup = function(user_opts)
```

### enabled

By default, the language server is not enabled.
Set the `enabled` option to true to start the language server and websocket interface when neovim starts.

```lua
  { 'niels4/websocket-text-relay.nvim', opts = {
      enabled = true
  }},
```

### allow_network_access

By default, the http and websocket server will only accept incoming connections from your local machine. If you
wish to allow network access you must set the `allow_network_access` option to true.

```lua
  { 'niels4/websocket-text-relay.nvim', opts = {
      allow_network_access = true
  }},
```

### allowed_hosts

This is similar to (CORS)[https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CORS]. But enforced server side.

By default, the http and websocket server will only accept connections from a web browser where the hostname is `localhost`.
If you wish visit another website and allow your browser to connect to the websocket interface, you must explicitly allow them using the `allowed_hosts` option.
Only add hosts that you trust, as they will be able to the contents of any source files opened in your editor.

```lua
  { 'niels4/websocket-text-relay.nvim', opts = {
      allowed_hosts = { "niels4.github.io", "some-other-host.test" },
  }},
```

### cmd

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

### updates_per_second

You can use the `updates_per_second` option to override the default update rate of the LSP client. As of September 2025, it seems that the max updates per second that neovim
will send to the LSP server is 30. That is the default setting for websocket-text-relay, if you wish to send updates at a lower rate
you can reduce the value in the config.


```lua
  { 'niels4/websocket-text-relay.nvim', opts = {
      updates_per_second = 30
  }},
```

## License

websocket-text-relay.nvim is released under the [MIT License](LICENSE).
