if #arg < 2 then
    error("Error: usage: run sysd <action> <service>")
end

local action = arg[1]
local service = arg[2]

local cmd
if action == "on" then
    cmd = "systemctl --user enable " .. service
elseif action == "off" then
    cmd = "systemctl --user disable " .. service
elseif action == "reload" then
    cmd = "systemctl --user restart systemd"
else
    error("Error: unknown subcommand: " .. action)
end

local result = os.execute(cmd)

if result then
    print("[OK] " .. action .. " " .. service)
else
    print("[FAIL] " .. action .. " " .. service)
end
