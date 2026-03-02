--[[
    ╔═╗┬  ┌─┐┌┐┌ ┌─┐  ╔╦╗┌─┐┌┐┌┬ ┬
    ║ ╦│  ├┤ │││ └─┐  ║║║├┤ ││││ │
    ╚═╝┴─┘└─┘┘└┘ └─┘  ╩ ╩└─┘┘└┘└─┘
    Powered by VT Scripts Studios
    Glen's Menu - Smart Lock-On System
    Version: 1.1 (Fixed No-Team Detection)
--]]

-- Services
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

-- VT Scripts Studios Branding Config
local VTConfig = {
    BrandName = "GLEN'S MENU",
    Subtitle = "VT Scripts Studios",
    Colors = {
        Primary = Color3.fromRGB(20, 20, 25),
        Accent = Color3.fromRGB(0, 170, 255),
        Success = Color3.fromRGB(0, 255, 100),
        Danger = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Lock-On System Variables
local lockOn = false
local target = nil

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GlensMenuGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Container Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainContainer"
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = VTConfig.Colors.Primary
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Header Bar
local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 50)
headerBar.BackgroundColor3 = VTConfig.Colors.Accent
headerBar.BorderSizePixel = 0
headerBar.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerBar

-- Fix bottom corners
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = VTConfig.Colors.Accent
headerFix.BorderSizePixel = 0
headerFix.Parent = headerBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -20, 0, 28)
titleText.Position = UDim2.new(0, 10, 0, 2)
titleText.BackgroundTransparency = 1
titleText.Text = VTConfig.BrandName
titleText.TextColor3 = VTConfig.Colors.Text
titleText.TextSize = 20
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = headerBar

-- Subtitle (VT Scripts)
local subtitleText = Instance.new("TextLabel")
subtitleText.Size = UDim2.new(1, -20, 0, 16)
subtitleText.Position = UDim2.new(0, 10, 0, 28)
subtitleText.BackgroundTransparency = 1
subtitleText.Text = "Powered by " .. VTConfig.Subtitle
subtitleText.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitleText.TextSize = 11
subtitleText.Font = Enum.Font.Gotham
subtitleText.TextXAlignment = Enum.TextXAlignment.Left
subtitleText.Parent = headerBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -43, 0, 7.5)
closeBtn.BackgroundColor3 = VTConfig.Colors.Danger
closeBtn.Text = "X"
closeBtn.TextColor3 = VTConfig.Colors.Text
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = headerBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Lock-On Button
local button = Instance.new("TextButton")
button.Name = "LockOnButton"
button.Size = UDim2.new(0, 240, 0, 60)
button.Position = UDim2.new(0, 20, 0, 70)
button.BackgroundColor3 = VTConfig.Colors.Accent
button.TextColor3 = VTConfig.Colors.Text
button.Text = "🎯 LOCK ON"
button.TextSize = 18
button.Font = Enum.Font.GothamBold
button.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 140)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = VTConfig.Colors.Success
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Lock-On Functions (FIXED: Works with or without teams)
local function isEnemy(otherPlayer)
    -- Get teams
    local myTeam = player.Team
    local otherTeam = otherPlayer.Team
    
    -- If EITHER player has no team, treat as enemy (lock onto anyone)
    if not myTeam or not otherTeam then
        return true
    end
    
    -- If both have teams, check if different teams
    return myTeam ~= otherTeam
end

