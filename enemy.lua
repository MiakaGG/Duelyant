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
        local colliders = world:queryRectangleArea(self.collider:getX() + (15 * self.dir), self.collider:getY(), 5, 2, {'Ground', 'Wood'})
        if #colliders == 1 then 
            self.dir = self.dir * -1 
        end

        self.collider:setX(self.collider:getX() + self.speed * dt * self.dir)
        self.x, self.y = self.collider:getX(), self.collider:getY()
    end
end

function Enemy:draw()
    if self.collider.body then
        self.animation:draw(self.img, self.x - self.width / 3, self.y - self.height) --, nil, self.dir, 1)
    end 
end 