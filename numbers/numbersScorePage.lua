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
local finalScoreUnit = ""
local finalDescription = ""
local NameOfGame = ""

--------------------------------------------
--Coordinates
--------------------------------------------
local titleX = centerX
local titleY = 25

local finalScoreTextX = centerX
local finalScoreTextY = 75

local playerScoreTextX = centerX
local playerScoreTextY = 150

--Return to the menu
local function goToMenu()
	storyboard.gotoScene("menu")
	storyboard.removeScene("NumbersScorePage")
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	--Collect gameOverOptions parameters
	print("event.params.var1"..event.params.var1..".")
	NameOfGame = event.params.gameName
	finalScore = event.params.finalScore
	finalScoreUnit = event.params.finalScoreUnit
	finalDescription = event.params.finalDescription

	--RENDER SCENE

	--Background image
	bg = display.newImage("images/bg.png", centerX,centerY+30*yscale)
	--bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)


end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view

	--Title Image 
	title = display.newImage("images/title.png", titleX, titleY)
	title:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(title)

	--Menu Button
	menu = display.newImage("images/Menu.png",centerX+160,centerY+130*yscale)
	menu:scale(0.4,0.4)
	menu:addEventListener("tap",goToMenu)
	screenGroup:insert(menu)

	--FinalScoreText
	if gameName==nil then
		gameName="[Name Error]"
	end
	local text = "Your "..gameName.." Final Score:"
	finalScoreText = display.newText(text, finalScoreTextX, finalScoreTextY, native.systemFont, 26 )
	finalScoreText:setFillColor(1)
	screenGroup:insert(finalScoreText)

	--Final Score and Unit
	playerScoreText = display.newText(finalScore.." "..finalScoreUnit, playerScoreTextX,playerScoreTextY, native.systemFontBold, 75)
	playerScoreText:setFillColor(0)
	screenGroup:insert(playerScoreText)

	--Description
	screenGroup:remove(myText)
	myText = display.newText(finalDescription, centerX, centerY+75*yscale, native.systemFont, 18 )
	myText:setFillColor(1)
	screenGroup:insert(myText)
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