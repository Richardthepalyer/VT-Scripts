-- ============================================================
--  Advanced Player Menu | LocalScript
--  Place in: StarterPlayer > StarterPlayerScripts
-- ============================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- CONSTANTS
-- ============================================================
local WINDOW_SIZE        = UDim2.new(0, 340, 0, 460)
local WINDOW_MINI_HEIGHT = 44
local ACCENT_GREEN       = Color3.fromRGB(80, 220, 100)
local TEXT_WHITE         = Color3.fromRGB(240, 240, 240)
local BG_DARK            = Color3.fromRGB(18, 18, 22)
local BG_PANEL           = Color3.fromRGB(26, 26, 32)
local BG_CARD            = Color3.fromRGB(34, 34, 42)
local BG_SEARCH          = Color3.fromRGB(40, 40, 50)
local TITLE_BAR_H        = 44
local SEARCH_BAR_H       = 36

-- ============================================================
-- BUILD SCREENGUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "PlayerMenuGui"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset  = true
ScreenGui.Parent          = LocalPlayer.PlayerGui

-- ============================================================
-- MAIN WINDOW FRAME
-- ============================================================
local Window = Instance.new("Frame")
Window.Name              = "Window"
Window.Size              = WINDOW_SIZE
Window.Position          = UDim2.new(0.5, -170, 0.5, -230)
Window.BackgroundColor3  = BG_PANEL
Window.BorderSizePixel   = 0
Window.ClipsDescendants  = true
Window.Parent            = ScreenGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 12)
WindowCorner.Parent       = Window

-- Drop shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name               = "Shadow"
Shadow.AnchorPoint        = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position           = UDim2.new(0.5, 0, 0.5, 8)
Shadow.Size               = UDim2.new(1, 40, 1, 40)
Shadow.ZIndex             = 0
Shadow.Image              = "rbxassetid://5028857084"
Shadow.ImageColor3        = Color3.new(0, 0, 0)
Shadow.ImageTransparency  = 0.55
Shadow.ScaleType          = Enum.ScaleType.Slice
Shadow.SliceCenter        = Rect.new(24, 24, 276, 276)
Shadow.Parent             = Window

-- ============================================================
-- TITLE BAR
-- ============================================================
local TitleBar = Instance.new("Frame")
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1, 0, 0, TITLE_BAR_H)
TitleBar.BackgroundColor3 = BG_DARK
TitleBar.BorderSizePixel  = 0
TitleBar.ZIndex           = 2
TitleBar.Parent           = Window

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent       = TitleBar

-- Patch bottom corners of title bar (make them square)
local TitlePatch = Instance.new("Frame")
TitlePatch.Size              = UDim2.new(1, 0, 0.5, 0)
TitlePatch.Position          = UDim2.new(0, 0, 0.5, 0)
TitlePatch.BackgroundColor3  = BG_DARK
TitlePatch.BorderSizePixel   = 0
TitlePatch.ZIndex            = 2
TitlePatch.Parent            = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name              = "TitleLabel"
TitleLabel.Size              = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text              = "Players In Server"
TitleLabel.TextColor3        = TEXT_WHITE
TitleLabel.Font              = Enum.Font.GothamBold
TitleLabel.TextSize          = 14
TitleLabel.ZIndex            = 3
TitleLabel.Parent            = TitleBar

-- ============================================================
-- MAC-STYLE CIRCLE BUTTONS
-- ============================================================
local function makeCircle(parent, color, xOffset)
    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.new(0, 14, 0, 14)
    btn.Position             = UDim2.new(0, xOffset, 0.5, -7)
    btn.BackgroundColor3     = color
    btn.BorderSizePixel      = 0
    btn.Text                 = ""
    btn.ZIndex               = 4
    btn.AutoButtonColor      = false
    btn.Parent               = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = btn
    -- hover dim
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.35}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    end)
    return btn
end

local RedBtn    = makeCircle(TitleBar, Color3.fromRGB(255, 95,  86),  12)
local YellowBtn = makeCircle(TitleBar, Color3.fromRGB(255, 189, 46),  32)
local GreenBtn  = makeCircle(TitleBar, Color3.fromRGB(39,  201, 63),  52)

-- ============================================================
-- SEARCH BAR
-- ============================================================
local SearchFrame = Instance.new("Frame")
SearchFrame.Name             = "SearchFrame"
SearchFrame.Size             = UDim2.new(1, -20, 0, SEARCH_BAR_H)
SearchFrame.Position         = UDim2.new(0, 10, 0, TITLE_BAR_H + 8)
SearchFrame.BackgroundColor3 = BG_SEARCH
SearchFrame.BorderSizePixel  = 0
SearchFrame.ZIndex           = 2
SearchFrame.Parent           = Window

