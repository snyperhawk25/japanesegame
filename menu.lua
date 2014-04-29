---------------------------------------------------------------------------------
--
-- menu.lua
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

local function goToSushi()
	storyboard.gotoScene("sushi")
	storyboard.removeScene("menu")
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
	bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	title = display.newImage("images/title.png", centerX,centerY-100*yscale)
	title:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(title)

	play = display.newImage("images/play.png", centerX,centerY-10*yscale)
	play:scale(0.5*xscale,0.5*yscale)
	play:addEventListener("tap",goToSushi)
	screenGroup:insert(play)

	info = display.newImage("images/info.png", centerX,centerY+40*yscale)
	info:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(info)

	settings = display.newImage("images/settings.png", centerX,centerY+90*yscale)
	settings:scale(0.5*xscale,0.5*yscale)
	screenGroup:insert(settings)

	


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