local function findClosestEnemy()
    local closestDist = math.huge
    local closestTarget = nil
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        -- Skip self
        if otherPlayer ~= player and otherPlayer.Character and
            otherPlayer.Character:FindFirstChild("Humanoid") and 
            otherPlayer.Character.Humanoid.Health > 0 then
            
            -- Check if enemy (or if no teams, lock onto anyone)
            if isEnemy(otherPlayer) then
                local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                
                if hrp and myHrp then
                    local dist = (hrp.Position - myHrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestTarget = hrp
                    end
                end
            end
        end
    end
    
    return closestTarget
end

local function updateCamera()
    if lockOn and target and target.Parent and 
        target.Parent:FindFirstChild("Humanoid") and
        target.Parent.Humanoid.Health > 0 then
        local cameraPos = camera.CFrame.Position
        local targetPos = target.Position + Vector3.new(0, 2, 0)
        local newCFrame = CFrame.new(cameraPos, targetPos)
        camera.CFrame = newCFrame
    end
end

-- Lock-On Button Click Handler
button.MouseButton1Click:Connect(function()
    lockOn = not lockOn
    if lockOn then
        button.Text = "🔓 UNLOCK"
        button.BackgroundColor3 = VTConfig.Colors.Success
        target = findClosestEnemy()
        if target then
            local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
            statusLabel.Text = "Status: Locked onto " .. (targetPlayer and targetPlayer.Name or "Enemy")
            statusLabel.TextColor3 = VTConfig.Colors.Success
        else
            statusLabel.Text = "Status: No target found"
            statusLabel.TextColor3 = VTConfig.Colors.Danger
            lockOn = false
            button.Text = "🎯 LOCK ON"
            button.BackgroundColor3 = VTConfig.Colors.Accent
        end
    else
        button.Text = "🎯 LOCK ON"
        button.BackgroundColor3 = VTConfig.Colors.Accent
        target = nil
        statusLabel.Text = "Status: Ready"
        statusLabel.TextColor3 = VTConfig.Colors.Success
    end
end)

-- Auto-update target
spawn(function()
    while true do
        if lockOn then
            local newTarget = findClosestEnemy()
            if newTarget ~= target then
                target = newTarget
                if target then
                    local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
                    statusLabel.Text = "Status: Locked onto " .. (targetPlayer and targetPlayer.Name or "Enemy")
                else
                    statusLabel.Text = "Status: Target lost"
                    statusLabel.TextColor3 = VTConfig.Colors.Danger
                end
            end
        end
        wait(0.5)
    end
end)

-- Camera Lock Update
RunService.RenderStepped:Connect(function()
    if lockOn then
        updateCamera()
    end
end)

-- Dragging System for Main Frame
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

headerBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

headerBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Close Button with Warning
closeBtn.MouseButton1Click:Connect(function()
    -- Create warning popup
    local warningFrame = Instance.new("Frame")
    warningFrame.Size = UDim2.new(0, 260, 0, 140)
    warningFrame.Position = UDim2.new(0.5, -130, 0.5, -70)
    warningFrame.BackgroundColor3 = VTConfig.Colors.Primary
    warningFrame.BorderSizePixel = 2
    warningFrame.BorderColor3 = VTConfig.Colors.Danger
    warningFrame.Parent = screenGui
    
    local warnCorner = Instance.new("UICorner")
    warnCorner.CornerRadius = UDim.new(0, 10)
    warnCorner.Parent = warningFrame
    
    local warnText = Instance.new("TextLabel")
    warnText.Size = UDim2.new(1, -20, 0, 70)
    warnText.Position = UDim2.new(0, 10, 0, 10)
    warnText.BackgroundTransparency = 1
    warnText.Text = "⚠️ Close Glen's Menu?\n\nThis will disable lock-on."
    warnText.TextColor3 = VTConfig.Colors.Text
    warnText.TextSize = 14
    warnText.Font = Enum.Font.Gotham
    warnText.TextWrapped = true
    warnText.Parent = warningFrame
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 110, 0, 40)
    yesBtn.Position = UDim2.new(0, 15, 1, -50)
    yesBtn.BackgroundColor3 = VTConfig.Colors.Danger
    yesBtn.Text = "YES"
    yesBtn.TextColor3 = VTConfig.Colors.Text
    yesBtn.TextSize = 14
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Parent = warningFrame
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 110, 0, 40)
    noBtn.Position = UDim2.new(1, -125, 1, -50)
    noBtn.BackgroundColor3 = VTConfig.Colors.Success
    noBtn.Text = "NO"
    noBtn.TextColor3 = Color3.new(0, 0, 0)
    noBtn.TextSize = 14
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = warningFrame
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = noBtn
    
    yesBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        warningFrame:Destroy()
    end)
end)

-- Console Messages
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("GLEN'S MENU - LOADED")
print("Lock-On System: Active")
print("Works with AND without teams!")
print("Powered by: VT Scripts Studios")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
