local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local myData = require("Code.mydata")

---------------------------------------------------------------------------------

-- local forward references should go here
local background
local soundEffect = audio.loadSound( "SFX/Common/Menu1.wav" )
local resume
local musict
local SFXt
local musics
local sfxs
local exit
local parent
---------------------------------------------------------------------------------
--Save the user's settings
local function saveOptions(event)
  local path = system.pathForFile("options.txt", system.DocumentsDirectory)
  local file, errorString = io.open( path,  "w")
  if not file then
    print("File error: " .. errorString)
    io.close(file)
  else
    file:write("music=" ..myData.music .."\nsfx=" .. myData.sfx)
    io.close(file)
  end
  file = nil
  print("Music Volume: " .. myData.music)
  print("SFX Valume: " .. myData.sfx)
end

--Set music volume
local function musicSet(event)
  --if event.phase == "ended" then
    myData.music = event.value/100
    --Music is being played on channel 1
    audio.setVolume(myData.music, {channel=1})
    --audio.play(soundEffect, {channel=1})
--  end
end

--Set SFX valume
local function sfxSet(event)
  if event.phase == "ended" then
    myData.sfx = event.value/100
    --sfx should be played on channel 2
    audio.setVolume(myData.sfx, {channel=2})
    audio.play(soundEffect, {channel=2})
  end
end

--Close the options/pause menu,
local function closeOptions( event )
  --Hide the overlay with the appropriate options
  if event.phase == "ended" then
    saveOptions()
    composer.hideOverlay("fade", 250)
  end
end

local function toTitle(event)
  local p = event.parent
  if event.phase == "ended" then
    saveOptions()
    parent:optionsToTitle(event)
  end
end

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view

   --Generate and set background music
   background = display.newImageRect("GFX/Common/options.png", 320, 320)
   background.x = display.contentCenterX
   background.y = display.contentCenterY
   sceneGroup:insert(background)

   --Generate text and set colors
   resume = display.newText(sceneGroup, event.params.text1, display.contentCenterX, display.contentHeight - 74, native.systemFont, 24)
   resume:setTextColor(0, 0, 0)

   musict = display.newText(sceneGroup, "Music: ", display.contentCenterX, 94, native.systemFont, 24)
   musict:setTextColor(0, 0, 0)
   SFXt = display.newText(sceneGroup, "SFX: ", display.contentCenterX, 154, native.systemFont, 24)
   SFXt:setTextColor(0, 0, 0)

   musics = widget.newSlider{
     left = display.contentCenterX-50,
     top = musict.y+5,
     value = tonumber(myData.music)*100,
     listener = musicSet,
     width = 100
   }
   sceneGroup:insert(musics)

   sfxs = widget.newSlider{
     left = display.contentCenterX-50,
     top = SFXt.y+5,
     value = tonumber(myData.sfx)*100,
     listener = sfxSet,
     width = 100
   }
   sceneGroup:insert(sfxs)

   if event.params.text1 == "Resume" then
     exit = display.newText(sceneGroup, "Return to Menu", display.contentCenterX, display.contentHeight - 40, native.systemFont, 24)
     exit:setTextColor(0,0,0)
   end

end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   parent = event.parent
   if ( phase == "will" ) then

   elseif ( phase == "did" ) then
      resume:addEventListener("touch", closeOptions)
      if exit then
        exit:addEventListener("touch", toTitle)
      end
      --musics:addEventListener("moved", musicSet)
      --sfxs:addEventListener("moved", sfxSet)
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then

   elseif ( phase == "did" ) then
      resume:removeEventListener("touch", closeOptions)
      if exit then
        exit:removeEventListener("touch", toTitle)
      end
      --musics:removeEventListener("moved", musicSet)
      --sfxs:removeEventListener("moved", sfxSet)
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view
   background:removeSelf()
   background = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


---------------------------------------------------------------------------------

return scene
