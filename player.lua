Object = require('libraries/classic/classic')
Player = Object:extend()

-- TODO: ADD PLAYER VELOCITY TO LIMIT JUMP AMOUNT 

function Player:new(x, y)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 16
    self.height = height or 32
    self.startX = startX or 500
    self.startY = startY or 100
    self.vel = vel or 200
    self.maxVel = maxVel or 75
    self.timer = timer or 0
    self.swingTimer = swingtimer or 0
    self.jumpCount = jumpCount or 0
    self.speed = speed or 120 
    self.isMoving = isMoving or false
    self.isSwinging = isSwinging or false
    self.direction = direction or 1 
    self.grounded = grounded or true 
    self.animation = animations.idle or nil
    self.collider = world:newRectangleCollider(self.x, self.y, self.width, self.height, {collision_class = "Player"})
    self.collider:setFixedRotation(true)
end

function Player:update(dt)
    if self.collider.body then
        if self.jumpCount > 0 then 
            self.timer = self.timer + dt 
        end 
        if self.timer > 0.5 then 
            self.jumpCount = 0 
        end 
        if self.isSwinging then 
            self.swingTimer = self.swingTimer + dt 
        end 
        if self.swingTimer > 0.5 then 
            self.isSwinging = false 
        end 
        local colliders = world:queryRectangleArea(self.collider:getX() - 12, self.collider:getY() + 15, 8, 2, {'Ground'})
        if #colliders > 0 then
            self.grounded = true
        else
            self.grounded = false
        end

        -- moving collider at the moment l
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
        if self.isSwinging == false then 
            if love.keyboard.isDown('space') then
                if self.direction == 1 then 
                    local swordcolliders = world:queryRectangleArea(px, py, 20, 2, {'Wood', 'Enemy'})
                    for i,c in ipairs(swordcolliders) do 
                        c:destroy()
                    end 
                    self.isSwinging = true 
                end 
                if self.direction == -1 then 
                    local swordcolliders = world:queryRectangleArea(px - 16, py, 20, 2, {'Wood','Enemy'})
                    for i,c in ipairs(swordcolliders) do 
                        c:destroy()
                    end 
                    self.isSwinging = true 
                end 
            end 
        end 
        if love.keyboard.isDown('up') then
            if self.grounded then
                if self.jumpCount < 1 then 
                    self.jumpCount = self.jumpCount + 1
                    self.collider:applyLinearImpulse(0, -self.vel)
                end 
            end
        end

        if self.grounded then
            if self.isMoving then
                self.animation = animations.walk
            else
                self.animation = animations.idle
                self.animation:gotoFrame(1)
            end
        elseif not self.grounded then 
            self.animation = animations.jump
        elseif self.isSwinging then 
            self.animation = animations.swing 
            self.animation:gotoFrame(9)
        end 
        self.animation:update(dt)
    end 
end 

function Player:draw()
    local px, py = self.collider:getPosition()
    --love.graphics.rectangle('fill', px, py, 16, 30)
    self.animation:draw(sprites.player, px, py, nil, 0.75 * self.direction, 0.75, 20, 20)
end 

function Player:keypressed(key)
end 
