-- Floaterm integration for vs-tasks.nvim
-- Simple integration using FloatermOpenInNewTerm command

local function Floaterm_process(command)
  -- Open a new Floaterm terminal (floaterm is pre-configured)
  vim.cmd("FloatermOpenInNewTerm")

  -- Put the command in the clipboard (register "*")
  -- This allows you to paste it with p or P
  vim.fn.setreg("*", command)
end

return { Process = Floaterm_process }
