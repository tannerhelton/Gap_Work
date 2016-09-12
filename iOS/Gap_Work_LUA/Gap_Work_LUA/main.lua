-----------------------------------------------------------------------------------------
--
-- main.lua
-- Created by Tanner Helton on Saturday September 10 2016
-- Used for the creation of Gap Work iOS app
-- https://tannerstechtips.com
--
-----------------------------------------------------------------------------------------

--Create WIDTH and HEIGHT variables for width and height of the screen
local WIDTH, HEIGHT = 2*display.contentWidth, 2*display.contentHeight

--Set the background to a color and create a function background(r,g,b) for setting a new background color
local bkGrnd = display.newRect(0, 0, 1334, 750)
bkGrnd:setFillColor(255, 255, 255)
function background(rX,gX,bX)
    bkGrnd:setFillColor(rX,gX,bX)
end

local dx, dy, dtheta = 5, 5, 5

local message = display.newText('Hello from Corona', WIDTH/2, HEIGHT/2)
message:setTextColor(0, 0, 200)


local function update(event)
   local counter_spin = false
   message:translate(dx, dy)
   message:rotate(dtheta)
   if message.x > WIDTH or message.x < 0 then
      dx = -1 * dx
        background(255,255,0)
      counter_spin = true
   end
   if message.y > HEIGHT or message.y < 0 then
      dy = -1 * dy
      counter_spin = true
   end
   if counter_spin then
      dtheta = -1 * dtheta
   end
end


Runtime:addEventListener('enterFrame', update)