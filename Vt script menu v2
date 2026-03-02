-- ============================================================
--  VT Script Hub | LocalScript
--  Place in: StarterPlayerScripts
--  Author:   VT Script Hub
-- ============================================================

-- ──────────────────────────────────────────────────────────
-- SERVICES
-- ──────────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local StarterGui       = game:GetService("StarterGui")

-- ──────────────────────────────────────────────────────────
-- PLAYER / CHARACTER REFS
-- ──────────────────────────────────────────────────────────
local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")
local Camera       = workspace.CurrentCamera

local function getChar()   return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ──────────────────────────────────────────────────────────
-- STATE
-- ──────────────────────────────────────────────────────────
local state = {
    floatEnabled   = false,
    flyEnabled     = false,
    noclipEnabled  = false,
    walkSpeed      = 16,
}

-- Runtime connections / objects (cleared on respawn)
local connections  = {}
local flyBodyVel   = nil
local floatBodyPos = nil

-- ──────────────────────────────────────────────────────────
-- COLOUR PALETTE
-- ──────────────────────────────────────────────────────────
local C = {
    BG          = Color3.fromRGB(15,  15,  20),
    Surface     = Color3.fromRGB(22,  22,  30),
    Card        = Color3.fromRGB(30,  30,  42),
    Accent      = Color3.fromRGB(99,  102, 241),  -- indigo
    AccentHover = Color3.fromRGB(129, 132, 250),
    AccentOn    = Color3.fromRGB(52,  211, 153),  -- emerald when ON
    Text        = Color3.fromRGB(240, 240, 255),
    SubText     = Color3.fromRGB(140, 140, 170),
    Stroke      = Color3.fromRGB(50,  50,  70),
    Red         = Color3.fromRGB(239, 68,  68),
    Transparent = Color3.fromRGB(0,   0,   0),
}

-- ──────────────────────────────────────────────────────────
-- UTILITY HELPERS
-- ──────────────────────────────────────────────────────────
local function tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir   = dir   or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(t or 0.2, style, dir), props):Play()
end

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color     = color or C.Stroke
    s.Thickness = thickness or 1.5
    s.Parent    = parent
    return s
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.Text              = text
    l.TextSize          = size  or 14
    l.TextColor3        = color or C.Text
    l.Font              = font  or Enum.Font.GothamBold
    l.BackgroundTransparency = 1
    l.Size              = UDim2.new(1, 0, 0, size and size + 6 or 20)
    l.TextXAlignment    = Enum.TextXAlignment.Left
    l.Parent            = parent
    return l
end

-- ──────────────────────────────────────────────────────────
-- DRAG LOGIC
-- ──────────────────────────────────────────────────────────
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            mousePos  = input.Position
            framePos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ──────────────────────────────────────────────────────────
-- BUTTON FACTORY
-- ──────────────────────────────────────────────────────────
local function makeButton(parent, text, onClick)
    local btn = Instance.new("TextButton")
    btn.Text              = text
    btn.Font              = Enum.Font.GothamBold
    btn.TextSize          = 14
    btn.TextColor3        = C.Text
    btn.BackgroundColor3  = C.Accent
    btn.Size              = UDim2.new(1, 0, 0, 38)
    btn.AutoButtonColor   = false
    btn.Parent            = parent
    corner(btn, 8)
    stroke(btn, C.Stroke, 1)

    -- Hover animations (PC only)
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = C.AccentHover, Size = UDim2.new(1, 0, 0, 40)}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = C.Accent, Size = UDim2.new(1, 0, 0, 38)}, 0.15)
    end)
    btn.MouseButton1Click:Connect(onClick)

    return btn
end

-- Toggle button factory (returns button + setState function)
local function makeToggle(parent, text, onToggle)
    local isOn = false

    local btn = Instance.new("TextButton")
    btn.Text             = "⬜  " .. text
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 13
    btn.TextColor3       = C.Text
    btn.BackgroundColor3 = C.Card
    btn.Size             = UDim2.new(1, 0, 0, 40)
    btn.AutoButtonColor  = false
    btn.TextXAlignment   = Enum.TextXAlignment.Left
    btn.Parent           = parent
    corner(btn, 8)
    stroke(btn, C.Stroke, 1)

    -- inner padding
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.Parent = btn

    local function setVisual(on)
        if on then
            tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 50, 38)}, 0.2)
            btn.Text = "✅  " .. text
        else
            tween(btn, {BackgroundColor3 = C.Card}, 0.2)
            btn.Text = "⬜  " .. text
        end
    end

    btn.MouseEnter:Connect(function()
        tween(btn, {Size = UDim2.new(1, 0, 0, 42)}, 0.12)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {Size = UDim2.new(1, 0, 0, 40)}, 0.12)
    end)

    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        setVisual(isOn)
        onToggle(isOn)
    end)

    local function setState(val)
        isOn = val
        setVisual(isOn)
    end

    return btn, setState
