local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and self.Name == "KickExploitEvent" then
        -- Optional cek pesan
        if args[1] and (args[1] == "BodyAngularVelocity exploit detected"
        or args[1] == "BodyGyro exploit detected"
        or args[1] == "BodyVelocity exploit detected") then
            print("EZ")
            return
        end
    end
    return oldNamecall(self, ...)
end

setreadonly(mt, true)
print("Bypass Anti Fly")

-- === Notifikasi berhasil jalan ===
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Prince Ganteng",
        Text = "Done ✅",
        Duration = 3
    })
end)
