# automarks.nvim

Automatically sets buffer-local marks on well-known exports in your code. Open a file and jump straight to the function you care about.

**Status: Work in progress.** Currently only supports Remix / React Router route files.

## What it does

When you open a file inside a `routes/` directory, automarks scans for common Remix exports and places marks so you can jump to them instantly:

| Export | Mark |
|--------|------|
| `loader` | l |
| `action` | a |
| `render` (default) | r |
| `meta` | m |
| `links` | c |
|--------|------|


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
