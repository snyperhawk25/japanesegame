--------------------------------------------------------------------------------
--
-- game1.lua
--
--------------------------------------------------------------------------------
require("vocab")

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local function goToMenu()
    storyboard.gotoScene("menu")
    storyboard.removeScene("game1")
end
local hair, gender, nationality, image1, image2
local questionText, ans1, ans2, ans3, ans4, ans5, ans6, continue
local ans1Box, ans2Box, ans3Box, ans4Box, ans5Box, ans6Box, continueBox
local hairChoice, genderChoice, nationalityChoice
local endgroup
--------------------------------------------------------------------------------
 -- END GAME --
--------------------------------------------------------------------------------

function endGame()
    print("END")
    if questionText~=nil then
        questionText:removeSelf()
    end
    if image2~=nil then
        image2:removeSelf()
    end
    if image1~=nil then
        image1:removeSelf()
        end
    if ans1~=nil then
        ans1:removeSelf()
        end
    if ans2~=nil then
        ans2:removeSelf()
        end
    if ans3~=nil then
        ans3:removeSelf()
        end
    if ans4~=nil then
        ans4:removeSelf()
        end
    --[[if image2~=nil then
        ans1Box:removeEventListener("tap", ans1Box)
        ans2Box:removeEventListener("tap", ans2Box)
        ans3Box:removeEventListener("tap", ans3Box)
        ans4Box:removeEventListener("tap", ans4Box)]]
    if ans1Box~=nil then
        ans1Box:removeSelf()
        end
    if ans2Box~=nil then
        ans2Box:removeSelf()
        end
    if ans3Box~=nil then
        ans3Box:removeSelf()
        end
    if ans4Box~=nil then
        ans4Box:removeSelf()
        end
    if continue~=nil then
        continue:removeSelf()
        end
    if continueBox~=nil then
        continueBox:removeEventListener("tap", continueBox)
        end
    if continueBox~=nil then
        continueBox:removeSelf()
        end
    goToMenu()
    
    
end

--------------------------------------------------------------------------------
 -- HAIR CHOICE --
--------------------------------------------------------------------------------

function hairAns1Box()
    print("ans1Box")
    if image2 ~= nil then
    image2:removeSelf()
    end
    
    if gender == "male" then
    image2 = display.newImage("art/Game1/mblonde.png")
    end
    if gender == "female" then
    image2 = display.newImage("art/Game1/femblonde.png")
    end
    image2:translate(50, 130)
    hair = "blonde"
end

function hairAns2Box()
    print("ans2Box")
    if image2 ~= nil then
    image2:removeSelf()
    end
    
    if gender == "male" then
    image2 = display.newImage("art/Game1/mbrown.png")
    end
    if gender == "female" then
    image2 = display.newImage("art/Game1/fembrown.png")
    end
    image2:translate(50, 130)
    hair = "brown"
end

function hairAns3Box()
    print("ans3Box")
    if image2 ~= nil then
    image2:removeSelf()
    end
    
    if gender == "male" then
    image2 = display.newImage("art/Game1/mblack.png")
    end
    if gender == "female" then
    image2 = display.newImage("art/Game1/femblack.png")
    end
    image2:translate(50, 130)    
    hair = "black"
end

function hairAns4Box()
    print("ans4Box")
    if image2 ~= nil then
    image2:removeSelf()
    end
    
    if gender == "male" then
    image2 = display.newImage("art/Game1/mred.png")
    end
    if gender == "female" then
    image2 = display.newImage("art/Game1/femred.png")
    end
    image2:translate(50, 130)
    hair = "red"
end

function hairContinueBox()
    print("hairContinueBox")
    endGame()
end

