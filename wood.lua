-- wood.lua

-- TODO: Refactor this and make it an object could possibly just get rid of it for now 

local Wood = {}
Wood.__index = Wood

function Wood.new(x, y, width, height)
    local wood = setmetatable({}, Wood)
    wood.collider = world:newRectangleCollider(x, y, width, height, {collision_class = "Wood"})
    wood.collider:setObject(wood)
    wood.dead = false
    return wood
end

function Wood:update(dt)
    -- Additional wood update logic
end

function Wood:draw()
    -- Additional wood draw logic
end

-- Create and manage woods
local woods = {}

function spawnWood(x, y, width, height)
    local wood = Wood.new(x, y, width, height)
    table.insert(woods, wood)
end

function updateWoods(dt)
    for i = #woods, 1, -1 do
        local wood = woods[i]
        wood:update(dt)
        -- Additional wood update logic
        
        if wood.dead then
            wood.collider:destroy()
            table.remove(woods, i)
        end
    end
end

function drawWoods()
    for i, wood in ipairs(woods) do
        wood:draw()
    end
end

return {
    spawnWood = spawnWood,
    updateWoods = updateWoods,
    drawWoods = drawWoods
}

