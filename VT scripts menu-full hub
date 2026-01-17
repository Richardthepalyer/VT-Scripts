--[[
    ╦  ╦╔╦╗  ╔═╗┌─┐┬─┐┬┌─┐┌┬┐┌─┐  ╔╦╗┌─┐┌┐┌┬ ┬
    ╚╗╔╝ ║   ╚═╗│  ├┬┘│├─┘ │ └─┐  ║║║├┤ ││││ │
     ╚╝  ╩   ╚═╝└─┘┴└─┴┴   ┴ └─┘  ╩ ╩└─┘┘└┘└─┘
    VT Scripts Studios - Universal Script Hub
    Version: 1.0
    Creator: VT Scripts AI
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- VT Scripts Studios Configuration
local VTConfig = {
    BrandName = "VT SCRIPTS",
    Version = "v1.0",
    Colors = {
        Primary = Color3.fromRGB(0, 0, 0),
        Accent1 = Color3.fromRGB(0, 255, 0),
        Accent2 = Color3.fromRGB(255, 0, 0),
        Background = Color3.fromRGB(15, 15, 15),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Transparency = 0.15
}

-- Feature States
local Features = {
    ESP = false,
    Fly = false,
    Noclip = false,
    InfiniteJump = false,
    WalkSpeed = 16,
    JumpPower = 50,
    FOV = 70
}

-- ESP Storage
local ESPObjects = {}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VTScriptsMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = VTConfig.Colors.Background
MainFrame.BackgroundTransparency = VTConfig.Transparency
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- UI Corner for Main Frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundColor3 = VTConfig.Colors.Primary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

-- Logo Text
local LogoText = Instance.new("TextLabel")
LogoText.Name = "LogoText"
LogoText.Size = UDim2.new(0, 250, 0, 50)
LogoText.Position = UDim2.new(0, 15, 0, 5)
LogoText.BackgroundTransparency = 1
LogoText.Text = VTConfig.BrandName
LogoText.TextColor3 = VTConfig.Colors.Accent1
LogoText.TextSize = 28
LogoText.Font = Enum.Font.GothamBold
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = TopBar

-- Version Label
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 60, 0, 20)
VersionLabel.Position = UDim2.new(0, 15, 0, 35)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = VTConfig.Version
VersionLabel.TextColor3 = VTConfig.Colors.Accent2
VersionLabel.TextSize = 12
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Parent = TopBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -90, 0, 10)
MinimizeBtn.BackgroundColor3 = VTConfig.Colors.Accent1
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(0, 0, 0)
MinimizeBtn.TextSize = 24
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.BackgroundColor3 = VTConfig.Colors.Accent2
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -80)
ContentFrame.Position = UDim2.new(0, 10, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = VTConfig.Colors.Accent1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentFrame

-- Helper Functions
local function CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Name = name .. "Section"
    Section.Size = UDim2.new(1, 0, 0, 40)
    Section.BackgroundColor3 = VTConfig.Colors.Primary
    Section.BackgroundTransparency = 0.3
    Section.BorderSizePixel = 0
    Section.Parent = ContentFrame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "━━ " .. name .. " ━━"
    Label.TextColor3 = VTConfig.Colors.Accent1
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Section
    
    return Section
end

local function CreateToggle(name, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = name .. "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 50)
    Toggle.BackgroundColor3 = VTConfig.Colors.Primary
    Toggle.BackgroundTransparency = 0.5
    Toggle.BorderSizePixel = 0
    Toggle.Parent = ContentFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = VTConfig.Colors.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 80, 0, 35)
    Button.Position = UDim2.new(1, -95, 0.5, -17.5)
    Button.BackgroundColor3 = VTConfig.Colors.Accent2
    Button.Text = "OFF"
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = Toggle
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        Button.BackgroundColor3 = enabled and VTConfig.Colors.Accent1 or VTConfig.Colors.Accent2
        Button.Text = enabled and "ON" or "OFF"
        callback(enabled)
    end)
    
    return Toggle
end

local function CreateSlider(name, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = name .. "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 70)
    Slider.BackgroundColor3 = VTConfig.Colors.Primary
    Slider.BackgroundTransparency = 0.5
    Slider.BorderSizePixel = 0
    Slider.Parent = ContentFrame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = Slider
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 15, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = VTConfig.Colors.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 25)
    ValueLabel.Position = UDim2.new(1, -75, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = VTConfig.Colors.Accent1
    ValueLabel.TextSize = 14
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Slider
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -30, 0, 8)
    SliderBar.Position = UDim2.new(0, 15, 0, 45)
    SliderBar.BackgroundColor3 = VTConfig.Colors.Primary
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Slider
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = VTConfig.Colors.Accent1
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local dragging = false
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return Slider
end