end

-- ──────────────────────────────────────────────────────────
-- SCROLL LIST FRAME HELPER
-- ──────────────────────────────────────────────────────────
local function makeList(parent, padding)
    local list = Instance.new("UIListLayout")
    list.Padding         = UDim.new(0, padding or 8)
    list.SortOrder       = Enum.SortOrder.LayoutOrder
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.Parent          = parent
    return list
end

-- ──────────────────────────────────────────────────────────
-- SCREENGUI ROOT
-- ──────────────────────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name                  = "VTScriptHub"
ScreenGui.ResetOnSpawn          = false
ScreenGui.ZIndexBehavior        = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset        = true
ScreenGui.Parent                = PlayerGui

-- ──────────────────────────────────────────────────────────
-- WATERMARK (top-right, always visible)
-- ──────────────────────────────────────────────────────────
local WatermarkFrame = Instance.new("Frame")
WatermarkFrame.Name             = "Watermark"
WatermarkFrame.Size             = UDim2.new(0, 190, 0, 32)
WatermarkFrame.Position         = UDim2.new(1, -200, 0, 10)
WatermarkFrame.BackgroundColor3 = C.Surface
WatermarkFrame.ZIndex           = 10
WatermarkFrame.Parent           = ScreenGui
corner(WatermarkFrame, 8)
stroke(WatermarkFrame, C.Accent, 1.5)

local WatermarkLabel = Instance.new("TextLabel")
WatermarkLabel.Text              = "VT Script  |  Local Client"
WatermarkLabel.Font              = Enum.Font.GothamBold
WatermarkLabel.TextSize          = 13
WatermarkLabel.TextColor3        = C.Text
WatermarkLabel.BackgroundTransparency = 1
WatermarkLabel.Size              = UDim2.new(1, 0, 1, 0)
WatermarkLabel.ZIndex            = 11
WatermarkLabel.Parent            = WatermarkFrame

-- Pulsing accent dot
local Dot = Instance.new("Frame")
Dot.Size              = UDim2.new(0, 7, 0, 7)
Dot.Position          = UDim2.new(0, 8, 0.5, -3)
Dot.BackgroundColor3  = C.AccentOn
Dot.ZIndex            = 12
Dot.Parent            = WatermarkFrame
corner(Dot, 50)

-- Dot pulse tween loop
local function pulseDot()
    tween(Dot, {BackgroundTransparency = 0.7}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    task.delay(0.8, function()
        tween(Dot, {BackgroundTransparency = 0}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.delay(0.8, pulseDot)
    end)
end
pulseDot()

-- ──────────────────────────────────────────────────────────
-- MAIN MENU FRAME
-- ──────────────────────────────────────────────────────────
local MainFrame = Instance.new("Frame")
MainFrame.Name             = "MainMenu"
MainFrame.Size             = UDim2.new(0, 300, 0, 220)
MainFrame.Position         = UDim2.new(0.5, -150, 0.5, -110)
MainFrame.BackgroundColor3 = C.BG
MainFrame.BackgroundTransparency = 1   -- start invisible for tween-in
MainFrame.Parent           = ScreenGui
corner(MainFrame, 14)
stroke(MainFrame, C.Accent, 1.5)

-- Inner shadow / gradient overlay
local Gradient = Instance.new("UIGradient")
Gradient.Color    = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20)),
}
Gradient.Rotation = 135
Gradient.Parent   = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = C.Surface
TitleBar.Parent           = MainFrame
corner(TitleBar, 14)

-- Square off bottom corners of title bar
local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size              = UDim2.new(1, 0, 0.5, 0)
TitleBarFix.Position          = UDim2.new(0, 0, 0.5, 0)
TitleBarFix.BackgroundColor3  = C.Surface
TitleBarFix.BorderSizePixel   = 0
TitleBarFix.Parent            = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text              = "⚡  VT Script Hub"
TitleLabel.Font              = Enum.Font.GothamBold
TitleLabel.TextSize          = 18
TitleLabel.TextColor3        = C.Text
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size              = UDim2.new(1, -10, 1, 0)
TitleLabel.Position          = UDim2.new(0, 10, 0, 0)
TitleLabel.TextXAlignment    = Enum.TextXAlignment.Left
TitleLabel.Parent            = TitleBar

