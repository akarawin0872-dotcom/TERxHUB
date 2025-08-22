local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer


local settings = {
    FOV = 200,
    Smoothness = 0.25,
    TeamCheck = true
}

local aiming = false


local circle = Drawing.new("Circle")
circle.Thickness = 1.5
circle.NumSides = 100
circle.Radius = settings.FOV
circle.Filled = false
circle.Transparency = 1
circle.Color = Color3.fromRGB(255, 230, 0)


local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,140,0,45)
ToggleBtn.Position = UDim2.new(0.05,0,0.85,0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextScaled = true
ToggleBtn.Text = "Aim: OFF"
ToggleBtn.MouseButton1Click:Connect(function()
    aiming = not aiming
    ToggleBtn.Text = aiming and "Aim: ON" or "Aim: OFF"
    ToggleBtn.BackgroundColor3 = aiming and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
end)


local function getTarget()
    local nearest,dist = nil,settings.FOV
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
            if not settings.TeamCheck or p.Team ~= LocalPlayer.Team then
                local pos,visible = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if visible then
                    local mag = (Vector2.new(pos.X,pos.Y)-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                    if mag < dist then
                        nearest,dist = p.Character.Head,mag
                    end
                end
            end
        end
    end
    return nearest
end


RunService.RenderStepped:Connect(function()
    circle.Position = UserInputService:GetMouseLocation()
    circle.Visible = aiming
    if aiming then
        local target = getTarget()
        if target then
            local aimPos = target.Position + Vector3.new(0,0.2,0)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, aimPos), settings.Smoothness)
        end
    end
end)
