requiredFiles({"Object", "Timer"})

local GameObject = Objects["Object"]:extend()
GameObject.__index = GameObject

function GameObject.new(self, area, x, y, opts)
    local self = self or setmetatable({}, GameObject)
    local opts = opts or {}
    if opts then
        for k, v in pairs(opts) do
            self[k] = v
        end
    end
    self.x = x
    self.y = y
    self.area = area
    self.id = self.id or UUID()
    self.dead = false
    self.lifespan = self.lifespan or (-1)
    self.red = self.red or love.math.random(255)
    self.green = self.green or love.math.random(255)
    self.blue = self.blue or love.math.random(255)
    self.alpha = self.alpha or 255
    self.timer = Objects["Timer"]()
    if (self.lifespan > 0) then
        timer:after(self.lifespan, function() self:kill() end)
    end

    --physics world stuff
    self.bodyType = self.bodyType or 'dynamic'
    self.category = self.category or 'wall'
    if self.shapeType == "Rectangle" then
        self.shape = self.area.world:newRectangleCollider(self.x, self.y, self.width, self.height)
    elseif self.shapeType == "Circle" then
        self.shape = self.area.world:newCircleCollider(self.x, self.y, self.radius)
    else
        error("no shape defined")
    end
    self.shape:setRestitution(0.8)
    self.shape:setCollisionClass(self.category)
    self.shape:setType(self.bodyType)
    self.shape:setObject(self)

    self.collisions = {}
    return self
end

function GameObject:update(dt)
    self.timer:update(dt)
end

function GameObject:draw()
    love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
end

function GameObject:kill()
    self.dead = true
end

function GameObject:mousepressed(x, y, button)

end

function GameObject:keypressed(key)

end

function GameObject:containsPoint(x, y)

end

function GameObject:contact(object, collision)

end

function GameObject:destroy()
    if self.shape then
        self.shape:destroy()
        self.shape = nil
    end
end

return GameObject
