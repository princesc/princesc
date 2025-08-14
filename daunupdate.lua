-- Waypoint TP Auto — Direct Return + Toast (BR) + Light Transparency + Gradient + Start/Stop (LM)

-- ==== Services ====
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- ==== Waypoints (fixed order) ====
local WAYPOINTS = {
    {pos=Vector3.new(-7.00,    13.73,  -8.00),   label="Base"},
    {pos=Vector3.new(-622.00,  250.10, -384.00), label="Camp 2"},
    {pos=Vector3.new(-1203.00, 261.47, -487.00), label="Camp 3"},
    {pos=Vector3.new(-1398.96, 578.21, -950.42), label="Camp 4"},
    {pos=Vector3.new(-1701.00, 816.41, -1400.00),label="Camp 5"},
    {pos=Vector3.new(-1972.00, 842.21, -1672.00),label="Camp 6"},
    {pos=Vector3.new(-2807.00, 1635.71,-2478.00),label="Camp 7"},
    {pos=Vector3.new(-3231.00, 1713.38,-2591.00),label="Puncak"},
}
local DIRECT_RETURN = true

-- ==== Teleport helpers ====
local function getHRP()
    local char = lp.Character or lp.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end
local function tp_to(v)
    local hrp = getHRP()
    pcall(function() hrp.CFrame = CFrame.new(v) end)
end

-- ==== Auto config ====
local SAFE = {
    settleTime = 0.20,
    retryDistance = 15,
    delayOverridesSec = { ["Base"]=0.50, ["Puncak"]=0.80 },
    directReturnPause = 0.30,
}
local AUTO = { running=false, mode="PINGPONG", idx=1, step=1, userMax=3.0 }

-- ==== UI (toast bottom-right + small buttons) ====
local gui = Instance.new("ScreenGui")
gui.Name = "TP_UI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = lp:WaitForChild("PlayerGui")

-- Soft shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = gui
shadow.AnchorPoint = Vector2.new(1,1)
shadow.Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12,-12)
shadow.Size = UDim2.fromOffset(330,84)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.4
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24,24,276,276)
shadow.Visible = false

local banner = Instance.new("Frame")
banner.Name = "Banner"
banner.Parent = gui
banner.AnchorPoint = Vector2.new(1,1)
banner.Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12, 100) -- start off-screen (di bawah)
banner.Size = UDim2.fromOffset(330,84)
banner.BackgroundColor3 = Color3.fromRGB(18,18,22)
banner.BackgroundTransparency = 0.35  -- transparansi ringan
banner.Visible = false
Instance.new("UICorner", banner).CornerRadius = UDim.new(0,12)

-- Border tipis
local stroke = Instance.new("UIStroke", banner)
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Transparency = 0.9  -- lebih tipis/halus

-- Padding
local pad = Instance.new("UIPadding", banner)
pad.PaddingTop = UDim.new(0,10); pad.PaddingBottom = UDim.new(0,10)
pad.PaddingLeft = UDim.new(0,12); pad.PaddingRight = UDim.new(0,12)

-- Gradient halus (top->bottom), tetap gelap ringan
local grad = Instance.new("UIGradient", banner)
grad.Rotation = 90
grad.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
grad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0.00, 0.05),  -- lebih solid di atas
    NumberSequenceKeypoint.new(1.00, 0.20)   -- sedikit lebih transparan di bawah
}

-- indikator kecil
local dot = Instance.new("Frame", banner)
dot.Size = UDim2.fromOffset(10,10)
dot.Position = UDim2.fromOffset(2,2)
dot.BackgroundColor3 = Color3.fromRGB(0,200,120)
Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

-- teks
local title = Instance.new("TextLabel", banner)
title.Size = UDim2.new(1, -16, 0, 26)
title.Position = UDim2.fromOffset(16,4)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.new(1,1,1)
title.TextTransparency = 0.05
title.Text = "PRINCE GANTENG"

local sub = Instance.new("TextLabel", banner)
sub.Size = UDim2.new(1, -16, 0, 44)
sub.Position = UDim2.fromOffset(16,30)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.Gotham
sub.TextSize = 14
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextYAlignment = Enum.TextYAlignment.Top
sub.TextWrapped = true
sub.TextColor3 = Color3.fromRGB(230,230,230)
sub.TextTransparency = 0.05
sub.Text = "JOKI SUMIT KE TIKTOK\n@jasagendongsumitroblox"