local SFC = Instance.new("UICorner")
SFC.CornerRadius = UDim.new(0, 8)
SFC.Parent       = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size               = UDim2.new(1, -12, 1, 0)
SearchBox.Position           = UDim2.new(0, 12, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText    = "Search player..."
SearchBox.PlaceholderColor3  = Color3.fromRGB(130, 130, 150)
SearchBox.Text               = ""
SearchBox.TextColor3         = TEXT_WHITE
SearchBox.Font               = Enum.Font.Gotham
SearchBox.TextSize           = 13
SearchBox.TextXAlignment     = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus   = false
SearchBox.ZIndex             = 3
SearchBox.Parent             = SearchFrame

-- ============================================================
-- PLAYER LIST (ScrollingFrame)
-- ============================================================
local ListContainer = Instance.new("ScrollingFrame")
ListContainer.Name               = "ListContainer"
ListContainer.Size               = UDim2.new(1, -20, 1, -(TITLE_BAR_H + SEARCH_BAR_H + 24))
ListContainer.Position           = UDim2.new(0, 10, 0, TITLE_BAR_H + SEARCH_BAR_H + 16)
ListContainer.BackgroundColor3   = BG_DARK
ListContainer.BorderSizePixel    = 0
ListContainer.ScrollBarThickness = 3
ListContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
ListContainer.CanvasSize         = UDim2.new(0, 0, 0, 0)
ListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListContainer.ZIndex             = 2
ListContainer.Parent             = Window

local LC_Corner = Instance.new("UICorner")
LC_Corner.CornerRadius = UDim.new(0, 8)
LC_Corner.Parent       = ListContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder    = Enum.SortOrder.LayoutOrder
ListLayout.Padding      = UDim.new(0, 4)
ListLayout.Parent       = ListContainer

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop    = UDim.new(0, 6)
ListPadding.PaddingBottom = UDim.new(0, 6)
ListPadding.PaddingLeft   = UDim.new(0, 6)
ListPadding.PaddingRight  = UDim.new(0, 6)
ListPadding.Parent        = ListContainer

-- ============================================================
-- PLAYER CARD BUILDER
-- ============================================================
local function isLocalPlayer(player)
    return player == LocalPlayer
end

local function isFriend(player)
    if isLocalPlayer(player) then return false end
    local ok, result = pcall(function()
        return LocalPlayer:IsFriendsWith(player.UserId)
    end)
    return ok and result
end

local function getNameColor(player)
    if isLocalPlayer(player) then return ACCENT_GREEN end
    if isFriend(player) then return ACCENT_GREEN end
    return TEXT_WHITE
end

local function makePlayerCard(player)
    local color = getNameColor(player)
    local isLocal = isLocalPlayer(player)

    local card = Instance.new("Frame")
    card.Name               = player.Name
    card.Size               = UDim2.new(1, 0, 0, 40)
    card.BackgroundColor3   = BG_CARD
    card.BorderSizePixel    = 0
    card.LayoutOrder        = isLocal and 0 or 1
    card.ZIndex             = 3

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 7)
    cc.Parent = card

    -- Avatar thumbnail
    local thumb = Instance.new("ImageLabel")
    thumb.Size               = UDim2.new(0, 28, 0, 28)
    thumb.Position           = UDim2.new(0, 6, 0.5, -14)
    thumb.BackgroundColor3   = BG_SEARCH
    thumb.BorderSizePixel    = 0
    thumb.ZIndex             = 4
    thumb.Parent             = card
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent       = thumb
    -- Load thumbnail async
    local thumbUrl = Players:GetUserThumbnailAsync(
        player.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size48x48
    )
    thumb.Image = thumbUrl

    -- Name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size              = UDim2.new(1, -50, 1, 0)
    nameLabel.Position          = UDim2.new(0, 42, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text              = player.DisplayName ~= player.Name
        and (player.DisplayName .. "  @" .. player.Name)
        or player.Name
    nameLabel.TextColor3        = color
    nameLabel.Font              = Enum.Font.GothamSemibold
    nameLabel.TextSize          = 13
    nameLabel.TextXAlignment    = Enum.TextXAlignment.Left
    nameLabel.TextTruncate      = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex            = 4
    nameLabel.Parent            = card

    -- "YOU" badge for local player
    if isLocal then
        local badge = Instance.new("TextLabel")
        badge.Size              = UDim2.new(0, 34, 0, 18)
        badge.Position          = UDim2.new(1, -40, 0.5, -9)
        badge.BackgroundColor3  = ACCENT_GREEN
        badge.Text              = "YOU"
        badge.TextColor3        = Color3.fromRGB(10, 10, 10)
        badge.Font              = Enum.Font.GothamBold
        badge.TextSize          = 9
        badge.BorderSizePixel   = 0
        badge.ZIndex            = 4
        badge.Parent            = card
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 4)
        bc.Parent = badge
    end

    return card
