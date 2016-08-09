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
local widget = require("widget")
local myData = require("mydata")
require("questions")
require("test.shufflingTest")


--For Submit Score
local App42API = require("App42-Lua-API.App42API")
local tools=require("app42.App42Tools") --this is for App42:Initialize
local scoreBoardService = App42API.buildScoreBoardService()   --For Leaderboard


-----------------------------------------
--SCENE VARIABLES
-----------------------------------------

local score=0
local questionCounter=0
local questionsStartIndex = 1 
local questionsEndIndex = table.getn(myData.custom.All) --Default: All
local orderOfQuestions={}

local countText = nil --check this fix

local scoreText
local menu

local scrollView, questionText = "This is a question"
local downArrow
local Ans1Button, Ans2Button, Ans3Button, Ans4Button
local submitButton
local submitText
local hasSubmitted=false
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
--audio.setVolume(1.0)

--Centers
local centerX = display.contentCenterX
local centerY = display.contentCenterY
--print("\nCoordinates:")
--print("CenterX: "..centerX.."\nCenterY: "..centerY)
--print("Display Actual Width: "..display.actualContentWidth.."\nDisplay Actual Height: "..display.actualContentHeight)
--print("ContentWidth: "..display.contentWidth.."\nContentHeight: "..display.contentHeight)
----------------------------------------
--COORDINATES
----------------------------------------

local questionTextX = 240
local questionTextY = 30
local scoreTextX = centerX+2
local scoreTextY = centerY

local menuX = 445
local menuY = 30


--New Values
-- 1 2
-- 3 4
local Ans1ButtonY = 180
local Ans2ButtonY = 180
local Ans3ButtonY = 240
local Ans4ButtonY = 240

local Ans1ButtonX = 20
local Ans2ButtonX = 280
local Ans3ButtonX = 20
local Ans4ButtonX = 280

--NOTE Hard coded thes position values for shuffling:
--{{20,180},{280,180},{20,240},{280,240}}

--Function to remove the elements of the active question. Also to empty "" the correct answer integer.
function clearQuestion()
    --Question Elements
    questionText:removeSelf()
    scrollView:removeSelf()

    display.remove(downArrow)
    

    --Clear buttons --need??
    Ans1Button:removeSelf()
    Ans2Button:removeSelf()
    Ans3Button:removeSelf()
    Ans4Button:removeSelf()

    --Reset Answer
    correctAns = ""
end

--Listener to look for double tap
local function myTapListener(event)
    if event.numTaps == 2 then
        print("DOUBLE TAP!")
        audio.play(audioClick,{channel=3})
        scrollView:scrollToPosition({x=0,y=0,time=250})
    end
    return true   
end    

local function downArrowListener(event)
    --Play Click and Alert
    audio.play(audioClick,{channel=3})
    print("Down Arrow Pressed. Scrolling Down")
    scrollView:scrollTo("bottom",{time=6000} )
end  

--Submit Listener
local function submitListener(event)
    --Play Click
    local function playSound()
        audio.play(audioClick,{channel=3})
    end
    timer.performWithDelay(50,playSound)
    
    --If the listener has not been pressed before, submit. Else ignore.
    if hasSubmitted==false then
        app42ScoreCallBack = {}
        scoreBoardService:saveUserScore("Dynamic_Vocab", myData.App42Username, score,app42ScoreCallBack)
        --If Successful, change button colour/text, and boolean  
        function app42ScoreCallBack:onSuccess(object)
            print("      -Score Saved: Value="..object:getScoreList():getValue()..";")
            submitButton:setFillColor(0,0,1)
            submitText:removeSelf() --?
            submitText = display.newText("Submitted "..object:getScoreList():getValue(), 450,140, native.systemFont,11)
            hasSubmitted=true
        end
        function app42ScoreCallBack:onException(exception)
            print("      -Score "..scoreValue.." NOT Saved correctly.")
            print("Score failed to save to App42. Reseting hasSumbitted.")
            --Score failed to register, so submit should be allowed to be pressed again.
            hasSubmitted=false
        end
    else
        print("A previous submission was recorded, so this submission will be ignored.")
        submitButton:setFillColor(1,0,0)
            submitText:removeSelf() --?
            submitText = display.newText("No Duplicates", 450,140, native.systemFont,11)
    end
