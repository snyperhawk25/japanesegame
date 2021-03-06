--NumbersScorePage.lua
--This file is for displaying the final score of the numbers game.


local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
require ("app42.scoreSaver")
local myData = require("mydata")
local widget = require("widget")


--For Submit Score. Not using scoreSaver.lua
local App42API = require("App42-Lua-API.App42API")
local tools=require("app42.App42Tools") --this is for App42:Initialize
local scoreBoardService = App42API.buildScoreBoardService()   --For Leaderboard



--Variables
local centerX = display.contentCenterX
local centerY = display.contentCenterY

--AUDIO
local audioClick = audio.loadSound("audio/click1.wav")
local audioKazoo = audio.loadSound("audio/kazoo1.wav")



local bubble, gameDescription, retry
local statusLight

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

local statusLightX = 17
local statusLightY = 289

--Function to remove all display objects, and listeners
local function removeAllDisplayObjects()
	--Listeners
	--retry:removeEventListener("tap", retry)
	--Display
	display.remove(finalScoreText)
	display.remove(playerScoreText)
	display.remove(bubble)
	display.remove(gameDescription)
	display.remove(menu)
	display.remove(retry)
	display.remove(statusLight)

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
	audio.play(audioClick,{channel=3})
	goToGivenScene("menu")
end

--Function to goto the 'reloadScene' scene.
--Need this for listener function.
local function goToReloadScene()
	audio.play(audioClick,{channel=3})
	goToGivenScene(reloadScene)
end

--Function to change status light
local function setStatusLight(stateNum)
	--Remove if existing
	if statusLight~=nil then
		display.remove(statusLight)
	end
	--Status Case
	statusLight = display.newCircle(statusLightX,statusLightY, 5)
	statusLight.strokeWidth = 1
	statusLight:setStrokeColor(0,0,0)
	statusLight.alpha = 0
	if stateNum==1 then
		print("(( Status Light: Green ))") --Green Check mark
		--statusLight = display.newPolygon(statusLightX, statusLightY,{12,0,50,40,50,50,12,25,0,35,0,25})
		statusLight:setFillColor(0.1,1,0.1)
	elseif stateNum==0 then
		print("(( Status Light: Red ))") --Red X
		--statusLight = display.newPolygon(statusLightX, statusLightY,{12,0,50,40,50,50,12,25,0,35,0,25})
		statusLight:setFillColor(1,0.1,0.1)
	else
		print("(( Status Light: Yellow ))") --Yellow Yeild
		--statusLight = display.newPolygon(statusLightX, statusLightY,{0,0,0,50,25,50})
		statusLight:setFillColor(1,0.8,0)
	end
	--Add Status Light
	--self.view:insert(statusLight)
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

	--Print GameOverOptions to console
	if reloadScene==nil then
		print("reloadScene was nil")
	end
	print("______gameOverOptions Readout:\nName Of Game: "..nameOfGame..".\nFinal Score: "..finalScore..".\nFinal Score Unit: "..finalScoreUnit..".\nFinal Description: "..finalDescription..".\nReload Scene: "..reloadScene..".\n_______END")

	
	--Auto statusLight to 0
	--setStatusLight(0)

	--Submit score to App42 (TimeIsNumbered: 100 is a meaningless number)
	app42ScoreCallBack = {}	
	function app42ScoreCallBack:onSuccess(object)
        print("      -Score Saved Successfully: Value="..object:getScoreList():getValue()..";")
        timer.performWithDelay(10,setStatusLight(1))
    end
    function app42ScoreCallBack:onException(exception)
        print("      -Score FAILED to Saved correctly: Value="..score)
        print("Score failed to save to App42.")
        timer.performWithDelay(10,setStatusLight(0))
    end
    scoreBoardService:saveUserScore(app42GameName, myData.App42Username, finalScore, app42ScoreCallBack)

	--Draw Background image (rotated and fliped horizontally)
	bg = display.newImage("images/bg.png", centerX,centerY+30) --yscale
	bg:rotate(180)
	bg.xScale=-1
	screenGroup:insert(bg)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view

	--Kazoo 
	local function playKazoo()
		local kaz = audio.play(audioKazoo,{channel=4})
		if kaz==0 then
			print("Kazoo could NOT be played...")
		else
			print("Kazoo played on Ch "..kaz..".")
		end
	end
	timer.performWithDelay(200, playKazoo)
	
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
	
	--Appear status light
	local function myFunk()
		statusLight.alpha = 1 --beta error
	end
	timer.performWithDelay(100, myFunk)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	--Dispose Audio
	--audio.dispose(audioClick)
	--audio.dispose(audioKazoo)
	
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