end

-- ============================================================
-- NAME TAG (BillboardGui)
-- ============================================================
local function applyNameTag(player)
    local function setup(character)
        local head = character:WaitForChild("Head", 5)
        if not head then return end

        -- Remove old tag
        local old = head:FindFirstChild("CustomNameTag")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui")
        bb.Name         = "CustomNameTag"
        bb.Size         = UDim2.new(0, 200, 0, 30)
        bb.StudsOffset  = Vector3.new(0, 2.8, 0)
        bb.AlwaysOnTop  = true
        bb.Parent       = head

        local lbl = Instance.new("TextLabel")
        lbl.Size                = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text                = player.DisplayName
        lbl.TextColor3          = getNameColor(player)
        lbl.Font                = Enum.Font.GothamBold
        lbl.TextSize            = 16
        lbl.TextStrokeTransparency = 0.5
        lbl.TextStrokeColor3    = Color3.new(0, 0, 0)
        lbl.Parent              = bb
    end

    if player.Character then setup(player.Character) end
    player.CharacterAdded:Connect(setup)
end

-- ============================================================
-- LIST MANAGEMENT
-- ============================================================
local playerCards = {}

local function refreshList(searchText)
    searchText = (searchText or SearchBox.Text):lower()

    for _, card in pairs(ListContainer:GetChildren()) do
        if card:IsA("Frame") then
            local name = card.Name:lower()
            card.Visible = (searchText == "" or name:find(searchText, 1, true) ~= nil)
        end
    end
end

local function addPlayerToList(player)
    if playerCards[player] then return end

    local ok, card = pcall(makePlayerCard, player)
    if not ok then return end

    card.Parent          = ListContainer
    playerCards[player]  = card

    applyNameTag(player)
    refreshList()
end

local function removePlayerFromList(player)
    local card = playerCards[player]
    if card then
        card:Destroy()
        playerCards[player] = nil
    end
end

-- Populate initial list
for _, p in ipairs(Players:GetPlayers()) do
    task.spawn(addPlayerToList, p)
end

Players.PlayerAdded:Connect(function(p)
    task.spawn(addPlayerToList, p)
end)

Players.PlayerRemoving:Connect(removePlayerFromList)

-- Live search
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshList(SearchBox.Text)
end)

-- ============================================================
-- DRAGGING (Desktop + Mobile)
-- ============================================================
local dragging, dragStart, startPos

local function beginDrag(input)
    dragging  = true
    dragStart = input.Position
    startPos  = Window.Position
end

local function updateDrag(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    Window.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

local function endDrag()
    dragging = false
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        endDrag()
    end
end)

-- ============================================================
-- WINDOW CONTROLS
-- ============================================================
local isMinimized  = false
local isFullscreen = false
local normalSize   = WINDOW_SIZE
local normalPos    = Window.Position

local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ðŸ”´ Red â€” Close
RedBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- ðŸŸ¡ Yellow â€” Minimize
YellowBtn.MouseButton1Click:Connect(function()
    if isFullscreen then return end
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(Window, tweenInfo, {
            Size = UDim2.new(WINDOW_SIZE.X.Scale, WINDOW_SIZE.X.Offset, 0, WINDOW_MINI_HEIGHT)
        }):Play()
        SearchFrame.Visible = false
        ListContainer.Visible = false
    else
        SearchFrame.Visible = true
        ListContainer.Visible = true
        TweenService:Create(Window, tweenInfo, { Size = WINDOW_SIZE }):Play()
    end
end)

-- ðŸŸ¢ Green â€” Fullscreen toggle
GreenBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end
    isFullscreen = not isFullscreen
    if isFullscreen then
        normalSize = Window.Size
        normalPos  = Window.Position
        TweenService:Create(Window, tweenInfo, {
            Size     = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    else
        TweenService:Create(Window, tweenInfo, {
            Size     = normalSize,
            Position = normalPos
        }):Play()
    end
end)

-- ============================================================
-- DONE
-- ============================================================
print("[PlayerMenu] Loaded successfully.")