-- anim util (bottom-right)
local function setBannerVisible(v)
    if v then
        banner.Visible = true; shadow.Visible = true
        banner.Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12, 100)
        shadow.Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12, 100)
        -- slide-in (naik) + fade-in ringan
        TweenService:Create(banner, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12,-12),
            BackgroundTransparency = 0.35
        }):Play()
        TweenService:Create(shadow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12,-12),
            ImageTransparency = 0.4
        }):Play()
    else
        -- slide-out (turun) + fade-out ringan
        local t1 = TweenService:Create(banner, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12, 100),
            BackgroundTransparency = 0.45
        })
        local t2 = TweenService:Create(shadow, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12, 100),
            ImageTransparency = 0.7
        })
        t1:Play(); t2:Play()
        t1.Completed:Connect(function()
            banner.Visible = false; shadow.Visible = false
        end)
    end
end

-- tombol kecil kiri–tengah
local btnStart = Instance.new("TextButton", gui)
btnStart.Size = UDim2.fromOffset(100, 30)
btnStart.AnchorPoint = Vector2.new(0, 0.5)
btnStart.Position = UDim2.new(0, 10, 0.5, -20)
btnStart.BackgroundColor3 = Color3.fromRGB(0,170,0)
btnStart.TextColor3 = Color3.new(1,1,1)
btnStart.Font = Enum.Font.GothamBold
btnStart.TextSize = 14
btnStart.Text = "▶ Start"
Instance.new("UICorner", btnStart).CornerRadius = UDim.new(0,8)

local btnStop = Instance.new("TextButton", gui)
btnStop.Size = UDim2.fromOffset(100, 30)
btnStop.AnchorPoint = Vector2.new(0, 0.5)
btnStop.Position = UDim2.new(0, 10, 0.5, 20)
btnStop.BackgroundColor3 = Color3.fromRGB(170,0,0)
btnStop.TextColor3 = Color3.new(1,1,1)
btnStop.Font = Enum.Font.GothamBold
btnStop.TextSize = 14
btnStop.Text = "⏸ Stop"
Instance.new("UICorner", btnStop).CornerRadius = UDim.new(0,8)

-- ==== Core auto ====
local function autoStep()
    local n = #WAYPOINTS
    if n == 0 then return false end
    AUTO.idx = math.clamp(AUTO.idx, 1, n)
    local wp = WAYPOINTS[AUTO.idx]

    tp_to(wp.pos)
    local t0 = os.clock()
    while os.clock() - t0 < SAFE.settleTime do task.wait() end

    local ok,hrp = pcall(getHRP)
    if ok and hrp then
        local dist = (hrp.Position - wp.pos).Magnitude
        if dist >= SAFE.retryDistance then
            tp_to(wp.pos); task.wait(0.10)
        end
    end

    local extra = SAFE.delayOverridesSec[wp.label] or 0
    if DIRECT_RETURN and wp.label == "Puncak" then
        extra = extra + (SAFE.directReturnPause or 0)
    end

    local waitUntil = os.clock() + AUTO.userMax + extra
    while AUTO.running and os.clock() < waitUntil do task.wait(0.05) end

    if AUTO.mode == "PINGPONG" then
        if DIRECT_RETURN and wp.label == "Puncak" then
            AUTO.idx = 1; AUTO.step = 1
        else
            AUTO.idx = AUTO.idx + AUTO.step
            if AUTO.idx >= n then AUTO.idx = n; AUTO.step = -1 end
            if AUTO.idx <= 1 then AUTO.idx = 1; AUTO.step = 1 end
        end
    else
        AUTO.idx = AUTO.idx + 1; if AUTO.idx > n then AUTO.idx = 1 end
    end
    return true
end

local function autoLoop()
    if not AUTO.running then return end
    setBannerVisible(true)
    task.spawn(function()
        while AUTO.running do
            if not autoStep() then break end
        end
        setBannerVisible(false)
    end)
end

local function startAuto()
    if AUTO.running then return end
    AUTO.running = true
    autoLoop()
end
local function stopAuto() AUTO.running = false end

btnStart.MouseButton1Click:Connect(startAuto)
btnStop.MouseButton1Click:Connect(stopAuto)

-- Hotkey toggle (Y)
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.Y then
        if AUTO.running then stopAuto() else startAuto() end
    end
end)
