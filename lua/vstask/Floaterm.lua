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
  vim.fn.setreg("*", command)

  -- Wait 1 second then paste and press Enter
  vim.defer_fn(function()
    -- Enter insert mode, paste, and press Enter
    vim.cmd("startinsert")
    vim.fn.feedkeys("*p", "n")
    vim.fn.feedkeys("\r", "n")
  end, 1000)
end

return { Process = Floaterm_process }