function hairChoice()

    -- Clear nationality choice stuff --
    questionText:removeSelf()
    ans1:removeSelf()
    ans2:removeSelf()
    ans3:removeSelf()
    ans4:removeSelf()
    ans5:removeSelf()
    ans6:removeSelf()
    ans5Box:removeSelf()
    ans6Box:removeSelf()
    ans1Box:removeEventListener("tap", ans1Box)
    ans2Box:removeEventListener("tap", ans2Box)
    ans3Box:removeEventListener("tap", ans3Box)
    ans4Box:removeEventListener("tap", ans4Box)
    ans5Box:removeEventListener("tap", ans5Box)
    ans6Box:removeEventListener("tap", ans6Box)
    
    continue:removeSelf()
    continueBox:removeEventListener("tap", continueBox)
    continueBox:removeSelf()

    questionText = display.newText(hiragana["ka"] .. hiragana["mi"] .. " " .. hiragana["no"] .. " " .. hiragana["i"] .. hiragana["ro"] .. " " .. hiragana["wa"] .. "?" , 320, 20, "Arial", 20)
    ans1 = display.newText(hiragana["ki"] .. hiragana["n"] .. hiragana["pa"] .. hiragana["su"], 300, 80, "Arial", 20) -- blonde
    ans2 = display.newText("brown", 300, 155, "Arial", 20) -- brown -- Must be changed to Japanese!
    ans3 = display.newText(hiragana["ku"] .. hiragana["ro"], 300, 230, "Arial", 20) -- black
    ans4 = display.newText(hiragana["a"] .. hiragana["ka"], 450, 80, "Arial", 20) -- red

    ans1Box.tap = hairAns1Box
    ans1Box:addEventListener("tap", ans1Box)
    ans2Box.tap = hairAns2Box
    ans2Box:addEventListener("tap", ans2Box)
    ans3Box.tap = hairAns3Box
    ans3Box:addEventListener("tap", ans3Box)
    ans4Box.tap = hairAns4Box
    ans4Box:addEventListener("tap", ans4Box)
    
    continueBox = display.newRect(460, 280, 100, 60)
    continueBox:setFillColor(0.3, 0, 0)
    continue = display.newText("next", 460, 285, "Arial", 20)
    
    continueBox.tap = hairContinueBox
    continueBox:addEventListener("tap", continueBox)
end 

--------------------------------------------------------------------------------
 -- NATIONALITY CHOICE -- 
--------------------------------------------------------------------------------
 
function nationalityAns1Box()
    print("ans1Box")
    if image1 ~= nil then
    image1:removeSelf()
    end
    
    if gender == "male" then
    image1 = display.newImage("art/Game1/mbrazil.png")
    end
    if gender == "female" then
    image1 = display.newImage("art/Game1/fembrazil.png")
    end
    image1:translate(50, 130)
    nationality = "brazil"
end

function nationalityAns2Box()
    print("ans2Box")
    if image1 ~= nil then
    image1:removeSelf()
    end
    
    if gender == "male" then
    image1 = display.newImage("art/Game1/mcanada.png")
    end
    if gender == "female" then
    image1 = display.newImage("art/Game1/femcanada.png")
    end
    image1:translate(50, 130)
    nationality = "canada"
end

function nationalityAns3Box()
    print("ans3Box")
    if image1 ~= nil then
    image1:removeSelf()
    end
    
    if gender == "male" then
    image1 = display.newImage("art/Game1/mchinese.png")
    end
    if gender == "female" then
    image1 = display.newImage("art/Game1/femchinese.png")
    end
    image1:translate(50, 130)    
    nationality = "chinese"
end

function nationalityAns4Box()
    print("ans4Box")
    if image1 ~= nil then
    image1:removeSelf()
    end
    
    if gender == "male" then
    image1 = display.newImage("art/Game1/mfrance.png")
    end
    if gender == "female" then
    image1 = display.newImage("art/Game1/femfrance.png")
    end
    image1:translate(50, 130)
    nationality = "france"
end

function nationalityAns5Box()
    print("ans5Box")
    if image1 ~= nil then
    image1:removeSelf()
    end
    
    if gender == "male" then
    image1 = display.newImage("art/Game1/mjapan.png")
    end
    if gender == "female" then
    image1 = display.newImage("art/Game1/femjapan.png")
    end
    image1:translate(50, 130)
    nationality = "japan"
end

function nationalityAns6Box()
    print("ans6Box")
    if image1 ~= nil then
    image1:removeSelf()
    end
    
    if gender == "male" then
    image1 = display.newImage("art/Game1/mkorean.png")
    end
    if gender == "female" then
    image1 = display.newImage("art/Game1/femkorean.png")
    end
    image1:translate(50, 130)
    nationality = "korean"
end

function nationalityContinueBox()
    print("NationalityContinueBox")
    hairChoice()
end
 
