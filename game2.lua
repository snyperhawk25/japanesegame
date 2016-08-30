---------------------------------------------------------------------------------
-- game2.lua ("Vocab")
-- This is the Vocab game. It uses quesions[0-9] from Questions.lua that are basic objects.
-- Barrett Sharpe, 2016. GitHub:"Snyperhawk25/japanesegame"
--------------------------------------------------------------------------------

----------------------------------------
--REQUIRE
----------------------------------------

--local composer = require("composer") --required for getting current scene name. getSceneName() //was not working
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"
require("questions")
require("vocab")
require("test.shufflingTest")

-----------------------------------------
--SCENE VARIABLES
-----------------------------------------

local score=0
local questionCounter=0
local questionsStartIndex = 1
local questionsEndIndex = 10
local orderOfQuestions={}

local scoreText, countText
local enemy
local player
local isMale=false 
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
--audio.setVolume(1.0)

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

local playerX = 55
local playerY = 140
local playerScale = 0.35

local enemyX = 450
local enemyY = 120
local enemyScale = 0.40

local audioBoxX = 20
local audioBoxY = 30
local audioBoxScale = 0.4

local scoreTextX = centerX
local scoreTextY = 75

local menuX = 460
local menuY = 30

local heartX = 5 -- -10
local heartY = 130
local heartScale = 0.25
local heartOffset = 30

local AnsBoxSize = 90
local Ans1BoxX = 60
local Ans2BoxX = 240
local Ans3BoxX = 420
local AnsBoxY = 270

local AnsTextScale = 0.15
local AnsTextTranslateX = 45
local AnsTextTranslateY = 10
local Ans1ImageX = 10
local Ans2ImageX = 190
local Ans3ImageX = 370
local AnsImageY = 260

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
    --Reaction Images based on Lives 
    if lives == 3 then
        if isMale then 
            player = display.newImage("art/Game1/mhappy.png",playerX,playerY)
        else
            player = display.newImage("art/Game1/femhappy.png",playerX,playerY)
        end
    end
    if lives == 2 then 
        if isMale then 
            player = display.newImage("art/Game1/mneutral.png",playerX,playerY)
        else
            player = display.newImage("art/Game1/femneutral.png",playerX,playerY)
        end
    end
    if lives == 1 then
        if isMale then 
            player = display.newImage("art/Game1/mscared.png",playerX,playerY)
        else
            player = display.newImage("art/Game1/femscared.png",playerX,playerY)
        end
    end
    --Scale Image
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
        transition.to(enemy,{x=enemyX,y=enemyY,time=1500})
    end
    if lives == 1 then
        --Change position
        enemyX=enemyX-160
        --Transition animation
        transition.to(enemy,{x=enemyX,y=enemyY,time=1500})
    end
    --No position for lives == 0, because the game doesn't need to draw the enemy after player loss (respectively)
end

--Funtion to update the number of hearts on the screen above the player
function updateHearts()
    --Based on player's lives remaining
    if lives == 3 then
        --Initial state. Add all 3 hearts to scene
        heart1 = display.newImage("images/heart.png",heartX,heartY)
        heart1:scale(heartScale,heartScale)
        heart2 = display.newImage("images/heart.png",heartX,heartY+heartOffset)
        heart2:scale(heartScale,heartScale)
        heart3 = display.newImage("images/heart.png",heartX,heartY+(2*heartOffset))
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
    livesText = display.newText(""..lives, heartX, heartY-heartOffset, "Arial", 20)
end

--Function to remove the elements of the active question, including the answer images from the scene. Also to 'zero' the correct answer integer.
function clearQuestion()
    --Question Text
    questionText:removeSelf()
    --Images
    Ans1Image:removeSelf()
    Ans2Image:removeSelf()
    Ans3Image:removeSelf()

    --Reset Answer
    correctAns = 0
end

---------------------------------------------
--METHODS
---------------------------------------------

