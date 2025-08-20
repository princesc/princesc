--// === TELEPORT TO PLAYER — Standalone (Merapi NAND, extracted) ===
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

-- Bersihkan versi lama
pcall(function() local g = CoreGui:FindFirstChild("Merapi_TeleportOnly"); if g then g:Destroy() end end)

-- ==== Util ====
local Y_OFFSET = 2
local function getHRP(ch)
    if not ch then return nil end
    return ch:FindFirstChild("HumanoidRootPart") or ch:WaitForChild("HumanoidRootPart", 3)
end
local function safeTP(pos)
    local ch = lp.Character or lp.CharacterAdded:Wait()
    local hrp = getHRP(ch); if not hrp then return end
    pcall(function() hrp.CFrame = CFrame.new(pos + Vector3.new(0, Y_OFFSET, 0)) end)
end
local function notif(msg)
    pcall(function() game.StarterGui:SetCore("SendNotification", {Title="Teleport", Text=msg, Duration=2}) end)
end

-- ==== GUI ====
local sg = Instance.new("ScreenGui")
sg.Name = "Merapi_TeleportOnly"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = CoreGui

local WIDTH, HEIGHT = 320, 260
local win = Instance.new("Frame", sg)
win.Size = UDim2.fromOffset(WIDTH, HEIGHT)
win.Position = UDim2.fromScale(0.5, 0.45)
win.AnchorPoint = Vector2.new(0.5, 0.5)
win.BackgroundColor3 = Color3.fromRGB(22,22,26)
win.BackgroundTransparency = 0.08
win.BorderSizePixel = 0
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 10)

-- Title bar
local top = Instance.new("Frame", win)
top.Size = UDim2.new(1, 0, 0, 30)
top.BackgroundColor3 = Color3.fromRGB(28,28,34)
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(200,230,255)
title.Text = "Teleport Player"

local btnClose = Instance.new("TextButton", top)
btnClose.Size = UDim2.fromOffset(26, 20)
btnClose.Position = UDim2.new(1, -30, 0.5, -10)
btnClose.Text = "X"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 14
btnClose.TextColor3 = Color3.fromRGB(240, 200, 200)
btnClose.BackgroundColor3 = Color3.fromRGB(54,28,28)
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)

-- Dragging
do
    local dragging, start, startPos
    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; start = i.Position; startPos = win.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - start
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- Header row (label kiri, refresh kanan)
local header = Instance.new("Frame", win)
header.Position = UDim2.fromOffset(8, 38)
header.Size = UDim2.fromOffset(WIDTH-16, 28)
header.BackgroundTransparency = 1

local lbl = Instance.new("TextLabel", header)
lbl.Size = UDim2.new(1, -96, 1, 0)
lbl.BackgroundTransparency = 1
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 14
lbl.TextXAlignment = Enum.TextXAlignment.Left
lbl.TextColor3 = Color3.fromRGB(210,235,255)
lbl.Text = "Players (tap untuk teleport)"

local btnRefresh = Instance.new("TextButton", header)
btnRefresh.Size = UDim2.fromOffset(90, 28)
btnRefresh.Position = UDim2.new(1, -90, 0, 0)
btnRefresh.Text = "Refresh"
btnRefresh.Font = Enum.Font.GothamBold
btnRefresh.TextSize = 14
btnRefresh.TextColor3 = Color3.fromRGB(210,235,255)
btnRefresh.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
Instance.new("UICorner", btnRefresh).CornerRadius = UDim.new(0, 8)

-- List
local list = Instance.new("ScrollingFrame", win)
list.Position = UDim2.fromOffset(8, 70)
list.Size = UDim2.fromOffset(WIDTH-16, HEIGHT-78-8)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 6
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new()

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function mkBtn(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(35,35,42)
    b.AutoButtonColor = true
    b.Font = Enum.Font.Gotham
    b.TextSize = 15
    b.TextColor3 = Color3.fromRGB(190, 225, 255)
    b.Text = text
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b); s.Thickness = 1; s.Color = Color3.fromRGB(160,200,255); s.Transparency = 0.55
    return b
end

-- Populate
local function refreshPlayers()
    for _,c in ipairs(list:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
    local arr = {}
    for _,p in ipairs(Players:GetPlayers()) do if p ~= lp then table.insert(arr, p) end end
    table.sort(arr, function(a,b) return a.DisplayName:lower() < b.DisplayName:lower() end)
    for _,p in ipairs(arr) do
        local b = mkBtn(p.DisplayName.."  (@"..p.Name..")")
        b.Parent = list
        b.MouseButton1Click:Connect(function()
            local t = Players:FindFirstChild(p.Name)
            if not t then notif("Player keluar"); return end
            local hrp = t.Character and getHRP(t.Character)
            if hrp then
                safeTP(hrp.Position)
                notif("Teleport ke "..t.DisplayName)
            else
                notif("Gagal: HRP tidak ada")
            end
        end)
    end
end
btnRefresh.MouseButton1Click:Connect(function() refreshPlayers(); notif("Daftar diperbarui") end)
refreshPlayers()

-- Close
btnClose.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Hotkey toggle (RightCtrl)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        win.Visible = not win.Visible
    end
end)
