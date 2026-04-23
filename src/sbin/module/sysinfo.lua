if #arg < 1 then
    print("Error: Please specify at least one argument")
    os.exit(1)
end

if arg[1] == "cpu" then
    os.execute("lscpu")
elseif arg[1] == "ram" then
    os.execute("free -h")
elseif arg[1] == "disk" then
    os.execute("df -h")
elseif arg[1] == "la" then
    os.execute("uptime")
elseif arg[1] == "inode" then
    os.execute('df -i')
else
    print("Unknown target: " .. arg[1])
end
