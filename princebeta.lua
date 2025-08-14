
-- === Reusable Toast (Bottom-Right) — "PRINCE GANTENG" ===
do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local lp = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "PRINCE_ToastUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = lp:WaitForChild("PlayerGui")

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
    banner.Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12, 100)
    banner.Size = UDim2.fromOffset(330,84)
    banner.BackgroundColor3 = Color3.fromRGB(18,18,22)
    banner.BackgroundTransparency = 0.35
    banner.Visible = false
    Instance.new("UICorner", banner).CornerRadius = UDim.new(0,12)

    local stroke = Instance.new("UIStroke", banner)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(255,255,255)
    stroke.Transparency = 0.9

    local pad = Instance.new("UIPadding", banner)
    pad.PaddingTop = UDim.new(0,10); pad.PaddingBottom = UDim.new(0,10)
    pad.PaddingLeft = UDim.new(0,12); pad.PaddingRight = UDim.new(0,12)

    local grad = Instance.new("UIGradient", banner)
    grad.Rotation = 90
    grad.Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1))
    grad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0.00, 0.05),
        NumberSequenceKeypoint.new(1.00, 0.20)
    }

    local dot = Instance.new("Frame", banner)
    dot.Size = UDim2.fromOffset(10,10)
    dot.Position = UDim2.fromOffset(2,2)
    dot.BackgroundColor3 = Color3.fromRGB(0,200,120)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

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

    -- Public API (global)
    _G.PRINCE_TOAST = _G.PRINCE_TOAST or {}
    function _G.PRINCE_TOAST.show(opts)
        opts = opts or {}
        if opts.title then title.Text = opts.title end
        if opts.text then sub.Text = opts.text end
        if opts.color then dot.BackgroundColor3 = opts.color end
        banner.Visible = true; shadow.Visible = true
        banner.Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12, 100)
        shadow.Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12, 100)
        TweenService:Create(banner, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12,-12),
            BackgroundTransparency = 0.35
        }):Play()
        TweenService:Create(shadow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(1,1) + UDim2.fromOffset(-12,-12),
            ImageTransparency = 0.4
        }):Play()
    end
    function _G.PRINCE_TOAST.hide()
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
-- === End Reusable Toast ===


--// === ADMIN PRINCE v17.9.7 ===
-- Change:
-- - Run/Stop digeser lebih jauh dari sisi kanan (RIGHT_PADDING = 54).
-- Lainnya sama seperti v17.9.6 (tema biru muda, scroll vertikal, topbar rapi, 4 item).

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local function HttpGet(url) return game:HttpGet(url) end
local LIGHT_BLUE = Color3.fromRGB(173, 216, 230)

local GDNState = { running = false, conns = {} }
_G.AdminPrinceCamp = _G.AdminPrinceCamp or { running = false }

local SCRIPTS = {}
local function push(entry) table.insert(SCRIPTS, entry) end

push({ name="Admin Full (sc infinite)", run=function()
    loadstring(HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end 
    ,stop=function()
        local Players = game:GetService("Players")
        -- Close Infinite Yield GUI (best-effort)
        pcall(function()
            local parents = {game:GetService("CoreGui")}
            local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pg then table.insert(parents, pg) end
            for _,parent in ipairs(parents) do
                for _,g in ipairs(parent:GetChildren()) do
                    if g:IsA("ScreenGui") then
                        local n = string.lower(g.Name)
                        if string.find(n, "infinite") or string.find(n, "yield") or string.find(n, "iy") then
                            pcall(function() g:Destroy() end)
                        end
                    end
                end
            end
        end)
        -- Clear flags (non-breaking)
        pcall(function()
            _G.IY_LOADED = false
            if getgenv then
                local gv = getgenv()
                if gv then
                    gv.IY_LOADED = false
                    gv.InfiniteYield = nil
                end
            end
        end)
    end
})

-- ===== ADMIN SIMPLE (no Stop) =====
push({
    name="ADMIN SIMPLE",
    run=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/princesc/princesc/refs/heads/main/adminsimple.lua"))()
    end
})


push({ name="KOMPLEK INDO", run=function()
    loadstring(HttpGet("https://raw.githubusercontent.com/numerouno2/eugunewuhub/refs/heads/main/eugunewustd.lua"))()
end })

-- ===== GUNUNG DAUN SIMPLE =====
push({
    name="GUNUNG DAUN SIMPLE",
    run=function()
        
        -- replaced to use external daunupdate.lua
        local ok, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/princesc/princesc/main/daunupdate.lua", true))()
        end)
        if not ok then warn("GUNUNG DAUN SIMPLE error: "..tostring(err)) end

    end,
    stop=function()
        if not GDNState.running then return end
        GDNState.running = false
        for _,c in ipairs(GDNState.conns) do pcall(function() c:Disconnect() end) end
        GDNState.conns = {}
    end
})