-- Close / minimise button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text             = "✕"
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.TextSize         = 14
CloseBtn.TextColor3       = C.SubText
CloseBtn.BackgroundColor3 = C.Card
CloseBtn.Size             = UDim2.new(0, 26, 0, 26)
CloseBtn.Position         = UDim2.new(1, -34, 0.5, -13)
CloseBtn.AutoButtonColor  = false
CloseBtn.Parent           = TitleBar
corner(CloseBtn, 6)

CloseBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, {BackgroundTransparency = 1, Size = UDim2.new(0, 270, 0, 198)}, 0.25)
    task.delay(0.25, function() MainFrame.Visible = false end)
end)

-- Body padding frame
local Body = Instance.new("Frame")
Body.Name             = "Body"
Body.Size             = UDim2.new(1, -24, 1, -60)
Body.Position         = UDim2.new(0, 12, 0, 52)
Body.BackgroundTransparency = 1
Body.Parent           = MainFrame

makeList(Body, 10)

-- Type TextBox
local TextBoxWrap = Instance.new("Frame")
TextBoxWrap.Size             = UDim2.new(1, 0, 0, 38)
TextBoxWrap.BackgroundColor3 = C.Card
TextBoxWrap.Parent           = Body
corner(TextBoxWrap, 8)
stroke(TextBoxWrap, C.Stroke, 1)

local TypeBox = Instance.new("TextBox")
TypeBox.PlaceholderText      = "Type something…"
TypeBox.PlaceholderColor3    = C.SubText
TypeBox.Text                 = ""
TypeBox.Font                 = Enum.Font.Gotham
TypeBox.TextSize             = 14
TypeBox.TextColor3           = C.Text
TypeBox.BackgroundTransparency = 1
TypeBox.Size                 = UDim2.new(1, -16, 1, 0)
TypeBox.Position             = UDim2.new(0, 8, 0, 0)
TypeBox.TextXAlignment       = Enum.TextXAlignment.Left
TypeBox.ClearTextOnFocus     = false
TypeBox.Parent               = TextBoxWrap

-- VT Script button (opens submenu)
local VTBtn = makeButton(Body, "⚙  VT Script", function() end)   -- wired below

-- Make main menu draggable by its title bar
makeDraggable(MainFrame, TitleBar)

-- Tween in on start
MainFrame.Visible = true
tween(MainFrame, {BackgroundTransparency = 0, Size = UDim2.new(0, 300, 0, 220)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- ──────────────────────────────────────────────────────────
-- SUB MENU
-- ──────────────────────────────────────────────────────────
local SubFrame = Instance.new("Frame")
SubFrame.Name             = "SubMenu"
SubFrame.Size             = UDim2.new(0, 280, 0, 330)
SubFrame.Position         = UDim2.new(0.5, -340, 0.5, -165)
SubFrame.BackgroundColor3 = C.BG
SubFrame.Visible          = false
SubFrame.Parent           = ScreenGui
corner(SubFrame, 14)
stroke(SubFrame, C.Accent, 1.5)

local SubGradient = Instance.new("UIGradient")
SubGradient.Color    = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 44)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 22)),
}
SubGradient.Rotation = 135
SubGradient.Parent   = SubFrame

-- Sub title bar
local SubTitleBar = Instance.new("Frame")
SubTitleBar.Name             = "TitleBar"
SubTitleBar.Size             = UDim2.new(1, 0, 0, 46)
SubTitleBar.BackgroundColor3 = C.Surface
SubTitleBar.Parent           = SubFrame
corner(SubTitleBar, 14)

local SubTitleFix = Instance.new("Frame")
SubTitleFix.Size             = UDim2.new(1, 0, 0.5, 0)
SubTitleFix.Position         = UDim2.new(0, 0, 0.5, 0)
SubTitleFix.BackgroundColor3 = C.Surface
SubTitleFix.BorderSizePixel  = 0
SubTitleFix.Parent           = SubTitleBar

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Text              = "🛠  Features"
SubTitleLabel.Font              = Enum.Font.GothamBold
SubTitleLabel.TextSize          = 16
SubTitleLabel.TextColor3        = C.Text
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Size              = UDim2.new(1, -10, 1, 0)
SubTitleLabel.Position          = UDim2.new(0, 10, 0, 0)
SubTitleLabel.TextXAlignment    = Enum.TextXAlignment.Left
SubTitleLabel.Parent            = SubTitleBar

