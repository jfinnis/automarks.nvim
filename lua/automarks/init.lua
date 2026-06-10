local detect = require("automarks.detect")
local scanner = require("automarks.scanner")

---@class Config
local config = {
  -- Marks set on any JS/TS file
  global_marks = {
    default = "d",
  },
  -- Marks only set on route files (detected by path)
  route_marks = {
    loader = "l",
    action = "a",
    meta = "m",
    links = "c",
  },
}

local M = {}

---@type Config
M.config = config

--- Set marks for the given name->letter map on a buffer.
---@param buf number Buffer handle
---@param lines string[] Buffer lines
---@param marks table<string, string> Map of export name -> mark letter
local function apply_marks(buf, lines, marks)
  local names = {}
  for name, _ in pairs(marks) do
    names[#names + 1] = name
  end

  local found = scanner.scan_all(lines, names)

  for name, lnum in pairs(found) do
    local mark = marks[name]
    vim.api.nvim_buf_set_mark(buf, mark, lnum, 0, {})
  end
end

--- Set marks on a buffer. Global marks are always set; route marks only on route files.
---@param buf number Buffer handle
---@param is_route boolean Whether this is a route file
M.set_marks = function(buf, is_route)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  apply_marks(buf, lines, M.config.global_marks)

  if is_route then
    apply_marks(buf, lines, M.config.route_marks)
  end
end

---@param args Config?
M.setup = function(args)
  vim.notify("[automarks] setup loaded", vim.log.levels.INFO)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

  local group = vim.api.nvim_create_augroup("AutoMarks", { clear = true })

  vim.api.nvim_create_autocmd("BufRead", {
    group = group,
    pattern = "*.ts,*.tsx,*.js,*.jsx",
    callback = function(ev)
      local is_route = detect.is_route_file(ev.file)
      M.set_marks(ev.buf, is_route)
    end,
  })
end

return M
