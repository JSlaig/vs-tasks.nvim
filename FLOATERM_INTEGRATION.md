# Floaterm Integration

This document describes the Floaterm integration for vs-tasks.nvim.

## Overview

The vs-tasks.nvim plugin now supports using [vim-floaterm](https://github.com/voldikss/vim-floaterm) as a terminal backend. This allows tasks to be executed in floating terminal windows using the `FloatermSendNew` command.

## How It Works

When you run a task with Floaterm enabled:
1. Floaterm is initialized if needed (by toggling it on and off)
2. The task is sent to a new Floaterm terminal using `FloatermSendNew <label>:<command>`
3. The terminal name is set to the task label for easy identification
4. The command is automatically executed in the new terminal

## Task Environment Variables

You can set environment variables in your task definitions using the `env` option:

```json
{
  "label": "Build with JDK 11",
  "type": "shell",
  "command": "mvn clean install",
  "options": {
    "env": {
      "JAVA_HOME": "C:\\Program Files\\Java\\jdk-11"
    }
  }
}
```

The plugin automatically detects if you're using PowerShell (on Windows) and sets environment variables accordingly:
- **PowerShell**: `$env:JAVA_HOME="C:\..."`
- **Unix shells**: `export JAVA_HOME="C:\..."`

## Configuration

To use Floaterm as the terminal backend, set the `terminal` option in your setup:

```lua
require("vstask").setup({
  terminal = "floaterm", -- Use floaterm instead of native nvim terminal
  -- other options...
})
```

## Features

### Position Support

Floaterm supports the following positions:
- `float` (default) - Floating terminal window
- `vertical` - Opens to the right side
- `horizontal` - Opens at the bottom
- `tab` - Opens in a split window

### Size Support

You can configure terminal size using the `term_opts` configuration:

```lua
require("vstask").setup({
  terminal = "floaterm",
  term_opts = {
    vertical = {
      direction = "vertical",
      size = 80
    },
    horizontal = {
      direction = "horizontal",
      size = 20
    }
  }
})
```

## Dependencies

Make sure to install vim-floaterm:

```lua
-- Using lazy.nvim
{
  "voldikss/vim-floaterm",
  -- No additional configuration needed
}
```

## Limitations

When using Floaterm terminal, the following features are limited:
- Job exit codes are not tracked
- Live output preview is not available
- Job status (running/completed) may not be accurate

These limitations exist because Floaterm handles job lifecycle independently from Neovim's job API.

## Comparison with Native Terminal

| Feature | Native (nvim) | Floaterm |
|---------|---------------|----------|
| Job tracking | Full | Limited |
| Exit codes | Yes | No |
| Live output | Yes | No |
| Position control | Basic | Advanced |
| Size control | Basic | Advanced |

## Example Configuration

Here's a complete example configuration:

```lua
{
  "EthanJWright/vs-tasks.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "voldikss/vim-floaterm", -- for floaterm terminal
  },
  opts = {
    picker = "telescope",
    terminal = "floaterm",
    cache_json_conf = true,
    config_dir = ".vscode",
    term_opts = {
      vertical = {
        direction = "vertical",
        size = 80
      },
      horizontal = {
        direction = "horizontal",
        size = 20
      }
    }
  }
}
```

## Copy Command to Clipboard

While in the picker, you can press `<C-y>` to copy the full command to your system clipboard. The picker will close automatically and a notification will confirm the command was copied.

This is useful for:
- Debugging task commands
- Sharing commands with teammates
- Running the command manually in a different terminal
