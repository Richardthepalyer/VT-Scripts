--[[
    ╦  ╦╔╦╗  ╔═╗┌─┐┬─┐┬┌─┐┌┬┐┌─┐
    ╚╗╔╝ ║   ╚═╗│  ├┬┘│├─┘ │ └─┐
     ╚╝  ╩   ╚═╝└─┘┴└─┴┴   ┴ └─┘
    VT Scripts Studios - Classic Hub (No Key)
    Version: 1.5
    Features: Fly, Speed, Noclip
    Supports PC and Mobile
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Player Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Script Variables
local flyEnabled = false
local noclipEnabled = false
local flySpeed = 50
local originalWalkSpeed = 16
local flyConnection = nil
local noclipConnection = nil

-- VT Scripts Branding
local VTConfig = {
    BrandName = "VT SCRIPT HUB",
    Version = "v1.5",
    Discord = "discord.gg/XvT7ZKbcwy"
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VTScriptHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

--[[═══════════════════════════════════════════════════════════
    MAIN SCRIPT UI
═══════════════════════════════════════════════════════════]]--

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 380)
mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 100, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Title Text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ " .. VTConfig.BrandName
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 17
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -65)
contentFrame.Position = UDim2.new(0, 10, 0, 55)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Fly Toggle
local flyToggle = Instance.new("TextButton")
flyToggle.Name = "FlyToggle"
flyToggle.Size = UDim2.new(1, 0, 0, 45)
flyToggle.Position = UDim2.new(0, 0, 0, 0)
flyToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
flyToggle.BorderSizePixel = 0
flyToggle.Text = "✈ Fly: OFF"
flyToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
flyToggle.TextSize = 15
flyToggle.Font = Enum.Font.GothamBold
flyToggle.Parent = contentFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyToggle

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 60)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🚀 Fly Speed: 50"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = contentFrame

-- Speed Slider
local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Size = UDim2.new(1, 0, 0, 30)
speedSlider.Position = UDim2.new(0, 0, 0, 90)
speedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = contentFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = speedSlider

local speedFill = Instance.new("Frame")
speedFill.Name = "Fill"
speedFill.Size = UDim2.new(0.25, 0, 1, 0)
speedFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
speedFill.BorderSizePixel = 0
speedFill.Parent = speedSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 8)
fillCorner.Parent = speedFill

-- Noclip Toggle
local noclipToggle = Instance.new("TextButton")
noclipToggle.Name = "NoclipToggle"
noclipToggle.Size = UDim2.new(1, 0, 0, 45)
noclipToggle.Position = UDim2.new(0, 0, 0, 135)
noclipToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
noclipToggle.BorderSizePixel = 0
noclipToggle.Text = "👻 Noclip: OFF"
noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
noclipToggle.TextSize = 15
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.Parent = contentFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipToggle

-- Walk Speed Label
local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Size = UDim2.new(1, 0, 0, 25)
walkSpeedLabel.Position = UDim2.new(0, 0, 0, 195)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Text = "🏃 Walk Speed: 16"
walkSpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
walkSpeedLabel.TextSize = 14
walkSpeedLabel.Font = Enum.Font.Gotham
walkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedLabel.Parent = contentFrame

-- Walk Speed Slider
local walkSpeedSlider = Instance.new("Frame")
walkSpeedSlider.Name = "WalkSpeedSlider"
walkSpeedSlider.Size = UDim2.new(1, 0, 0, 30)
walkSpeedSlider.Position = UDim2.new(0, 0, 0, 225)
walkSpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
walkSpeedSlider.BorderSizePixel = 0
walkSpeedSlider.Parent = contentFrame

local walkSliderCorner = Instance.new("UICorner")
walkSliderCorner.CornerRadius = UDim.new(0, 8)
walkSliderCorner.Parent = walkSpeedSlider

local walkSpeedFill = Instance.new("Frame")
walkSpeedFill.Name = "Fill"
walkSpeedFill.Size = UDim2.new(0.16, 0, 1, 0)
walkSpeedFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
walkSpeedFill.BorderSizePixel = 0
walkSpeedFill.Parent = walkSpeedSlider

local walkFillCorner = Instance.new("UICorner")
walkFillCorner.CornerRadius = UDim.new(0, 8)
walkFillCorner.Parent = walkSpeedFill

