-- Waypoint TP Auto — No UI, Auto Start (PINGPONG)
-- Start otomatis, bolak-balik Base ⇄ Puncak
-- Hotkey: Y = toggle Start/Stop

-- ==== Services ====
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local function notify(t,d)
	pcall(function() StarterGui:SetCore("SendNotification",{Title="TP Auto",Text=t,Duration=d or 1.8}) end)
	print("[TP-AUTO] "..t)
end

-- ==== Data awal (dari kamu) ====
local WAYPOINTS = {
	{pos=Vector3.new(-7.00, 13.73, -8.00),    alt=14,   time="2025-08-13 05:14:27Z"},
	{pos=Vector3.new(-622.00, 250.10, -384.00),alt=250,  time="2025-08-13 05:14:32Z"},
	{pos=Vector3.new(-1203.00, 261.47, -487.00),alt=261, time="2025-08-13 05:14:36Z"},
	{pos=Vector3.new(-1398.96, 578.21, -950.42),alt=578, time="2025-08-13 05:14:40Z"},
	{pos=Vector3.new(-1701.00, 816.41, -1400.00),alt=816, time="2025-08-13 05:14:43Z"},
	{pos=Vector3.new(-1972.00, 842.21, -1672.00),alt=842, time="2025-08-13 05:14:48Z"},
	{pos=Vector3.new(-2807.00, 1635.71, -2478.00),alt=1636, time="2025-08-13 05:14:52Z"},
	{pos=Vector3.new(-3231.00, 1713.38, -2591.00),alt=1713, time="2025-08-13 05:14:56Z"},
}

-- ==== Helpers ====
local function sortByAlt() table.sort(WAYPOINTS, function(a,b) return a.alt < b.alt end) end
local function autoLabel()
	if #WAYPOINTS == 0 then return end
	sortByAlt()
	for i,wp in ipairs(WAYPOINTS) do
		if i == 1 then wp.label = "Base"
		elseif i == #WAYPOINTS then wp.label = "Puncak"
		else wp.label = "Camp "..tostring(i) end
	end
end
local function tp_to(vec3)
	local char = lp.Character or lp.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	pcall(function() hrp.CFrame = CFrame.new(vec3) end)
end
autoLabel()

-- ==== Safety & Auto Runner ====
local SAFE = {
	settleTime = 0.20,              -- diam sebentar setelah TP
	delayOverridesSec = {           -- ekstra delay di titik tertentu
		["Base"]   = 0.50,
		["Puncak"] = 0.80,
	}
}

local AUTO = {
	running=true,            -- auto start
	mode="PINGPONG",         -- bolak-balik
	idx=1, step=1,
	userMax=3.0,             -- jeda dasar per waypoint (detik)
}

local function autoStep()
	local n = #WAYPOINTS
	if n == 0 then return false end
	AUTO.idx = math.clamp(AUTO.idx, 1, n)
	local wp = WAYPOINTS[AUTO.idx]

	-- Teleport
	tp_to(wp.pos)

	-- Settle
	local t0 = os.clock()
	while os.clock() - t0 < SAFE.settleTime do task.wait() end

	-- Hitung total jeda: dasar + override label (jika ada)
	local extra = SAFE.delayOverridesSec[wp.label] or 0
	local waitUntil = os.clock() + AUTO.userMax + extra
	while AUTO.running and os.clock() < waitUntil do task.wait(0.05) end

	-- Next index (PINGPONG)
	if AUTO.mode == "PINGPONG" then
		AUTO.idx = AUTO.idx + AUTO.step
		if AUTO.idx >= n then AUTO.idx = n; AUTO.step = -1 end
		if AUTO.idx <= 1 then AUTO.idx = 1; AUTO.step = 1 end
	else
		AUTO.idx = AUTO.idx + 1; if AUTO.idx > n then AUTO.idx = 1 end
	end
	return true
end

local function autoLoop()
	if not AUTO.running then return end
	notify(("Start auto (%s, %.1fs)"):format(AUTO.mode, AUTO.userMax),1.2)
	task.spawn(function()
		while AUTO.running do
			local ok = autoStep()
			if not ok then break end
		end
		notify("Stop auto",1.0)
	end)
end

local function autoStop() AUTO.running = false end
local function autoStart()
	if AUTO.running then return end
	AUTO.running = true
	autoLoop()
end

-- Hotkey darurat: Y untuk toggle
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.Y then
		if AUTO.running then autoStop() else autoStart() end
	end
end)

-- Mulai sekarang
autoLoop()
