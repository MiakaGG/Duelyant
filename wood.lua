-- file for wood that is breakable and destroyable will drop one wood to add 

woods = {}

function spawnWood(x, y, width, height)
    local wood = world:newRectangleCollider(x, y, width, height, {collision_class = "Wood"})
    wood:setObject(self)
    wood:setType('static')
    table.insert(woods, wood)
end 

function woodUpdate(dt)
    local i = #woods
    for i=#woods,1,-1 do
        local w = woods[i]
        if w.dead == true then
            table.remove(woods, i)
        end
    end
end 