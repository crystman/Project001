requiredFiles({"GameObject"})

local Rectangle = Objects["GameObject"]:extend()
Rectangle.__index = Rectangle

function Rectangle.new(self, area, x, y, opts)
    local self = self or setmetatable({}, Rectangle)
    opts["shapeType"] = "Rectangle"
    self = Rectangle.super.new(self, area, x, y, opts)
    if not self.width or not self.height then
        error("Width or Height missing in Rectangle")
    end
    return self
end

function Rectangle:draw()
    Rectangle.super.draw(self)
    love.graphics.polygon("fill", self.shape:getWorldPoints(self.shape:getPoints()))
end

function Rectangle:update(dt)
    Rectangle.super.update(self, dt)
end

return Rectangle


