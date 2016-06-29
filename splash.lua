---------------------------------------------------------------------------------
--
-- splash.lua
--This scene is the splash screen and will transition to the menu scene after 3 seconds
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )



---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local scene = storyboard.newScene()
storyboard.removeAll()
local audioWelcome = audio.loadSound("audio/welcome/welcome.wav")
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function continue()
	storyboard.gotoScene( "menu", "fade", 250 ) --b was 750
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	--bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
	--UBC BLUE
	--RGB:0,33,69
	--HSL:141,240,32
	bg = display.newRect(0,0,2000,2000)
	bg:setFillColor(0,0.129,0.269) --RGB/256
	--bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	--Play Welcome Audio 
	audio.play(audioWelcome)

	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view
	
	--local image = display.newImage( "images/title.png", centerX, centerY )
	local image = display.newImage( "art/Logo/UBCOJLG.png", centerX, centerY )
	image:scale(0.50,0.55) --0.6 --0.50*xscale
	screenGroup:insert( image )
	
	--image.touch = onSceneTouch


	endSceneTimer = timer.performWithDelay( 500, continue)	--after .5 seconds, go to menu
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