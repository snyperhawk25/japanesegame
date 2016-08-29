--Options Page
--This page is for displaying/managing the game's options

--LISTED SETTINGS-----------
--1. Music Vol
--2. Sound Effects Vol
--3. Pronunciation Vol
----------------------------

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
local description = "Default Description"
local nextSceneName = "menu"

--Widgets
local musicSlider, sfxSlider, pronunSlider
local musicLabel, sfxLabel, pronunLabel
local musicVol = 100
local sfxVol = 100
local pronunVol = 70

--------------------------------------------
--Coordinates
--------------------------------------------

local acceptX = centerX--45
local acceptY = 240

local sliderX = 110
local sliderY = 70


--Function to remove all display objects, and listeners
local function removeAllDisplayObjects()
  display.remove(title)
  display.remove(accept)

  display.remove(musicSlider)
  display.remove(sfxSlider)
  display.remove(pronunSlider)
  display.remove(musicLabel)
  display.remove(sfxLabel)
  display.remove(pronunLabel)


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


----------------------------
--LISTENERS
----------------------------
local function musicSliderListener(event)
    print( "Music Slider at " .. event.value .. "%" )
end

local function sfxSliderListener(event)
    print( "SFX Slider at " .. event.value .. "%" )
end

local function pronunSliderListener(event)
    print( "Pronun Slider at " .. event.value .. "%" )
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local screenGroup = self.view

  --Draw Background image (rotated and fliped horizontally)
  bg = display.newImage("images/CherryBlossoms.png", centerX,centerY)    
  bg.xScale=-1
  bg:scale(0.45,0.42)
  screenGroup:insert(bg)

  --Title:
  title = display.newText("Options:", centerX, 30, native.systemFontBold, 40 ) --26 and not bold
  title:setFillColor(0,0,0) --Black
  screenGroup:insert(title)

  --Collect the 'dialogueOptions' parameters from the scene event
  --title = event.params.dialogueTitle
  --description = event.params.dialogueText
  --nextSceneName = event.params.nextScene
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local screenGroup = self.view


  --Music Volume Slider
    musicSlider = widget.newSlider(
      {
        top = (sliderY),
        left = sliderX,
        width = 200,
        value = musicVol,
        listener = musicSliderListener
      }
    )
    musicLabel = display.newText("Music Volume:",sliderX-70, (sliderY)+10, native.systemFontBold, 12)
    musicLabel.anchorY=0
    musicLabel:setFillColor(0,0,0)

    --SFX Volume Slider
    sfxSlider = widget.newSlider(
      {
        top = (1.5*sliderY),
        left = sliderX,
        width = 200,
        value = sfxVol,
        listener = sfxSliderListener
      }
    )
    sfxLabel = display.newText("Sound Effects Volume:",sliderX-70, (1.5*sliderY)+10, native.systemFontBold, 12)
    sfxLabel.anchorY=0
    sfxLabel:setFillColor(0,0,0)

    --Pronun Volume Slider
    pronunSlider = widget.newSlider(
      {
        top = (2*sliderY),
        left = sliderX,
        width = 200,
        value = pronunVol,
        listener = pronunSliderListener
      }
    )
    pronunLabel = display.newText("Pronunciation Volume:",sliderX-70, (2*sliderY)+10, native.systemFontBold, 12)
    pronunLabel.anchorY=0
    pronunLabel:setFillColor(0,0,0)

  --Accept Button
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
  timer.performWithDelay(100, renderAcceptButton)
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