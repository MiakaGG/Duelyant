function createCollisionClasses()
    world:addCollisionClass('Ground')
    world:addCollisionClass('Wood')
    world:addCollisionClass('Water')
    world:addCollisionClass('Sword')
    world:addCollisionClass('Enemy')
    world:addCollisionClass('Player', {ignores = {'Water'}})
end