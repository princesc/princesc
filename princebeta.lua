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
        if GDNState.running then return end
        GDNState.running = true
        local player = Players.LocalPlayer
        local TELEPORT_DELAY, JITTER, LOOP_PAUSE = 0.75, 0.15, 1.0
        local Y_OFFSET, HEAL_CHECK = 6, 0.15
        local rng = Random.new()
        local teleportLocations = {
            Vector3.new(-621.52, 250.26, -383.50),
            Vector3.new(-1202.22, 261.63, -486.78),
            Vector3.new(-1398.98, 578.32, -949.40),
            Vector3.new(-1700.21, 816.68, -1398.28),
            Vector3.new(-3222.09, 1715.10, -2601.32)
        }
        local function fastSafeTeleportLoop(character)
            local hrp = character:WaitForChild("HumanoidRootPart", 5); if not hrp then return end
            task.spawn(function()
                while GDNState.running and hrp and hrp.Parent do
                    for _, pos in ipairs(teleportLocations) do
                        if not GDNState.running then break end
                        pcall(function() hrp.CFrame = CFrame.new(pos + Vector3.new(0, Y_OFFSET, 0)) end)
                        task.wait(TELEPORT_DELAY + rng:NextNumber(0, JITTER))
                    end
                    task.wait(LOOP_PAUSE)
                end
            end)
        end
        local function setHealthLoop(humanoid)
            task.spawn(function()
                while GDNState.running and humanoid and humanoid.Parent do
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
            local hrp = character:WaitForChild("HumanoidRootPart", 5)
            if humanoid and hrp then setHealthLoop(humanoid); fastSafeTeleportLoop(character) end
        end
        table.insert(GDNState.conns, player.CharacterAdded:Connect(onCharacterAdded))
        if player.Character then onCharacterAdded(player.Character) end
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
        --[[ MISC ONLY: Teleport to Player (Final, tombol rapi & teks pas) ]]--

        -- efek klik (opsional)
        local function klik(btn)
            pcall(function()
                local s = Instance.new("Sound")
                s.SoundId = "rbxassetid://9118823104"
                s.Volume = 1
                s.PlayOnRemove = true
                s.Parent = btn
                s:Destroy()
            end)
        end

        -- notif helper
        local function notif(txt)
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "🔔 Teleport Misc",
                    Text = tostring(txt),
                    Duration = 3
                })
            end)
        end

        local Players = game:GetService("Players")
        local player = Players.LocalPlayer

        -- Bersihkan GUI lama jika ada
        pcall(function()
            if game.CoreGui:FindFirstChild("TeleportMisc_GUI") then
                game.CoreGui.TeleportMisc_GUI:Destroy()
            end
        end)

        -- ===== GUI =====
        local gui = Instance.new("ScreenGui")
        gui.Name = "TeleportMisc_GUI"
        gui.ResetOnSpawn = false
        gui.Parent = game.CoreGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 230)
        frame.Position = UDim2.new(0.5, -150, 0.5, -115)
        frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
        frame.BackgroundTransparency = 0.15
        frame.Active = true
        frame.Draggable = true
        frame.BorderSizePixel = 0
        frame.Parent = gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(255,165,0)
        stroke.Thickness = 2

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -60, 0, 28)
        title.Position = UDim2.new(0, 10, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = "🎯 Teleport Player (Misc)"
        title.TextColor3 = Color3.fromRGB(255,255,255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = frame

        -- close/minimize
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0,26,0,26)
        closeBtn.Position = UDim2.new(1,-32,0,6)
        closeBtn.Text = "X"
        closeBtn.BackgroundColor3 = Color3.fromRGB(200,40,40)
        closeBtn.TextColor3 = Color3.new(1,1,1)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 14
        closeBtn.Parent = frame
        Instance.new("UICorner", closeBtn)

        local minBtn = closeBtn:Clone()
        minBtn.Text = "-"
        minBtn.BackgroundColor3 = Color3.fromRGB(255,170,0)
        minBtn.Position = UDim2.new(1,-64,0,6)
        minBtn.Parent = frame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0,160,0,28)
        toggleBtn.Position = UDim2.new(0,10,0,10)
        toggleBtn.Text = "🎯 Tampilkan Teleport"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
        toggleBtn.TextColor3 = Color3.new(1,1,1)
        toggleBtn.Font = Enum.Font.Gotham
        toggleBtn.TextSize = 14
        toggleBtn.Visible = false
        toggleBtn.Parent = gui
        Instance.new("UICorner", toggleBtn)

        -- helper tombol
        local function newBtn(parent, text, bg)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0)
            b.Text = text
            b.BackgroundColor3 = bg
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.Font = Enum.Font.Gotham
            b.TextSize = 14 -- teks aman
            b.Parent = parent
            Instance.new("UICorner", b)
            return b
        end

        -- ===== Konten MISC =====
        local playerListBtn = Instance.new("TextButton")
        playerListBtn.Size = UDim2.new(0.8, 0, 0, 36)
        playerListBtn.Position = UDim2.new(0.1, 0, 0, 44)
        playerListBtn.Text = "📋 Buka/Tutup Player List"
        playerListBtn.BackgroundColor3 = Color3.fromRGB(150,150,0)
        playerListBtn.TextColor3 = Color3.new(1,1,1)
        playerListBtn.Font = Enum.Font.Gotham
        playerListBtn.TextSize = 14
        playerListBtn.Parent = frame
        Instance.new("UICorner", playerListBtn)

        local scroll = Instance.new("ScrollingFrame")
        scroll.Position = UDim2.new(0.1, 0, 0, 84)
        scroll.Size = UDim2.new(0.8, 0, 0, 96)
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.Visible = false
        scroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4
        scroll.Parent = frame
        Instance.new("UICorner", scroll)

        local selectedName = nil

        local Players = game:GetService("Players")
        local player = Players.LocalPlayer

        local function refreshList()
            scroll:ClearAllChildren()
            local y = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player then
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -4, 0, 26)
                    btn.Position = UDim2.new(0, 2, 0, y)
                    btn.Text = plr.Name
                    btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
                    btn.TextColor3 = Color3.new(1,1,1)
                    btn.Font = Enum.Font.Gotham
                    btn.TextSize = 14
                    btn.Parent = scroll
                    Instance.new("UICorner", btn)

                    btn.MouseButton1Click:Connect(function()
                        klik(btn)
                        selectedName = plr.Name
                        notif("Player Dipilih: "..plr.Name)
                    end)
                    y += 30
                end
            end
            scroll.CanvasSize = UDim2.new(0, 0, 0, y)
        end

        playerListBtn.MouseButton1Click:Connect(function()
            klik(playerListBtn)
            scroll.Visible = not scroll.Visible
        end)

        -- === ROW tombol sejajar ===
        local buttonRow = Instance.new("Frame")
        buttonRow.Size = UDim2.new(0.8, 0, 0, 36)
        buttonRow.Position = UDim2.new(0.1, 0, 1, -46)
        buttonRow.BackgroundTransparency = 1
        buttonRow.Parent = frame

        local rowLayout = Instance.new("UIListLayout", buttonRow)
        rowLayout.FillDirection = Enum.FillDirection.Horizontal
        rowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        rowLayout.Padding = UDim.new(0, 8)

        -- kiri (Teleport) lebih sempit
        local leftCell = Instance.new("Frame", buttonRow)
        leftCell.Size = UDim2.new(0.45, -4, 1, 0)
        leftCell.BackgroundTransparency = 1
        local tpBtn = newBtn(leftCell, "🚀 TELEPORT", Color3.fromRGB(255,170,0))

        -- kanan (Refresh) lebih lebar
        local rightCell = Instance.new("Frame", buttonRow)
        rightCell.Size = UDim2.new(0.55, -4, 1, 0)
        rightCell.BackgroundTransparency = 1
        local refreshBtn = newBtn(rightCell, "🔄 REFRESH PLAYER", Color3.fromRGB(0,170,255))

        -- === Logic tombol ===
        tpBtn.MouseButton1Click:Connect(function()
            klik(tpBtn)
            if not selectedName then
                notif("Pilih Player dulu!")
                return
            end
            local target = Players:FindFirstChild(selectedName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = player.Character or player.CharacterAdded:Wait()
                local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    myHRP.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
                    notif("Teleport ke "..selectedName)
                else
                    notif("Gagal: HumanoidRootPart kamu tidak ditemukan")
                end
            else
                notif("Gagal: Player tidak ditemukan")
            end
        end)

        refreshBtn.MouseButton1Click:Connect(function()
            klik(refreshBtn)
            refreshList()
            notif("Daftar Player Diperbarui")
        end)

        -- auto-refresh saat player join/leave
        Players.PlayerAdded:Connect(function()
            if scroll.Visible then refreshList() end
        end)
        Players.PlayerRemoving:Connect(function(plr)
            if selectedName == plr.Name then selectedName = nil end
            if scroll.Visible then refreshList() end
        end)

        -- minimize/close/toggle
        local minimized = false
        minBtn.MouseButton1Click:Connect(function()
            klik(minBtn)
            minimized = not minimized
            frame.Visible = not minimized
            toggleBtn.Visible = minimized
        end)
        toggleBtn.MouseButton1Click:Connect(function()
            klik(toggleBtn)
            frame.Visible = true
            toggleBtn.Visible = false
        end)
        closeBtn.MouseButton1Click:Connect(function()
            klik(closeBtn)
            gui:Destroy()
        end)

        -- init
        refreshList()
        notif("Teleport Misc siap dipakai 🎯")
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
-- frame.Draggable removed; using smooth drag handler
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
        -- Cari ScrollingFrame di dalam container untuk dimatikan sementara saat drag
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

-- Tambah: perkecil lebar setiap row agar tombol makin ke kiri
local ROW_SHRINK = 0  -- px dikurangi dari lebar row

-- Row builder (RIGHT_PADDING = 54, old-style buttons 64x18)
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
    runBtn.Position = UDim2.new(1, -BTN_W, 0, MARGIN) -- RIGHT_PADDING handled by parent width
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
