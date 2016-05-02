---------------------------------------------------------------------------------
-- game2.lua ("Vocab")
-- This is the Vocab game. It uses quesions[0-9] from Questions.lua.
-- Barrett Sharpe
--------------------------------------------------------------------------------

----------------------------------------
--REQUIRE
----------------------------------------

--local composer = require("composer")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
require("questions")
require("vocab")

-----------------------------------------
--SCENE VARIABLES
-----------------------------------------

local enemy
local player
local menu
local heart1,heart2,heart3
local questionBubble, questionText
local Ans1Box, Ans2Box, Ans3Box
local Ans1Image, Ans2Image, Ans3Image
local lives, livesText
local correctAns
local chosenAns
local gameOver, gameOverText
local q1, q2, q3
local audioBox, audioSample
--Audio
local audioCorrect = audio.loadSound("audio/ding1.wav")
local audioIncorrect = audio.loadSound("audio/buzz1.wav")
local audioClick = audio.loadSound("audio/click1.wav")
--Centers
local centerX = display.contentCenterX
local centerY = display.contentCenterY

----------------------------------------
--COORDINATES
----------------------------------------

local questionTextX = 240
local questionTextY = 30
local questionBubbleX = 240
local questionBubbleY = 30

local playerX = 40
local playerY = 130
local playerScale = 0.4

local enemyX = 450
local enemyY = 110
local enemyScale = 0.45

local audioBoxX = 20
local audioBoxY = 30
local audioBoxScale = 0.1

local menuX = 465
local menuY = 30

--//!@#Need some heart png's with alpha backgrounds from Kate
local heartX = -10
local heartY = 130
local heartScale = 0.07
local heartOffset = 30

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
local Ans1ImageX = 10
local Ans1ImageY = 260
local Ans2ImageX = 190
local Ans2ImageY = 260
local Ans3ImageX = 370
local Ans3ImageY = 260

---------------------------------------------
--VISUAL METHODS
---------------------------------------------

--Function to draw the Player image at the Player coordinates (playerX,playerY)
local function drawPlayer()
    --Remove Existing Player
    if player ~= nil then
        player:removeSelf()
    end
    --Draw Player 
    player = display.newImage("art/Game1/mcanada.png",playerX,playerY)
    player:scale(playerScale,playerScale)
end

--Function to draw/animate the Enemy image at the Enemy coordinates (enemyX,enemyY)
local function drawEnemy()
    --Position based on the player's remaining lives
    if lives == 3 then
        --Initial state. Draw Enemy at enemy position
        enemy = display.newImage("art/Game2/yakuza2.png", enemyX,enemyY)
        enemy:scale(enemyScale, enemyScale)
    end
    if lives == 2 then 
        --Change position
        enemyX=enemyX-125
        --Transition animation
        transition.to(enemy,{x=enemyX,y=enemyY,time=2000})
    end
    if lives == 1 then
        --Change position
        enemyX=enemyX-160
        --Transition animation
        transition.to(enemy,{x=enemyX,y=enemyY,time=2000})
    end
    --No position for lives == 0, because the game doesn't need to draw the enemy after player loss (respectively)
end

--Funtion to update the number of hearts on the screen above the player
function updateHearts()
    --Based on player's lives remaining
    if lives == 3 then
        --Initial state. Add all 3 hearts to scene
        heart1 = display.newImage("art/Game3/hamburger.png",heartX,heartY)
        heart1:scale(heartScale,heartScale)
        heart2 = display.newImage("art/Game3/hamburger.png",heartX,heartY+heartOffset)
        heart2:scale(heartScale,heartScale)
        heart3 = display.newImage("art/Game3/hamburger.png",heartX,heartY+(2*heartOffset))
        heart3:scale(heartScale,heartScale)
    end
    if lives == 2 then
        --remove heart3
        heart3:removeSelf()
    end
    if lives == 1 then
        --remove heart2
        heart2:removeSelf()
    end

    --Update the displayed lives value
    if livesText ~= nil then
        livesText:removeSelf()
    end
    livesText = display.newText(""..lives, heartX, heartY-heartOffset, "Arial", 25)
end

--Function to remove the text of the question and the answer images from the scene. Also to 'zero' the correct answer integer.
function clearQuestion()
    questionText:removeSelf()
    Ans1Image:removeSelf()
    Ans2Image:removeSelf()
    Ans3Image:removeSelf()
    correctAns = 0
end
---------------------------------------------
--METHODS
---------------------------------------------

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("game2")
    end
    timer.performWithDelay(500, removeSceneListener)
end

--Function to return to the Main Menu (menu.lua)
local function goToMenu()
    --Click Audio
    audio.play(audioClick)

    --Remove Objects
    display.remove(gameOverText)

    display.remove(Ans1Box)
    display.remove(Ans2Box)
    display.remove(Ans3Box)

    display.remove(Ans1Image)
    display.remove(Ans2Image)
    display.remove(Ans3Image)

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

    --Change Scenes and Delay Removal
    storyboard.gotoScene("menu","fade",500)
    delayedSceneRemoval()
