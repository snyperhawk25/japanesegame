--------------------------------------------------------------------------------
--
-- game2.lua
-- This is the Vocab game. It uses quesions[0-9] from Questions.lua.
--------------------------------------------------------------------------------

require("questions")
require("vocab")

--local composer = require("composer")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


local enemy
local player
local menu
local heart1,heart2,heart3
local questionBubble
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
local audioCorrect, audioIncorrect, audioClick

local centerX = display.contentCenterX
local centerY = display.contentCenterY

--Delayed Scene Removal
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("game2")
    end
    timer.performWithDelay(500, removeSceneListener)
end

--Function to return to the Main Menu (menu.lua)
local function goToMenu() --update this method

    --Click Audio
    audio.play(audioClick)

    display.remove(gameOverText)

    display.remove(Ans1Box)
    display.remove(Ans2Box)
    display.remove(Ans3Box)

    display.remove(Ans1Text)
    display.remove(Ans2Text)
    display.remove(Ans3Text)

    display.remove(questionText)
    display.remove(questionBubble)

    display.remove(enemy)
    display.remove(player)
    display.remove(heart1)
    display.remove(heart2)
    display.remove(heart3)

    display.remove(livesText)
    display.remove(audioBox)
    display.remove(menu)

    --Change Scenes
    storyboard.gotoScene("menu","fade",500)
    delayedSceneRemoval()
end
-------------------------
--COORDINATES
local livesTextX = 25 --may not be of use anymore, as
local livesTextY = 55 --text wil be at heartX minus some.

local questionTextX = 240
local questionTextY = 30
local questionBubbleX = 240
local questionBubbleY = 30

local playerX = 40
local playerY = 130

local enemyX = 450
local enemyY = 110

local audioBoxX = 20 --475
local audioBoxY = 30
local audioBoxScale = 0.1

local menuX = 465
local menuY = 30

--//!@#Need some heart png's with alpha backgrounds from Kate
local heartX = -10
local heartY = 130
local heartScale = 0.07

--ANSWER BOXES AND ANSWER IMAGES("Text" for images for now)
local AnsBoxSize = 90
local Ans1BoxX = 60
local Ans1BoxY = 270
local Ans2BoxX = 240
local Ans2BoxY = 270
local Ans3BoxX = 420
local Ans3BoxY = 270

local AnsTextScale = 0.15
local AnsTextTranslateX = 45
local AnsTextTranslateY = 10
local Ans1TextX = 10
local Ans1TextY = 260
local Ans2TextX = 190
local Ans2TextY = 260
local Ans3TextX = 370
local Ans3TextY = 260

------------------------ GAME INITIALIZE FUNCTION -------------------------- 

function Game2()
    --draw Character and Enemy
    drawCharacter()
    enemy = display.newImage("art/Game2/yakuza2.png", enemyX,enemyY)
    enemy:scale(0.45, 0.45)

    --Question Bubble
    questionBubble = display.newImage("images/bubble.png", questionBubbleX,questionBubbleY)
    questionBubble:scale(0.5,0.18)

    --lives text and hearts(to be moved later)
    lives = 3
    livesText = display.newText(""..lives, heartX, heartY-30, "Arial", 25)
    heart1 = display.newImage("art/Game3/hamburger.png",heartX,heartY)
    heart1:scale(heartScale,heartScale)
    heart2 = display.newImage("art/Game3/hamburger.png",heartX,heartY+30)
    heart2:scale(heartScale,heartScale)
    heart3 = display.newImage("art/Game3/hamburger.png",heartX,heartY+60)
    heart3:scale(heartScale,heartScale)

    --Menu Button
    menu = display.newImage("images/Menu.png",menuX,menuY)
    menu:scale(0.45,0.45)
    menu:addEventListener("tap", goToMenu)

    --Initial Audio
    audioCorrect = audio.loadSound("audio/ding1.wav")
    audioIncorrect = audio.loadSound("audio/buzz1.wav")
    audioClick = audio.loadSound("audio/click1.wav")
    

    --Begin Playing by Generating Questions
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

    --Dont go to menu immediately
    --timer.performWithDelay(1,goToMenu)
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
    
    --Answer Box Rectangles
    Ans1Box = display.newRect(Ans1BoxX, Ans1BoxY, AnsBoxSize, AnsBoxSize)
    Ans1Box:setFillColor(0.85,0.85,0.85)
    Ans2Box = display.newRect(Ans2BoxX, Ans2BoxY, AnsBoxSize, AnsBoxSize)
    Ans2Box:setFillColor(0.85,0.85,0.85)
    Ans3Box = display.newRect(Ans3BoxX, Ans3BoxY, AnsBoxSize, AnsBoxSize)
    Ans3Box:setFillColor(0.85,0.85,0.85)
    --Answer Box Listeners
    Ans1Box.tap = Ans1BoxListener
    Ans1Box:addEventListener("tap", Ans1Box)
    Ans2Box.tap = Ans2BoxListener
    Ans2Box:addEventListener("tap", Ans2Box)
    Ans3Box.tap = Ans3BoxListener
    Ans3Box:addEventListener("tap", Ans3Box)
    
    --Answer Images
    Ans1Text = display.newImage(question[num].a1, Ans1TextX, Ans1TextY)
    Ans1Text:scale(AnsTextScale,AnsTextScale)
    Ans1Text:translate(AnsTextTranslateX,AnsTextTranslateY)

    Ans2Text = display.newImage(question[num].a2, Ans2TextX,Ans2TextY)
    Ans2Text:scale(AnsTextScale,AnsTextScale)
    Ans2Text:translate(AnsTextTranslateX,AnsTextTranslateY)

    Ans3Text = display.newImage(question[num].a3, Ans3TextX, Ans3TextY)
    Ans3Text:scale(AnsTextScale,AnsTextScale)
    Ans3Text:translate(AnsTextTranslateX,AnsTextTranslateY)

    --b Change to "question[num].qj" for string literal japanese
    questionText = display.newText(question[num].qj , questionTextX, questionTextY, "Arial", 24)
    questionText:setFillColor(0, 0, 0)
    


    --swapped to images from .t1 to .a1, etc
    --Ans1Text = display.newText(question[num].t1, 10, 260, "Arial", 18)
   -- Ans1Text:setFillColor(0, 1, 0)
    --Ans2Text = display.newText(question[num].t2, 190, 260, "Arial", 18)
    --Ans2Text:setFillColor(0, 1, 0)
    --Ans3Text = display.newText(question[num].t3, 370, 260, "Arial", 18)
    --Ans3Text:setFillColor(0, 1, 0)

    
    --Set correct answer and correct audio
    correctAns = question[num].ans
    audioSample = audio.loadSound(question[num].audio)
    

    --Audio Box
    if audioBox ~= nil then
        audioBox:removeSelf()
    end
    audioBox = display.newImage("art/Game3/audio_icon.png",audioBoxX,audioBoxY)
    audioBox:scale(audioBoxScale,audioBoxScale)
    audioBox.tap = AudioBoxListener
    audioBox:addEventListener("tap", audioBox)

