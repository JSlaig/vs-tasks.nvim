# Floaterm Integration

This document describes the Floaterm integration for vs-tasks.nvim.

## Overview

The vs-tasks.nvim plugin now supports using [vim-floaterm](https://github.com/voldikss/vim-floaterm) as a terminal backend. This allows tasks to be executed in floating terminal windows.

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

When using external terminals (Floaterm or ToggleTerm), the following features are limited:
- Job exit codes are not tracked
- Live output preview is not available
- Job status (running/completed) may not be accurate

These limitations exist because external terminal managers handle job lifecycle independently from Neovim's job API.

## Comparison with Native Terminal

| Feature | Native (nvim) | Floaterm | ToggleTerm |
|---------|---------------|----------|------------|
| Job tracking | Full | Limited | Limited |
| Exit codes | Yes | No | No |
| Live output | Yes | No | No |
| Position control | Basic | Advanced | Advanced |
| Size control | Basic | Advanced | Advanced |

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
