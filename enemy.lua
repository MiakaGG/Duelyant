local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, width, height, args)
    local enemy = setmetatable({}, Enemy)
    enemy.collider = world:newRectangleCollider(x, y, width, height, {collision_class = "Enemy"})
    enemy.speed = 100
    enemy.dir = 1
    enemy.animation = animations.enemy 
    enemy.dead = false
    enemy.grounded = true
    return enemy
end 

function Enemy:update(dt)
    self.animation:update(dt)
    -- Additional enemy update logic
    if self.body then 
        local ex, ey = self.collider:getPosition()
        
        local colliders = world:queryRectangleArea(self.collider:getX() + 9, self.collider:getY() + 4, 8, 2, {'Ground', 'Wood', 'Player'})
        if colliders == 0 or 3 then 
            self.dir = self.dir * -1 
        end 

        self.collider:setX(ex + self.speed * dt * self.dir)
    end
end

function Enemy:draw()
    self.animation:draw(sprites.enemy, ex, ey, nil, self.dir, 1)
    -- Additional enemy draw logic
end

-- Create and manage enemies
local enemies = {}

function spawnEnemy(x, y, width, height, args)
    local enemy = Enemy.new(x, y, width, height, args)
    table.insert(enemies, enemy)
end

function updateEnemies(dt)
    for i = #enemies, 1, -1 do
        local enemy = enemies[i]
        enemy:update(dt)
        -- Additional enemy update logic
        if enemy.body then 
        -- Handle collision with other colliders
            local colliders = world:queryRectangleArea(enemy.collider:getX(), enemy.collider:getY() - 12, 10, 4, {'Ground', 'Wood', 'Player'})
            for _, collider in ipairs(colliders) do
                if collider.collision_class == 'Player' then
                    enemy.dead = true
                elseif collider.collision_class == 'Ground' or collider.collision_class == 'Wood' then
                    -- Handle collision with the ground or wood colliders
                end
            end

            if enemy.dead then
                enemy.collider:destroy()
                table.remove(enemies, i)
            end
        end 
    end
end

function drawEnemies()
    for i, enemy in ipairs(enemies) do
        enemy:draw()
        -- Additional enemy draw logic
    end
end