-- Credits
local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, 0, 0, 20)
credits.Position = UDim2.new(0, 0, 1, -25)
credits.BackgroundTransparency = 1
credits.Text = "Made by VT Scripts Studios | " .. VTConfig.Version
credits.TextColor3 = Color3.fromRGB(150, 150, 150)
credits.TextSize = 11
credits.Font = Enum.Font.Gotham
credits.Parent = contentFrame

--[[═══════════════════════════════════════════════════════════
    SCRIPT FUNCTIONS
═══════════════════════════════════════════════════════════]]--

-- Fly Function
local function toggleFly()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "FlyGyro"
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.Parent = rootPart
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyEnabled then return end
            
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- PC Controls
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            -- Mobile Support
            if humanoid.MoveDirection.Magnitude > 0 then
                moveDirection = moveDirection + (camera.CFrame.LookVector * humanoid.MoveDirection.Z)
                moveDirection = moveDirection + (camera.CFrame.RightVector * humanoid.MoveDirection.X)
            end
            
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity.Velocity = moveDirection * flySpeed
            end
            
            if bodyGyro and bodyGyro.Parent then
                bodyGyro.CFrame = camera.CFrame
            end
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if rootPart:FindFirstChild("FlyVelocity") then
            rootPart.FlyVelocity:Destroy()
        end
        if rootPart:FindFirstChild("FlyGyro") then
            rootPart.FlyGyro:Destroy()
        end
    end
end

-- Noclip Function
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipEnabled then return end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

--[[═══════════════════════════════════════════════════════════
    UI INTERACTIONS
═══════════════════════════════════════════════════════════]]--

-- Fly Toggle
flyToggle.MouseButton1Click:Connect(function()
    toggleFly()
    if flyEnabled then
        flyToggle.Text = "✈ Fly: ON"
        flyToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        flyToggle.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
    else
        flyToggle.Text = "✈ Fly: OFF"
        flyToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        flyToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

-- Noclip Toggle
noclipToggle.MouseButton1Click:Connect(function()
    toggleNoclip()
    if noclipEnabled then
        noclipToggle.Text = "👻 Noclip: ON"
        noclipToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        noclipToggle.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
    else
        noclipToggle.Text = "👻 Noclip: OFF"
        noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        noclipToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

-- Speed Slider
local function updateSpeedSlider(input)
    local relativeX = math.clamp((input.Position.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
    flySpeed = math.floor(relativeX * 200)
    speedFill.Size = UDim2.new(relativeX, 0, 1, 0)
    speedLabel.Text = "🚀 Fly Speed: " .. flySpeed
end

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        updateSpeedSlider(input)
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                connection:Disconnect()
            end
        end)
    end
end)

speedSlider.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputState ~= Enum.UserInputState.End then
            updateSpeedSlider(input)
        end
    end
end)

-- Walk Speed Slider
local function updateWalkSpeedSlider(input)
    local relativeX = math.clamp((input.Position.X - walkSpeedSlider.AbsolutePosition.X) / walkSpeedSlider.AbsoluteSize.X, 0, 1)
    local newSpeed = math.floor(relativeX * 100)
    humanoid.WalkSpeed = newSpeed
    walkSpeedFill.Size = UDim2.new(relativeX, 0, 1, 0)
    walkSpeedLabel.Text = "🏃 Walk Speed: " .. newSpeed
end

walkSpeedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        updateWalkSpeedSlider(input)
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                connection:Disconnect()
            end
        end)
    end
end)

walkSpeedSlider.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputState ~= Enum.UserInputState.End then
            updateWalkSpeedSlider(input)
        end
    end
end)

-- Close Button
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Character Reset Handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset states
    if flyEnabled then
        flyEnabled = false
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        flyToggle.Text = "✈ Fly: OFF"
        flyToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        flyToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
    
    if noclipEnabled then
        noclipEnabled = false
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        noclipToggle.Text = "👻 Noclip: OFF"
        noclipToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        noclipToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

-- Mobile Toggle Button (for showing/hiding UI)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(1, -70, 0.5, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "⚡"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 30
toggleButton.Font = Enum.Font.GothamBold
toggleButton.ZIndex = 5
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 30)
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(80, 80, 200)
toggleStroke.Thickness = 3
toggleStroke.Parent = toggleButton

-- Make toggle button draggable
toggleButton.Active = true
toggleButton.Draggable = true

-- Toggle button click
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("VT SCRIPT HUB - LOADED")
print("Version: " .. VTConfig.Version)
print("NO KEY REQUIRED!")
print("VT Scripts Studios")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