end

-- ScrollView listener
local function scrollViewListener( event )
    --Widget Phase Decision
    local phase = event.phase
    if ( phase == "began" ) then       

    elseif ( phase == "moved" ) then 
    --print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then 
    --print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then
            print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then 
            print( "Reached top limit" )
        --elseif ( event.direction == "left" ) then 
            print( "Reached right limit" )
        --elseif ( event.direction == "right" ) then 
            print( "Reached left limit" )
        end
    end

    return true
end

---------------------------------------------
--METHODS
---------------------------------------------

--Function to generate the next question.
function generateQuestion()
    --Alert (TEST)
    print("//Generating New Question//")

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
    print("myData.custom.All; Question Index: "..num..".")

    --Assign question answers
    q1=myData.custom.All[num][3]
    q2=myData.custom.All[num][4]
    q3=myData.custom.All[num][5]
    q4=myData.custom.All[num][6]
    
    --Shuffle/Reassign Coordinates
    local coordinateOrder = {}
    coordinateOrder = fisherYates({{20,180},{280,180},{20,240},{280,240}})  
    Ans1ButtonX = coordinateOrder[1][1]
    Ans2ButtonX = coordinateOrder[2][1]
    Ans3ButtonX = coordinateOrder[3][1]
    Ans4ButtonX = coordinateOrder[4][1]
    Ans1ButtonY = coordinateOrder[1][2]
    Ans2ButtonY = coordinateOrder[2][2]
    Ans3ButtonY = coordinateOrder[3][2]
    Ans4ButtonY = coordinateOrder[4][2]

-----------------------------------------------------------------------------
    --Add In The Question

    --Calculate Scroll Height Required
    --OLD::Based on: Width (at font 20): ~26characters (@%90 space) / 300 = 11.53 --> 12/character
    --NEW::Based on about 31 characters (@90%space) / 375 --> 12 px per character
    --NEW:: AND ~ 128 characters of space in the 375x100 space.
    local scrollWidthSize = 375
    local scrollHeightSize = 100 --defualt value
    --scrollHeightSize = math.ceil((string.len(myData.custom.All[num][2])*12)/scrollWidthSize)*20 
    --print("scrollHeightSize: "..scrollHeightSize..".")

    --Condition for Down Arrow
    qlen=string.len(myData.custom.All[num][2])
    if qlen>128 then
        --Alert
        print("Exceded 128 characters (375x128 worth). Adding Down Arrow.")
        --Update distanceDown
        --distanceDown = (math.floor(qlen/31))*(-20)
        --print("Distance To Scroll Down: "..distanceDown)
        downArrow = display.newPolygon(400,90,
            {
            --Old Arrow (2x; centerX,140)
            --0,0,-10,0,-10,30,-20,30,0,50,20,30,10,30,10,0
            --New Arrow
            0,0,-5,0,-5,15,-10,15,0,25,10,15,5,15,5,0
            }
        ) --400,80
        downArrow:setFillColor(1,0,0)
        downArrow:addEventListener("tap",downArrowListener)
    end

    local textOptions = {
        text = myData.custom.All[num][2],
        x = 10,
        y = 5,
        width = scrollWidthSize-(scrollHeightSize*0.1), --width is only 90% of scrollWidth size
        height = 0, -- 0 = no height restrictions
        fontSize = 20,
        align = "left"
    }
    questionText = display.newText(textOptions)
    --Change Fill Colour and Anchors
    questionText:setFillColor(0, 0, 0)
    questionText.anchorX = 0.0
    questionText.anchorY = 0.0
    


    -- Create the scrollView
    scrollView = nil
    scrollView = widget.newScrollView(
        {
            top= 5,
            left = 5 ,
            width = scrollWidthSize, 
            height =  scrollHeightSize, 
            scrollWidth = scrollWidthSize,
            scrollHeight = scrollHeightSize,
            horizontalScrollDisabled = true,
            --friction = 2,
            isBounceEnabled = true,
            listener = scrollViewListener,
            hideScrollBar = false,
            backgroundColor = {1,1,1,0.8}
        }
    )
    
    --Top Corner Rectangle
    local questionFrame = display.newRect(0,0,10,10)
    questionFrame:setFillColor(0,0,0)
    scrollView:insert(questionFrame)

    --Insert Text into Scrollview
    scrollView:insert(questionText)
    
    --Add Double Tap Listener to Scrollview
    scrollView:addEventListener("tap", myTapListener)

    --scroll to top
    scrollView:scrollToPosition{x=0,y=0,time=250}


