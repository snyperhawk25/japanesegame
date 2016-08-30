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
local optionsFileName = "options.txt"
--local helpLink = "http://fccs.ok.ubc.ca/faculty/nlangton.html" --Nina's Personal Page
--local helpLink = "http://fccs.ok.ubc.ca/programs/other/japanese.html" --UBCO FCCS Japanese Studies Page
local helpLink = "https://github.com/snyperhawk25/japanesegame/wiki" --KissaVocab Wikipedia
local devLink = "http://play.google.com/store/apps/dev?id=5168709452795191961"

--AUDIO
local audioClick = audio.loadSound("audio/click1.wav") --//!@# Remember to add clicks for buttons
local audioIncorrect = audio.loadSound("audio/buzz1.wav")
local menuMusic = audio.loadSound("audio/KissaVocabMenuMusic.mp3")
local pronunDemo = audio.loadSound("audio/ji-nzu.wav")

local title = nil

--Widgets
local musicSlider, sfxSlider, pronunSlider
local musicLabel, sfxLabel, pronunLabel
local playMusic, playSFX, playPronun
local helpButton, devButton, accept



--------------------------------------------
--Coordinates
--------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local acceptX = centerX--45
local acceptY = 240

local sliderX = 150 --130
local sliderY = 70

local buttonX = 300
local buttonY = sliderY




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

  --playMusic:removeEventListener("tap", playMusicListener) --Error, nil key?
  --playSFX:removeEventListener("tap", playSFXListener)
  --playPronun:removeEventListener("tap", playPronunListener)
  display.remove(playMusic)
  display.remove(playSFX)
  display.remove(playPronun)

  display.remove(helpButton)
  display.remove(devButton)


end

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("options.lua") --? numbers. ....
    end
    timer.performWithDelay(500, removeSceneListener)
end

--Function to go to scene, given name of the scene
function goToGivenScene(sceneName)
  if sceneName~=nil then
    removeAllDisplayObjects()
    delayedSceneRemoval()
    storyboard.gotoScene(sceneName, "fade", 500)
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
  goToGivenScene()
end


--Sets the channel levels
local function relevelChannels()
  print("Audio Channels Releveled.")
  audio.setVolume(musicVol, {channel=1})
  audio.setVolume(pronunVol, {channel=2})
  audio.setVolume(sfxVol, {channel=3})
  audio.setVolume(sfxVol, {channel=4})
end

--Function to Write user's settings
function saveOptionsFile(event)
  local path = system.pathForFile(optionsFileName, system.DocumentsDirectory)
  local file, errorString = io.open( path,  "w")
  if not file then
    print("Options File Error: " .. errorString)
    io.close(file)
  else
    file:write("musicVol=" ..musicVol .."\nsfxVol=" .. sfxVol .. "\npronunVol=" .. pronunVol)
    print("< Options File Written >")
    io.close(file)
  end
  file = nil
end

--Function to Read in, if existant, options file
function readOptionsFile(event)
  local filePath = system.pathForFile(optionsFileName, system.DocumentsDirectory)
    if (filePath) then
        local file, errorString = io.open( filePath, "r" ) --open
        if not file then
            -- Error occurred; output the cause
            --print( "Options File error: " .. errorString )
            print("No Options file found. Writing default file...")
            saveOptionsFile()
        else
            --Read Ready. Start at Music
            local contents = file:read( "*l" )
            contents = string.gsub(contents, "musicVol=", "")
            musicVol = tonumber(contents)
            print( "Read: musicVol set to " .. musicVol..";")
            --SFX
            contents = file:read( "*l" )
            contents = string.gsub(contents, "sfxVol=", "")
            sfxVol = tonumber(contents)
            print( "Read: sfxVol set to " .. sfxVol..";")
            --Pronun
            contents = file:read( "*l" )
            contents = string.gsub(contents, "pronunVol=", "")
            pronunVol = tonumber(contents)
            print( "Read: pronunVol set to " .. pronunVol..";")
            -- Close the file
            io.close( file )
        end
    else
      print("Options FilePath Error. Invalid filepath.")
    end
end

----------------------------
--LISTENERS
----------------------------
--SLIDERS
local function musicSliderListener(event)
    print( "Music Slider at " .. event.value .. "%" )
    musicVol = (event.value / 100.0)
end

local function sfxSliderListener(event)
    print( "SFX Slider at " .. event.value .. "%" )
    sfxVol = (event.value / 100.0)
end

local function pronunSliderListener(event)
    print( "Pronun Slider at " .. event.value .. "%" )
    pronunVol = (event.value / 100.0)
end

--PLAY
local function playMusicListener(event)
    print("PlayMusic Clicked.")
    saveOptionsFile()
    relevelChannels()
    local function playSound()
      --audio.seek(5000, menuMusic, {channel=1}) --?
      audio.play(menuMusic,{channel=1})
    end
    timer.performWithDelay(50,playSound)

