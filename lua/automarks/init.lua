local scanner = require("automarks.scanner")

---@class Config
local config = {
  -- Marks set on any JS/TS file when the export is found
  marks = {
    default = "d",
    loader = "l",
    action = "a",
    meta = "m",
    links = "c",
  },
}

local M = {}

---@type Config
M.config = config

--- Set marks on a buffer for any configured exports that are found.
---@param buf number Buffer handle
M.set_marks = function(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local names = {}
  for name, _ in pairs(M.config.marks) do
    names[#names + 1] = name
  end

  local found = scanner.scan_all(lines, names)

  for name, lnum in pairs(found) do
    local mark = M.config.marks[name]
    vim.api.nvim_buf_set_mark(buf, mark, lnum, 0, {})
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
      M.set_marks(ev.buf)
    end,
  })
end

return M
