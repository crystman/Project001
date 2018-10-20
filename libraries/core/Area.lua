requiredFiles({"windfield", "Object", "Rectangle"})

local Area = Objects["Object"]:extend()
Area.__index = Area

function Area.new(room, boundaries, gravity)
    local self = setmetatable({}, Area)
    self.room = room
    self.game_objects = {}

    if gravity then
        self.world = Objects["windfield"].newWorld(gravity['x'], gravity['y'], true)
    else
        self.world = Objects["windfield"].newWorld(0, 512, true)
    end
    self.world:setQueryDebugDrawing(true)
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    self.world:addCollisionClass("wall")
    self.world:addCollisionClass("projectile")
    if boundaries == nil or boundaries then
        self:generateWalls()
    end
    return self
end

function Area:update(dt)
    self.world:update(dt)
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)

        if game_object.dead then
            game_object:destroy()
            self:removeGameObject(i)
        end
    end
end

function Area:draw()
    self.world:draw()
    for _, game_object in ipairs(self.game_objects) do
        game_object:draw()
    end
end

function Area:addGameObject(game_object_type, x, y, opts)
    local opts = opts or {}
    local game_object = Objects[game_object_type].new(nil, self, x, y, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:generateWalls()
    self:addGameObject("Rectangle", 5, height - 15, {['width'] = width - 10, ['height'] = 10, ['id'] = ("Bottom Edge Wall"), ['bodyType'] = 'static', ['category'] = 'wall'})
    self:addGameObject("Rectangle", 5, 5, {['width'] = width - 10, ['height'] = 10, ['id'] = ("Top Edge Wall"), ['bodyType'] = 'static', ['category'] = 'wall'})
    self:addGameObject("Rectangle", 5, 5, {['width'] = 10, ['height'] = height - 10, ['id'] = ("Left Edge Wall"), ['bodyType'] = 'static', ['category'] = 'wall'})
    self:addGameObject("Rectangle", width - 15, 5, {['width'] = 10, ['height'] = height - 10, ['id'] = ("Right Edge Wall"), ['bodyType'] = 'static', ['category'] = 'wall'})
end

function Area:removeGameObject(id)
    table.remove(self.game_objects, id)
end

function Area:getGameObjects()
    local objects = {}
    for _, game_object in ipairs(self.game_objects) do
        if not string.match(game_object.id, 'Edge Wall') then
            table.insert(objects, game_object)
        end
    end
    return objects
end

function Area:getAllGameObjects()
    return self.game_objects
end

function Area:getGameObjectByID(id)
    for _, game_object in ipairs(self.game_objects) do
        if game_object.id == id then
            return game_object
        end
    end
    return nil
end

function Area:queryCircleArea(x, y, r, collision_classes)
    local objects = {}
    local colliders = self.world:queryCircleArea(x, y, r, collision_classes)
    for _, collider in ipairs(colliders) do
        table.insert(objects, collider:getObject())
    end
    return objects
end

function Area:getClosestObjects(x, y, collision_classes, radius_increment)
    local objects = {}
    local r = 1
    local radius_increment = radius_increment or 5
    local found = false
    while not found do
        local colliders = self.world:queryCircleArea(x, y, r, collision_classes)
        for _, collider in ipairs(colliders) do
            table.insert(objects, collider:getObject())
        end
        if (#objects > 0) then
            found = true
        end
        r = r + radius_increment
    end
    return objects
end

function Area.inRange(x1, y1, x2, y2, distance)
    local dx = x1 - x2
    local dy = y1 - y2
    local diff = math.sqrt(dx * dx + dy * dy)
    return (diff < distance)
end

function Area:destroy()
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:destroy()
        table.remove(self.game_objects, i)
    end
    self.game_objects = {}

    if self.world then
        self.world:destroy()
        self.world = nil
    end
end

function beginContact(a, b, coll)
    if a:getUserData() and b:getUserData() then
        local x, y = coll:getNormal()
        local object_a = a:getUserData():getObject()
        local object_b = b:getUserData():getObject()
        -- print(object_a.id .. " contacting " .. object_b.id)

        local player = find(object_a, object_b, "Player")
        if player then
            player[1]:contact(player[2], coll)
        end
        local projectile = find(object_a, object_b, "Projectile")
        if projectile then
            projectile[1]:contact(projectile[2], coll)
        end
    end
end

function find(object_a, object_b, name)
    if string.find(object_a.id, name) then
        return {object_a, object_b}
    elseif string.find(object_b.id, name) then
        return {object_b, object_a}
    end
    return nil
end

function endContact(a, b, coll)
    -- if a:getUserData() and b:getUserData() then
    --     object_a = a:getUserData():getObject().id
    --     object_b = b:getUserData():getObject().id
    -- end
end

function preSolve(a, b, coll)
    -- local object_a = a:getUserData():getObject()
    -- local object_b = b:getUserData():getObject()
    -- print(object_a.id .. " presolve " .. object_b.id)
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
    -- local object_a = a:getUserData():getObject()
    -- local object_b = b:getUserData():getObject()
    -- print(object_a.id .. " postolve " .. object_b.id)
end

return Area
