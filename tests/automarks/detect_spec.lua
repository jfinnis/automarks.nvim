local detect = require("automarks.detect")

describe("detect", function()
  describe("is_route_file", function()
    it("returns true for a file inside a routes/ folder", function()
      assert.is_true(detect.is_route_file("/home/user/project/app/routes/my-route.tsx"))
    end)

    it("returns true for nested route files", function()
      assert.is_true(detect.is_route_file("/project/app/routes/dashboard/index.tsx"))
    end)

    it("returns false for non-route files", function()
      assert.is_false(detect.is_route_file("/project/app/components/Button.tsx"))
    end)

    it("returns false for files with 'routes' in the name but not as a folder", function()
      assert.is_false(detect.is_route_file("/project/app/routes.config.ts"))
    end)
  end)
end)