function nationalityChoice()

    -- Clear gender choice stuff --
    questionText:removeSelf()
    ans1:removeSelf()
    ans2:removeSelf()
    ans1Box:removeEventListener("tap", ans1Box)
    ans2Box:removeEventListener("tap", ans2Box)
    continue:removeSelf()
    continueBox:removeEventListener("tap", continueBox)
    continueBox:removeSelf()

    questionText = display.newText(hiragana["o"] .. hiragana["ku"] .. hiragana["ni"] .. " " .. hiragana["wa"] .. "?" , 320, 20, "Arial", 20)
    ans1 = display.newText("brazil", 300, 80, "Arial", 20) -- Must be changed to Japanese!
    ans2 = display.newText(hiragana["ka"] .. hiragana["na"] .. hiragana["da"], 300, 155, "Arial", 20)
    
    ans3Box = display.newRect(300, 225, 100, 60)
    ans3Box:setFillColor(0, 0.3, 0)
    ans3 = display.newText("chinese", 300, 230, "Arial", 20) -- Must be changed to Japanese!
    
    ans4Box = display.newRect(450, 75, 100, 60)
    ans4Box:setFillColor(0, 0.3, 0)
    ans4 = display.newText("france", 450, 80, "Arial", 20) -- Must be changed to Japanese!
    
    ans5Box = display.newRect(450, 150, 100, 60)
    ans5Box:setFillColor(0, 0.3, 0)
    ans5 = display.newText(hiragana["ni"] .. hiragana["ho"] .. hiragana["n"], 450, 155, "Arial", 20)
    
    ans6Box = display.newRect(450, 225, 100, 60)
    ans6Box:setFillColor(0, 0.3, 0)
    ans6 = display.newText("korean", 450, 230, "Arial", 20) -- Must be changed to Japanese!
    

    ans1Box.tap = nationalityAns1Box
    ans1Box:addEventListener("tap", ans1Box)
    ans2Box.tap = nationalityAns2Box
    ans2Box:addEventListener("tap", ans2Box)
    ans3Box.tap = nationalityAns3Box
    ans3Box:addEventListener("tap", ans3Box)
    ans4Box.tap = nationalityAns4Box
    ans4Box:addEventListener("tap", ans4Box)
    ans5Box.tap = nationalityAns5Box
    ans5Box:addEventListener("tap", ans5Box)
    ans6Box.tap = nationalityAns6Box
    ans6Box:addEventListener("tap", ans6Box)
    
    continueBox = display.newRect(460, 280, 100, 60)
    continueBox:setFillColor(0.3, 0, 0)
    continue = display.newText("next", 460, 285, "Arial", 20) -- Must be changed to Japanese!
    
    continueBox.tap = nationalityContinueBox
    continueBox:addEventListener("tap", continueBox)
end

--------------------------------------------------------------------------------
 -- GENDER CHOICE --
--------------------------------------------------------------------------------

function genderAns1Box()
    print("Ans1Box")
    gender = "male"
end

function genderAns2Box()
    print("Ans2Box")
    gender = "female"
end

function genderContinueBox()
    print("GenderContinueBox")
    nationalityChoice()
end

function genderChoice()
    questionText = display.newText("Choose Gender", 320, 20, "Arial", 20) -- Must be changed to Japanese!
    
    ans1Box = display.newRect(300, 75, 100, 60)
    ans1Box:setFillColor(0, 0.3, 0)
    ans1 = display.newText("male", 300, 80, "Arial", 20) -- Must be changed to Japanese!
    
    ans2Box = display.newRect(300, 150, 100, 60)
    ans2Box:setFillColor(0, 0.3, 0)
    ans2 = display.newText("female", 300, 155, "Arial", 20) -- Must be changed to Japanese! 
    
    continueBox = display.newRect(460, 280, 100, 60)
    continueBox:setFillColor(0.3, 0, 0)
    continue = display.newText("next", 460, 285, "Arial", 20) -- Must be changed to Japanese!
    
    ans1Box.tap = genderAns1Box
    ans1Box:addEventListener("tap", ans1Box)
    ans2Box.tap = genderAns2Box
    ans2Box:addEventListener("tap", ans2Box)
    continueBox.tap = genderContinueBox
    continueBox:addEventListener("tap", continueBox)
end

--------------------------------------------------------------------------------
-- Game Start
--------------------------------------------------------------------------------

function Game1()
    print("Inside Game1()")
    gender = "male" -- preset gender as male in case player doesn't pick one
    genderChoice()
end


---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local screenGroup = self.view
    bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
    --bg:scale(0.6*xscale,0.6*yscale)
    screenGroup:insert(bg)

    endgroup = screenGroup
    
    Game1()
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
