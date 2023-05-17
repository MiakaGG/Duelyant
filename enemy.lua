enemies = {}

function spawnEnemy(x, y, width, height, args)
    local enemy = world:newRectangleCollider(x, y, width, height, {collision_class = "Enemy"})
    enemy.speed = 100
    enemy.dir = 1
    enemy.animation = animations.enemy
    table.insert(enemies, enemy)
end 


function enemies:update(dt)
    for i,e in ipairs(enemies) do
        e.animation:update(dt)
        local ex, ey = e:getPosition()
    end 

    for i=#enemies,1,-1 do
        local e = enemies[i]
        if e.dead == true then
            table.remove(enemies, i)
        end
    end
end 

function enemies:draw()
    for i,e in ipairs(enemies) do 
        local ex, ey = e:getPosition()
        e.animation:draw(sprites.enemy, ex, ey, nil, e.dir, 1, 8, 18)
    end 
end 