--Function to generate the next question.
function generateQuestion()
    
    --Check questionCounter for need of reordering orderOfQuestions
    if questionCounter%(questionsEndIndex-questionsStartIndex+1)==0 then
        --Check for first-time ordering
        if questionCounter==0 then
            orderOfQuestions = fisherYatesNumbers(questionsStartIndex,questionsEndIndex)
        end  
        orderOfQuestions = fisherYatesNumbers(questionsStartIndex,questionsEndIndex,orderOfQuestions[1])
    end    
    print("orderOfQuestions["..((questionCounter % (questionsEndIndex-questionsStartIndex+1))+1).."];")
    local num = orderOfQuestions[(questionCounter%(questionsEndIndex-questionsStartIndex+1))+1]
    print("questions.lua Question Index: "..num..".")

    
    --Remove existing AnswerBoxes (not images)
    if  ( Ans1Box ~= nil ) and ( Ans2Box ~= nil ) and ( Ans3Box ~= nil ) then --optimize?
        Ans1Box:removeSelf()
        Ans2Box:removeSelf()
        Ans3Box:removeSelf()
    end
    
    --Shuffle Coordinates and Re-assign.
    local coordinateOrder = {}
    --coordinateOrder = fisherYates({{Ans1BoxX, Ans1ImageX},{Ans2BoxX, Ans2ImageX},{Ans3BoxX, Ans3ImageX}})
    coordinateOrder = fisherYates({{60, 10},{240, 190},{420, 370}})

    Ans1BoxX = coordinateOrder[1][1]
    Ans1ImageX = coordinateOrder[1][2]
    Ans2BoxX = coordinateOrder[2][1]
    Ans2ImageX = coordinateOrder[2][2]
    Ans3BoxX = coordinateOrder[3][1]
    Ans3ImageX= coordinateOrder[3][2]
    --print("CoordTest1: Box:"..Ans1BoxX.."; Image:"..Ans1ImageX..";")

    --Create new AnswerBoxes
    --Answer Box Rectangles
    Ans1Box = display.newRect(Ans1BoxX, AnsBoxY, AnsBoxSize, AnsBoxSize)
    Ans1Box:setFillColor(0.85,0.85,0.85)
    --Ans1Box:setFillColor(0.85,0,0.85) --purple

    Ans2Box = display.newRect(Ans2BoxX, AnsBoxY, AnsBoxSize, AnsBoxSize)
    Ans2Box:setFillColor(0.85,0.85,0.85)
    --Ans2Box:setFillColor(0,0.85,0.85) --teal

    Ans3Box = display.newRect(Ans3BoxX, AnsBoxY, AnsBoxSize, AnsBoxSize)
    Ans3Box:setFillColor(0.85,0.85,0.85)
    --Ans3Box:setFillColor(0.85,0.85,0) --yellow?

    --Answer Box Listeners
    Ans1Box:addEventListener("tap", Ans1BoxListener)
    Ans2Box:addEventListener("tap", Ans2BoxListener)
    Ans3Box:addEventListener("tap", Ans3BoxListener)
    
    --Add Answer Object Images
    --Answer Images
    Ans1Image = display.newImage(question[num].a1, Ans1ImageX, AnsImageY)
    Ans1Image:scale(AnsTextScale,AnsTextScale)
    Ans1Image:translate(AnsTextTranslateX,AnsTextTranslateY)

    Ans2Image = display.newImage(question[num].a2, Ans2ImageX,AnsImageY)
    Ans2Image:scale(AnsTextScale,AnsTextScale)
    Ans2Image:translate(AnsTextTranslateX,AnsTextTranslateY)

    Ans3Image = display.newImage(question[num].a3, Ans3ImageX, AnsImageY)
    Ans3Image:scale(AnsTextScale,AnsTextScale)
    Ans3Image:translate(AnsTextTranslateX,AnsTextTranslateY)

    --Add Question Text
    questionText = display.newText(question[num].qj , questionTextX, questionTextY, "Arial", 24)
    questionText:setFillColor(0, 0, 0)
    
    --Set correct answer and correct audio sample
    correctAns = question[num].ans
    audioSample = audio.loadSound(question[num].audio)
    

    --Initialize Audio Box
    if audioBox ~= nil then
        audioBox:removeSelf()
    end
    audioBox = display.newImage("images/Speaker_Icon.png",audioBoxX,audioBoxY)
    audioBox:scale(audioBoxScale,audioBoxScale)
    audioBox:addEventListener("tap", AudioBoxListener)

    --Increment question counter, print countText
    questionCounter=questionCounter+1
    if countText ~= nil then
        countText:removeSelf()
    end
    if questionCounter > (questionsEndIndex-questionsStartIndex+1) then
        countText = display.newText(""..(questionsEndIndex-questionsStartIndex+1).." / "..(questionsEndIndex-questionsStartIndex+1), 450, 60, native.systemFont, 15)
    else
        countText = display.newText(""..questionCounter.." / "..(questionsEndIndex-questionsStartIndex+1), 450, 60, native.systemFont, 15)
    end
end

--Function to evaluate the player-selected answer
function evaluateAnswer()
    if chosenAns == correctAns then
        --Print/Sound Correct
        audio.play(audioCorrect,{channel=4})
        print("Correct Answer")
        --Increment Score
        score=score+1
        scoreText:removeSelf()
        scoreText= display.newText(""..score, scoreTextX, scoreTextY, "Arial", 35)
        scoreText:setFillColor(0,1,0)
    else
        --Print/Sound Incorrect
        audio.play(audioIncorrect,{channel=4})
        print("Wrong Answer")
        --Decrement Lives
        lives = lives - 1
        --Draw Enemy, Player and Update Hearts
        drawEnemy()
        drawPlayer() --//!@#
        updateHearts()
    end
    
    --Check if remaining lives.
    if lives == 0 then
        gameOver()
    else
        --Continue playing with new question.
        clearQuestion()
        generateQuestion()  --r?
    end
end

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("game2")
    end
    timer.performWithDelay(500, removeSceneListener)
