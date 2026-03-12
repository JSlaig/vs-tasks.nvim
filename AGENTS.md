# AGENTS.md

## Project Overview
**VS Tasks** is a Neovim plugin that loads and runs tasks conforming to VS Code's "Editor Tasks" specification. It supports multiple picker backends (Telescope, snacks.nvim) and manages terminal jobs, inputs, and launch configurations.

## Architecture

### Entry Points
- `lua/vstask/init.lua`: Main module entry point. Handles setup, configuration, and exposes the public API (e.g., `tasks()`, `jobs()`).
- `lua/telescope/_extensions/vstask.lua`: Telescope extension entry point.

### Core Modules
1.  **`lua/vstask/Parse.lua`**:
    *   Parses `.vscode/tasks.json`, `.vscode/launch.json`, and `*.code-workspace` files.
    *   Handles JSON parsing (supports `vim.json.decode` or custom parsers like `json5`).
    *   Manages input variables (`promptString`, `pickString`).
    *   Caches configuration if enabled.

2.  **`lua/vstask/Job.lua`**:
    *   Manages job execution (running, background, watched).
    *   Supports different terminal types: "nvim" (native) and "floaterm".
    *   Tracks live output buffers and job status.
    *   For Floaterm terminals, job tracking is limited (no exit codes or live output).
    *   Handles environment variables in task options (supports PowerShell and Unix shells).

3.  **`lua/vstask/Floaterm.lua`**:
    *   Integration with `vim-floaterm` plugin.
    *   Opens commands in floating terminals using `FloatermSendNew`.
    *   Uses `Floaterm_process` function to handle terminal creation.
    *   Sends commands with task name as terminal name (e.g., `FloatermSendNew TaskName:command`).

4.  **`lua/vstask/picker_core.lua`**:
    *   Core picker functionality shared by all picker implementations.
    *   Handles task execution logic, command cleaning, and environment variable substitution.
    *   Provides copy-to-clipboard functionality for commands.

5.  **`lua/vstask/picker.lua`**:
    *   Defines the `PickerInterface`.
    *   Acts as a proxy to the active picker implementation (Telescope or Snacks).

7.  **`lua/vstask/pickers/telescope.lua`**:
    *   Implements the PickerInterface using Telescope.
    *   Handles task selection, preview, and key mappings.

8.  **`lua/vstask/pickers/snacks.lua`**:
    *   Implements the PickerInterface using snacks.nvim.

9.  **`lua/vstask/Opts.lua`**:
    *   Handles terminal options (direction, size, type).

10. **`lua/vstask/Config.lua`**:
    *   Manages global configuration state.

## Key Workflows

### Running a Task
1.  User calls `require("vstask").tasks()`.
2.  `init.lua` delegates to `picker.lua`.
3.  `picker.lua` delegates to the active picker (e.g., `telescope.lua`).
4.  Picker displays tasks parsed by `Parse.lua`.
5.  Upon selection, `Job.lua` executes the command in a terminal.

### Managing Jobs
1.  User calls `require("vstask").jobs()`.
2.  Picker displays active/completed jobs tracked in `Job.lua`.
3.  User can view output, kill jobs, or toggle watch mode.

### Input Variables
1.  `Parse.lua` extracts inputs from `tasks.json`.
2.  `picker.lua` calls `inputs()` to display a picker for setting values.
3.  Values are stored in `Parse.lua` and substituted into commands.

## Common Commands & Setup

### Installation (Lazy.nvim)
```lua
{
  "EthanJWright/vs-tasks.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- or "folke/snacks.nvim"
    -- Optional: add for floaterm terminal support
    "voldikss/vim-floaterm",
  },
  opts = {
    picker = "telescope", -- or "snacks"
    terminal = "nvim", -- "nvim" or "floaterm"
    cache_json_conf = true,
    config_dir = ".vscode",
  }
}
```

### Telescope Extension
```lua
require("telescope").load_extension("vstask")
```

### Key Mappings (Universal API)
```vim
nnoremap <Leader>ta :lua require("vstask").tasks()<CR>
nnoremap <Leader>tj :lua require("vstask").jobs()<CR>
nnoremap <Leader>tl :lua require("vstask").launches()<CR>
```

### Picker Key Mappings
When using the task picker (Telescope or Snacks):
- `<CR>` - Run task in current window
- `<C-v>` - Run in vertical split
- `<C-p>` - Run in horizontal split
- `<C-t>` - Run in new tab
- `<C-b>` - Run in background terminal
- `<C-w>` - Run as watched job (restarts on file save)
- `<C-y>` - Copy command to clipboard and close picker

### Configuration Options
- `picker`: "telescope" | "snacks" | custom_impl
- `cache_json_conf`: boolean
- `config_dir`: string (default ".vscode")
- `support_code_workspace`: boolean
- `autodetect`: table (e.g., `{ npm = "on" }`)
- `terminal`: "nvim" | "floaterm"
- `env`: table of environment variables (in task options)
- `json_parser`: function (default `vim.json.decode`)
- `default_tasks`: table of task definitions

## Development Notes
- **Linting/Typechecking**: No specific command found in README. Check `package.json` or Makefile if exists (none found). Assume standard Lua linting if configured.
- **Testing**: No test directory found in the glob results. Verify if tests exist in `test-config` or elsewhere.
- **Dependencies**: Relies on `plenary.nvim` for async/job operations and `telescope.nvim` or `snacks.nvim` for UI.

## References
- VS Code Tasks: https://code.visualstudio.com/docs/editor/tasks
- VS Code Variables: https://code.visualstudio.com/docs/editor/variables-reference
