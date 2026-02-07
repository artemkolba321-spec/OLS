local lfs = require("lfs")
local json = require("dkjson") -- или другой JSON парсер для Lua

local HOME = os.getenv("HOME")
local PLUGINS_PATH = HOME .. "/OLS/plugins"

-- ===================== utils =====================

local function days_since(date_str)
    local y, m, d = date_str:match("(%d+)%-(%d+)%-(%d+)")
    if not y then
        return math.huge
    end
    local t = os.time({year = tonumber(y), month = tonumber(m), day = tonumber(d)})
    return os.difftime(os.time(), t) / 86400
end

local function load_package_json(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    local obj, pos, err = json.decode(content, 1, nil)
    if err then
        return nil
    end
    return obj
end

local function remove_dir(path)
    os.execute('rm -rf "' .. path .. '"')
end

-- ===================== index plugins =====================

local plugin = {}

for dir in lfs.dir(PLUGINS_PATH) do
    if dir ~= "." and dir ~= ".." then
        local fullpath = PLUGINS_PATH .. "/" .. dir

        if lfs.attributes(fullpath, "mode") == "directory" then
            local package_json = fullpath .. "/package.json"
            local pkg = load_package_json(package_json)

            if pkg then
                plugin[dir] = {
                    path = fullpath,
                    info = pkg
                }
            else
                print("[OLS-ENV] Broken plugin (no package.json or invalid): " .. dir)
            end
        end
    end
end

-- ===================== health check =====================

print("[OLS-ENV] Checking plugins health...\n")

for name, data in pairs(plugin) do
    local info = data.info
    local last = info.last_update

    if not last then
        print("[OLS-ENV] Plugin '" .. name .. "' has no last_update field")
        goto continue
    end

    local age_days = days_since(last)
    local age_years = age_days / 365

    -- Warning level
    if age_years > 2 and age_years <= 10 then
        print(string.format(
            "[OLS-ENV][WARN] Plugin '%s' is %.1f years old (last update: %s)",
            name, age_years, last
        ))
    end

    -- Critical level
    if age_years > 20 then
        io.write(string.format(
            "[OLS-ENV][CRITICAL] Plugin '%s' is %.1f years old (last update: %s)\nRemove it? [y/N]: ",
            name, age_years, last
        ))

        local resp = io.read()
        if resp and resp:lower() == "y" then
            remove_dir(data.path)
            print("[OLS-ENV] Plugin '" .. name .. "' removed\n")
        else
            print("[OLS-ENV] Keeping plugin '" .. name .. "'\n")
        end
    end

    ::continue::
end

print("\n[OLS-ENV] Check complete.")
