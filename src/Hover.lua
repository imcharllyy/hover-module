--!native
--[[
    Hover Module
    -------------
    Author: imcharlly
    Description:
        This module provides hover detection functionality for BasePart instances
        in a Roblox client environment. It allows developers to detect when the
        player's mouse enters or leaves a 3D part, and trigger custom behavior via
        events.

    Usage:
        local Hover = require(path_to_module)
        local hoverTracker = Hover.create(partInstance)

        hoverTracker.MouseEnter:Connect(function(position)
            -- Handle mouse entering the part (Vector2 position of mouse)
        end)

        hoverTracker.MouseLeave:Connect(function(position)
            -- Handle mouse leaving the part
        end)

        hoverTracker.OnDestroy:Connect(function()
            -- Handle cleanup logic
        end)

        -- When done:
        hoverTracker:Destroy()

    Notes:
        - Only works on the client side.
        - The given instance must be of type BasePart.
        - Uses RunService.RenderStepped to track the mouse each frame.
        
    Module Use : 
        - Signal (sleitnick)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Signal = require(script.Signal)
local Spawn = require(script.Spawn)

export type Connection = RBXScriptConnection

local Hover = {}
Hover.__index = Hover

function Hover.create(instance: Instance)
    if not instance:IsA("BasePart") then
        warn(`Error: The provided instance must be of type BasePart.`)
        return
    end    
    
    if not RunService:IsClient() then
        warn("Error: This module should only be used on the client side.")
        return
    end

    local self = setmetatable({
        _instance = instance,
        _isHovering = false,
        
        -- Events
        MouseEnter = Signal.new(),
        MouseLeave = Signal.new(),
        OnDestroy = Signal.new(),
        
        _Connection = nil :: Connection
        
    }, Hover)
    
    Spawn(function()
        self:_track()
    end)
    
    return self
end

function Hover:_track()
    local instance = self._instance
    local player = Players.LocalPlayer
    
    local lastTarget = nil

    self._Connection = RunService.RenderStepped:Connect(function(delta: number)
        local playerMouse = player:GetMouse()
        local target = playerMouse.Target

        if target == instance then
            self._isHovering = true
            self.MouseEnter:Fire()
            
        elseif target ~= instance and lastTarget == instance then
            if self._isHovering then
                self._isHovering = false
                self.MouseLeave:Fire()
            end
        end

        lastTarget = target
    end)
end

function Hover:Destroy()
    if self._Connection then
        self._Connection:Disconnect()
        self._Connection = nil
    end
    
    self.OnDestroy:Fire()
    setmetatable(self, nil)
end

return Hover
