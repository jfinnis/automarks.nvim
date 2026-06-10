# automarks.nvim

Automatically sets buffer-local marks on well-known exports in your code. Open a file and jump straight to the function you care about.

**Status: Work in progress.**

## What it does

When you open a JS/TS file, automarks scans for well-known exports and sets marks on them. Jump to any matched export with `'<mark>`.

| Export | Mark |
|--------|------|
| `export default` | d |
| `loader` | l |
| `action` | a |
| `meta` | m |
| `links` | c |


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