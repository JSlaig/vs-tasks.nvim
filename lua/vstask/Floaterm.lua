-- Floaterm integration for vs-tasks.nvim
-- Uses FloatermSendNew to send command to a new terminal

local initialized = false

local function Floaterm_process(command, label)
  -- Initialize Floaterm if not already done
  if not initialized then
    vim.cmd("FloatermToggle")
    vim.cmd("FloatermToggle") -- Toggle off immediately
    initialized = true
  end

  -- Send command to a new Floaterm terminal with the task name as terminal name
  vim.cmd("FloatermSendNew " .. label .. ":" .. command)
end

return { Process = Floaterm_process }
