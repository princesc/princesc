--[[ Admin Simple by Prince — FULL (Compact + IY-Style FLING TURBO)

Fitur utama:
• Fly (ikut arah kamera)
• Noclip (toggle)
• Fling IY-style Turbo (spin super cepat + netless drift) → “nendang” maksimal*
• TPUA (TP ke pemain via input/dropdown)
• WalkSpeed (set manual)
• UI compact: 4 kolom, minimize kecil, close "X"
*Catatan: efektivitas ke player lain tergantung proteksi game/server.

]]

-- ========== Services / Helpers ==========
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local LP             = Players.LocalPlayer

local function HRP(p) p=p or LP local c=p.Character or p.CharacterAdded:Wait() return c:FindFirstChild("HumanoidRootPart") end
local function HUM(p) p=p or LP local c=p.Character or p.CharacterAdded:Wait() return c:FindFirstChildOfClass("Humanoid") end

-- Executor helpers (opsional, kalau didukung)
local sethidden = sethiddenproperty or set_hidden_property or sethiddenprop
local setsimrad = setsimulationradius or set_simulation_radius

-- ========== UI Constants (Compact) ==========
local FRAME_W   = 310
local CELL_W    = 68
local CELL_H    = 28
local PAD_X     = 6
local PAD_Y     = 6
local HEADER_H  = 34
local MIN_HEADER_H = 24
local MIN_H     = 8 + MIN_HEADER_H + 8 -- 40

local CONTENT_H = (4*CELL_H) + (3*PAD_Y)              -- 130
local FRAME_H   = (8 + HEADER_H + 6) + CONTENT_H + 10 -- 188

-- ========== ScreenGui ==========
local pg   = LP:WaitForChild("PlayerGui")
local main = Instance.new("ScreenGui")
main.Name = "AdminSimple_Prince"
main.ResetOnSpawn = false
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.IgnoreGuiInset = true
main.Parent = pg

-- ========== Frame + Header ==========
local frame = Instance.new("Frame", main)
frame.Name = "Container"
frame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
frame.Position = UDim2.new(0.5, -FRAME_W/2, 0.16, 0)
frame.BackgroundColor3 = Color3.fromRGB(32,32,32)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, -16, 0, HEADER_H)
header.Position = UDim2.new(0, 8, 0, 8)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Admin Simple by Prince"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local function makeHdrBtn(txt, offX)
    local b = Instance.new("TextButton", header)
    b.Size = UDim2.new(0, 22, 0, 22)
    b.AnchorPoint = Vector2.new(1, .5)
    b.Position = UDim2.new(1, offX, .5, 0)
    b.BackgroundColor3 = Color3.fromRGB(55,55,55)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = Color3.new(1,1,1)
    b.AutoButtonColor = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end
local closeBtn = makeHdrBtn("X", -8)
local minBtn   = makeHdrBtn("—", -(8+22+6))

-- ========== Content (Grid 4 kolom) ==========
local content = Instance.new("ScrollingFrame", frame)
content.Position = UDim2.new(0, 8, 0, 8+HEADER_H+6)
content.Size     = UDim2.new(1, -16, 0, CONTENT_H)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 6
content.CanvasSize = UDim2.new()

local grid = Instance.new("UIGridLayout", content)
grid.CellSize = UDim2.new(0, CELL_W, 0, CELL_H)
grid.CellPadding = UDim2.new(0, PAD_X, 0, PAD_Y)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.FillDirectionMaxCells = 4
grid.HorizontalAlignment = Enum.HorizontalAlignment.Left
grid.VerticalAlignment = Enum.VerticalAlignment.Top
grid.SortOrder = Enum.SortOrder.LayoutOrder

local function mkBase(bg)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, CELL_W, 0, CELL_H)
    f.BackgroundColor3 = bg or Color3.fromRGB(55,55,55)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    f.Parent = content
    return f
end
local function mkBtn(txt, cb)
    local f = mkBase()
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundTransparency = 1
    b.Text = txt
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.TextColor3 = Color3.new(1,1,1)
    if cb then b.MouseButton1Click:Connect(cb) end
    return f, b
