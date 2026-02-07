local ols = {}

ols.t = {}

function ols.t.log(text)
    local home = os.getenv("HOME") or os.getenv("USERPROFILE")
    local file = io.open(home.."/OLS/logs.log", "a")
    file:write(string.format("%s [ols][venv] %s", os.date("%Y-%m-%d %H:%M:%S"), text))
end

return ols