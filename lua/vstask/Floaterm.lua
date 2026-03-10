local Opts = require('vstask.Opts')

-- Floaterm integration for vs-tasks.nvim
-- Supports both vim-floaterm (vimscript) and floaterm.nvim (lua)

local function Floaterm_process(command, direction, opts)
  local opt_direction = Opts.get_direction(direction, opts)
  
  -- Build Floaterm command
  local floaterm_cmd = "FloatermNew"
  
  -- Add position argument based on direction
  if opt_direction == "vertical" then
    floaterm_cmd = floaterm_cmd .. " --position=right"
  elseif opt_direction == "horizontal" then
    floaterm_cmd = floaterm_cmd .. " --position=bottom"
  elseif opt_direction == "tab" then
    floaterm_cmd = floaterm_cmd .. " --position=split"
  else
    -- Default to float
    floaterm_cmd = floaterm_cmd .. " --position=float"
  end
  
  -- Add size if specified
  local size = Opts.get_size(direction, opts)
  if size then
    -- Floaterm uses height/width percentages
    floaterm_cmd = floaterm_cmd .. " --height=" .. math.floor(size / 10)
  end
  
  -- Execute the command - pass command as argument to FloatermNew
  -- Note: FloatermNew expects the command as a string argument
  vim.cmd(floaterm_cmd .. " " .. command)
end

return { Process = Floaterm_process }
