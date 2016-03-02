--NumbersScorePage.lua
--This file is for displaying the final score of the numbers game.
--b


local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"

--Variables

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local finalScore = 0

--Return to the menu
local function goToMenu()
	storyboard.gotoScene("menu")
	storyboard.removeScene("NumbersScorePage")
end

--Calculate the score value
local function calculateScore()
	print("\nCalculating Score..\n")
	--hard code for now
	finalScore = 100
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	--Background image
	bg = display.newImage("images/bg.png", centerX,centerY+30*yscale)
	--bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	--Title Image (Should be "Final Score")
	title = display.newImage("images/title.png", centerX,centerY-100*yscale)
	title:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(title)

	--Menu Button
	menu = display.newImage("images/Menu.png",centerX+160,centerY+130*yscale)
	menu:scale(0.4,0.4)
	menu:addEventListener("tap",goToMenu)
	screenGroup:insert(menu)
	
	-- 	--
	-- game1 = display.newImage("images/Character-Creation.png", centerX,centerY-10*yscale)
	-- game1:scale(0.4*xscale,0.4*yscale)
	-- game1:addEventListener("tap",goToGame1)
	-- screenGroup:insert(game1)

	--Text
	local yourScore = "Your Final Score:"
	text1 = display.newText(yourScore, centerX, centerY-50*yscale, native.systemFont, 26 )
	text1:setFillColor(0)
	screenGroup:insert(text1)

	--Call the score function and print out
	calculateScore()
	local playerScore=finalScore
	playerScoreText = display.newText(playerScore.." ", centerX,centerY+5, native.systemFontBold, 75)
	playerScoreText:setFillColor(0)
	screenGroup:insert(playerScoreText)



	--from correct in numbers6
	screenGroup:remove(myText)
	local instructions = "Awesome. You defused the bomb, and saved the day!"
	myText = display.newText(instructions, centerX, centerY+75*yscale, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

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