-- ESP Function
local function CreateESP(plr)
    if plr == player then return end
    
    local function addESP(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end
        
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "VT_ESP"
        BillboardGui.Adornee = hrp
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Parent = hrp
        
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = plr.Name
        NameLabel.TextColor3 = VTConfig.Colors.Accent1
        NameLabel.TextSize = 14
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextStrokeTransparency = 0
        NameLabel.Parent = BillboardGui
        
        local DistanceLabel = Instance.new("TextLabel")
        DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.TextColor3 = VTConfig.Colors.Text
        DistanceLabel.TextSize = 12
        DistanceLabel.Font = Enum.Font.Gotham
        DistanceLabel.TextStrokeTransparency = 0
        DistanceLabel.Parent = BillboardGui
        
        RunService.RenderStepped:Connect(function()
            if Features.ESP and character and character:FindFirstChild("HumanoidRootPart") and hrp.Parent then
                local dist = (character.HumanoidRootPart.Position - hrp.Position).Magnitude
                DistanceLabel.Text = math.floor(dist) .. " studs"
            end
        end)
        
        table.insert(ESPObjects, BillboardGui)
    end
    
    if plr.Character then
        addESP(plr.Character)
    end
    plr.CharacterAdded:Connect(addESP)
end

local function RemoveAllESP()
    for _, esp in pairs(ESPObjects) do
        if esp then esp:Destroy() end
    end
    ESPObjects = {}
end

-- Build UI
CreateSection("PLAYER")

CreateToggle("ESP", function(enabled)
    Features.ESP = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            CreateESP(plr)
        end
        Players.PlayerAdded:Connect(function(plr)
            if Features.ESP then CreateESP(plr) end
        end)
    else
        RemoveAllESP()
    end
end)

CreateSection("MOVEMENT")

CreateToggle("Fly", function(enabled)
    Features.Fly = enabled
    -- Fly implementation (basic)
    if enabled then
        local BV = Instance.new("BodyVelocity")
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = character.HumanoidRootPart
        
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not Features.Fly then
                BV:Destroy()
                connection:Disconnect()
                return
            end
            
            local cam = workspace.CurrentCamera
            local move = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
            
            BV.Velocity = move * 50
        end)
    end
end)

CreateToggle("Noclip", function(enabled)
    Features.Noclip = enabled
    local connection
    connection = RunService.Stepped:Connect(function()
        if not Features.Noclip then
            connection:Disconnect()
            return
        end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end)

CreateToggle("Infinite Jump", function(enabled)
    Features.InfiniteJump = enabled
end)

UserInputService.JumpRequest:Connect(function()
    if Features.InfiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

CreateSlider("WalkSpeed", 16, 200, 16, function(value)
    Features.WalkSpeed = value
    humanoid.WalkSpeed = value
end)

CreateSlider("JumpPower", 50, 300, 50, function(value)
    Features.JumpPower = value
    humanoid.JumpPower = value
end)

CreateSection("CAMERA")

CreateSlider("FOV", 70, 120, 70, function(value)
    Features.FOV = value
    workspace.CurrentCamera.FieldOfView = value
end)

-- Dragging System
local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Minimize/Maximize
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ContentFrame.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 450, 0, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinimizeBtn.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 450, 0, 500), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        wait(0.3)
        ContentFrame.Visible = true
        MinimizeBtn.Text = "-"
    end
end)

-- Close with Warning
CloseBtn.MouseButton1Click:Connect(function()
    local warning = Instance.new("Frame")
    warning.Size = UDim2.new(0, 300, 0, 150)
    warning.Position = UDim2.new(0.5, -150, 0.5, -75)
    warning.BackgroundColor3 = VTConfig.Colors.Background
    warning.BorderSizePixel = 2
    warning.BorderColor3 = VTConfig.Colors.Accent2
    warning.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = warning
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 0, 80)
    text.Position = UDim2.new(0, 10, 0, 10)
    text.BackgroundTransparency = 1
    text.Text = "Close VT Scripts Menu?"
    text.TextColor3 = VTConfig.Colors.Text
    text.TextSize = 16
    text.Font = Enum.Font.GothamBold
    text.TextWrapped = true
    text.Parent = warning
    
    local yes = Instance.new("TextButton")
    yes.Size = UDim2.new(0, 120, 0, 40)
    yes.Position = UDim2.new(0, 20, 1, -50)
    yes.BackgroundColor3 = VTConfig.Colors.Accent2
    yes.Text = "YES"
    yes.TextColor3 = Color3.new(1, 1, 1)
    yes.TextSize = 14
    yes.Font = Enum.Font.GothamBold
    yes.Parent = warning
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 6)
    yesCorner.Parent = yes
    
    local no = Instance.new("TextButton")
    no.Size = UDim2.new(0, 120, 0, 40)
    no.Position = UDim2.new(1, -140, 1, -50)
    no.BackgroundColor3 = VTConfig.Colors.Accent1
    no.Text = "NO"
    no.TextColor3 = Color3.new(0, 0, 0)
    no.TextSize = 14
    no.Font = Enum.Font.GothamBold
    no.Parent = warning
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 6)
    noCorner.Parent = no
    
    yes.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    no.MouseButton1Click:Connect(function()
        warning:Destroy()
    end)
end)

-- Parent to PlayerGui
ScreenGui.Parent = player:WaitForChild("PlayerGui")

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("VT SCRIPTS MENU LOADED")
print("Version: " .. VTConfig.Version)
print("Created by: VT Scripts Studios")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
