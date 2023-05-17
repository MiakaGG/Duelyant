playerStartX = 500
playerStartY = 100
player = world:newRectangleCollider(playerStartX, playerStartY, 16, 30, {collision_class = "Player"})
player:setFixedRotation(true)
player.speed = 120
player.isMoving = false
player.direction = 1
player.grounded = true
player.x = 0
player.y = 0

function player:update(dt)
    if player.body then
        local colliders = world:queryRectangleArea(player:getX() - 8, player:getY() + 15, 8, 2, {'Ground', 'Wood'})
        if #colliders > 0 then
            player.grounded = true
        else
            player.grounded = false
        end

        player.x = player:getX()
        player.y = player:getY()

           --[[ if player.direction == 1 then 
                attackCollider = world:newRectangleCollider(player.x, player.y, 10, 2)
                attackCollider:setCollisionClass('Melee')
                Timer.after(1, function() attackCollider:destroy() end)
                if attackCollider:enter('Wood') then
                    local collision_data = attackCollider:getEnterCollisionData('Wood')
                    local wood = collision_data.collider:getObject()
                    wood:destroy()
                    w.dead = true
                end
            elseif player.direction == -1 then 
                attackCollider = world:newRectangleCollider(player.x - 16, player.y, 10, 2)
                attackCollider:setCollisionClass('Melee')
                if attackCollider:enter('Wood') then
                    local collision_data = attackCollider:getEnterCollisionData('Wood')
                    local wood = collision_data.collider:getObject()
                    wood:destroy()
                    w.dead = true
                end
            end --]]

        player.isMoving = false
        local px, py = player:getPosition()
        if love.keyboard.isDown('right') then
            player:setX(px + player.speed*dt)
            player.isMoving = true
            player.direction = 1
        end
        if love.keyboard.isDown('left') then
            player:setX(px - player.speed*dt)
            player.isMoving = true
            player.direction = -1
        end
        if love.keyboard.isDown('space') then
            if player.direction == 1 then 
                local colliders = world:queryRectangleArea(px, py, 20, 2, {'Wood'--[[, 'Enemy']]})
                for i,c in ipairs(colliders) do 
                    -- wood.dead = true
                    --e.dead = true
                    c:destroy()
                end 
            end 
            if player.direction == -1 then 
                local colliders = world:queryRectangleArea(px - 16, py, 20, 2, {'Wood'--[[, 'Enemy']]})
                for i,c in ipairs(colliders) do 
                    -- wood.dead = true
                    --e.dead = true
                     c:destroy()
                end 
            end 
        end 
    end 
end 

function player:draw()
    local px, py = player:getPosition()
    --love.graphics.rectangle('fill', px, py, 16, 30)
end 