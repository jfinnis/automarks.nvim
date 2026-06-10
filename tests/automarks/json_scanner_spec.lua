local json_scanner = require("automarks.json_scanner")

describe("json_scanner", function()
  describe("scan_all", function()
    it("finds dependencies, devDependencies, and overrides", function()
      local lines = {
        '{',
        '  "name": "my-app",',
        '  "version": "1.0.0",',
        '  "dependencies": {',
        '    "react": "^18.0.0"',
        '  },',
        '  "devDependencies": {',
        '    "typescript": "^5.0.0"',
        '  },',
        '  "overrides": {',
        '    "react": "^18.2.0"',
        '  }',
        '}',
      }
      local results = json_scanner.scan_all(lines, { "dependencies", "devDependencies", "overrides" })
      assert.equals(4, results.dependencies)
      assert.equals(7, results.devDependencies)
      assert.equals(10, results.overrides)
    end)

    it("returns nil for keys not present", function()
      local lines = {
        '{',
        '  "name": "my-app"',
        '}',
      }
      local results = json_scanner.scan_all(lines, { "dependencies", "devDependencies" })
      assert.is_nil(results.dependencies)
      assert.is_nil(results.devDependencies)
    end)

    it("handles no leading whitespace", function()
      local lines = {
        '{',
        '"dependencies": {',
        '  "react": "^18.0.0"',
        '}',
        '}',
      }
      local results = json_scanner.scan_all(lines, { "dependencies" })
      assert.equals(2, results.dependencies)
    end)

    it("does not match a key that is a substring of the target", function()
      local lines = {
        '{',
        '  "devDependencies": {',
        '    "typescript": "^5.0.0"',
        '  }',
        '}',
      }
      local results = json_scanner.scan_all(lines, { "dependencies" })
      assert.is_nil(results.dependencies)
    end)
  end)
end)