end
local function mkBox(ph, onCommit)
    local f = mkBase()
    local t = Instance.new("TextBox", f)
    t.Size = UDim2.new(1, -8, 1, 0)
    t.Position = UDim2.new(0, 4, 0, 0)
    t.BackgroundTransparency = 1
    t.PlaceholderText = ph or ""
    t.Text = ""
    t.Font = Enum.Font.Gotham
    t.TextSize = 12
    t.TextColor3 = Color3.new(1,1,1)
    t.ClearTextOnFocus = false
    if onCommit then t.FocusLost:Connect(function() onCommit(t.Text) end) end
    return f, t
end
local function spanX(f, cols) f.Size = UDim2.new(0, CELL_W*cols + PAD_X*(cols-1), 0, CELL_H) end

-- ========== States ==========
local minimized = false
local function destroyIf(o) if o then o:Destroy() end end

-- ========== Fly (kamera-follow) ==========
getgenv().FlySpeed = getgenv().FlySpeed or 40
local flySpeed = getgenv().FlySpeed
local fly_on, fly_conn = false, nil

local function startFly()
    local ch = LP.Character or LP.CharacterAdded:Wait()
    local hum, hrp = HUM(), HRP()
    if not hum or not hrp then return end
    local target = (hum.RigType == Enum.HumanoidRigType.R6) and ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso")
    target = target or hrp

    local bg = Instance.new("BodyGyro", target)
    bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.CFrame = target.CFrame
    local bv = Instance.new("BodyVelocity", target)
    bv.Velocity = Vector3.new(0,0.1,0); bv.MaxForce = Vector3.new(9e9,9e9,9e9)

    hum.PlatformStand = true
    if fly_conn then fly_conn:Disconnect() end
    fly_conn = RunService.RenderStepped:Connect(function()
        if not ch or not hum or hum.Health<=0 then return end
        local cam = workspace.CurrentCamera
        local input = hum.MoveDirection
        local maxspeed = math.max(5, tonumber(flySpeed) or 40)

        local f = input:Dot(cam.CFrame.LookVector)
        local r = input:Dot(cam.CFrame.RightVector)
        local v = (cam.CFrame.LookVector*f) + (cam.CFrame.RightVector*r)

        if v.Magnitude > 0 then
            bv.Velocity = v.Unit * maxspeed
        else
            bv.Velocity = Vector3.new(0,0,0)
        end

        local horiz = Vector3.new(v.X,0,v.Z)
        if horiz.Magnitude > 0 then
            local pos = HRP().Position
            bg.CFrame = CFrame.lookAt(pos, pos + horiz)
        else
            bg.CFrame = cam.CFrame
        end
    end)

    local con; con = LP.CharacterAdded:Connect(function()
        if fly_conn then fly_conn:Disconnect() fly_conn=nil end
        destroyIf(bg); destroyIf(bv); hum.PlatformStand=false; con:Disconnect()
    end)
    getgenv()._bg, getgenv()._bv = bg, bv
end
local function stopFly()
    if fly_conn then fly_conn:Disconnect() fly_conn=nil end
    local hum = HUM(); if hum then hum.PlatformStand=false end
    destroyIf(getgenv()._bg); destroyIf(getgenv()._bv); getgenv()._bg, getgenv()._bv = nil, nil
end
local function FlyToggle() if fly_on then fly_on=false; stopFly() else fly_on=true; startFly() end end
local function FlySetSpeed(n) local v=tonumber(n) if v and v>0 then flySpeed=v; getgenv().FlySpeed=v end end