end

------------------------ GAME INITIALIZE FUNCTION -------------------------- 

--This function begins Game2.lua (Vocab)
function Game2()
    --Start by setting 'lives' to 3.
    lives = 3

    --Now we draw our scene elements
    --Question Bubble
    questionBubble = display.newImage("images/bubble.png", questionBubbleX,questionBubbleY)
    questionBubble:scale(0.5,0.18)

    --Menu Button
    menu = display.newImage("images/Menu.png",menuX,menuY)
    menu:scale(0.45,0.45)
    menu:addEventListener("tap", goToMenu)

    

    --//!@#Loop?

    --Draw Player and Enemy
    drawPlayer()
    drawEnemy()
    --Set Hearts and Lives Text.
    updateHearts()

    --Begin Playing by Generating Questions
    generateQuestion()
end

------------------------ GAME OVER FUNCTION -------------------------- 

--//!@#THis function will need to be changed
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

function gameClear()
    gameOver:removeEventListener("tap", gameOver)
    gameOverText:removeSelf()
end





------------------------ GENERATE QUESTION FUNCTION -------------------------- 

--Function to generate the next question.
function generateQuestion()
    local num = math.random(9)
    
    if  ( Ans1Box ~= nil ) and ( Ans2Box ~= nil ) and ( Ans3Box ~= nil ) then --//!@#optmize? Something in one --> something in all?
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
    Ans1Image = display.newImage(question[num].a1, Ans1ImageX, Ans1ImageY)
    Ans1Image:scale(AnsTextScale,AnsTextScale)
    Ans1Image:translate(AnsTextTranslateX,AnsTextTranslateY)

    Ans2Image = display.newImage(question[num].a2, Ans2ImageX,Ans2ImageY)
    Ans2Image:scale(AnsTextScale,AnsTextScale)
    Ans2Image:translate(AnsTextTranslateX,AnsTextTranslateY)

    Ans3Image = display.newImage(question[num].a3, Ans3ImageX, Ans3ImageY)
    Ans3Image:scale(AnsTextScale,AnsTextScale)
    Ans3Image:translate(AnsTextTranslateX,AnsTextTranslateY)

    --b Change to "question[num].qj" for string literal japanese
    questionText = display.newText(question[num].qj , questionTextX, questionTextY, "Arial", 24)
    questionText:setFillColor(0, 0, 0)

    
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


------------------------ ANSWER FUNCTION -------------------------- 
--Function to evaluate the player-selected answer
function evaluateAnswer()
    if chosenAns == correctAns then
        --Print/Sound Correct
        audio.play(audioCorrect)
        print("Correct Answer")
    else
        --Print/Sound Correct
        audio.play(audioIncorrect)
        print("Wrong Answer")
        --Decrement Lives
        lives = lives - 1
        --Draw Enemy and Update Hearts
        drawEnemy()
        updateHearts()
    end
    
    --Check if remaining lives
    if lives == 0 then
        gameOver()
    else
        clearQuestion()
        generateQuestion() --//!@#this is recurisive
    end
end    

------------------------ ANSBOX LISTENERS -------------------------- 

-------------------------------------------
--LISTENERS
-------------------------------------------
--Answer box Listeners 1 - 3
function Ans1BoxListener()
    local function animate(event)
        transition.from(Ans1Box,{time=200,x=Ans1BoxX,y=Ans1BoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 1 Pressed")
    chosenAns = 1
    evaluateAnswer()
end

function Ans2BoxListener()
    local function animate(event)
        transition.from(Ans2Box,{time=200,x=Ans2BoxX,y=Ans2BoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 2 Pressed")
    chosenAns = 2
    evaluateAnswer()
end

function Ans3BoxListener()
    local function animate(event)
        transition.from(Ans3Box,{time=200,x=Ans3BoxX,y=Ans3BoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 3 Pressed")
    chosenAns = 3
    evaluateAnswer()
end

--Audio Box Listener
function AudioBoxListener()
    local function animate(event)
        transition.from(audioBox,{time=1000,x=audioBoxX,y=audioBoxY,xScale=audioBoxScale-0.05,yScale=audioBoxScale-0.05})
    end  
    --Start Audio
    audio.play(audioSample)
    print("AudioBoxListener tapped.")
    --Then Animate
    animate() --//!@#timer didnt work here
end

-------------------------------------------------
--CORONA SCENE EVENTS
-------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local screenGroup = self.view
    --Load background image
    bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
    screenGroup:insert(bg)
    --bg:scale(0.6*xscale,0.6*yscale)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    --Play Game
    Game2()
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    
end


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
