Objects = {}
local RequiresTree = {}
local test = nil

function recursiveEnumerate(folder)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
        	RequiresTree[item:sub(1, -5)] = file:sub(1, -5)
        elseif love.filesystem.isDirectory(file) then
        	RequiresTree[item] = file
            recursiveEnumerate(file)
        end
    end
end

function requiredFiles(files)
	for _,file in pairs(files) do
		if RequiresTree[file] then
			Objects[file] = require(RequiresTree[file])
		else
			error("File " .. file .. " requested. Unable to locate in libraries directory.")
		end
	end
end

function love.load()
	recursiveEnumerate('libraries')
	requiredFiles({"Test"})

	test = Objects["Test"].new(nil, {["text"] = "Hello World!"})
end

function love.draw()
	test:draw()
end