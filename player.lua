Object = require('libraries/classic/classic')
Player = Object:extend()

function Player:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 16
    self.height = height or 30
    self.startX = startX or 500
    self.startY = startY or 100
    self.speed = speed or 120 
    self.isMoving = isMoving or false
    self.direction = direction or 1 
    self.grounded = grounded or true 
    self.collider = world:newRectangleCollider(self.startX, self.startY, 16, 30, {collision_class = "Player"})
    self.collider:setFixedRotation(true)
end

function Player:update(dt)
    if self.collider.body then
        local colliders = world:queryRectangleArea(self.collider:getX() - 8, self.collider:getY() + 15, 8, 2, {'Ground', 'Wood'})
        if #colliders > 0 then
            self.grounded = true
        else
            self.grounded = false
        end

        self.isMoving = false
        local px, py = self.collider:getPosition()
        if love.keyboard.isDown('right') then
            self.collider:setX(px + self.speed*dt)
            self.isMoving = true
            self.direction = 1
        end
        if love.keyboard.isDown('left') then
            self.collider:setX(px - self.speed*dt)
            self.isMoving = true
            self.direction = -1
        end
        if love.keyboard.isDown('y') then
            if self.direction == 1 then 
                local swordcolliders = world:queryRectangleArea(px, py, 20, 2, {'Wood', 'Enemy'})
                for i,c in ipairs(swordcolliders) do 
                    c:destroy()
                end 
            end 
            if self.direction == -1 then 
                local swordcolliders = world:queryRectangleArea(px - 16, py, 20, 2, {'Wood','Enemy'})
                for i,c in ipairs(swordcolliders) do 
                     c:destroy()
                end 
            end 
        end 
        if love.keyboard.isDown('space') then
            if Player.grounded then
                Player.collider:applyLinearImpulse(0, -200)
            end
        end
    end 
end 

function Player:draw()
    local px, py = self.collider:getPosition()
    --love.graphics.rectangle('fill', px, py, 16, 30)
end 

function Player:keypressed(key)
    local px, py = self.collider:getPosition()
    if key == 'right' then
        self.collider:setX(px + self.speed*dt)
        self.isMoving = true
        self.direction = 1
    end
    if key == 'left' then
        self.collider:setX(px - self.speed*dt)
        self.isMoving = true
        self.direction = -1
    end
    if key == 'space' then
        if self.direction == 1 then 
            local swordcolliders = world:queryRectangleArea(px, py, 20, 2, {'Wood', 'Enemy'})
            for i,c in ipairs(swordcolliders) do 
                c:destroy()
            end 
        end 
        if self.direction == -1 then 
            local swordcolliders = world:queryRectangleArea(px - 16, py, 20, 2, {'Wood','Enemy'})
            for i,c in ipairs(swordcolliders) do 
                    c:destroy()
            end 
        end 
    end 
    if love.keyboard.isDown('space') then
        if Player.grounded then
            Player.collider:applyLinearImpulse(0, -200)
        end
    end
end 
