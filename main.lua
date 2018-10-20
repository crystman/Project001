-- Global properties
height = love.graphics.getHeight()
width = love.graphics.getWidth()
Objects = {}
timer = nil
input = nil

local RequiresTree = {}
local Rooms = {}
local current_room = nil

function recursiveEnumerate(folder)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local address = folder .. '/' .. item
        local info = love.filesystem.getInfo(address)
        if info.type == 'file' then
			RequiresTree[item:sub(1, -5)] = address:sub(1, -5)
		elseif info.type == 'directory' then
        	RequiresTree[item] = address
            recursiveEnumerate(address)
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
	requiredFiles({"Timer", "Input"})

	timer = Objects["Timer"]()
	input = Objects["Input"]()

    input:bind('space', 'space')

	requiredFiles({"Test"})	
end

function love.update(dt)
	timer:update(dt)
	if current_room then 
		current_room:update(dt) 
	end
	if input:pressed('space') then 
		gotoRoom('RectangleRoom', 'rr1', false)
	end
end

function love.draw()
	if current_room then 
		current_room:draw()
	else
		love.graphics.print("Main", 400, 300)
	end
end

function love.mousepressed(x, y, button)
	if current_room then current_room:mousepressed(x, y, button) end
	if button == 1 then 
	elseif button == 2 then
	end
end

function gotoRoom(room_type, room_name, ...)
	if current_room and current_room.destroy then
		current_room:destroyRoom()
		Rooms[current_room.name] = nil
	elseif current_room then
		current_room:deactivate()
	end
    if Rooms[room_name] then
        current_room = Rooms[room_name]
    else 
    	current_room = addRoom(room_type, room_name, ...) 
    end
    current_room:activate() 
end

function addRoom(room_type, room_name, ...)
	requiredFiles({room_type})
    Rooms[room_name] = Objects[room_type].new(room_name, ...)
    return Rooms[room_name]
end