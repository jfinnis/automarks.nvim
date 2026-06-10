local export_scanner = require("automarks.scanner")
local json_scanner = require("automarks.json_scanner")

---@class FileTypeEntry
---@field pattern string Autocmd file pattern
---@field scanner table Scanner module (must have scan_all(lines, names))
---@field marks table<string, string> Map of name -> mark letter

---@class Config
---@field filetypes FileTypeEntry[]

---@type Config
local config = {
  filetypes = {
    {
      pattern = "*.ts,*.tsx,*.js,*.jsx",
      scanner = export_scanner,
      marks = {
        default = "d",
        loader = "l",
        action = "a",
        meta = "m",
        links = "c",
      },
    },
    {
      pattern = "package.json",
      scanner = json_scanner,
      marks = {
        dependencies = "d",
        devDependencies = "v",
        overrides = "o",
      },
    },
  },
}

local M = {}

---@type Config
M.config = config

--- Set marks on a buffer using the given scanner and mark definitions.
---@param buf number Buffer handle
---@param scanner table Scanner module with scan_all(lines, names)
---@param marks table<string, string> Map of name -> mark letter
M.set_marks = function(buf, scanner, marks)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

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

---@param args Config?
M.setup = function(args)
  vim.notify("[automarks] setup loaded", vim.log.levels.INFO)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

  local group = vim.api.nvim_create_augroup("AutoMarks", { clear = true })

  for _, ft in ipairs(M.config.filetypes) do
    vim.api.nvim_create_autocmd("BufRead", {
      group = group,
      pattern = ft.pattern,
      callback = function(ev)
        M.set_marks(ev.buf, ft.scanner, ft.marks)
      end,
    })
  end
end

return M
