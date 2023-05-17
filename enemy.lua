enemies = {}

function spawnEnemy(x, y, width, height)
    local enemy = world:newRectangleCollider(x, y, width, height, {collision_class = "Enemy"})
    enemy:setObject(self)
    enemy:setType('dynamic')
    table.insert(enemies, enemy)
end 


function enemyUpdate(dt)
    for i=#enemies,1,-1 do
        local e = enemies[i]
        if e.dead == true then
            table.remove(enemies, i)
        end
    end
end 