--[[ TODO:
Initialize world and physics. DONE----
Then we create a square for a player
Add movement and physics with keypresses and windfield 
Add a key for attacking which will query an area for collidable enemies.

--]]


anim8 = require 'libraries/anim8/anim8'
sti = require 'libraries/Simple-Tiled-Implementation/sti'
cameraFile = require 'libraries/hump/camera'
Timer = require 'libraries/hump/timer'


function love.load()
    -- initalize new windfield physics world and call method to enable debug drawing
    wf = require 'libraries/windfield/windfield'
    world = wf.newWorld(0, 800, false)
    world:setQueryDebugDrawing(true)

    -- create classes to be able to use functions on different ones
    world:addCollisionClass('Ground')
    world:addCollisionClass('Player')
    world:addCollisionClass('Wood')
    world:addCollisionClass('Water')
    world:addCollisionClass('Enemy')


    cam = cameraFile()

    grounds = {}
    waters = {}

    require('libraries/show')
    require('player')
    require('wood')
    require('enemy')

    saveData = {}
    saveData.currentLevel = "map"

    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end

    -- loads the map from the save data 
    loadMap(saveData.currentLevel)

    spawnEnemy(300, 100, 40, 40)
end 

function love.update(dt)
    -- update functions 
    world:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    woodUpdate(dt)
    enemyUpdate(dt)

    local px, py = player:getPosition()
    cam:lookAt(px, love.graphics.getHeight()/2)

end 

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        drawPlayer()
        world:draw()
    cam:detach()
end 

function love.keypressed(key)
    if key == 'up' then
        if player.grounded then
            player:applyLinearImpulse(0, -200)
        end
    end
    if key == 'space' then 
        player.x = player:getX()
        player.y = player:getY()
        if player.direction == 1 then 
            local colliders = world:queryRectangleArea(player.x, player.y, 20, 2, {'Wood'})
            for i,c in ipairs(colliders) do 
                wood.dead = true
                c:destroy()
            end 
        end 
        if player.direction == -1 then 
            local colliders = world:queryRectangleArea(player.x - 16, player.y, 20, 2, {'Wood'})
            for i,c in ipairs(colliders) do 
                wood.dead = true
                c:destroy()
            end 
        end 
    end 
end 

-- We could possibly create a function that can make the process of spawning in collision classes less tedious. 
-- I think a possible solution could be to abstract the spawn process more and make it its own file. 
-- TODO: CREATE COLLISION CLASS SPAWNING FUNCTION
function spawnGround(x, y, width, height)
    local ground = world:newRectangleCollider(x, y, width, height, {collision_class = "Ground"})
    ground:setType('static')
    table.insert(grounds, ground)
end 

function spawnWater(x, y, width, height)
    local water = world:newRectangleCollider(x, y, width, height, {collision_class = "Water"})
    water:setType('static')
    table.insert(waters, water)
end 

-- This function serves as a sort of gc so we dont clog the memory with a bunch of identifiers and 'dead' tiles
function destroyAll()
    local i = #grounds
    while i > -1 do
        if grounds[i] ~= nil then
            grounds[i]:destroy()
        end
        table.remove(grounds, i)
        i = i -1
    end
end 

-- Loads map and is a save function for the maps also renders and all that 
function loadMap(mapName)
    saveData.currentLevel = mapName
    love.filesystem.write("data.lua", table.show(saveData, "saveData"))
    
    destroyAll()
    gameMap = sti("maps/" .. mapName .. ".lua")
    
    for i, obj in pairs(gameMap.layers["start"].objects) do
        playerStartX = obj.x
        playerStartY = obj.y
    end

    player:setPosition(playerStartX, playerStartY)
    
    for i, obj in pairs(gameMap.layers["Ground"].objects) do
        spawnGround(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(gameMap.layers["Water"].objects) do 
        spawnWater(obj.x, obj.y, obj.width, obj.height)
    end 
    
    for i, obj in pairs (gameMap.layers["Wood"].objects) do 
        spawnWood(obj.x, obj.y, obj.width, obj.height)
    end 
end