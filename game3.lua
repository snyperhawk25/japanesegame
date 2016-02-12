--------------------------------------------------------------------------------
--
-- game3.lua
-- This is the Food Vocab game. It uses questions[10-19] from Questions.lua
--------------------------------------------------------------------------------

require("questions")
require("vocab")

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


local background, chef, customer
local audioBox, audioSample
local Ans1Box, Ans2Box, Ans3Box
local Ans1Text, Ans2Text, Ans3Text, questionText
local correctAns, chosenAns
local score, scoreText

------------------------ CLEAR QUESTION FUNCTION -------------------------- 

function clearQuestion()
    questionText:removeSelf()
    Ans1Text:removeSelf()
    Ans2Text:removeSelf()
    Ans3Text:removeSelf()
    correctAns = 0
end


local function goToMenu()
    display.remove(Ans1Box)
    display.remove(Ans2Box)
    display.remove(Ans3Box)
    display.remove(questionText)
    display.remove(Ans1Text)
    display.remove(Ans2Text)
    display.remove(Ans3Text)
    display.remove(scoreText)
    display.remove(customer)
    display.remove(background)
    display.remove(audioBox)
    display.remove(chef)
    display.remove(menu)
    storyboard.gotoScene("menu")
    storyboard.removeScene("game3")
end
------------------------ ANSWER FUNCTION -------------------------- 

function answer()
    if chosenAns == correctAns then
        print("Correct Answer")
        score = score + 1
    end
    if chosenAns ~= correctAns then
        score = score - 1
        print("Wrong Answer")

    end
    
    scoreText:removeSelf()
    scoreText = display.newText("Score: "..score, 200, 60, "Arial", 20)
    clearQuestion()
    generateQuestion()
    
end    

------------------------ GAME INITIALIZE FUNCTION --------------------------

function Game3()
    score = 0
    background = display.newImage("art/Game3/sushibar.png")
    background:translate(300, 130)
    chef = display.newImage("art/Game3/chef.png")
    chef:translate(300, 130)
    customer = display.newImage("art/Game3/customer.png")
    customer:translate(300, 130)
    scoreText = display.newText("Score: "..score, 200, 60, "Arial", 20)
    generateQuestion()
     menu = display.newImage("images/Menu.png",420,30)
    menu:scale(0.4,0.4)
   menu:addEventListener("tap",goToMenu)
    --screenGroup:insert(menu)
end

------------------------ GENERATE QUESTION FUNCTION -------------------------- 

function generateQuestion()
    local num = math.random(10) + 10
    
    if  ( Ans1Box ~= nil ) and ( Ans2Box ~= nil ) and ( Ans3Box ~= nil ) then
        Ans1Box:removeSelf()
        Ans2Box:removeSelf()
        Ans3Box:removeSelf()
    end
    
    Ans1Box = display.newRect(140, 220, 100, 60)
    Ans1Box:setFillColor(0, 0.3, 0)
    Ans2Box = display.newRect(260, 220, 100, 60)
    Ans2Box:setFillColor(0, 0.3, 0)
    Ans3Box = display.newRect(380, 220, 100, 60)
    Ans3Box:setFillColor(0, 0.3, 0)
    Ans1Box.tap = Ans1BoxListener
    Ans1Box:addEventListener("tap", Ans1Box)
    Ans2Box.tap = Ans2BoxListener
    Ans2Box:addEventListener("tap", Ans2Box)
    Ans3Box.tap = Ans3BoxListener
    Ans3Box:addEventListener("tap", Ans3Box)
    
    questionText = display.newText(question[num].q , 60, 40, "Arial", 18)
    questionText:setFillColor(1, 1, 1)
    Ans1Text = display.newText(question[num].t1, 150, 230, "Arial", 18)
    Ans1Text:setFillColor(0, 1, 0)
    Ans2Text = display.newText(question[num].t2, 270, 230, "Arial", 18)
    Ans2Text:setFillColor(0, 1, 0)
    Ans3Text = display.newText(question[num].t3, 390, 230, "Arial", 18)
    Ans3Text:setFillColor(0, 1, 0)
    correctAns = question[num].ans
    audioSample = audio.loadSound(question[num].audio)
    
    if audioBox ~= nil then
        audioBox:removeSelf()
    end
    
     audioBox = display.newImage("art/Game3/audio_icon.png",300,300)
    audioBox:scale(0.1,0.1)
    audioBox.tap = AudioBoxListener
    audioBox:addEventListener("tap", audioBox)

end

------------------------ ANSBOX LISTENERS -------------------------- 

function Ans1BoxListener()
    print("Ans1Box")
    chosenAns = 1
    answer()
end

function Ans2BoxListener()
    print("Ans2Box")
    chosenAns = 2
    answer()
end

function Ans3BoxListener()
    print("Ans3Box")
    chosenAns = 3
    answer()
end

function AudioBoxListener()
    print("AudioBox")
    audio.play(audioSample)
end

---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------


-- Called when the scene's view does not exist:
function scene:createScene( event )
    

   Game3()

    


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
