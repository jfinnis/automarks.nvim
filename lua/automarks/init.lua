local detect = require("automarks.detect")

---@class Config
local config = {}

local M = {}

---@type Config
M.config = config

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
      -- ev.file is the full path of the file being read
      if detect.is_route_file(ev.file) then
        vim.notify("[automarks] detected route file: " .. ev.file, vim.log.levels.INFO)
      end
    end,
  })
end

return M
