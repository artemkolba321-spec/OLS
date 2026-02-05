local plugin = {}

plugin.opt = {}
plugin.t = {}

export type: meta = {
	name: string,
	version: number,
	author: string
}

function plugin.meta(meta: meta) 
	self.meta = meta
	
end
