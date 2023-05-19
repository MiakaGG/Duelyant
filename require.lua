function requireFiles()
    anim8 = require 'libraries/anim8/anim8'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'
    Timer = require 'libraries/hump/timer'
    wf = require 'libraries/windfield/windfield'
    Object = require'libraries/classic/classic'
    cam = cameraFile()

    require('libraries/show')
    require('player')
    require('wood')
    require('enemy')
    require('collisionclasses')
end 