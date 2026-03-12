-- Floaterm integration for vs-tasks.nvim
-- Uses FloatermSendNew to send command to a new terminal

local function Floaterm_process(command, label)
  -- Send command to a new Floaterm terminal with the task name as terminal name
  vim.cmd("FloatermSendNew " .. label .. ":" .. command)
end

return { Process = Floaterm_process }