-- ========== Noclip ==========
local noclip_on, noclip_conn = false, nil
local function setNoclip(on)
    noclip_on = on
    if noclip_conn then noclip_conn:Disconnect(); noclip_conn=nil end
    if on then
        noclip_conn = RunService.Stepped:Connect(function()
            local ch = LP.Character; if not ch then return end
            for _,v in ipairs(ch:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end
        end)
    end
end

-- ========== FLING IY-STYLE TURBO ==========
-- TUNABLES (silakan ubah kalau mau)
local FLING_SPIN_Y = 3200      -- 2800–3600 → makin besar makin “nendang”
local NETLESS_XZ   = 60        -- 40–80   → drift samping/depan
local NETLESS_Y    = -35       -- <0      → tahan supaya nggak mental ke atas
local DAMPING_XZ   = 0.6       -- 0.4–0.9 → redam drift pribadi

local fling_on, fling_netless_conn, fling_spin_conn = false, nil, nil

local function setIYNetless(active)
    if active then
        pcall(function()
            if sethidden then
                sethidden(LP, "MaximumSimulationRadius", math.huge)
                sethidden(LP, "SimulationRadius", math.huge)
            end
            if setsimrad then setsimrad(math.huge) end
        end)
        if not fling_netless_conn then
            fling_netless_conn = RunService.Stepped:Connect(function()
                local ch = LP.Character
                if not ch then return end
                for _,bp in ipairs(ch:GetDescendants()) do
                    if bp:IsA("BasePart") then
                        bp.Velocity = Vector3.new(NETLESS_XZ, NETLESS_Y, NETLESS_XZ)
                    end
                end
            end)
        end
    else
        if fling_netless_conn then fling_netless_conn:Disconnect() fling_netless_conn=nil end
    end
end

local function setFling_IY(on)
    local hrp, hum = HRP(), HUM()
    if not hrp or not hum then return end

    if not on then
        if fling_spin_conn then fling_spin_conn:Disconnect() fling_spin_conn=nil end
        setIYNetless(false)
        -- reset agar tidak nyeret
        hrp.AssemblyAngularVelocity = Vector3.new()
        local lv = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(lv.X*0.3, 0, lv.Z*0.3)
        fling_on = false
        return
    end

    -- collide ON biar “ngigit” objek lain; noclip OFF
    if noclip_on then setNoclip(false) end
    local ch = LP.Character
    if ch then
        for _,bp in ipairs(ch:GetDescendants()) do
            if bp:IsA("BasePart") then bp.CanCollide = true end
        end
    end
    hum.Sit = false
    hum.PlatformStand = false

    setIYNetless(true)

    if fling_spin_conn then fling_spin_conn:Disconnect() end
    fling_spin_conn = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent then return end
        -- spin turbo
        hrp.AssemblyAngularVelocity = Vector3.new(0, FLING_SPIN_Y, 0)
        -- clamp Y + redam drift pribadi (biar kamu nggak ngelayang)
        local v = hrp.AssemblyLinearVelocity
        hrp.AssemblyLinearVelocity = Vector3.new(v.X * DAMPING_XZ, 0, v.Z * DAMPING_XZ)
    end)

    fling_on = true
end

