requiredFiles({"Rectangle", "Room"})

local RectangleRoom = Objects["Room"]:extend()
RectangleRoom.__index = RectangleRoom

function RectangleRoom.new(...)
    local self = setmetatable({}, RectangleRoom)
    self = RectangleRoom.super.new(self, ...)
    self:generateRectangles()
    return self
end

function RectangleRoom:draw()
    RectangleRoom.super.draw(self)
end

function RectangleRoom:update(dt)
    RectangleRoom.super.draw(self)
end

function RectangleRoom:keypressed(key)
    if key == "d" then
        allobjects = self.area:getGameObjects()
        if allobjects then 
            val = love.math.random(#allobjects)
            allobjects[val]:kill()
            if #allobjects <= 1 then
                self:generateRectangles()
            end
        end
    end
end

function RectangleRoom:mousepressed(x, y, button)
    if button == 1 then
        local objects = self.area:queryCircleArea(x, y, 100, {'wall'})
        for _, value in pairs(objects) do 
            value.red = 255
            value.green = 0
            value.blue = 0
        end
    elseif button == 2 then
        local objects = self.area:getClosestObjects(x, y, {'wall'})
        for _, value in pairs(objects) do 
            value.red = 0
            value.green = 255
            value.blue = 0
        end
    end
end

function RectangleRoom:generateRectangles()
    for i = 1, 10 do
        self:generateRectangle(i)
    end
end

function RectangleRoom:generateRectangle(id)
    local widthFraction = width / 10
    local heightFraction = height / 10
    local x = love.math.random(widthFraction, (width - widthFraction))
    local y = love.math.random(heightFraction, (height - heightFraction))
    self.area:addGameObject("Rectangle", x, y, {['width'] = love.math.random(50, 100), ['height'] = love.math.random(50, 100), ['id'] = ("Rectangle" .. id), ['category'] = 'wall', ['bodytype'] = "dynamic"})
end

return RectangleRoom