local SubCloseBtn = Instance.new("TextButton")
SubCloseBtn.Text             = "✕"
SubCloseBtn.Font             = Enum.Font.GothamBold
SubCloseBtn.TextSize         = 14
SubCloseBtn.TextColor3       = C.SubText
SubCloseBtn.BackgroundColor3 = C.Card
SubCloseBtn.Size             = UDim2.new(0, 26, 0, 26)
SubCloseBtn.Position         = UDim2.new(1, -34, 0.5, -13)
SubCloseBtn.AutoButtonColor  = false
SubCloseBtn.Parent           = SubTitleBar
corner(SubCloseBtn, 6)

SubCloseBtn.MouseButton1Click:Connect(function()
    tween(SubFrame, {Size = UDim2.new(0, 250, 0, 297)}, 0.2)
    task.delay(0.2, function()
        SubFrame.Visible = false
        SubFrame.Size    = UDim2.new(0, 280, 0, 330)
    end)
end)

makeDraggable(SubFrame, SubTitleBar)

-- Sub body
local SubBody = Instance.new("Frame")
SubBody.Name             = "SubBody"
SubBody.Size             = UDim2.new(1, -24, 1, -58)
SubBody.Position         = UDim2.new(0, 12, 0, 52)
SubBody.BackgroundTransparency = 1
SubBody.Parent           = SubFrame

makeList(SubBody, 8)

-- VT Script button wires up here
VTBtn.MouseButton1Click:Connect(function()
    SubFrame.Visible = true
    SubFrame.Size    = UDim2.new(0, 250, 0, 297)
    tween(SubFrame, {Size = UDim2.new(0, 280, 0, 330)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- ──────────────────────────────────────────────────────────
-- FEATURE IMPLEMENTATIONS
-- ──────────────────────────────────────────────────────────

-- ── FLOAT ────────────────────────────────────────────────
local function enableFloat()
    local hrp = getHRP()
    if not hrp then return end

    -- Remove existing
    local old = hrp:FindFirstChild("VT_FloatPos")
    if old then old:Destroy() end

    local bp = Instance.new("BodyPosition")
    bp.Name          = "VT_FloatPos"
    bp.MaxForce      = Vector3.new(0, 4e4, 0)
    bp.D             = 500
    bp.P             = 10000
    bp.Position      = hrp.Position + Vector3.new(0, 5, 0)
    bp.Parent        = hrp
    floatBodyPos     = bp
end

local function disableFloat()
    local hrp = getHRP()
    if hrp then
        local bp = hrp:FindFirstChild("VT_FloatPos")
        if bp then bp:Destroy() end
    end
    floatBodyPos = nil
end

-- ── FLY ─────────────────────────────────────────────────
local FLY_SPEED = 50   -- adjusted by speed slider too

local function enableFly()
    local hrp = getHRP()
    local hum = getHum()
    if not hrp or not hum then return end

    -- Remove existing velocity
    local old = hrp:FindFirstChild("VT_FlyVel")
    if old then old:Destroy() end

    hum.PlatformStand = true

    local bv = Instance.new("BodyVelocity")
    bv.Name     = "VT_FlyVel"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.zero
    bv.Parent   = hrp
    flyBodyVel  = bv

    -- BodyGyro to keep upright
    local old2 = hrp:FindFirstChild("VT_FlyGyro")
    if old2 then old2:Destroy() end
    local bg = Instance.new("BodyGyro")
    bg.Name      = "VT_FlyGyro"
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.D         = 100
    bg.CFrame    = hrp.CFrame
    bg.Parent    = hrp

    -- Movement loop
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not state.flyEnabled then
            conn:Disconnect()
            return
        end
        hrp = getHRP()
        if not hrp then conn:Disconnect() return end

        local bvel = hrp:FindFirstChild("VT_FlyVel")
        local bgyro = hrp:FindFirstChild("VT_FlyGyro")
        if not bvel or not bgyro then conn:Disconnect() return end

        local speed = state.walkSpeed * 2  -- fly is faster than walk
        local camCF = Camera.CFrame
        local dir   = Vector3.zero

        -- PC input
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space)  then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

        -- Mobile joystick (Thumbstick1)
        local thumb = UserInputService:GetNavigationGamepads()
        local mobileState = UserInputService:GetKeysPressed()

        -- Try reading mobile thumb state via touch/joystick
        local thumbVec = Vector2.zero
        for _, gs in ipairs(UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)) do
            if gs.KeyCode == Enum.KeyCode.Thumbstick1 then
                thumbVec = gs.Position
            end
        end

        if thumbVec.Magnitude > 0.1 then
            local flatLook  = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
            local flatRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z).Unit
            dir = dir + flatLook * thumbVec.Y + flatRight * thumbVec.X
        end

        -- Read on-screen joystick via AnalogMovement (Roblox TouchEnabled)
        -- Fallback: check PlayerModule joystick if accessible (best effort)
        if UserInputService.TouchEnabled then
            -- use the PlayerModule's MoveVector when available
            local pm = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then
                local controls = require(pm):GetControls()
                if controls and controls.GetMoveVector then
                    local mv = controls:GetMoveVector()
                    if mv and mv.Magnitude > 0.1 then
                        local flatLook  = Vector3.new(camCF.LookVector.X,  0, camCF.LookVector.Z).Unit
                        local flatRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z).Unit
                        dir = dir + flatLook * mv.Z + flatRight * mv.X
                    end
                end
            end
        end

        if dir.Magnitude > 1 then dir = dir.Unit end
        bvel.Velocity = dir * speed
        bgyro.CFrame  = CFrame.new(Vector3.zero, camCF.LookVector)
                          * CFrame.Angles(0, 0, 0)

        -- Keep gyro updated
        connections["flyGyro"] = conn
    end)
    connections["fly"] = conn
