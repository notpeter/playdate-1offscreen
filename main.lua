-- Copyright: Peter Tripp (c) 2022
-- License: MIT
--
-- Purpose:
--   Demonstrates an off-by-one bug drawing sprites.
--   Link: https://devforum.play.date/t/playdate-sprite-position-off-by-1-bug/8312

import "CoreLibs/graphics"
import "CoreLibs/sprites"
local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry

function drawgrid()
    for i = 0,239,20 do -- horizontal
        gfx.drawLine(0,i,399,i)
    end
    for i = 0,399,20 do -- vertical
        gfx.drawLine(i,0,i,239)
    end
end

function makeBox()
    local boximg = gfx.image.new(81, 81)
    gfx.lockFocus(boximg)
        gfx.fillRect(0,0,81,81)
    gfx.unlockFocus()
    return boximg
end

function setup()
    grid = gfx.image.new(400, 240)
    gfx.lockFocus(grid)
        drawgrid()
    gfx.unlockFocus()

    gfx.sprite.setBackgroundDrawingCallback(function(x, y, width, height) grid:draw(0,0) end)

    local box = gfx.sprite.new(makeBox())
    box:add()
    box:moveTo(41,41)
    -- Bug only occurs with box:setCenter(0.5,0.5) (default center)
    -- Uncomment these two lines and we observe the correct behavior.
    -- box:setCenter(0,0)
    -- box:moveTo(40,40)

    playdate.leftButtonDown = function() box:moveBy(-20,0) end
    playdate.rightButtonDown = function() box:moveBy(20,0) end
    playdate.upButtonDown = function() box:moveBy(0,-20) end
    playdate.downButtonDown = function() box:moveBy(0,20) end
    playdate.update = function() gfx.sprite.update() end
end

function playdate.debugDraw()
    drawgrid()
end
setup()
