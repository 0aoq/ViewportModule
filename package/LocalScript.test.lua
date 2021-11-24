--[[
StarterGui:
    >> ScreenGui:
        >>> ViewportFrame
        >>> LocalScript
]]

local Player = game:GetService("Players").LocalPlayer
local viewport = require(game.ReplicatedStorage.Viewport)

-- set up viewport
local frame = script.Parent.ViewportFrame
viewport.MatchCamera(frame)

-- create effect
repeat wait() until Player.Character

viewport.SearchObjects(workspace, frame, {}, function(folder, x)
    local red = Instance.new("Part")
    red.Parent = folder
    red.CFrame = x.CFrame
    red.BrickColor = BrickColor.new("Really red")
    red.Anchored = true
    red.CanCollide = false
    red.Material = Enum.Material.Neon
    red.Size = x.Size
    red.Transparency = 0.9
    
    if (red.Position ~= x.Position) then
        red.Position = x.Position
    end
end)