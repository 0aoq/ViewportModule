function Crawl(_Instance, viewport: ViewportFrame, blacklist: { Instance }, doWithPart)
    if (not table.find(blacklist, _Instance)) then 
        for i,x: any in pairs(_Instance:GetChildren()) do
            if (not x:GetAttribute("ViewportName")) then
                -- fix the system only rendering certain objects if multiple instances have the same name
                x:SetAttribute("ViewportName", x:GetFullName() .. "{IN_ORDER}" .. i .. math.random(0, 23423234))
            end
            
            if (not x:IsA("LocalScript") or not x:IsA("Script")) then 
                if (x:IsA("Part") or x:IsA("MeshPart")) then
                    local folder = viewport:FindFirstChild(x:GetAttribute("ViewportName"))
                    if (folder) then folder:Destroy(); end
                    folder = Instance.new("Folder", viewport); folder.Name = x:GetAttribute("ViewportName")
                    doWithPart(folder, x); Crawl(x, viewport, blacklist, doWithPart)
                elseif (x:IsA("Model")) then
                    -- still search for more items, but don't run doWithPart
                    Crawl(x, viewport, blacklist, doWithPart)
                end
            end
        end
    end
end

return {
    SearchObjects = function(object, viewport: ViewportFrame, blacklist: { Instance }, doWithPart: any)
        -- viewport cleanup
        table.insert(blacklist, viewport)
        task.spawn(function()
            while (true) do
                wait(); Crawl(object, viewport, blacklist, doWithPart)
            end
        end)
    end,
    MatchCamera = function(viewport: ViewportFrame)
        local viewportCamera = Instance.new("Camera", viewport)
        viewport.CurrentCamera = viewportCamera

        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            while (true) do
                -- match the normal camera position
                wait(0); viewportCamera.CFrame = workspace.CurrentCamera.CFrame
                -- weird looking below:
                -- TweenService:Create(viewportCamera, TweenInfo.new(0.15), { CFrame = workspace.CurrentCamera.CFrame }):Play()
            end
        end)
    end,
}