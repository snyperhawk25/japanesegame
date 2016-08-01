--Tutorial Page
--This file is for displaying incomming dialogue.


local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
--local myData = require("mydata")
local widget = require("widget")

--Variables
local centerX = display.contentCenterX
local centerY = display.contentCenterY

--AUDIO
local audioClick = audio.loadSound("audio/click1.wav")


local accept = nil
local title = "Default Title"
local description = "Default Description"
local nextSceneName = "menu"

local finalScoreText = nil

--------------------------------------------
--Coordinates
--------------------------------------------

--Title
local finalScoreTextX = centerX
local finalScoreTextY = 40 --75

local acceptX = centerX--45
local acceptY = 240

--Function to remove all display objects, and listeners
local function removeAllDisplayObjects()
	display.remove(finalScoreText)
	display.remove(gameDescription)
	display.remove(accept)

end

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("dialoguePage") --? numbers. ....
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
	goToGivenScene(nextSceneName)
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	--Draw Background image (rotated and fliped horizontally)
	bg = display.newImage("images/bg.png", centerX,centerY+30) --yscale
	bg:rotate(180)
	bg.xScale=-1
	screenGroup:insert(bg)

	--Collect the 'dialogueOptions' parameters from the scene event
	title = event.params.dialogueTitle
	description = event.params.dialogueText
	nextSceneName = event.params.nextScene

	

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view


	--Title:
	if title==nil then
		title="[Name Error]"
	end
	finalScoreText = display.newText(title..":", finalScoreTextX, finalScoreTextY, native.systemFontBold, 35 ) --26 and not bold
	finalScoreText:setFillColor(0.1,1,0.1) --green
	screenGroup:insert(finalScoreText)


	--(Multiline) Description
	local descriptionOptions = {
		text = description,
		x = centerX,
		y = 70,
		width = 450,
		height = 160,
		fontSize = 20,
		align = "left"
	}	
	gameDescription = display.newText(descriptionOptions)
	gameDescription:setFillColor(1)
	gameDescription.anchorY=0.0
	screenGroup:insert(gameDescription)

	--Accept Button Function
	function renderAcceptButton()
		accept = widget.newButton (
	      {
	        id = "accept",
	        x = acceptX,
	        y = acceptY,
	        label = "Continue",
	        shape = "rect",
	        font = native.systemFont,
	        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
	        fillColor = { default={ 1, 1, 0, 1 }, over={ 1, 1, 0.5, 1 } }, --Yellow
	        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
	        strokeWidth = 4,
	        onPress = goToReloadScene
	      }
	    )
	    --accept.anchorX = 0.0
	    accept.anchorY = 0.0
	    screenGroup:insert(accept)
	end
	timer.performWithDelay(1000, renderAcceptButton)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	--Eliminate varaible values from memory
	accept:removeSelf()
	title = nil
	description = nil
	nextSceneName = nil
	finalScoreText = nil
	
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