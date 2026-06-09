local detect = require("automarks.detect")
local scanner = require("automarks.scanner")

---@class Config
local config = {
  -- Map of export name -> mark letter
  -- "default" is a special case: matches "export default function"
  marks = {
    loader = "l",
    action = "a",
    default = "r",
    meta = "m",
    links = "c", -- "l" is taken, use "c" for (mostly css) links
  },
}

local M = {}

---@type Config
M.config = config

--- Set marks for all recognized exports in a buffer.
---@param buf number Buffer handle
M.set_marks = function(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- Collect the export names we're looking for
  local names = {}
  for name, _ in pairs(M.config.marks) do
    names[#names + 1] = name
  end

  -- Single pass through the file
  local found = scanner.scan_all(lines, names)

  -- Set marks for everything we found
  for name, lnum in pairs(found) do
    local mark = M.config.marks[name]
    vim.api.nvim_buf_set_mark(buf, mark, lnum, 0, {})
  end
end

---@param args Config?
M.setup = function(args)
  vim.notify("[automarks] setup loaded", vim.log.levels.INFO)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

  -- Create augroup with clear=true so re-sourcing doesn't duplicate
  local group = vim.api.nvim_create_augroup("AutoMarks", { clear = true })

  vim.api.nvim_create_autocmd("BufRead", {
    group = group,
    pattern = "*",
    callback = function(ev)
      if detect.is_route_file(ev.file) then
        M.set_marks(ev.buf)
      end
    end,
  })
end

return M
