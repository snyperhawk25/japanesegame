---------------------------------------------------------------------------------
-- game4.lua ("Dynamic_Vocab")
-- This is the Dynamic Vocab game.
-- Barrett Sharpe, 2016. GitHub:"Snyperhawk25/japanesegame"
--------------------------------------------------------------------------------

----------------------------------------
--REQUIRE
----------------------------------------
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require("questions")
require("vocab")
require("test.shufflingTest")
local widget = require("widget")
local myData = require("mydata")


-----------------------------------------
--SCENE VARIABLES
-----------------------------------------

local score=0
local questionCounter=0
local questionsStartIndex = 1 --Default: Medium
local questionsEndIndex = table.getn(myData.custom.Medium) --Default: Medium
local orderOfQuestions={}

local scoreText
local menu
local questionBubble, questionText = "This is a question"
local Ans1Button, Ans2Button, Ans3Button, Ans4Button
local lives
local correctAns
local chosenAns
local gameOver, gameOverText
local q1 = "ANSWER 1"
local q2 = "ANSWER 2"
local q3 = "ANSWER 3"
local q4 = "ANSWER 4"

--Audio
local audioCorrect = audio.loadSound("audio/ding1.wav")
local audioIncorrect = audio.loadSound("audio/buzz1.wav")
local audioClick = audio.loadSound("audio/click1.wav")
--Centers
local centerX = display.contentCenterX
local centerY = display.contentCenterY
print("\nCoordinates:")
print("CenterX: "..centerX.."\nCenterY: "..centerY)
print("Display Actual Width: "..display.actualContentWidth.."\nDisplay Actual Height: "..display.actualContentHeight)
print("ContentWidth: "..display.contentWidth.."\nContentHeight: "..display.contentHeight)
----------------------------------------
--COORDINATES
----------------------------------------

local questionTextX = 240
local questionTextY = 30
local questionBubbleX = 240
local questionBubbleY = 30

local scoreTextX = centerX
local scoreTextY = 75

local menuX = 465
local menuY = 30

local Ans1ButtonX = (display.contentWidth-200)/2-100
local Ans12ButtonY = display.contentCenterY + 25
local Ans2ButtonX = (display.contentWidth-200)/2+100

local Ans3ButtonX = (display.contentWidth-200)/2-100
local Ans34ButtonY = display.contentCenterY - 25
local Ans4ButtonX = (display.contentWidth-200)/2+100

local AnsTextScale = 0.15
local AnsTextTranslateX = 45
local AnsTextTranslateY = 10


--Function to remove the elements of the active question. Also to empty "" the correct answer integer.
function clearQuestion()
    --Question Text
    questionText:removeSelf()

    --Clear buttons --need?
    Ans1Button:removeSelf()
    Ans2Button:removeSelf()
    Ans3Button:removeSelf()
    Ans4Button:removeSelf()

    --Reset Answer
    correctAns = ""
end

---------------------------------------------
--METHODS
---------------------------------------------

--Function to generate the next question.
function generateQuestion()
    --Alert (TEST)
    print("\n//Generating New Question//\n")

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
    print("myData.custom.Medium; Question Index: "..num..".")

    --Assign question answers
    q1=myData.custom.Medium[num][3]
    q2=myData.custom.Medium[num][4]
    q3=myData.custom.Medium[num][5]
    q4=myData.custom.Medium[num][6]
    
    --Shuffle Coordinates/Answers and Re-assign.
    local coordinateOrder = {}
    coordinateOrder = fisherYates({{Ans1ButtonX, q1},{Ans2ButtonX, q2},{Ans3ButtonX, q3},{Ans4ButtonX, q4}})
    --1    
    Ans1ButtonX = coordinateOrder[1][1]
    q1 = coordinateOrder[1][2]
    --2
    Ans2ButtonX = coordinateOrder[2][1]
    q2 = coordinateOrder[2][2]
    --3
    Ans3ButtonX = coordinateOrder[3][1]
    q3 = coordinateOrder[3][2]
    --4
    Ans4ButtonX = coordinateOrder[4][1]
    q4 = coordinateOrder[4][2]
    
    --Create new Answer Boxes
    Ans1Button = widget.newButton (
      {
        id = "Ans1Button",
        left = (display.contentWidth-200)/2-100,
        top = display.contentCenterY + 25,
        label = q1,
        shape = "roundedRect",
        font = native.systemFont,
        cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 0.5, 0.60, 0.5, 1 }, over={ 0.38, 0.27, 0.32, 1 } },
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        --onEvent = Ans1BoxListener
        onPress = Ans1BoxListener
      }
    )

    Ans2Button = widget.newButton (
      {
        id = "Ans2Button",
        left = (display.contentWidth-200)/2+100,
        top = display.contentCenterY + 25,
        label = q2,
        shape = "roundedRect",
        font = native.systemFont,
        cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 0.5, 0.60, 0.5, 1 }, over={ 0.38, 0.27, 0.32, 1 } },
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        --onEvent = Ans2BoxListener
        onPress = Ans2BoxListener
      }
    )

    Ans3Button = widget.newButton (
      {
        id = "Ans3Button",
        left = (display.contentWidth-200)/2-100,
        top = display.contentCenterY - 25,
        label = q3,
        shape = "roundedRect",
        font = native.systemFont,
        cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 0.5, 0.60, 0.5, 1 }, over={ 0.38, 0.27, 0.32, 1 } },
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        --onEvent = Ans3BoxListener
        onPress = Ans3BoxListener
      }
    )

    Ans4Button = widget.newButton (
      {
        id = "Ans4Button",
        left = (display.contentWidth-200)/2+100,
        top = display.contentCenterY - 25,
        label = q4,
        shape = "roundedRect",
        font = native.systemFont,
        cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ 0.5, 0.60, 0.5, 1 }, over={ 0.38, 0.27, 0.32, 1 } },
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        --onEvent = Ans4BoxListener
        onPress = Ans4BoxListener
      }
    )

    --Add Question Text
    questionText = display.newText(myData.custom.Medium[num][2], questionTextX, questionTextY, "Arial", 24)
    questionText:setFillColor(0, 0, 0)
    
    --Set correct answer
    correctAns = myData.custom.Medium[num][7]
    
    --Increment question counter
    questionCounter=questionCounter+1
