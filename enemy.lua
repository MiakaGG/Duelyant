Object = require 'libraries/classic/classic'
Enemy = Object:extend()

function Enemy:new(x, y, width, height)
    self.x = x or 100
    self.y = y or 100 
    self.width = width or 16
    self.height = height or 30
    self.speed = speed or 100
    self.dir = dir or 1
    self.animation = animations.enemy or nil
    self.dead = false
    self.grounded = true
    self.enemies = {} or nil
    self.img = img or love.graphics.newImage('art/enemy2.png')
    self.collider = world:newRectangleCollider(x, y, width, height, {collision_class = "Enemy"})
end 

function Enemy:update(dt)
    self.animation:update(dt)
    -- Additional enemy update logic
    if self.collider.body then 
        local ex, ey = self.collider:getPosition()
        
        local colliders = world:queryRectangleArea(self.x + 9, self.y + 4, 8, 2, {'Ground', 'Wood', 'Player'})
        if colliders == 0 or 3 then 
            self.dir = self.dir * -1 
        end 

        self.collider:setX(ex + self.speed * dt * self.dir)
    end
end

function Enemy:draw()
    for i, enemy in ipairs(Enemy) do
        self.animation:draw(self.img, self.x, self.y, nil, self.dir, 1)
        -- Additional enemy draw logic
    end
end 

local enemies = {}