-- ===== GUNUNG DAUN FULL (Camp UI) =====
push({
    name="GUNUNG DAUN FULL",
    run=function()
        local player = Players.LocalPlayer
        _G.AdminPrinceCamp.running = true

        local TELEPORT_DELAY, JITTER, LOOP_PAUSE = 0.75, 0.15, 1.0
        local Y_OFFSET, HEAL_CHECK = 6, 0.15
        local AUTO_SUMMIT_LOOP = true
        local rng = Random.new()

        local teleportLocations = {
            Vector3.new(-621.52, 250.26, -383.50),
            Vector3.new(-1202.22, 261.63, -486.78),
            Vector3.new(-1398.98, 578.32, -949.40),
            Vector3.new(-1700.21, 816.68, -1398.28),
            Vector3.new(-3222.09, 1715.10, -2601.32)
        }
        local campNames = { "Camp 1", "Camp 2", "Camp 3", "Camp 4", "Camp 5 (Summit)" }

        local autoSummitRunning = false

        local function getHRP(character)
            if not character then return nil end
            return character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
        end
        local function safeTP(pos)
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = getHRP(character); if not hrp then return false end
            local ok = pcall(function() hrp.CFrame = CFrame.new(pos + Vector3.new(0, Y_OFFSET, 0)) end)
            return ok
        end
        local function startAutoSummit()
            if autoSummitRunning then return end
            autoSummitRunning = true
            task.spawn(function()
                repeat
                    for _, pos in ipairs(teleportLocations) do
                        if not _G.AdminPrinceCamp.running then break end
                        if not autoSummitRunning then break end
                        if not safeTP(pos) then break end
                        task.wait(TELEPORT_DELAY + rng:NextNumber(0, JITTER))
                    end
                    if AUTO_SUMMIT_LOOP and autoSummitRunning and _G.AdminPrinceCamp.running then
                        task.wait(LOOP_PAUSE)
                    end
                until not AUTO_SUMMIT_LOOP or not autoSummitRunning or not _G.AdminPrinceCamp.running
                autoSummitRunning = false
            end)
        end
        local function stopAutoSummit() autoSummitRunning = false end
        local function setHealthLoop(humanoid)
            task.spawn(function()
                while _G.AdminPrinceCamp.running and humanoid and humanoid.Parent do
                    pcall(function()
                        if humanoid.Health < humanoid.MaxHealth then
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end)
                    task.wait(HEAL_CHECK)
                end
            end)
        end
        local function onCharacterAdded(character)
            local humanoid = character:WaitForChild("Humanoid", 5)
            if humanoid then setHealthLoop(humanoid) end
        end
        table.insert(_G.AdminPrinceCamp, (player.CharacterAdded:Connect(onCharacterAdded)))
        if player.Character then onCharacterAdded(player.Character) end

        pcall(function()
            local pg = player:FindFirstChild("PlayerGui")
            if pg then local old = pg:FindFirstChild("CampTeleportUI"); if old then old:Destroy() end end
        end)

        local sg = Instance.new("ScreenGui")
        sg.Name = "CampTeleportUI"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = false
        sg.Parent = player:WaitForChild("PlayerGui")

        local frameWidth = 260
        local titleBarHeight = 32
        local itemHeight, padding = 32, 6
        local visibleItems = 4
        local listHeight = (visibleItems * itemHeight) + ((visibleItems - 1) * padding)
        local topMargin = 44
        local bottomMargin = 12
        local frameHeightNormal = topMargin + listHeight + bottomMargin

        local TOP_OFFSET = 0
        local miniWidth = 220
        local tweenTime = 0.18
        local easing = Enum.EasingStyle.Quad
        local easingDir = Enum.EasingDirection.Out
        local minimized = false

        local frame = Instance.new("Frame")
        frame.Name = "Main"
        frame.Size = UDim2.new(0, frameWidth, 0, frameHeightNormal)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.new(0.5, 0, 0.45, 0)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        frame.BackgroundTransparency = 0.15
        frame.BorderSizePixel = 0
        frame.Parent = sg
        local uicorner = Instance.new("UICorner", frame); uicorner.CornerRadius = UDim.new(0, 10)

        local titleBar = Instance.new("Frame", frame)
        titleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
        titleBar.BackgroundTransparency = 1

        local title = Instance.new("TextLabel", titleBar)
        title.Size = UDim2.new(1, -70, 1, 0)
        title.Position = UDim2.new(0, 12, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "Gunung Daun Full"
        title.TextColor3 = LIGHT_BLUE
        title.TextSize = 18
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left

        local minimizeBtn = Instance.new("TextButton", titleBar)
        minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
        minimizeBtn.Position = UDim2.new(1, -60, 0, 2)
        minimizeBtn.Text = "_"
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
        minimizeBtn.TextColor3 = LIGHT_BLUE
        minimizeBtn.Font = Enum.Font.GothamBold
        minimizeBtn.TextSize = 18

        local closeBtn = Instance.new("TextButton", titleBar)
        closeBtn.Size = UDim2.new(0, 28, 0, 28)
        closeBtn.Position = UDim2.new(1, -30, 0, 2)
        closeBtn.Text = "X"
        closeBtn.BackgroundColor3 = Color3.fromRGB(40,20,20)
        closeBtn.TextColor3 = LIGHT_BLUE
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 18

        local scroll = Instance.new("ScrollingFrame", frame)
        scroll.Name = "Menu"
        scroll.Size = UDim2.new(1, -24, 0, listHeight)
        scroll.Position = UDim2.new(0, 12, 0, topMargin)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 6
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.ClipsDescendants = true
        local list = Instance.new("UIListLayout", scroll); list.Padding = UDim.new(0, padding); list.SortOrder = Enum.SortOrder.LayoutOrder

        local function mkButton(text)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, itemHeight)
            btn.BackgroundColor3 = Color3.fromRGB(35,35,42)
            btn.TextColor3 = LIGHT_BLUE
            btn.TextSize = 16
            btn.Font = Enum.Font.Gotham
            btn.Text = text
            btn.AutoButtonColor = true
            local corner = Instance.new("UICorner", btn); corner.CornerRadius = UDim.new(0, 8)
            local s = Instance.new("UIStroke", btn); s.Thickness = 1; s.Color = LIGHT_BLUE; s.Transparency = 0.5
            return btn
        end

        for i, name in ipairs(campNames) do
            local btn = mkButton("Teleport: " .. name)
            btn.Parent = scroll
            btn.MouseButton1Click:Connect(function()
                _G.AdminPrinceCamp.running = true
                stopAutoSummit()
                if teleportLocations[i] then safeTP(teleportLocations[i]) end
            end)
        end

        local summitBtn = mkButton("⬆ Teleport: Puncak Langsung")
        summitBtn.Parent = scroll
        summitBtn.MouseButton1Click:Connect(function()
            _G.AdminPrinceCamp.running = true
            stopAutoSummit()
            safeTP(teleportLocations[#teleportLocations])
        end)

        local sep = Instance.new("Frame", scroll)
        sep.Size = UDim2.new(1, 0, 0, 1)
        sep.BackgroundColor3 = LIGHT_BLUE
        sep.BackgroundTransparency = 0.65

        local autoBtn = mkButton("▶ Auto SUMMIT (Loop)")
        autoBtn.Parent = scroll
        local stopBtn = mkButton("■ Stop Auto SUMMIT")
        stopBtn.Parent = scroll

        autoBtn.MouseButton1Click:Connect(function()
            if not _G.AdminPrinceCamp.running then _G.AdminPrinceCamp.running = true end
            if not autoSummitRunning then
                autoBtn.Text = "… Auto SUMMIT Running"
                startAutoSummit()
                task.spawn(function()
                    while autoSummitRunning and _G.AdminPrinceCamp.running do task.wait(0.25) end
                    autoBtn.Text = "▶ Auto SUMMIT (Loop)"
                end)
            end
        end)
        stopBtn.MouseButton1Click:Connect(function()
            stopAutoSummit()
            _G.AdminPrinceCamp.running = false
            autoBtn.Text = "▶ Auto SUMMIT (Loop)"
        end)

        local function tweenFrame(targetSize, targetAnchor, targetPos)
            local ti = TweenInfo.new(tweenTime, easing, easingDir)
            TweenService:Create(frame, ti, {AnchorPoint = targetAnchor}):Play()
            TweenService:Create(frame, ti, {Size = targetSize}):Play()
            TweenService:Create(frame, ti, {Position = targetPos}):Play()
        end

        local function minimizeUI()
            scroll.Visible = false
            minimizeBtn.Text = "▢"
            tweenFrame(UDim2.new(0, miniWidth, 0, titleBarHeight), Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 0))
        end
        local function restoreUI()
            scroll.Visible = true
            minimizeBtn.Text = "_"
            tweenFrame(UDim2.new(0, frameWidth, 0, frameHeightNormal), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.45, 0))
        end
        minimizeBtn.MouseButton1Click:Connect(function() minimized = not minimized; if minimized then minimizeUI() else restoreUI() end end)
        closeBtn.MouseButton1Click:Connect(function() _G.AdminPrinceCamp.running = false; stopAutoSummit(); sg:Destroy() end)
    end
})