-- ========== TPUA & WS ==========
local function tpToPlayer(prefix)
    if not prefix or prefix=="" then return end
    prefix = prefix:lower()
    local target
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Name:lower():sub(1, #prefix)==prefix then target=p break end
    end
    local me, th = HRP(LP), target and HRP(target)
    if me and th then me.CFrame = th.CFrame + Vector3.new(0,2,0) end
end
local function setWS(n) local h=HUM() if h then h.WalkSpeed = tonumber(n) or 16 end end

-- ========== UI Rows ==========
-- Row1: Fly | + | - | Speed
local r1_fly,_  = mkBtn("Fly", function() FlyToggle() end)
local r1_plus,_ = mkBtn("+",   function() FlySetSpeed((tonumber(getgenv().FlySpeed) or 1)+1) end)
local r1_min,_  = mkBtn("-",   function() FlySetSpeed(math.max(1,(tonumber(getgenv().FlySpeed) or 1)-1)) end)
local r1_boxF, speedBox = mkBox(tostring(getgenv().FlySpeed), function(txt) FlySetSpeed(txt) end)

-- Row2: Noclip (x2) | Fling (x2)
local r2_nc,_ = mkBtn("Noclip", function() setNoclip(not noclip_on) end) spanX(r2_nc, 2)
local r2_fl,_ = mkBtn("Fling",  function() setFling_IY(not fling_on) end) spanX(r2_fl, 2)

-- Row3: TP | Nama (x2) | Pilih ▼
local r3_tpF, r3_tpB = mkBtn("TP", function() end)
local r3_nameF, nameBox = mkBox("nama/prefix") spanX(r3_nameF, 2)
local r3_pickF, r3_pickB = mkBtn("Pilih ▼", nil)

-- Dropdown (full width tepat di bawah Row3)
local ddPanel = Instance.new("Frame", content)
ddPanel.Size = UDim2.new(1, 0, 0, 110)
ddPanel.BackgroundColor3 = Color3.fromRGB(40,40,40)
ddPanel.Visible = false
ddPanel.LayoutOrder = 999
Instance.new("UICorner", ddPanel).CornerRadius = UDim.new(0, 8)

local ddScroll = Instance.new("ScrollingFrame", ddPanel)
ddScroll.Size = UDim2.new(1, -8, 1, -8)
ddScroll.Position = UDim2.new(0, 4, 0, 4)
ddScroll.BackgroundTransparency = 1
ddScroll.ScrollBarThickness = 6
ddScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ddScroll.CanvasSize = UDim2.new()
local ddList = Instance.new("UIListLayout", ddScroll)
ddList.FillDirection = Enum.FillDirection.Vertical
ddList.SortOrder = Enum.SortOrder.LayoutOrder
ddList.Padding = UDim.new(0, 4)

local function refreshDropdown()
    for _,c in ipairs(ddScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local arr = {}
    for _,p in ipairs(Players:GetPlayers()) do if p~=LP then table.insert(arr, p.Name) end end
    table.sort(arr)
    for _,name in ipairs(arr) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -2, 0, 24)
        b.BackgroundColor3 = Color3.fromRGB(55,55,55)
        b.Text = name
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.Gotham
        b.TextSize = 12
        b.Parent = ddScroll
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(function()
            nameBox.Text = name
            ddPanel.Visible = false
        end)
    end
end
r3_tpB.MouseButton1Click:Connect(function() tpToPlayer(nameBox.Text) end)
r3_pickB.MouseButton1Click:Connect(function()
    if ddPanel.Visible then ddPanel.Visible=false else refreshDropdown(); ddPanel.Visible=true end
end)
Players.PlayerAdded:Connect(function() if ddPanel.Visible then refreshDropdown() end end)
Players.PlayerRemoving:Connect(function() if ddPanel.Visible then refreshDropdown() end end)

-- Row4: Set WS | WS (x3)
local r4_set,_ = mkBtn("Set WS", function() setWS(speedBox and speedBox.Text or "30") end)
local r4_wsF, wsBox = mkBox("30", function(txt) setWS(txt) end) spanX(r4_wsF, 3)

-- ========== Minimize ==========
local function applyMinimized(mini)
    if mini then
        content.Visible = false
        ddPanel.Visible = false
        frame.Size = UDim2.new(0, FRAME_W, 0, MIN_H)
        header.Size = UDim2.new(1, -16, 0, MIN_HEADER_H)
        header.Position = UDim2.new(0, 8, 0, (MIN_H - MIN_HEADER_H)/2)
    else
        frame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
        header.Size = UDim2.new(1, -16, 0, HEADER_H)
        header.Position = UDim2.new(0, 8, 0, 8)
        content.Visible = true
    end
end
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = minimized and UDim2.new(0, FRAME_W, 0, MIN_H) or UDim2.new(0, FRAME_W, 0, FRAME_H)}):Play()
    applyMinimized(minimized)
end)

closeBtn.MouseButton1Click:Connect(function()
    if fly_on then FlyToggle() end
    setNoclip(false); setFling_IY(false)
    main:Destroy()
end)

-- ========== Keybind opsional ==========
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.F then FlyToggle()
    elseif inp.KeyCode == Enum.KeyCode.N then setNoclip(not noclip_on)
    elseif inp.KeyCode == Enum.KeyCode.G then setFling_IY(not fling_on) end
end)

-- ========== Respawn safety ==========
LP.CharacterAdded:Connect(function()
    if fly_on then FlyToggle() end
    setNoclip(false); setFling_IY(false)
end)
