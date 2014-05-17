---------------------------------------------------------------------------------
--
--This scene isn't needed anymore, it was just me messing around with the sushi conveyer belt mini game (which is already completed apparently)
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/conveyerbg.png", centerX,centerY-(30*yscale))
	bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	local conveyeroptions =
		{
		    width = 1000,
		    height = 747,
		    numFrames = 2
		}
	local conveyersheet = graphics.newImageSheet( "images/conveyersheet.png", conveyeroptions )

	local sequenceData =
		{
		    name="moving",
		    frames={ 1,2 },
		    time = 1000,
		    loopCount = 0     -- Optional ; default is 0
		}

	local conveyerbelt = display.newSprite( conveyersheet, sequenceData )
	conveyerbelt.x = centerX
	conveyerbelt.y =centerY-(30*yscale) 
	conveyerbelt:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(conveyerbelt)
	conveyerbelt:setSequence( "moving" )
	conveyerbelt:play()

	spawnPlate(screenGroup)


end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
end

function spawnPlate(n)
	local screenGroup = n

	local plate = display.newImage("images/plate.png", centerX-230*xscale, centerY)
	plate:scale(0.4*xscale,0.4*yscale)
	physics.addBody(plate)
	screenGroup:insert(plate)

	plate:setLinearVelocity(10,30)

	local function changePlate1()
		plate:setLinearVelocity(0,0)
		plate:setLinearVelocity(34,0)
	end

	timer1 = timer.performWithDelay(1500,changePlate1)

	local function changePlate2()
		plate:setLinearVelocity(0,0)
		plate:setLinearVelocity(10,-30)
	end

	timer2 = timer.performWithDelay(13500,changePlate2)

	local function removePlate()
		plate:removeSelf()
		spawnPlate(screenGroup)
	end

	timer3 = timer.performWithDelay(15000,removePlate)

end




---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene