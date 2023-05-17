-- file for wood that is breakable and destroyable will drop one wood to add 

woods = {}

function spawnWood(x, y, width, height)
    local wood = {}
    local woodCollider = world:newRectangleCollider(x, y, width, height, {collision_class = "Wood"})
    woodCollider:setObject(self)
    wood.dead = false
    woodCollider:setType('static')
    table.insert(woods, wood)
end 

function woods:update(dt)
    local i = #woods
    for i=#woods,1,-1 do
        local w = woods[i]
        if w.dead == true then
            table.remove(woods, i)
        end
    end
end 


