---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
local widget = require("widget")
local myData = require("mydata")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local place1 = 100
local place2 = 150 
local place3 = 200
local place4 = 250
local miniFont = 14

--local webLink = "http://fccs.ok.ubc.ca/faculty/nlangton.html" --Nina's Personal Page
--local webLink = "http://fccs.ok.ubc.ca/programs/other/japanese.html" --UBCO FCCS Japanese Studies Page
local weblink = "https://github.com/snyperhawk25/japanesegame/wiki" --KissaVocab Wikipedia

--AUDIO
local audioClick = audio.loadSound("audio/click1.wav")
local menuMusic = audio.loadSound("audio/KissaVocabMenuMusic.mp3")


local transitionOptions = {
	effect="fade",
	time=500
}

--Function to delay the removal of the scene, smoothing out the transition between scenes
local function delayedSceneRemoval()
	--Stop Music
	audio.pause(menuMusic)

	local function removeSceneListener(event)
		storyboard.removeScene("menu")
	end
	timer.performWithDelay(500, removeSceneListener)
end


local function goToGame4()
	--Click 
	local function playClick()
		if audio.play(audioClick,{channel=3})==0 then
			print("Click Failed To Play...")
		end
	end
	timer.performWithDelay(50, playClick)

	storyboard.gotoScene("game4",transitionOptions)
	--storyboard.gotoScene("test.shufflingTest",transitionOptions)
	--storyboard.gotoScene("test.testPrintCharactersScreen",transitionOptions)
	delayedSceneRemoval()
end
local function goToGame2()
	--Click 
	local function playClick()
		if audio.play(audioClick,{channel=3})==0 then
			print("Click Failed To Play...")
		end
	end
	timer.performWithDelay(50, playClick)

	storyboard.gotoScene("game2",transitionOptions)
	--storyboard.removeScene("menu")
	delayedSceneRemoval()
end
local function goToGame3()
	--Click 
	local function playClick()
		if audio.play(audioClick,{channel=3})==0 then
			print("Click Failed To Play...")
		end
	end
	timer.performWithDelay(50, playClick)

	storyboard.gotoScene("game3v2",transitionOptions)
	delayedSceneRemoval()
end

--b test Numbers Game.
local function goToNum()
	--Click 
	local function playClick()
		if audio.play(audioClick,{channel=3})==0 then
			print("Click Failed To Play...")
		end
	end
	timer.performWithDelay(50, playClick)

	storyboard.gotoScene("numbers.numbers1",transitionOptions)
	delayedSceneRemoval()
end

