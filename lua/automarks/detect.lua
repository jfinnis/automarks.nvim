-- Route detection logic
local M = {}

--- Check if a file path looks like a Remix/React Router route file.
--- For MVP: just checks if the path contains a "/routes/" segment.
---@param filepath string The full file path
---@return boolean
M.is_route_file = function(filepath)
  return filepath:find("/routes/") ~= nil
end

return M
