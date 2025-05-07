# Hover Module for Roblox

A lightweight module to detect mouse hovering over `BasePart` instances on the client side.

## Features
- Detect when the mouse enters and leaves a 3D part
- Custom events for `MouseEnter` and `MouseLeave`
- Clean API for connecting and destroying

- ## Dependencies

This module uses [Signal]([https://github.com/Sleitnick/RbxUtil/blob/main/modules/Signal.lua](https://github.com/Sleitnick/RbxUtil/tree/main/modules/signal)) by [Sleitnick](https://github.com/Sleitnick), a lightweight and efficient event system for Roblox.

The `Signal.lua` file included in this repository is a direct copy of that module.

## Installation

1. Download the `Hover.lua`, `Signal.lua` and `Spawn.lua` files from the `src` folder.
2. Place them in your Roblox project.
3. Use it like this:

```lua
local Hover = require(path.to.Hover)
local tracker = Hover.create(workspace.Part)

tracker.MouseEnter:Connect(function()
    print("Mouse entered at")
end)

tracker:Destroy()
```
