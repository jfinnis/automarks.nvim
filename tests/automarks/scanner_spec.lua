local scanner = require("automarks.scanner")

describe("scanner", function()
  describe("line_exports", function()
    it("matches export function loader(", function()
      assert.is_true(scanner.line_exports("export function loader() {", "loader"))
    end)

    it("matches export async function loader(", function()
      assert.is_true(scanner.line_exports("export async function loader({ request }: LoaderArgs) {", "loader"))
    end)

    it("matches export const loader =", function()
      assert.is_true(scanner.line_exports("export const loader = async () => {", "loader"))
    end)

    it("matches export let loader =", function()
      assert.is_true(scanner.line_exports("export let loader = function() {", "loader"))
    end)

    it("matches export with type annotation", function()
      assert.is_true(scanner.line_exports("export const loader: LoaderFunction = async () => {", "loader"))
    end)

    it("does NOT match commented out export", function()
      assert.is_false(scanner.line_exports("// export function loader() {", "loader"))
    end)

    it("does NOT match export function myCustomLoader", function()
      assert.is_false(scanner.line_exports("export function myCustomLoader() {", "loader"))
    end)

    it("does NOT match export function loaderUtils", function()
      assert.is_false(scanner.line_exports("export function loaderUtils() {", "loader"))
    end)

    it("does NOT match non-export lines with the identifier", function()
      assert.is_false(scanner.line_exports("const loader = something()", "loader"))
    end)

    it("does NOT match export of a different identifier", function()
      assert.is_false(scanner.line_exports("export function action() {", "loader"))
    end)
  end)

  describe("scan_all", function()
    it("finds all exports in a single pass", function()
      local lines = {
        "import { json } from '@remix-run/node';",
        "",
        "export async function loader({ request }) {",
        "  return json({});",
        "}",
        "",
        "export async function action({ request }) {",
        "  return null;",
        "}",
        "",
        "export default function MyRoute() {",
        "  return <div />;",
        "}",
      }
      local results = scanner.scan_all(lines, { "loader", "action", "default", "meta" })
      assert.equals(3, results.loader)
      assert.equals(7, results.action)
      assert.equals(11, results.default)
      assert.is_nil(results.meta)
    end)
  end)
end)