end
local function playSFXListener(event)
    print("PlaySFX Clicked.")
    saveOptionsFile()
    relevelChannels()
    local function playSound()
      audio.play(audioIncorrect,{channel=4})
    end
    timer.performWithDelay(50,playSound)    

end
local function playPronunListener(event)
    print("PlayPronun Clicked.")
    saveOptionsFile()
    relevelChannels()
    local function playSound()
      audio.play(pronunDemo,{channel=2})
    end
    timer.performWithDelay(50,playSound)

end

--BUTTONS
local function helpButtonListener(event)
    print("HelpButton Clicked.")
    audio.play(audioClick,{channel=3})
    system.openURL(helpLink)
end
local function devButtonListener(event)
    print("DevButton Clicked.")
    audio.play(audioClick,{channel=3})
    system.openURL(devLink)
end
local function acceptListener(event)
    print("Accept Pressed")
    audio.play(audioClick,{channel=3})
    saveOptionsFile()
    relevelChannels()
    goToMenu()
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
  local screenGroup = self.view

  --Draw Background image (rotated and fliped horizontally)
  bg = display.newImage("images/CherryBlossoms.png", centerX,centerY)    
  bg.xScale=-1
  bg:scale(0.45,0.42)
  screenGroup:insert(bg)

  colorFilter = display.newRect(centerX,centerY,2000,2000)
  colorFilter:setFillColor(0.5,0.5,0.5,0.6)
  screenGroup:insert(colorFilter)

  --Collect the 'dialogueOptions' parameters from the scene event
  --title = event.params.dialogueTitle
  --description = event.params.dialogueText
  --nextSceneName = event.params.nextScene
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local screenGroup = self.view

  --Title:
  title = display.newText("Options:", 70, 30, native.systemFontBold, 40 ) --26 and not bold
  title:setFillColor(0,0,0) --Black
  screenGroup:insert(title)

  --Music Volume Slider
    musicSlider = widget.newSlider(
      {
        top = (sliderY),
        left = sliderX,
        width = 150,
        value = (musicVol*100.0),
        height = 50,
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
        width = 150,
        value = (sfxVol*100.0),
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
        width = 150,
        value = (pronunVol*100.0),
        listener = pronunSliderListener
      }
    )
    pronunLabel = display.newText("Pronunciation Volume:",sliderX-70, (2*sliderY)+10, native.systemFontBold, 12)
    pronunLabel.anchorY=0
    pronunLabel:setFillColor(0,0,0)

    local playScale=0.20
    --playMusic
    playMusic = display.newImage("images/Speaker_Icon.png", sliderX+170, sliderY+20)
    playMusic:scale(playScale, playScale)
    playMusic.anchorX=0.0
    playMusic:addEventListener("tap", playMusicListener)

    --playMusic
    playSFX = display.newImage("images/Speaker_Icon.png", sliderX+170, (1.5*sliderY)+20)
    playSFX:scale(playScale, playScale)
    playSFX.anchorX=0.0
    playSFX:addEventListener("tap", playSFXListener)

    --playMusic
    playPronun = display.newImage("images/Speaker_Icon.png", sliderX+170, (2*sliderY)+20)
    playPronun:scale(playScale, playScale)
    playPronun.anchorX=0.0
    playPronun:addEventListener("tap", playPronunListener)


    --Help Button
    helpButton = widget.newButton (
        {
          id = "helpButton",
          left = buttonX,
          top = buttonY,
          label = "Help?",
          width = 130,
          height = 40,
          shape = "roundedRect",
          font = native.systemFontBold,
          labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 1 } },
          fillColor = { default={ 0.4, 1, 0.2, 1 }, over={0.4, 1, 0.2, 0.4} }, --Green
          strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
          strokeWidth = 2,
          onPress = helpButtonListener
        }
      )
      helpButton.anchorX = 0.0
      screenGroup:insert(helpButton)

    --Developer Button
    devButton = widget.newButton (
        {
          id = "devButton",
          left = buttonX,
          top = (1.5*buttonY),
          label = "Our Games!",
          width = 130,
          height = 40,
          shape = "roundedRect",
          font = native.systemFontBold,
          labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 1 } },
          fillColor = { default={ 0, 0.13, 0.27, 1 }, over={ 0, 0.13, 0.27, 0.4} }, --UBC Blue
          strokeColor = { default={ 0,0,0, 1 }, over={ 0,0,0, 1 } },
          strokeWidth = 2,
          onPress = devButtonListener
        }
      )
      devButton.anchorX = 0.0
      devButton.anchorY = 0.0
      screenGroup:insert(devButton)


  --Accept Button
  function renderAcceptButton()
    accept = widget.newButton (
        {
          id = "accept",
          x = acceptX,
          y = acceptY,
          label = "Accept",
          shape = "roundedRect",
          font = native.systemFontBold,
          labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 1 } },
          fillColor = { default={ 1, 1, 0, 1 }, over={ 1, 1, 0.5, 0.8 } }, --Yellow
          strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
          strokeWidth = 2,
          onPress = acceptListener
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