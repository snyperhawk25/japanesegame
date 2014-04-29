---------------------------------------------------------------------------------
--
-- In this scene I was just messing around with displaying various words in Japanese.
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

	umbrellaText = display.newText(syl[11][2]..syl[21][2], 100, 100, native.systemFont, 24)
	umbrellaText:setFillColor(1)

	shoesText = display.newText(syl[15][2]..syl[36][2], 100, 120, native.systemFont, 24)
	shoesText:setFillColor(1)

	walletText = display.newText(syl[21][2]..syl[4][2]..syl[53][2], 100, 140, native.systemFont, 24)
	walletText:setFillColor(1)

	teleText = display.newText(syl[39][2]..syl[83][2]..syl[79][2], 100, 160, native.systemFont, 24)
	teleText:setFillColor(1)

	bagText = display.newText(syl[11][2]..syl[48][2]..syl[83][2], 200, 100, native.systemFont, 24)
	bagText:setFillColor(1)

	newspaperText = display.newText(syl[23][2]..syl[83][2]..syl[54][2]..syl[83][2], 200, 120, native.systemFont, 24)
	newspaperText:setFillColor(1)

	windowText = display.newText(syl[62][2]..syl[41][2], 200, 140, native.systemFont, 24)
	windowText:setFillColor(1)

	hatText = display.newText(syl[60][2]..syl[6][2]..syl[23][2], 300, 100, native.systemFont, 24)
	hatText:setFillColor(1)

	bicycleText = display.newText(syl[24][2]..syl[38][2]..syl[83][2]..syl[67][2], 300, 120, native.systemFont, 24)
	bicycleText:setFillColor(1)

	photoText = display.newText(syl[83][2]..syl[67][2]..syl[23][2]..syl[83][2], 300, 140, native.systemFont, 24)
	photoText:setFillColor(1)

	doorText = display.newText(syl[41][2]..syl[2][2], 400, 100, native.systemFont, 24)
	doorText:setFillColor(1)

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