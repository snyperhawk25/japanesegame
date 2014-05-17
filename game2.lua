--------------------------------------------------------------------------------
--
-- game2.lua
--
--------------------------------------------------------------------------------

require("questions")
require("vocab")

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


local enemy
local questionBox
local questionText
local Ans1Box
local Ans1Text
local Ans2Box
local Ans2Text
local Ans3Box
local Ans3Text
local lives
local livesText
local correctAns
local chosenAns
local gameOverText
local gameOver
local q1, q2, q3
local audioBox, audioSample

local function goToMenu()
    gameOverText:removeSelf()
    gameOver:removeSelf()
    display.remove(Ans1Box)
    display.remove(Ans2Box)
    display.remove(Ans3Box)
    display.remove(questionText)
    display.remove(Ans1Text)
    display.remove(Ans2Text)
    display.remove(Ans3Text)
    display.remove(enemy)
    display.remove(livesText)
    display.remove(audioBox)
    display.remove(Ans1Box)
    display.remove(Ans1Box)

    storyboard.gotoScene("menu")
    storyboard.removeScene("game2")
end

------------------------ GAME INITIALIZE FUNCTION -------------------------- 

function Game2()
    enemy = display.newImage("art/Game2/yakuza2.png")
    enemy:translate(400, 130)

    lives = 3
    livesText = display.newText("Lives: "..lives, 40, 40, "Arial", 20)
    
    generateQuestion()
end

------------------------ GAME OVER FUNCTION -------------------------- 

function gameOver()

    print("GAME OVER")

    Ans1Box:removeEventListener("tap", Ans1Box)
    Ans2Box:removeEventListener("tap", Ans1Box)
    Ans3Box:removeEventListener("tap", Ans1Box)

    gameOver = display.newRect(-100, -100, 2000, 2000)
    gameOver:setFillColor(0, 0, 0)
    
    gameOverText = display.newText("GAME OVER!...", 40, 10, "Arial", 20)
    gameOverText:setFillColor(0.8, 0, 0)
    gameOver.tap = gameClear
    gameOver:addEventListener("tap", gameOver)

    goToMenu()
end

------------------------ GAME CLEAR FUNCTION -------------------------- 

function gameClear()
    gameOver:removeEventListener("tap", gameOver)
    gameOverText:removeSelf()
end

------------------------ CLEAR QUESTION FUNCTION -------------------------- 

function clearQuestion()
    questionText:removeSelf()
    Ans1Text:removeSelf()
    Ans2Text:removeSelf()
    Ans3Text:removeSelf()
    correctAns = 0
end

------------------------ GENERATE QUESTION FUNCTION -------------------------- 

function generateQuestion()
    local num = math.random(9)
    
    if  ( Ans1Box ~= nil ) and ( Ans2Box ~= nil ) and ( Ans3Box ~= nil ) then
        Ans1Box:removeSelf()
        Ans2Box:removeSelf()
        Ans3Box:removeSelf()
    end
    
    Ans1Box = display.newRect(40, 280, 100, 60)
    Ans1Box:setFillColor(0, 0.3, 0)
    Ans2Box = display.newRect(220, 280, 100, 60)
    Ans2Box:setFillColor(0, 0.3, 0)
    Ans3Box = display.newRect(400, 280, 100, 60)
    Ans3Box:setFillColor(0, 0.3, 0)
    Ans1Box.tap = Ans1BoxListener
    Ans1Box:addEventListener("tap", Ans1Box)
    Ans2Box.tap = Ans2BoxListener
    Ans2Box:addEventListener("tap", Ans2Box)
    Ans3Box.tap = Ans3BoxListener
    Ans3Box:addEventListener("tap", Ans3Box)
    
    questionText = display.newText(question[num].q , 60, 210, "Arial", 18)
    questionText:setFillColor(1, 1, 1)
    Ans1Text = display.newText(question[num].t1, 10, 260, "Arial", 18)
    Ans1Text:setFillColor(0, 1, 0)
    Ans2Text = display.newText(question[num].t2, 190, 260, "Arial", 18)
    Ans2Text:setFillColor(0, 1, 0)
    Ans3Text = display.newText(question[num].t3, 370, 260, "Arial", 18)
    Ans3Text:setFillColor(0, 1, 0)
    correctAns = question[num].ans
    audioSample = audio.loadSound(question[num].audio)
    
    if audioBox ~= nil then
        audioBox:removeSelf()
    end
    
    audioBox = display.newImage("art/Game3/audio_icon.png",100,100)
    audioBox:scale(0.1,0.1)
    audioBox.tap = AudioBoxListener
    audioBox:addEventListener("tap", audioBox)

end

------------------------ ENEMY MOVE FUNCTION --------------------------

function enemyMove()
    if lives == 2 then 
        enemy:removeSelf()
        enemy = display.newImage("art/Game2/yakuza2.png")
        enemy:translate(300, 130)
    end
    if lives == 1 then
        enemy:removeSelf()
        enemy = display.newImage("art/Game2/yakuza2.png")
        enemy:translate(200, 130)
    end
end

------------------------ ANSWER FUNCTION -------------------------- 

function answer()
    if chosenAns == correctAns then
        print("Correct Answer")
    end
    if chosenAns ~= correctAns then
        lives = lives - 1
        enemyMove()
        print("Wrong Answer")

    end
    
    livesText:removeSelf()
    livesText = display.newText("Lives: "..lives, 40, 40, "Arial", 20)
    
    if lives == 0 then
        gameOver()
    end
    
    if lives ~=0 then
        clearQuestion()
        generateQuestion()
    end
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

local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local screenGroup = self.view
    bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
    --bg:scale(0.6*xscale,0.6*yscale)
    screenGroup:insert(bg)
   
    Game2()
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
