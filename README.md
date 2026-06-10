# automarks.nvim

Automatically sets buffer-local marks on well-known exports in your code. Open a file and jump straight to the function you care about.

**Status: Work in progress.**

## What it does

When you open a file, automarks scans for well-known patterns and sets marks on them. Jump to any matched location with `'<mark>`.

### JS/TS files (`*.ts`, `*.tsx`, `*.js`, `*.jsx`)

| Export | Mark |
|--------|------|
| `export default` | d |
| `loader` | l |
| `action` | a |
| `meta` | m |
| `links` | c |

### JSON files (`package.json`)

| Key | Mark |
|-----|------|
| `"dependencies"` | d |
| `"devDependencies"` | v |
| `"overrides"` | o |


## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "jfinnis/automarks.nvim",
  config = function()
    require("automarks").setup()
  end,
}
```