--Link to website
local function logoLinkListener()
	-- apprently null print("Options Pressed.\nGoing to external link: "..webLink)
	print("Options Pressed.\nGoing to external link. ")
	system.openURL(weblink)
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view

	--BACKGROUND
	--bg = display.newImage("images/bg.png", centerX,centerY+(30)) --(30*yscale)
	--screenGroup:insert(bg)

	bg = display.newImage("images/numbers/clockbg.png",centerX,0) --(30*yscale)
	--bg.anchorX=0.0
	bg.anchorY=0.0
	bg:scale(0.5,0.5)
	screenGroup:insert(bg)

	--TITLE
	-----------------------------------------------------------------------
	--title = display.newImage("images/title.png", centerX,centerY-100) --centerY-100*yscale
	--title:scale(0.6*xscale,0.6*yscale)
	--title:scale(0.6,0.6)
	--screenGroup:insert(title)
	
	titleBackground = display.newRect(centerX,10,1000,65)
	titleBackground:setFillColor(0)
	titleBackground.anchorY=0.0
	screenGroup:insert(titleBackground)

	title = display.newText("KissaVocab, The Vocab Café",centerX, 30, native.systemFontBold, 35)
	title:setFillColor(1)	
	screenGroup:insert(title)

	title2 = display.newText("Nina Langton's Introduction to Japanese Vocabluary",centerX, 60, native.systemFont, 14)
	title2:setFillColor(1)	
	screenGroup:insert(title2)


	--OPTION COG (just a web link for now)
	optionCog = display.newImage("images/Gear_Button.png", 440, place1)
	optionCog.anchorX=0.0
	optionCog.anchorY=0.0
	optionCog:scale(0.4,0.4)
	optionCog:addEventListener("tap",logoLinkListener)
	screenGroup:insert(optionCog)

	--PLAYER ID
	playerID = display.newText("Player ID: "..myData.App42Username.."",3, 300, native.systemFontBold, 14)
	playerID.anchorX=0.0
	playerID.anchorY=0.0
	playerID:setFillColor(1,1,0)	
	screenGroup:insert(playerID)


	--GAME 1
	--------------------------------------------------------
	--game1 = display.newImage("images/Character-Creation.png", centerX,centerY-10)
	--game1:scale(0.4*xscale,0.4*yscale)
	--game1:scale(0.4,0.4)
	--game1:addEventListener("tap",goToGame1)
	--screenGroup:insert(game1)

	--game1 = display.newText("Nina's Questions",centerX, place1, native.systemFontBold, 40)
	--game1:setFillColor(0)	
	--game1:addEventListener("tap",goToGame1)
	--screenGroup:insert(game1)

	game1 = widget.newButton (
      {
        id = "game1",
        x = centerX-150,
        y = place1,
        label = "Nina's Questions",
        labelAlign = "left",
        shape = "rect",
        font = native.systemFontBold,
        fontSize = miniFont,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 1,0.6,1, 1 }, over={ 1,0.72,1,1 } }, --Purple
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = goToGame4
      }
    )
   	game1.anchorY = 0.0
    screenGroup:insert(game1)

	--GAME 2
	--------------------------------------------------------
	--game2 = display.newImage("images/Vocab.png", centerX,centerY+30)
	--game2:scale(0.4*xscale,0.4*yscale)
	--game2:scale(0.4,0.4)
	--game2:addEventListener("tap",goToGame2)
	--screenGroup:insert(game2)

	--game2 = display.newText("Item Identity",centerX, place2, native.systemFontBold, 40)
	--game2:setFillColor(0)	
	--game2:addEventListener("tap",goToGame2)
	--screenGroup:insert(game2)

	game2 = widget.newButton (
      {
        id = "game2",
        x = centerX-50,
        y = place2,
        label = "Item Identity",
        labelAlign = "left",
        shape = "rect",
        font = native.systemFontBold,
        fontSize = miniFont,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 1, 0.36, 0.2, 1 }, over={ 1, 0.52, 0.4, 1 } }, --Red
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = goToGame2
      }
    )
   	game2.anchorY = 0.0
    screenGroup:insert(game2)

	--GAME 3
	---------------------------------------------------------
	--game3 = display.newImage("images/Food-Vocab.png", centerX,centerY+70)
	--game3:scale(0.4*xscale,0.4*yscale)
	--game3:scale(0.4,0.4)
	--game3:addEventListener("tap",goToGame3)
	--screenGroup:insert(game3)

	--game3 = display.newText("Food Frenzy",centerX, place3, native.systemFontBold, 40)
	--game3:setFillColor(0)	
	--game3:addEventListener("tap",goToGame3)
	--screenGroup:insert(game3)

	game3 = widget.newButton (
      {
        id = "game3",
        x = centerX+50,
        y = place3,
        label = "Food Frenzy",
        labelAlign = "left",
        shape = "rect",
        font = native.systemFontBold,
        fontSize = miniFont,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 0.36,0.83,0.36, 1 }, over={ 0.6,0.9,0.6, 1 } }, --GREEN
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = goToGame3
      }
    )
   	game3.anchorY = 0.0
    screenGroup:insert(game3)

	--GAME 4
	----------------------------------------------------------
	--game4 = display.newImage("images/Numbers.png", centerX,centerY+110)
	--game4:scale(0.4*xscale,0.4*yscale)
	--game4:scale(0.4,0.4)
	--game4:addEventListener("tap",goToNum)
	--screenGroup:insert(game4)

	--game4 = display.newText("Time Is Numbered",centerX, place4, native.systemFontBold, 40)
	--game4:setFillColor(0)	
	--game4:addEventListener("tap",goToNum)
	--screenGroup:insert(game4)

	game4 = widget.newButton (
      {
        id = "game4",
        x = centerX+150,
        y = place4,
        label = "Time Is Numbered",
        labelAlign = "left",
        shape = "rect",
        font = native.systemFontBold,
        fontSize = miniFont,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 0.2,0.6,1, 1 }, over={0.5,0.75,1 } }, --BLUE
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = goToNum
      }
    )
   	game4.anchorY = 0.0
    screenGroup:insert(game4)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	--MUSIC
	--Stopping all audio, and clearing all channels
	local wasStopped = audio.stop()
	if wasStopped > 0 then
		print("Stopped "..wasStopped.." Audio Channels.")		
	else
		if wasStopped < 0 then
			print("Error Stopping Audio.")
		else
			print("No Audio Channels To Stop.")
		end
	end
	--Replaying menu music
	print("Playing menuMusic")
	--audio.setVolume(1.0)//!@#??commented out
	audio.play(menuMusic, {channel = 1,loops = -1})

	--Audio Readout
	getAudioLevels()
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