-----------------------------------------------------------------------------


--Define Fill Colours (teal-blue)
    local fillR = 0.4
    local fillG = 0.78
    local fillB = 1

    --Create new Answer Boxes
    Ans1Button = widget.newButton (
      {
        id = "Ans1Button",
        x = Ans1ButtonX,
        y = Ans1ButtonY,
        label = q1,
        shape = "roundedRect",
        font = native.systemFont,
        cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ fillR,fillG,fillB,0.9 }, over={ fillR,fillG,fillB,0.3 } },
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = Ans1BoxListener
      }
    )
    Ans1Button.anchorY=0.0
    Ans1Button.anchorX=0.0

        Ans2Button = widget.newButton (
      {
        id = "Ans2Button",
        x = Ans2ButtonX,
        y = Ans2ButtonY,
        label = q2,
        shape = "roundedRect",
        font = native.systemFont,
        cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ fillR,fillG,fillB,0.9 }, over={ fillR,fillG,fillB,0.3 } },
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = Ans2BoxListener
      }
    )
    Ans2Button.anchorY=0.0
    Ans2Button.anchorX=0.0

    Ans3Button = widget.newButton (
      {
        id = "Ans3Button",
        x = Ans3ButtonX,
        y = Ans3ButtonY,
        label = q3,
        shape = "roundedRect",
        font = native.systemFont,
        cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ fillR,fillG,fillB,0.9 }, over={ fillR,fillG,fillB,0.3 } },
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = Ans3BoxListener
      }
    )
    Ans3Button.anchorY=0.0
    Ans3Button.anchorX=0.0

    Ans4Button = widget.newButton (
      {
        id = "Ans4Button",
        x = Ans4ButtonX,
        y = Ans4ButtonY,
        label = q4,
        shape = "roundedRect",
        font = native.systemFont,
        cornerRadius = 4,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        fillColor = { default={ fillR,fillG,fillB,0.9 }, over={ fillR,fillG,fillB,0.3 } },
        strokeColor = { default={ 0, 0, 0, 1 }, over={ 0, 0, 0, 1 } },
        strokeWidth = 4,
        onPress = Ans4BoxListener
      }
    )
    Ans4Button.anchorY=0.0
    Ans4Button.anchorX=0.0



    --Set correct answer
    correctAns = myData.custom.All[num][7]
    
    --Increment question counter, print countText
    questionCounter=questionCounter+1
    if countText ~= nil then
        countText:removeSelf()
    end
    if questionCounter > questionsEndIndex then
        countText = display.newText("Questions Seen: "..questionsEndIndex.." / "..questionsEndIndex, 70, 120, native.systemFontBold, 13)
    else
        countText = display.newText("Questions Seen: "..questionCounter.." / "..questionsEndIndex, 70, 120, native.systemFontBold, 13)
    end
    countText:setFillColor(0,0,0)
end