push({ name="GUNUNG MERAPI", run=function() loadstring(HttpGet("https://pastebin.com/raw/yGZcP0T7"))() end })
push({ name="GUNUNG JAWA",   run=function() loadstring(HttpGet("https://pastebin.com/raw/VQxMe5Z5"))() end })

-- ===== TELEPORT (no Stop) =====
push({
    name="TELEPORT",
    run=function()
        -- (Teleport Misc UI code omitted here for brevity in this build)
        loadstring(HttpGet("https://raw.githubusercontent.com/princesc/princesc/refs/heads/main/teleport_misc_embed.lua"))()
    end
})



-- ===== ALL EMOTE (no Stop) =====
push({
    name="ALL EMOTE",
    run=function()
        loadstring(HttpGet("https://raw.githubusercontent.com/princesc/princesc/main/all-emotes.lua"))()
    end
})



-- ===== ANTARTIKA (no Stop) =====
push({
    name="ANTARTIKA",
    run=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nearastro/Lego-hack/refs/heads/main/00AntarticaExpedition.lua"))()
    end
})



-- ===== YAGATW (no Stop) =====
push({
    name="YAGATW",
    run=function()
        loadstring(game:HttpGet("https://pastebin.com/raw/DXrLrmaw"))()
    end
})



-- ===== COPY AVA (no Stop) =====
push({
    name="COPY AVA",
    run=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nearastro/Nearastro/refs/heads/main/00CopyAvaFE.lua"))()
    end
})


