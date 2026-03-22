local M = {}

--- @param fn function: The function to debounce
--- @param ms number: Timeout in milliseconds
--- @return function: The debounced version of the function
M.debounce = function(fn, ms)
  local timer = vim.uv.new_timer()
  assert(timer, 'Timer failed to create')

  return function(...)
    local argv = { ... }

    timer:stop()

    timer:start(
      ms,
      0,
      vim.schedule_wrap(function()
        fn(unpack(argv))
      end)
    )
  end
end

return M
