-- Buffer scanning logic: finds exported functions and returns their line numbers.
local M = {}

--- Check if a line exports a specific identifier as a standalone word.
--- Matches patterns like:
---   export function loader(
---   export const loader =
---   export async function loader(
---   export let loader:
--- Does NOT match:
---   export function myCustomLoader(
---   // export function loader(
---@param line string The line of code to check
---@param name string The identifier to look for (e.g. "loader")
---@return boolean
M.line_exports = function(line, name)
  -- Must start with "export" (no leading comment characters)
  if not line:match("^export%s") then
    return false
  end

  -- Look for the identifier as a standalone word.
  -- We search for the name surrounded by non-word characters (or start/end of string).
  -- Lua pattern: find "name" preceded by a non-alphanumeric/underscore char
  -- and followed by a non-alphanumeric/underscore char.
  local pattern = "[^%w_]" .. name .. "[^%w_]"

  -- Also handle the case where name is right after "function " or "const " etc.
  -- We pad the line so we don't need to special-case start/end boundaries.
  local padded = " " .. line .. " "
  return padded:find(pattern) ~= nil
end

--- Check if a line is a default export.
--- Matches: export default function, export default class, export default (
---@param line string
---@return boolean
M.line_exports_default = function(line)
  return line:match("^export%s+default%s") ~= nil
end

--- Single-pass scan: check all names at once, return a table of { name = line_number }.
--- Only loops through the file once regardless of how many names we're looking for.
---@param lines string[] Array of lines from the buffer
---@param names string[] List of export names to look for
---@return table<string, number> Map of name -> line number (only includes found exports)
M.scan_all = function(lines, names)
  local results = {}
  -- Track which names we still need to find
  local remaining = {}
  for _, name in ipairs(names) do
    remaining[name] = true
  end

  for i, line in ipairs(lines) do
    -- Skip lines that don't start with export
    if line:match("^export%s") then
      for name, _ in pairs(remaining) do
        local found = false
        if name == "default" then
          found = M.line_exports_default(line)
        else
          found = M.line_exports(line, name)
        end
        if found then
          results[name] = i
          remaining[name] = nil
          break -- each line can only match one export
        end
      end
    end

    -- Stop early if we've found everything
    if next(remaining) == nil then
      break
    end
  end

  return results
end

return M