-- ===== Main UI Shell =====
pcall(function() if CoreGui:FindFirstChild("ScriptHub_AdminPrince") then CoreGui.ScriptHub_AdminPrince:Destroy() end end)

local ROW_H, LAYOUT_PADDING, VISIBLE_ROWS = 50, 6, 4
local VISIBLE_LIST_H = (ROW_H*VISIBLE_ROWS) + (LAYOUT_PADDING*(VISIBLE_ROWS-1))

local WINDOW_W = 300
local TOPBAR_H = 28
local OUTER_PADDING = 6
local MIN_BAR_HEIGHT = 20

local WINDOW_H = TOPBAR_H + OUTER_PADDING*2 + VISIBLE_LIST_H + OUTER_PADDING

local gui = Instance.new("ScreenGui")
gui.Name = "ScriptHub_AdminPrince"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.IgnoreGuiInset = true; gui.Parent = CoreGui

local container = Instance.new("Frame")
container.Size = UDim2.new(0, WINDOW_W, 0, WINDOW_H)
container.Position = UDim2.new(0.5, -WINDOW_W/2, 0.5, -WINDOW_H/2)
container.BackgroundTransparency = 1
container.Active = true
container.Parent = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(1,1)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = container
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", frame); stroke.Thickness = 1; stroke.Color = LIGHT_BLUE; stroke.Transparency = 0.35