end

-------------------------Draw Character-------------------------
function drawCharacter()
    if player ~= nil then
        player:removeSelf()
    end
    player = display.newImage("art/Game1/mcanada.png",playerX,playerY)
    player:scale(0.4,0.4)
end

------------------------ ENEMY MOVE FUNCTION --------------------------

function enemyMove()
    if lives == 2 then 
        --enemy:removeSelf()
        --enemy = display.newImage("art/Game2/yakuza2.png")
        --enemy:scale(0.5,0.5)
        --enemy:translate(300, 130)
        --transition.to(enemy,{x=300,y=130,time=2000})

        --new method
        enemyX=enemyX-125
        transition.to(enemy,{x=enemyX,y=enemyY,time=2000})
    end
    if lives == 1 then
        --enemy:removeSelf()
       -- enemy = display.newImage("art/Game2/yakuza2.png")
       -- enemy:scale(0.5,0.5)
        --enemy:translate(200, 130)

        --new
        enemyX=enemyX-160
        transition.to(enemy,{x=enemyX,y=enemyY,time=2000})
    end
end

--Updates the number of hearts on the screen above the player
function updateHearts()
    if lives == 2 then
        --remove heart3
        heart3:removeSelf()
    end
    if lives == 1 then
        --remove heart2
        heart2:removeSelf()
    end
end
------------------------ ANSWER FUNCTION -------------------------- 

function answer()
    if chosenAns == correctAns then
        --Audio Correct
        audio.play(audioCorrect)
        print("Correct Answer")
    else
        --Decrement Lives
        lives = lives - 1
        --Audio Incorrect
        audio.play(audioIncorrect)
        print("Wrong Answer")
        --Move Enemy
        enemyMove()
        --Update Hearts
        updateHearts()
    end
    
    livesText:removeSelf()
    livesText = display.newText(""..lives, heartX, heartY-30, "Arial", 25)
    
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
    local function animate(event)
        transition.from(Ans1Box,{time=200,x=Ans1BoxX,y=Ans1BoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Ans1Box")
    chosenAns = 1
    answer()
end

function Ans2BoxListener()
    local function animate(event)
        transition.from(Ans2Box,{time=200,x=Ans2BoxX,y=Ans2BoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Ans2Box")
    chosenAns = 2
    answer()
end

function Ans3BoxListener()
    local function animate(event)
        transition.from(Ans3Box,{time=200,x=Ans3BoxX,y=Ans3BoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Ans3Box")
    chosenAns = 3
    answer()
end

--Audio Box Listener
function AudioBoxListener()
    local function animate(event)
        transition.from(audioBox,{
            time=1000,
            x=audioBoxX,
            y=audioBoxY,
            xScale=audioBoxScale-0.05,
            yScale=audioBoxScale-0.05
        })
    end  
    --Initial Print. Start Audio.    
    print("AudioBoxListener tapped.")
    audio.play(audioSample)

    --Animate
    animate() --timer didnt work here
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
    local screenGroup = self.view
    bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
    --bg:scale(0.6*xscale,0.6*yscale)
    screenGroup:insert(bg)
     
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    --main game function
    Game2()
   
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
