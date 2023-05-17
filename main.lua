--[[ TODO:
Initialize world and physics. DONE----
Then we create a square for a player DONE
Add movement and physics with keypresses and windfield DONE
Add a key for attacking which will query an area for collidable enemies. DONE

    I have added stuff without the TODO but I am going to try to add more

ADD FUNCTION TO FIND TILE ID AND REMOVE IT. (BREAKABLE TILES)
    I KNOW THE FORUMS HAS ONE BUT IT MIGHT NOT SUIT MY NEEDS,
    WE WILL DO SOME MORE RESEARCH.

ADD PLAYER SPRITE AND ANIMATIONS. 
    - GET SPRITE SHEET AND REST SHOULD BE EASY.
    - WILL HAVE TO CHANGE THE QUERY HITBOXESTO FIT THE ATTACK
        KEEP IN MIND DIRECTION NOW TOO MIGHT HAVE TO CHANGE COLLIDER SHAPE.
    - SHOULD BE IT.

EXTEND GAME WORLD 
    - WE CAN DO THIS PRETTY EASILY IN TILED AND WE CAN POLISH LATER.
    - ONCE WORLD GETS BIG ENOUGH TO AFFECT FPS WE CAN DO CHUNKS.

REFACTORING!!!!!!!!
    - MAKE CODE CLEANER AND EASY TO READ FOR MYSELF IN FUTURE.
    - MAIN.LUA SHOULD BE CLEAN AND FUNCTIONAL.

--]]

require('require')

function love.load()
    wf = require 'libraries/windfield/windfield'
    world = wf.newWorld(0, 800, false)
    world:setQueryDebugDrawing(true)

    -- cleaner functions
    requireFiles()
    createCollisionClasses()
    sprites = {}
    sprites.enemy = love.graphics.newImage('art/enemy2.png')

    local enemyGrid = anim8.newGrid(16, 32, sprites.enemy:getWidth(), sprites.enemy:getHeight())
    
    animations = {}
    animations.enemy = anim8.newAnimation(enemyGrid('1-2',1), 0.05)

    cam = cameraFile()

    grounds = {}
    waters = {}

    saveData = {}
    saveData.currentLevel = "map"

    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end

    -- loads the map from the save data 
    loadMap(saveData.currentLevel)
end 

function love.update(dt)
    -- update functions 
    world:update(dt)
    gameMap:update(dt)
    player:update(dt)
    woods:update(dt)
    enemies:update(dt)

    local px, py = player:getPosition()
    cam:lookAt(px*2, love.graphics.getHeight()/2 - 130)

end 

function love.draw()
    cam:attach()
        love.graphics.scale(2, 2)
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        player:draw()
        world:draw()
        enemies:draw()
    cam:detach()
end 

function love.keypressed(key)
    if key == 'up' then
        if player.grounded then
            player:applyLinearImpulse(0, -200)
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
        local wx, wy = obj.x, obj.y     
    end 

    for i, obj in pairs (gameMap.layers["Enemies"].objects) do 
        spawnEnemy(obj.x, obj.y, obj.width, obj.height, obj.args)
    end 
end