-- Topbar
local topbar = Instance.new("Frame", frame)
topbar.Size = UDim2.new(1, -OUTER_PADDING*2, 0, TOPBAR_H)
topbar.Position = UDim2.new(0, OUTER_PADDING, 0, OUTER_PADDING)
topbar.BackgroundTransparency = 1
topbar.Active = true

-- Smooth drag (topbar-only)
do
    local dragging = false
    local dragStart
    local startPos

    local function findScrollable()
        local sf = nil
        pcall(function()
            sf = container:FindFirstChildWhichIsA("ScrollingFrame", true)
        end)
        return sf
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = container.Position
            local sf = findScrollable()
            if sf then sf.ScrollingEnabled = false end

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    local sf2 = findScrollable()
                    if sf2 then sf2.ScrollingEnabled = true end
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            container.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end


local titleLbl = Instance.new("TextLabel", topbar)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ADMIN PRINCE"
titleLbl.TextColor3 = LIGHT_BLUE
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Center

local function makeIcon(txt)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(0, 24, 0, 24)
    holder.AnchorPoint = Vector2.new(1, 0.5)
    holder.BackgroundTransparency = 1
    holder.Active = true

    local b = Instance.new("TextButton", holder)
    b.Size = UDim2.fromScale(1,1)
    b.AnchorPoint = Vector2.new(0.5, 0.5)
    b.Position = UDim2.fromScale(0.5, 0.5)
    b.Text = txt
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.BackgroundTransparency = 0.25
    b.AutoButtonColor = false
    b.Active = true
    b.TextColor3 = LIGHT_BLUE
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke", b); s.Thickness = 1; s.Color = LIGHT_BLUE; s.Transparency = 0.35
    return holder, b
end

local closeHolder, closeBtn       = makeIcon("×")
local minimizeHolder, minimizeBtn = makeIcon("–")
closeHolder.Parent = topbar; minimizeHolder.Parent = topbar

-- List container
local listHolder = Instance.new("Frame", frame)
listHolder.Size = UDim2.new(1, -OUTER_PADDING*2, 0, VISIBLE_LIST_H)
listHolder.Position = UDim2.new(0, OUTER_PADDING, 0, TOPBAR_H + OUTER_PADDING*2)
listHolder.BackgroundColor3 = Color3.fromRGB(30,30,30)
listHolder.BackgroundTransparency = 0.24
listHolder.Active = true
listHolder.ClipsDescendants = true
Instance.new("UICorner", listHolder).CornerRadius = UDim.new(0, 8)
local listStroke = Instance.new("UIStroke", listHolder); listStroke.Thickness = 1; listStroke.Color = LIGHT_BLUE; listStroke.Transparency = 0.45