--Function to evaluate the player-selected answer
function evaluateAnswer()
    if chosenAns == correctAns then
        --Print/Sound Correct
        local function playSound()
            audio.play(audioCorrect,{channel=4})
        end
        timer.performWithDelay(50,playSound)
        print("Correct Answer")
        --Increment Score
        score=score+1
        scoreText:removeSelf()
        scoreText= display.newText(""..score, scoreTextX, scoreTextY, native.systemFont, 35)
        scoreText:setFillColor(0,0,0)
    else
        --Print/Sound Incorrect
        print("Wrong Answer")
        local function playSound()
            audio.play(audioIncorrect,{channel=4})
        end
        timer.performWithDelay(50,playSound)
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

    display.remove(questionText)
    display.remove(downArrow)
    scrollView:remove(questionFrame)
    scrollView:remove(questionText)
    scrollView:removeSelf()

    display.remove(gameOverText)
    
    display.remove(menu)
    display.remove(scoreText)
    display.remove(countText)

    display.remove(submitButton)
    display.remove(submitText)
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
function Game4()
    --Alert (TEST)
    print("\n\nBEGINNING GAME 4 DYNAMIC VOCAB..\n\n")

    --Randomize Seed
    math.randomseed(os.time())

    --Now we draw our scene elements.

    --Menu Button
    menu = display.newImage("images/Menu.png",menuX,menuY)
    menu:scale(0.45,0.45)
    menu:addEventListener("tap", goToMenu) 
    
    --Sumbit Score Button
    submitButton = display.newRoundedRect(450,140,80,40,3)
    submitButton.strokeWidth = 3
    submitButton:setFillColor(0.1,0.9,0.3, 0.8)
    submitButton:setStrokeColor(0,0,0)
    submitButton:addEventListener("tap",submitListener)
    submitText = display.newText("Submit Score", 450,140, native.systemFont,11)

    --Score Text
    scoreText= display.newText(""..score, scoreTextX, scoreTextY, "Arial", 35)
    scoreText:setFillColor(0,0,0)

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
    scrollView:removeEventListener("tap", scrollView)
    submitButton:removeEventListener("tap",submitButton)

    --down arrow listener removal needed??
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
    print("Answer Box 1 Pressed (A)")
    local function animate(event)
        audio.play(audioClick,{channel=3})
        transition.from(Ans1Button,{time=200,x=Ans1ButtonX,y=Ans12ButtonY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(50,animate) --timer required to animate properly.
    chosenAns = "A"
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

function Ans2BoxListener()
    print("Answer Box 2 Pressed (B)")
    local function animate(event)
        audio.play(audioClick,{channel=3})
        transition.from(Ans2Button,{time=200,x=Ans2ButtonX,y=Ans12ButtonY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(50,animate) --timer required to animate properly.
    chosenAns = "B"
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

function Ans3BoxListener()
    print("Answer Box 3 Pressed (C)")
    local function animate(event)
        audio.play(audioClick,{channel=3})
        transition.from(Ans3Button,{time=200,x=Ans3ButtonX,y=Ans34ButtonY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(50,animate) --timer required to animate properly.
    chosenAns = "C"
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end

function Ans4BoxListener()
    print("Answer Box 4 Pressed (D)")
    local function animate(event)
        audio.play(audioClick,{channel=3})
        transition.from(Ans4Button,{time=200,x=Ans4ButtonX,y=Ans34ButtonY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(50,animate) --timer required to animate properly.
    chosenAns = "D"
    timer.performWithDelay(200, evaluateAnswer) --wait for box to animate before eval
end




-------------------------------------------------
--CORONA SCENE EVENTS
-------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local screenGroup = self.view

    --Draw Background image (rotated and fliped horizontally)
    --bg = display.newImage("images/bg.png", centerX,centerY+30) --yscale    
    --bg:rotate(180)
    --bg.xScale=-1

    bg = display.newImage("images/CherryBlossoms.png", centerX,centerY)
    bg:scale(0.45,0.42)    
    screenGroup:insert(bg)
    
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

--1) qid
--2) Question
--3) A value
--4) B value
--5) C value
--6) D value
--7) Answer
--8) Difficulty