end

--Function to remove all display objects from the scene.
local function removeAllDisplayObjects()
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
    display.remove(scoreText)
    display.remove(countText)
end

--Function to return to the Main Menu (menu.lua)
local function goToMenu()
    --Click Audio
    audio.play(audioClick,{channel=3})
    --Remove Display Objects
    removeAllDisplayObjects()

    --Change Scenes and Delay Removal
    storyboard.gotoScene("menu","fade",500)
    delayedSceneRemoval()
end

--This function begins Game2.lua (Vocab)*************************
function Game2()
    --Start by setting 'lives' to 3.
    lives = 3
    --And picking isMale
    if (math.random(2)-1)==0 then
        isMale = true
    else
        isMale = false
    end
    print(isMale)
    print("the isMale value is above.")
    --Randomize Seed
    math.randomseed(os.time())

    --Now we draw our scene elements.
    --Question Bubble
    questionBubble = display.newImage("images/bubble.png", questionBubbleX,questionBubbleY)
    questionBubble:scale(0.5,0.18)
    --Menu Button
    menu = display.newImage("images/Menu.png",menuX,menuY)
    menu:scale(0.40,0.40)
    menu:addEventListener("tap", goToMenu) 
    
    --Draw Player and Enemy.
    drawPlayer()
    drawEnemy()
    
    --Set Hearts and Lives Text.
    updateHearts()
    
    --Score Text
    scoreText= display.newText(""..score, scoreTextX, scoreTextY, "Arial", 35)
    scoreText:setFillColor(0,1,0)

    --Finally, Begin Playing by Generating A Question.
    generateQuestion()
end


------------------------ GAME OVER FUNCTION -------------------------- 

--Function to transition to the game over screen, to display score and option.
function gameOver()
    --Print to Console
    print("GAME OVER")

    --Remove All Event Listeners and Display Objects //!@# expand
    Ans1Box:removeEventListener("tap", Ans1Box)
    Ans2Box:removeEventListener("tap", Ans2Box)
    Ans3Box:removeEventListener("tap", Ans3Box)
    removeAllDisplayObjects()

    --Collect Important Information (along with transition info)
    local gameOverOptions = {
        effect = "fade",
        time = 500,
        params = {
            --var1 = "test",
            retryScene = "game2",
            gameName = "Item Vocab",
            finalScore = score,
            finalScoreUnit = "Correct",
            finalDescription = "You got "..score.." correct word(s) before the Yakuza got you.",
            var2 = "hi",
            --app 42 info
            app42GameName = "Item_Vocab"
        }
    }

    --gameOver = display.newRect(-100, -100, 2000, 2000)
    --gameOver:setFillColor(0, 0, 0)
    
    --gameOverText = display.newText("GAME OVER!...", 40, 10, "Arial", 20)
    --gameOverText:setFillColor(0.8, 0, 0)
    --gameOver:addEventListener("tap", gameClear)

    --Change Scenes and Delay Removal
    storyboard.gotoScene("numbers.numbersScorePage", gameOverOptions)
    delayedSceneRemoval()

end 

function gameClear()
    gameOver:removeEventListener("tap", gameOver)
    gameOverText:removeSelf()
end

-------------------------------------------
--LISTENERS
-------------------------------------------

--Answer Box Listeners 1 - 3
function Ans1BoxListener()
    local function animate(event)
        audio.play(audioClick,{channel=3})
        transition.from(Ans1Box,{time=200,x=Ans1BoxX,y=AnsBoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(50,animate) --timer required to animate properly.
    print("Answer Box 1 Pressed")
    chosenAns = 1
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

function Ans2BoxListener()
    local function animate(event)
        audio.play(audioClick,{channel=3})
        transition.from(Ans2Box,{time=200,x=Ans2BoxX,y=AnsBoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(50,animate) --timer required to animate properly.
    print("Answer Box 2 Pressed")
    chosenAns = 2
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

function Ans3BoxListener()
    local function animate(event)
        audio.play(audioClick,{channel=3})
        transition.from(Ans3Box,{time=200,x=Ans3BoxX,y=AnsBoxY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(50,animate) --timer required to animate properly.
    print("Answer Box 3 Pressed")
    chosenAns = 3
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

--Audio Box Listener
function AudioBoxListener()
    print("AudioBoxListener tapped.")
    local function animate(event)
        --Start Audio Pronunciation
        audio.play(audioSample,{channel=2})
        transition.from(audioBox,{time=1000,x=audioBoxX,y=audioBoxY,xScale=audioBoxScale-0.05,yScale=audioBoxScale-0.05})
    end
    timer.performWithDelay(50,animate)
end

-------------------------------------------------
--CORONA SCENE EVENTS
-------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local screenGroup = self.view
    --Load background image
    bg = display.newImage("images/bg.png", centerX,centerY+30)
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
    --Dispose Audio
    --audio.dispose(audioClick)
    --audio.dispose(audioCorrect)
    --audio.dispose(audioIncorrect)
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