local list = Instance.new("ScrollingFrame", listHolder)
list.Size = UDim2.new(1, -OUTER_PADDING*2, 1, -OUTER_PADDING*2)
list.Position = UDim2.new(0, OUTER_PADDING, 0, OUTER_PADDING)
list.CanvasSize = UDim2.new(0,0,0,0)
list.ScrollBarThickness = 6
list.BackgroundTransparency = 1
list.ScrollingDirection = Enum.ScrollingDirection.Y
list.ClipsDescendants = true
local layout = Instance.new("UIListLayout", list); layout.Padding = UDim.new(0, LAYOUT_PADDING)

-- Predeclare so rows can call it
local setMinimized

local ROW_SHRINK = 0
local RIGHT_PADDING = 35
local BTN_W, BTN_H, MARGIN = 64, 18, 6
local function addScriptRow(entry)
    local rowH = 50
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -ROW_SHRINK, 0, rowH)
    row.Position = UDim2.new(0, 0, 0, 0)
    row.BackgroundColor3 = Color3.fromRGB(40,40,40)
    row.BackgroundTransparency = 0.18
    row.Active = true
    row.Parent = list
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local rs = Instance.new("UIStroke", row); rs.Thickness = 1; rs.Color = LIGHT_BLUE; rs.Transparency = 0.5

    local rightW = BTN_W + RIGHT_PADDING

    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size = UDim2.new(1, -(rightW + 12), 1, -8)
    nameLbl.Position = UDim2.new(0, 8, 0, 4)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextSize = 13
    nameLbl.TextColor3 = LIGHT_BLUE
    nameLbl.Text = entry.name

    local col = Instance.new("Frame", row)
    col.Size = UDim2.new(0, rightW, 1, 0)
    col.Position = UDim2.new(1, -rightW, 0, 0)
    col.BackgroundTransparency = 1

    local runBtn = Instance.new("TextButton", col)
    runBtn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    runBtn.Position = UDim2.new(1, -BTN_W, 0, MARGIN)
    runBtn.Text = "Run"
    runBtn.BackgroundColor3 = Color3.fromRGB(70,140,70)
    runBtn.BackgroundTransparency = 0.15
    runBtn.AutoButtonColor = true
    runBtn.TextColor3 = LIGHT_BLUE
    Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 6)
    local s1 = Instance.new("UIStroke", runBtn); s1.Thickness = 1; s1.Color = LIGHT_BLUE; s1.Transparency = 0.45
    runBtn.MouseButton1Click:Connect(function()
        task.spawn(function() local ok, err = pcall(entry.run) end)
        if setMinimized then setMinimized(true) end
    end)

    if entry.stop then
        local stopBtn = Instance.new("TextButton", col)
        stopBtn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        stopBtn.Position = UDim2.new(1, -BTN_W, 1, -(BTN_H + MARGIN))
        stopBtn.Text = "Stop"
        stopBtn.BackgroundColor3 = Color3.fromRGB(140,70,70)
        stopBtn.BackgroundTransparency = 0.15
        stopBtn.AutoButtonColor = true
        stopBtn.TextColor3 = LIGHT_BLUE
        Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 6)
        local s2 = Instance.new("UIStroke", stopBtn); s2.Thickness = 1; s2.Color = LIGHT_BLUE; s2.Transparency = 0.45
        stopBtn.MouseButton1Click:Connect(function() pcall(entry.stop) end)
    end
end

for _, sc in ipairs(SCRIPTS) do addScriptRow(sc) end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    list.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + OUTER_PADDING)
end)

