--NumbersScorePage.lua
--This file is for displaying the final score of the numbers game.
--b


local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
require ("app42.scoreSaver")
local myData = require("mydata")

--Variables

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local bubble, title, gameDescription, retry

local finalScore = 0
local finalScoreUnit = ""
local finalDescription = ""
local nameOfGame = ""
local app42GameName = ""
local reloadScene = "game2" --test, for now

--------------------------------------------
--Coordinates
--------------------------------------------
local titleX = centerX
local titleY = 30

local finalScoreTextX = centerX
local finalScoreTextY = 75

local playerScoreTextX = centerX
local playerScoreTextY = 150

local bubbleX = centerX
local bubbleY = 150

local menuX = 350
local menuY = 250

local retryX = 150
local retryY = 275

--Function to remove all display objects, and listeners
local function removeAllDisplayObjects()
	--Listeners
	retry:removeEventListener("tap", retry)
	--Display
	display.remove(title)
	display.remove(finalScoreText)
	display.remove(playerScoreText)
	display.remove(bubble)
	display.remove(gameDescription)
	display.remove(menu)
	display.remove(retry)

end

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("numbers.numbersScorePage") --? numbers. ....
    end
    timer.performWithDelay(500, removeSceneListener)
end

--Function to go to scene, given name of the scene
function goToGivenScene(sceneName)
	if sceneName~=nil then
		removeAllDisplayObjects()
		storyboard.gotoScene(sceneName, "fade", 500)
		delayedSceneRemoval()
	else
		print("sceneName was nil. Failed to transition.")
	end
end

--Return to the menu
local function goToMenu()
	goToGivenScene("menu")
end

--Function to goto the 'reloadScene' scene.
--Need this for listener function.
local function goToReloadScene()
	goToGivenScene(reloadScene)
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	--Collect the 'gameOverOptions' parameters from the scene event
	nameOfGame = event.params.gameName
	finalScore = event.params.finalScore
	finalScoreUnit = event.params.finalScoreUnit
	finalDescription = event.params.finalDescription
	reloadScene = event.params.retryScene

	app42GameName = event.params.app42GameName
	
	--Confirm Print
	if reloadScene==nil then
		print("reloadScene was nil")
	end
	print("______gameOverOptions Readout:\nName Of Game: "..nameOfGame..".\nFinal Score: "..finalScore..".\nFinal Score Unit: "..finalScoreUnit..".\nFinal Description: "..finalDescription..".\nReload Scene: "..reloadScene..".\n_______END")

	--Submit Score to App42
	saveUserScore(app42GameName, myData.App42Username, finalScore)
	

	--Draw Background image
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
	menu:addEventListener("tap",goToMenu) --no()
	screenGroup:insert(menu)

	--Retry Button
	retry = display.newText("retry",retryX, retryY, native.systemFontBold, 40)
	retry:setFillColor(0)	
	retry:addEventListener("tap",goToReloadScene)--no()
	screenGroup:insert(retry)

	--Bubble
	bubble = display.newImage("images/bubble.png", bubbleX,bubbleY)
    bubble:scale(0.6,0.35)
    screenGroup:insert(bubble)

	--FinalScoreText "[Game] Score Is:"
	if nameOfGame==nil then
		nameOfGame="[Name Error]"
	end
	local text = ""..nameOfGame.." Final Score:"
	finalScoreText = display.newText(text, finalScoreTextX, finalScoreTextY, native.systemFont, 26 )
	finalScoreText:setFillColor(1)
	screenGroup:insert(finalScoreText)

	--Final Score and Unit "3 Correct"
	playerScoreText = display.newText(finalScore.." "..finalScoreUnit, playerScoreTextX,playerScoreTextY, native.systemFontBold, 60)
	playerScoreText:setFillColor(0)
	screenGroup:insert(playerScoreText)

	--Description
	gameDescription = display.newText(finalDescription, centerX, centerY+75*yscale, native.systemFont, 18 )
	gameDescription:setFillColor(1)
	screenGroup:insert(gameDescription)
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