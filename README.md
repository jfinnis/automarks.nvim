# automarks.nvim

Automatically sets buffer-local marks on well-known exports in your code. Open a file and jump straight to the function you care about.

**Status: Work in progress.**

## What it does

When you open a JS/TS file, automarks sets a mark on the default export so you can jump to it instantly. For files inside a `routes/` directory, it also marks common Remix/React Router exports:

**All JS/TS files:**

| Export | Mark |
|--------|------|
| `export default` | d |

**Route files only (path contains `/routes/`):**

| Export | Mark |
|--------|------|
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