end

local function disableFly()
    if connections["fly"] then connections["fly"]:Disconnect() end
    local hrp = getHRP()
    if hrp then
        local bv = hrp:FindFirstChild("VT_FlyVel")
        if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("VT_FlyGyro")
        if bg then bg:Destroy() end
    end
    flyBodyVel = nil
    local hum = getHum()
    if hum then hum.PlatformStand = false end
end

-- ── NOCLIP ───────────────────────────────────────────────
local function enableNoclip()
    local conn = RunService.Stepped:Connect(function()
        if not state.noclipEnabled then return end
        local char = getChar()
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
    connections["noclip"] = conn
end

local function disableNoclip()
    if connections["noclip"] then
        connections["noclip"]:Disconnect()
        connections["noclip"] = nil
    end
    local char = getChar()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ──────────────────────────────────────────────────────────
-- TOGGLE BUTTONS IN SUBMENU
-- ──────────────────────────────────────────────────────────

-- Float toggle
local _, setFloatState = makeToggle(SubBody, "Float", function(on)
    state.floatEnabled = on
    if on then enableFloat() else disableFloat() end
end)

-- Fly toggle
local _, setFlyState = makeToggle(SubBody, "Fly  (WASD / Joystick)", function(on)
    state.flyEnabled = on
    if on then enableFly() else disableFly() end
end)

-- ── SPEED SECTION ────────────────────────────────────────
local SpeedSection = Instance.new("Frame")
SpeedSection.Size             = UDim2.new(1, 0, 0, 72)
SpeedSection.BackgroundColor3 = C.Card
SpeedSection.Parent           = SubBody
corner(SpeedSection, 8)
stroke(SpeedSection, C.Stroke, 1)

local SpeedPad = Instance.new("UIPadding")
SpeedPad.PaddingLeft   = UDim.new(0, 12)
SpeedPad.PaddingRight  = UDim.new(0, 12)
SpeedPad.PaddingTop    = UDim.new(0, 8)
SpeedPad.Parent        = SpeedSection

local SpeedTitleRow = Instance.new("Frame")
SpeedTitleRow.Size             = UDim2.new(1, 0, 0, 22)
SpeedTitleRow.BackgroundTransparency = 1
SpeedTitleRow.Parent           = SpeedSection

local SpeedLbl = label(SpeedTitleRow, "🏃 Walk Speed", 13, C.SubText)
SpeedLbl.Size = UDim2.new(0.6, 0, 1, 0)

local SpeedValueLbl = Instance.new("TextLabel")
SpeedValueLbl.Text              = "16"
SpeedValueLbl.Font              = Enum.Font.GothamBold
SpeedValueLbl.TextSize          = 13
SpeedValueLbl.TextColor3        = C.AccentOn
SpeedValueLbl.BackgroundTransparency = 1
SpeedValueLbl.Size              = UDim2.new(0.4, 0, 1, 0)
SpeedValueLbl.Position          = UDim2.new(0.6, 0, 0, 0)
SpeedValueLbl.TextXAlignment    = Enum.TextXAlignment.Right
SpeedValueLbl.Parent            = SpeedTitleRow

-- Slider track
local SliderTrack = Instance.new("Frame")
SliderTrack.Size             = UDim2.new(1, 0, 0, 10)
SliderTrack.Position         = UDim2.new(0, 0, 0, 36)
SliderTrack.BackgroundColor3 = C.BG
SliderTrack.Parent           = SpeedSection
corner(SliderTrack, 5)

local SliderFill = Instance.new("Frame")
SliderFill.Size             = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = C.Accent
SliderFill.Parent           = SliderTrack
corner(SliderFill, 5)

local SliderKnob = Instance.new("Frame")
SliderKnob.Size             = UDim2.new(0, 18, 0, 18)
SliderKnob.Position         = UDim2.new(0, -9, 0.5, -9)
SliderKnob.BackgroundColor3 = C.Text
SliderKnob.Parent           = SliderFill
corner(SliderKnob, 9)
stroke(SliderKnob, C.Accent, 2)

-- Slider TextBox (manual entry)
local SpeedInput = Instance.new("TextBox")
SpeedInput.Text              = "16"
SpeedInput.Font              = Enum.Font.Gotham
SpeedInput.TextSize          = 12
SpeedInput.TextColor3        = C.Text
SpeedInput.BackgroundColor3  = C.BG
SpeedInput.Size              = UDim2.new(1, 0, 0, 24)
SpeedInput.Position          = UDim2.new(0, 0, 0, 50)
SpeedInput.TextXAlignment    = Enum.TextXAlignment.Center
SpeedInput.Parent            = SpeedSection
corner(SpeedInput, 5)
stroke(SpeedInput, C.Stroke, 1)

local MIN_SPEED, MAX_SPEED = 16, 160

local function applySpeed(val)
    val = math.clamp(val, MIN_SPEED, MAX_SPEED)
    state.walkSpeed = val
    SpeedValueLbl.Text = tostring(val)
    SpeedInput.Text    = tostring(val)
    -- update fill
    local pct = (val - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)
    tween(SliderFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
    -- apply to humanoid
    local hum = getHum()
    if hum then hum.WalkSpeed = val end
end

-- Slider drag
local sliderDragging = false

SliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local absPos  = SliderTrack.AbsolutePosition
        local absSize = SliderTrack.AbsoluteSize
        local relX    = math.clamp(input.Position.X - absPos.X, 0, absSize.X)
        local pct     = relX / absSize.X
        local val     = math.round(MIN_SPEED + pct * (MAX_SPEED - MIN_SPEED))
        applySpeed(val)
    end
end)

SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then
        applySpeed(val)
    else
        SpeedInput.Text = tostring(state.walkSpeed)
    end
end)

-- Noclip toggle
local _, setNoclipState = makeToggle(SubBody, "Noclip", function(on)
    state.noclipEnabled = on
    if on then enableNoclip() else disableNoclip() end
end)

-- ──────────────────────────────────────────────────────────
-- RESPAWN CLEANUP
-- ──────────────────────────────────────────────────────────
local function cleanupAll()
    -- Stop all features
    state.floatEnabled  = false
    state.flyEnabled    = false
    state.noclipEnabled = false

    disableFloat()
    disableFly()
    disableNoclip()

    -- Reset toggle UI visuals
    setFloatState(false)
    setFlyState(false)
    setNoclipState(false)
end

local function onCharAdded(char)
    char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    -- Re-apply walk speed
    hum.WalkSpeed = state.walkSpeed
    -- Re-enable active features after respawn if still toggled
    task.wait(0.1)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    cleanupAll()
    onCharAdded(char)
end)

if LocalPlayer.Character then
    onCharAdded(LocalPlayer.Character)
end

-- ──────────────────────────────────────────────────────────
-- DISABLE TOPBAR OVERLAP (optional polish)
-- ──────────────────────────────────────────────────────────
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)

print("[VT Script Hub] Loaded successfully ✅")
