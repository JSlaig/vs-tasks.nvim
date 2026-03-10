local M = {}

-- Terminal manager interface
-- Provides a unified way to create terminals using different backends

local terminal_type = "nvim" -- nvim, toggleterm, floaterm

-- Set the terminal type
function M.set_terminal_type(type)
	terminal_type = type
end

-- Get the current terminal type
function M.get_terminal_type()
	return terminal_type
end

-- Open a terminal and run a command
-- Returns job_id (for nvim) or terminal id (for toggleterm/floaterm)
function M.open_terminal(command, opts)
	opts = opts or {}
	local direction = opts.direction or "current"
	local size = opts.size

	if terminal_type == "nvim" then
		return M._open_nvim_terminal(command, direction, size)
	elseif terminal_type == "toggleterm" then
		return M._open_toggleterm_terminal(command, direction, size)
	elseif terminal_type == "floaterm" then
		return M._open_floaterm_terminal(command, direction, size)
	else
		vim.notify("Unknown terminal type: " .. terminal_type, vim.log.levels.ERROR)
		return nil
	end
end

-- NVim native terminal (default)
function M._open_nvim_terminal(command, direction, size)
	-- Create terminal buffer
	local buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_set_current_buf(buf)

	-- Start terminal job
	local job_id = vim.fn.termopen(command, {
		on_exit = function()
			-- Terminal closed
		end,
	})

	return job_id
end

-- ToggleTerm terminal
function M._open_toggleterm_terminal(command, direction, size)
	-- Parse direction for ToggleTerm
	local tt_direction = direction
	if direction == "vertical" then
		tt_direction = "vertical"
	elseif direction == "horizontal" then
		tt_direction = "horizontal"
	elseif direction == "tab" then
		tt_direction = "tab"
	else
		tt_direction = "float"
	end

	-- Build ToggleTerm command
	local cmd = "ToggleTerm "
	if size then
		cmd = cmd .. "size=" .. size .. " "
	end
	if tt_direction ~= "float" then
		cmd = cmd .. "direction=" .. tt_direction .. " "
	end

	-- Open terminal
	vim.cmd(cmd)
	vim.cmd('TermExec cmd="' .. command .. '"')

	return nil -- ToggleTerm manages its own job IDs
end

-- Floaterm terminal
function M._open_floaterm_terminal(command, direction, size)
	-- Use the Floaterm module to process the command
	local Floaterm = require("vstask.Floaterm")
	
	-- Build options table
	local opts = {}
	if direction == "vertical" or direction == "horizontal" or direction == "tab" then
		opts[direction] = { direction = direction }
		if size then
			opts[direction].size = size
		end
	end
	
	-- Call Floaterm's Process function
	Floaterm.Process(command, direction, opts)
	
	return nil -- Floaterm manages its own terminal
end

return M
