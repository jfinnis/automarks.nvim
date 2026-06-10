-- JSON scanning logic: finds top-level keys and returns their line numbers.
local M = {}

--- Scan buffer lines for JSON keys matching the given names.
--- Matches lines like:   "dependencies": {
--- Ignores leading whitespace.
---@param lines string[] Array of lines from the buffer
---@param names string[] List of key names to look for (e.g. "dependencies")
---@return table<string, number> Map of name -> line number (only includes found keys)
M.scan_all = function(lines, names)
  local results = {}
  local remaining = {}
  for _, name in ipairs(names) do
    remaining[name] = true
  end

  for i, line in ipairs(lines) do
    for name, _ in pairs(remaining) do
      -- Match: optional whitespace, then "name" followed by :
      if line:match('^%s*"' .. name .. '"%s*:') then
        results[name] = i
        remaining[name] = nil
        break
      end
    end

    if next(remaining) == nil then
      break
    end
  end

  return results
end

return M
