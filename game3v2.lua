--game3v2.lua
---------------------------------------------------------------------------------
-- game3v2.lua ("Food Vocab, version 2")
-- This is the Food Vocab game. It uses quesions[10-20] from Questions.lua that are basic objects.
-- Barrett Sharpe, 2016. GitHub:"Snyperhawk25/japanesegame"

--Note, this is a structural copy of game2, with visual modifications.
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

local customer, chef
local score, scoreText



local menu
local questionBubble, questionText
local Ans1Box, Ans2Box, Ans3Box
local Ans1Image, Ans2Image, Ans3Image
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
local backgroundX = 300
local backgroundY = 130
local backgroundScale = 1.0

local questionTextX = 240
local questionTextY = 30
local questionBubbleX = 240
local questionBubbleY = 30

local customerX = 100
local customerY = 130
local customerScale = 0.4

local chefX = 300
local chefY = 130
local chefScale = 0.45

local audioBoxX = 20
local audioBoxY = 30
local audioBoxScale = 0.4

local menuX = 465
local menuY = 30

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

--Function to draw the customer image at the customer coordinates (customerX,customerY)
local function drawScene()
    --1) Draw Customer
    if customer ~= nil then
        customer:removeSelf()
    end
    customer = display.newImage("art/Game3/customer.png",customerX,customerY)
    customer:scale(customerScale,customerScale)

    --2) Draw Chef
    if chef ~= nil then
        chef:removeSelf()
    end
    chef = display.newImage("art/Game3/chef.png", chefX,chefY)
    chef:scale(chefScale, chefScale)

    --3) Draw Question Bubble
    if questionBubble~=nil then
    	questionBubble:removeSelf()
    end
    questionBubble = display.newImage("images/bubble.png", questionBubbleX,questionBubbleY)
    questionBubble:scale(0.5,0.18)

    --4) Draw Menu Button
    if menu~=nil then
    	menu:removeSelf()
    end
    menu = display.newImage("images/Menu.png",menuX,menuY)
    menu:scale(0.45,0.45)
    menu:addEventListener("tap", goToMenu) 

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
    --Step 1: Random question number from 10-20 (random(n) goes form 1<x<n)
    local num = math.random(10,20)
    
    --Step 2: Remove existing AnswerBoxes (not images)
    if  ( Ans1Box ~= nil ) and ( Ans2Box ~= nil ) and ( Ans3Box ~= nil ) then --optimize?
        Ans1Box:removeSelf()
        Ans2Box:removeSelf()
        Ans3Box:removeSelf()
    end
    
    --Step 3: Create new AnswerBoxes
    --Answer Box Plates (instead of Rectangles)
    Ans1Box = display.newImage("images/plate.png",Ans1BoxX, Ans1BoxY)
    Ans1Box:scale(AnsBoxSize, AnsBoxSize)
    Ans2Box = display.newImage("images/plate.png",Ans2BoxX, Ans2BoxY)
    Ans2Box:scale(AnsBoxSize, AnsBoxSize)
    Ans3Box = display.newImage("images/plate.png",Ans3BoxX, Ans3BoxY)
    Ans3Box:scale(AnsBoxSize, AnsBoxSize)

    --Answer Box Listeners
    Ans1Box:addEventListener("tap", Ans1BoxListener)
    Ans2Box:addEventListener("tap", Ans2BoxListener)
    Ans3Box:addEventListener("tap", Ans3BoxListener)
    
    --Step 4: Add Answer Object Images
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

    --Step 5: Add Question Text
    questionText = display.newText(question[num].qj , questionTextX, questionTextY, "Arial", 24)
    questionText:setFillColor(0, 0, 0)
    
    --Step 6: Set correct answer and correct audio sample
    correctAns = question[num].ans
    audioSample = audio.loadSound(question[num].audio)
    

    --Step 7: Initialize Audio Box
    if audioBox ~= nil then
        audioBox:removeSelf()
    end
    audioBox = display.newImage("images/Speaker_Icon.png",audioBoxX,audioBoxY)
    audioBox:scale(audioBoxScale,audioBoxScale)
    audioBox:addEventListener("tap", AudioBoxListener)

end

--Function to evaluate the customer-selected answer
function evaluateAnswer()
    if chosenAns == correctAns then
        --Print/Sound Correct
        audio.play(audioCorrect)
        print("Correct Answer")
    else
        --Print/Sound Incorrect
        audio.play(audioIncorrect)
        print("Wrong Answer")
       
    end
   
    --Continue playing with new question.
    clearQuestion()
    generateQuestion()  --r?

end

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("game3v2")
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
    display.remove(chef)
    display.remove(customer)
    display.remove(audioBox)
    display.remove(menu)
    --Change Scenes and Delay Removal
    storyboard.gotoScene("menu","fade",500)
    delayedSceneRemoval()
end

--This function begins Game3.lua (Vocab)*************************
function Game3()
	--Set initial score to zero
	score = 0
    --Randomize Seed
    math.randomseed(os.time())


    --Draw customer and chef in scene.
    drawScene()

    --Finally, Begin Playing by Generating A Question.
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
    gameOver:addEventListener("tap", gameClear)
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
    animate() --timer didnt work here    
end

-------------------------------------------------
--CORONA SCENE EVENTS
-------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local screenGroup = self.view
    --First load background image. --//!@# coords for background X and Y needed?
    bg = display.newImage("art/Game3/sushibar.png", centerX,centerY+(30*yscale))
    screenGroup:insert(bg)
    --bg:scale(0.6*xscale,0.6*yscale)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    --Play Game
    Game3()
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