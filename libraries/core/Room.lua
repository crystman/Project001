requiredFiles({"Object", "Area"})

local Room = Objects["Object"]:extend()
Room.__index = Room

function Room.new(self, name, destroy)
    local self = self or setmetatable({}, Room)
    self.name = name
    self.active = false
    self.area = self.area or Objects["Area"].new(self)
    self.destroy = destroy
    return self
end

function Room:update(dt)
    self.area:update(dt)
end

function Room:draw()
    self.area:draw()
end

function Room:activate()
    active = true
end

function Room:deactivate()
    active = false
end

function Room:isActive()
    return active
end

function Room:mousepressed(x, y, button)

end

function Room:keypressed(key)

end

function Room:destroyRoom()
    self:deactivate()
    self.area:destroy()
    self.area = nil
end

return Room