end

--Function to evaluate the player-selected answer
function evaluateAnswer()
    if chosenAns == correctAns then
        --Print/Sound Correct
        audio.play(audioCorrect)
        print("Correct Answer")
        --Increment Score
        score=score+1
        scoreText:removeSelf()
        scoreText= display.newText(""..score, scoreTextX, scoreTextY, "Arial", 35)
        scoreText:setFillColor(0,1,0)
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
        storyboard.removeScene("game4")
    end
    timer.performWithDelay(500, removeSceneListener)
end

--Function to remove all display objects from the scene.
local function removeAllDisplayObjects()
    --display.remove(Ans1Button)
    --display.remove(Ans2Button)
    --display.remove(Ans3Button)
    --display.remove(Ans4Button)

    Ans1Button:removeSelf()
    Ans2Button:removeSelf()
    Ans3Button:removeSelf()
    Ans4Button:removeSelf()

    display.remove(gameOverText)
    
    display.remove(questionText)
    display.remove(questionBubble)

    display.remove(menu)
    display.remove(scoreText)
end

--Function to return to the Main Menu (menu.lua)
local function goToMenu()
    --Click Audio
    audio.play(audioClick)
    --Remove Display Objects
    removeAllDisplayObjects()

    --Change Scenes and Delay Removal
    storyboard.gotoScene("menu","fade",500)
    delayedSceneRemoval()
end

--This function begins Game2.lua (Vocab)*************************
function Game4()
    --Alert (TEST)
    print("\n\nBEGINNING GAME 4 DYNAMIC VOCAB..\n\n")

    --Randomize Seed
    math.randomseed(os.time())

    --Now we draw our scene elements.
    --Question Bubble
    questionBubble = display.newImage("images/bubble.png", questionBubbleX,questionBubbleY)
    questionBubble:scale(0.5,0.18)
    --Menu Button
    menu = display.newImage("images/Menu.png",menuX,menuY)
    menu:scale(0.45,0.45)
    menu:addEventListener("tap", goToMenu) 
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
    Ans1Button:removeEventListener("tap", Ans1Button)
    Ans2Button:removeEventListener("tap", Ans2Button)
    Ans3Button:removeEventListener("tap", Ans3Button)
    Ans4Button:removeEventListener("tap", Ans4Button)
    removeAllDisplayObjects()

    --Collect Important Information (along with transition info)
    local gameOverOptions = {
        effect = "fade",
        time = 500,
        params = {
            --var1 = "test",
            retryScene = "game4",
            gameName = "Dynamic Vocab",
            finalScore = score,
            finalScoreUnit = "Correct",
            finalDescription = "You got "..score.." correct word(s).",
            var2 = "hi",
            --app 42 info
            app42GameName = "Dynamic_Vocab"
        }
    }

    --Change Scenes and Delay Removal
    storyboard.gotoScene("numbers.numbersScorePage", gameOverOptions)
    delayedSceneRemoval()

end 

-------------------------------------------
--LISTENERS //!@#messed up timer delay. 1000->1sec
-------------------------------------------

--Answer Box Listeners 1 - 4
function Ans1BoxListener()
    local function animate(event)
        transition.from(Ans1Button,{time=200,x=Ans1ButtonX,y=Ans12ButtonY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 1 Pressed (A)")
    chosenAns = "A"
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

function Ans2BoxListener()
    local function animate(event)
        transition.from(Ans2Button,{time=200,x=Ans2ButtonX,y=Ans12ButtonY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 2 Pressed (B)")
    chosenAns = "B"
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

function Ans3BoxListener()
    local function animate(event)
        transition.from(Ans3Button,{time=200,x=Ans3ButtonX,y=Ans34ButtonY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 3 Pressed (C)")
    chosenAns = "C"
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

function Ans4BoxListener()
    local function animate(event)
        transition.from(Ans4Button,{time=200,x=Ans4ButtonX,y=Ans34ButtonY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 4 Pressed (D)")
    chosenAns = "D"
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
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
    Game4()
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

--1) qid
--2) Question
--3) A value
--4) B value
--5) C value
--6) D value
--7) Answer
--8) Difficulty