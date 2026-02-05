local plugin = {}

plugin.opt = {}
plugin.t = {}
function valid(value, valid, name)
    if type(value) ~= valid then
        error(string.format("Invalid type: %s"), name or "value")
    end
end
function plugin.opt:meta(meta) 
	valid(meta, "table", "meta")

    valid(meta.name, "string", "name")
    valid(meta.version, "number", "version")
    valid(meta.author, "string", "author")

    self.meta = meta
    local file = io.open("package.conf", 'w')
    file:write("name = "..self.meta.name)
    file:write("version = "..self.meta.version)
    file:write("author = "..self.meta.author)
    
    file:close()
end

return plugin
