--NumbersScorePage.lua
--This file is for displaying the final score of the numbers game.
--b


local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
require ("app42.scoreSaver")
local myData = require("mydata")
local widget = require("widget")

--Variables

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local audioClick = audio.loadSound("audio/click1.wav")
local audioKazoo = audio.loadSound("audio/kazoo1.wav")
audio.setVolume(1.0)

local bubble, gameDescription, retry

local finalScore = 0
local finalScoreUnit = ""
local finalDescription = ""
local nameOfGame = ""
local app42GameName = ""
local reloadScene = "game2" --test, for now

--------------------------------------------
--Coordinates
--------------------------------------------

local finalScoreTextX = centerX
local finalScoreTextY = 40 --75

local playerScoreTextX = centerX
local playerScoreTextY = 130 --150

local bubbleX = centerX
local bubbleY = 130 --150

local menuX = 245--350
local menuY = 240--250

local retryX = 45
local retryY = 240

--Function to remove all display objects, and listeners
local function removeAllDisplayObjects()
	--Listeners
	retry:removeEventListener("tap", retry)
	--Display
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
	audio.play(audioClick)
	goToGivenScene("menu")
end

--Function to goto the 'reloadScene' scene.
--Need this for listener function.
local function goToReloadScene()
	audio.play(audioClick)
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
	
	--Do NOT Submit "TimeIsNumbered"  Scores to App42
	if nameOfGame~="TimeIsNumbered" then
		--Console Print
		if reloadScene==nil then
			print("reloadScene was nil")
		end
		print("______gameOverOptions Readout:\nName Of Game: "..nameOfGame..".\nFinal Score: "..finalScore..".\nFinal Score Unit: "..finalScoreUnit..".\nFinal Description: "..finalDescription..".\nReload Scene: "..reloadScene..".\n_______END")

		--Submit Score to App42
		saveUserScore(app42GameName, myData.App42Username, finalScore)
	end

	--Draw Background image (rotated and fliped horizontally)
	bg = display.newImage("images/bg.png", centerX,centerY+30) --yscale
	bg:rotate(180)
	bg.xScale=-1
	screenGroup:insert(bg)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view

	--MUSIC 
	print("playing kazoo")
	audio.play(kazoo1)

	--Menu Button
	--menu = display.newImage("images/Menu.png",centerX+160,centerY+130) --yscale
	--menu:scale(0.4,0.4)
	--menu:addEventListener("tap",goToMenu) --no()
	--screenGroup:insert(menu)
	menu = widget.newButton (
      {
        id = "menu",
        x = menuX,
        y = menuY,
        --width = 200,
        --height = 50,
        label = "Menu",
        shape = "rect",
        font = native.systemFont,
        --cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 1, 0.36, 0.2, 1 }, over={ 1, 0.52, 0.4, 1 } }, --Red
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = goToMenu --to menu
      }
    )
   	menu.anchorX = 0.0
    menu.anchorY = 0.0
    screenGroup:insert(menu)


	--Retry Button
	--retry = display.newText("retry",retryX, retryY, native.systemFontBold, 40)
	--retry:setFillColor(0)	
	--retry:addEventListener("tap",goToReloadScene)--no()
	--screenGroup:insert(retry)
	retry = widget.newButton (
      {
        id = "retry",
        x = retryX,
        y = retryY,
        --width = 200,
        --height = 50,
        label = "Retry",
        shape = "rect",
        font = native.systemFont,
        --cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 1, 1, 0, 1 }, over={ 1, 1, 0.5, 1 } }, --Yellow
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = goToReloadScene --to retry
      }
    )
    retry.anchorX = 0.0
    retry.anchorY = 0.0
    screenGroup:insert(retry)

	--Bubble
	bubble = display.newImage("images/bubble.png", bubbleX,bubbleY)
    bubble:scale(0.6,0.35)  --0.6,0.35
    screenGroup:insert(bubble)

	--FinalScoreText "[Game] Score Is:"
	if nameOfGame==nil then
		nameOfGame="[Name Error]"
	end
	local text = ""..nameOfGame.." Final Score:"
	finalScoreText = display.newText(text, finalScoreTextX, finalScoreTextY, native.systemFontBold, 35 ) --26 and not bold
	finalScoreText:setFillColor(0.1,1,0.1) --green
	screenGroup:insert(finalScoreText)

	--Final Score and Unit "3 Correct"
	playerScoreText = display.newText(finalScore.." "..finalScoreUnit, playerScoreTextX,playerScoreTextY, native.systemFontBold, 46)
	playerScoreText:setFillColor(0)
	screenGroup:insert(playerScoreText)

	--(Multiline) Description
	local descriptionOptions = {
		text = finalDescription,
		x = centerX,
		y = centerY+75,
		width = 450,
		height = 100,
		fontSize = 20,
		align = "left"
	}	
	gameDescription = display.newText(descriptionOptions)
	gameDescription:setFillColor(1)
	screenGroup:insert(gameDescription)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	--Dispose Audio
	audio.dispose(audioClick)
	audio.dispose(audioKazoo)
	
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