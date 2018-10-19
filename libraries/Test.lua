requiredFiles({"Object"})

local Test = Objects["Object"]:extend()
Test.__index = Test

function Test.new(self, opts)
	print(self)
	local self = self or setmetatable({}, Test)
	print(self)
    local opts = opts or {}
    if opts then
        for k, v in pairs(opts) do
            print(k)
            print(v)
            self[k] = v
        end
    end
    print(self)
    return self
end

function Test:draw()
	if (self.text) then
    	love.graphics.print(self.text, 400, 300)
	end
end

return Test