-- ===== Minimize / Close layout =====
local isMinimized = false
local function applyTopbarLayout(minimized)
    local btnSize = minimized and 18 or 24
    local fontSize = minimized and 12 or 16
    local posY = minimized and 2 or OUTER_PADDING
    local padX = minimized and 4 or OUTER_PADDING
    local topH = minimized and (MIN_BAR_HEIGHT - 4) or TOPBAR_H
    local gap = 6

    topbar.Size = UDim2.new(1, -padX*2, 0, topH)
    topbar.Position = UDim2.new(0, padX, 0, posY)

    titleLbl.Size = UDim2.new(1, -(btnSize*2 + gap + padX), 1, 0)
    titleLbl.Position = UDim2.new(0, 0, 0, 0)
    titleLbl.TextSize = fontSize

    closeHolder.Size    = UDim2.new(0, btnSize, 0, btnSize)
    minimizeHolder.Size = UDim2.new(0, btnSize, 0, btnSize)
    closeHolder.Position    = UDim2.new(1, -padX, 0.5, 0)
    minimizeHolder.Position = UDim2.new(1, -(padX + btnSize + gap), 0.5, 0)
end

function setMinimized(minimize)
    isMinimized = minimize
    if minimize then
        listHolder.Visible = false
        applyTopbarLayout(true)
        TweenService:Create(container, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, WINDOW_W, 0, MIN_BAR_HEIGHT),
            Position = UDim2.new(0.5, -WINDOW_W/2, 0, 8)
        }):Play()
    else
        applyTopbarLayout(false)
        TweenService:Create(container, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, WINDOW_W, 0, WINDOW_H),
            Position = UDim2.new(0.5, -WINDOW_W/2, 0.5, -WINDOW_H/2)
        }):Play()
        task.delay(0.18, function() listHolder.Visible = true end)
    end
end

minimizeBtn.MouseButton1Click:Connect(function() setMinimized(not isMinimized) end)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

applyTopbarLayout(false)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then gui.Enabled = not gui.Enabled end
end)



-- === Toast Control: show on script start, hide only when main menu closed ===
task.spawn(function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local pg = lp:WaitForChild("PlayerGui")

    -- Tampilkan toast saat script dijalankan
    if _G.PRINCE_TOAST and _G.PRINCE_TOAST.show then
        _G.PRINCE_TOAST.show({
            title = "PRINCE GANTENG",
            text  = "JOKI SUMIT KE TIKTOK\n@jasagendongsumitroblox"
        })
    end

    -- Cari GUI utama Admin Prince (berdasarkan nama yang ada di script)
    local hub = pg:FindFirstChild("ScriptHub_AdminPrince")
    if not hub then
        -- fallback: tunggu sebentar kalau dibuat belakangan
        hub = pg:WaitForChild("ScriptHub_AdminPrince", 5)
    end

    if hub then
        -- Sembunyikan toast bila GUI di-destroy atau keluar dari PlayerGui
        hub.AncestryChanged:Connect(function(_, parent)
            if not hub:IsDescendantOf(pg) then
                if _G.PRINCE_TOAST and _G.PRINCE_TOAST.hide then
                    _G.PRINCE_TOAST.hide()
                end
            end
        end)

        -- Juga sembunyikan saat semua Frame di dalam hub tidak ada yang Visible
        task.spawn(function()
            while hub.Parent and hub:IsDescendantOf(pg) do
                local anyVisible = false
                for _,d in ipairs(hub:GetDescendants()) do
                    if d:IsA("Frame") and d.Visible then anyVisible = True break end
                end
                if not anyVisible then
                    if _G.PRINCE_TOAST and _G.PRINCE_TOAST.hide then
                        _G.PRINCE_TOAST.hide()
                    end
                    break
                end
                task.wait(0.3)
            end
        end)
    else
        -- Jika GUI utama tidak ditemukan, biar toast auto hilang setelah 10 detik agar tidak mengganggu
        task.delay(10, function()
            if _G.PRINCE_TOAST and _G.PRINCE_TOAST.hide then
                _G.PRINCE_TOAST.hide()
            end
        end)
    end
end)
-- === End Toast Control ===
