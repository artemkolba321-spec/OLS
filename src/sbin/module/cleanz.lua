if #arg < 1 then
    print("Error: Please specify at least one argument")
    os.exit(1)
end

if arg[1] == "log" then
    os.execute(': > ~/.local/share/OLS/logs.log')
    print("done!")
elseif arg[1] == "tmp" then
    os.execute('mkdir -p ~/.cache/OLS')
    os.execute('rm -rf ~/.cache/OLS/*')
    print("done!")
else
    print("Unknown target: " .. arg[1])
    os.exit(1)
end
