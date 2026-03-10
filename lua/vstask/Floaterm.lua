-- Floaterm integration for vs-tasks.nvim
-- Simple integration using FloatermOpenInNewTerm command

local initialized = false

local function Floaterm_process(command)
  -- Initialize Floaterm if not already done
  if not initialized then
    vim.cmd("FloatermToggle")
    vim.cmd("FloatermToggle") -- Toggle off immediately
    initialized = true
  end

  -- Open a new Floaterm terminal (floaterm is pre-configured)
  vim.cmd("FloatermOpenInNewTerm")

  -- Put the command in the clipboard (register "*")
  -- This allows you to paste it with p or P
  vim.fn.setreg("*", command)
end

return { Process = Floaterm_process }
