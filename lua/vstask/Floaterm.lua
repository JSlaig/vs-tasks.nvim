-- Floaterm integration for vs-tasks.nvim
-- Simple integration using FloatermOpenInNewTerm command

local function Floaterm_process(command)
  -- Open a new Floaterm terminal (floaterm is pre-configured)
  vim.cmd("FloatermOpenInNewTerm")
  
  -- Execute the command in the newly opened terminal
  vim.cmd([[TermExec cmd="]] .. command .. [["]])
end

return { Process = Floaterm_process }
