--game3v2.lua
---------------------------------------------------------------------------------
-- game3v2.lua ("Food Vocab, version 2")
-- This is the Food Vocab game. It uses quesions[10-20] from Questions.lua that are basic objects.
-- Barrett Sharpe, 2016. GitHub:"Snyperhawk25/japanesegame"

--Note, this is a structural copy of game2, with visual modifications.


--//!@# remember to remove event listeners on game over
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
require("test.shufflingTest")


-----------------------------------------
--SCENE VARIABLES
-----------------------------------------

--Scoring Variables
local score=0 --player's score in game
local performanceScore=0 --player's final score, to be registered on app42
local questionCounter=0 --questions counter
local playerCombo=0 --player current combo
local maxCombo=0 --maximum combo
local start, finish --times
local winState = 500 --score to achieve Win

--Question Randomization
local questionsStartIndex = 11
local questionsEndIndex = 21
local orderOfQuestions = {}

--Display
local scoreText, countText, countText2
local menu
local customer, chef
local questionBubble, questionText
local Ans1Box, Ans2Box, Ans3Box
local plate1, plate2, plate3
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
--audio.setVolume(1.0)

--Centers
local centerX = display.contentCenterX
local centerY = display.contentCenterY

----------------------------------------
--COORDINATES
----------------------------------------
local backgroundX = 300
local backgroundY = 180
local backgroundScale = 1.0

local questionTextX = 240
local questionTextY = 30
local questionBubbleX = 240
local questionBubbleY = 30

local customerX = 300
local customerY = 180
local customerScale = 1.0

local chefX = 290	--Note: Customer and Chef Images were drawn to 
local chefY = 180 --      be translated by the same amount.
local chefScale = 1.0

local audioBoxX = 20
local audioBoxY = 30
local audioBoxScale = 0.4

local menuX = 465
local menuY = 30

local scoreTextX = 235
local scoreTextY = 100


local plateScale = 0.8
local plate1X = 120
local plate2X = 280
local plate3X = 440
local plateY = 250

local AnsBoxSize = 150
local Ans1BoxX = 120
local Ans2BoxX = 280
local Ans3BoxX = 440
local AnsBoxY = 240

local AnsImageScale = 0.15
local AnsImageTranslateX = 0 --redundant
local AnsImageTranslateY = 0 --redundant
local Ans1ImageX = 120
local Ans2ImageX = 280
local Ans3ImageX = 440
local AnsImageY = 235

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("game3v2")
    end
    timer.performWithDelay(500, removeSceneListener)
end

--Function to remove all display objects.
local function removeAllDisplayObjects()
	display.remove(gameOverText)
    display.remove(Ans1Box)
    display.remove(Ans2Box)
    display.remove(Ans3Box)
    display.remove(Ans1Image)
    display.remove(Ans2Image)
    display.remove(Ans3Image)
	display.remove(plate1)
    display.remove(plate2)
    display.remove(plate3)


    display.remove(questionText)
    display.remove(questionBubble)
    display.remove(chef)
    display.remove(customer)
    display.remove(audioBox)
    display.remove(menu)

    display.remove(customer)
    display.remove(chef)
    display.remove(scoreText)
    display.remove(countText)
    display.remove(countText2)
end	

--Function to return to the Main Menu (menu.lua)
local function goToMenu()
    --Click Audio
    audio.play(audioClick,{channel=3})
    --Remove Objects
    removeAllDisplayObjects()

    --Change Scenes and Delay Removal
    storyboard.gotoScene("menu","fade",500)
    delayedSceneRemoval()
end

---------------------------------------------
--VISUAL METHOD
---------------------------------------------

--Function to draw the customer image at the customer coordinates (customerX,customerY)
local function drawScene()
    --1) Draw Customer
    if customer ~= nil then
        customer:removeSelf()
    end
    customer = display.newImage("art/Game3/customer.png",customerX,customerY)
    customer:scale(customerScale,customerScale)

    --2) Draw Chef (animated)
    if chef ~= nil then
        chef:removeSelf()
    end
    local function animate(event) --//!@# second animation step malfunctioning
    	print("...moving chef...")
        transition.to(chef,{x=chefX+40,y=chefY,time=1500,oncomplete=
        		function()
        			transition.from(chef,{x=chefX-40,y=chefY,time=1500,delay=1500})
        		end
        	})
    end
    timer.performWithDelay(1,animate,1) --timer required to animate properly.

    chef = display.newImage("art/Game3/chef.png", chefX,chefY)
    chef:scale(chefScale, chefScale)

    --3) Draw Question Bubble and Count Text
    if questionBubble~=nil then
    	questionBubble:removeSelf()
    end
    questionBubble = display.newImage("images/bubble.png", questionBubbleX,questionBubbleY)
    questionBubble:scale(0.5,0.18)

    countText2 = display.newText("Questions Seen:", 30, scoreTextY-20, native.systemFontBold, 13)
    countText2:setFillColor(0,0,0)

    --4) Draw Menu Button
    if menu ~= nil then
    	menu:removeSelf()
    end
    menu = display.newImage("images/Menu.png",menuX,menuY)
    menu:scale(0.45,0.45)
    menu:addEventListener("tap", goToMenu) 

    --5) Initialize ScoreText
    scoreText = display.newText(""..score, scoreTextX, scoreTextY, "Arial", 30)
	scoreText:setFillColor(0,0,1)    
end


---------------------------------------------
--METHODS
---------------------------------------------

--Function to remove the elements of the active question, including the answer images from the scene. 
-- Also to 'zero' the correct answer integer, and answering times.
function clearQuestion()
    --Question Text
    --questionText:removeSelf()
    display.remove(questionText)
    --Images
    --Ans1Image:removeSelf()
    --Ans2Image:removeSelf()
    --Ans3Image:removeSelf()
    display.remove(Ans1Image)
    display.remove(Ans2Image)
    display.remove(Ans3Image)
    --Reset Answer
    correctAns = 0
    --Reset Times
    start=0.0
    finish=0.0
end

--Function to get accurate time
function now()
	--return socket.gettime()*1000
	return os.clock()
end

--Function to update the player's score.
function updateScore(isCorrect,time,combo)
	--    SCORE CHART
	--<1/2 sec = 100pts
	--< 1 sec =  50pts
	--< 2  sec =  25pts
	--< 5  sec =  20pts
	-->=5  sec =  10pts
	--Note: Scores above are multiplied by a factor of
	--      how many combos of 5 correct answers they 
	--      have, up to a maximum of 5x multiplier
	--Note: Incorrect Answers lose 10pts, to minimum of 0.
	--Note: To prevent cheating, if the playerCombo goes
	--      below -6 (6 consectively incorrect), it's assumed
	--      they are spamming guesses. Score is set to 0.

	--Copy Current score
	local newScore=0+score

	--Calulate Combo multiplier
	local newCombo
	if combo>0 then
        --Positive Combo
		newCombo=(math.floor(combo/5))+1
	elseif combo<=-6 then
        --Cheating
		print("CHEATING")
		newCombo=10000--cheating (> 6 wrongs, assumed cheating)
	else
        --Negative Combo
		newCombo=1
	end	

    --Update maxCombo
    if combo > maxCombo then
        maxCombo = combo
    end

	--If Correct Answer
	if isCorrect then
		--Based on their time
		if time<500 then
			newScore=newScore+(100*newCombo)
		elseif time<1000 then
			newScore=newScore+(50*newCombo)
		elseif time<2000 then
			newScore=newScore+(25*newCombo)
		elseif time<5000 then
			newScore=newScore+(20*newCombo)
		else
			newScore=newScore+(10*newCombo)
		end
	else
		--Incorrect Answer
		newScore=newScore-(10*newCombo)
		--correct for negative scores
		if 	newScore < 0 then
			newScore=0
		end
	end

	--Set 'score'
	score=newScore
	--Change scoreText
	--scoreText:removeSelf()
    display.remove(scoreText)
	scoreText = display.newText(""..score, scoreTextX, scoreTextY, "Arial", 30)
	scoreText:setFillColor(0,0,1)	

end	

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
        --?plates
        plate1:removeSelf()
        plate2:removeSelf()
        plate3:removeSelf()
    end
    
    --Shuffle Coordinates and Re-assign.
    local coordinateOrder = {}
    --coordinateOrder = fisherYates({{Ans1BoxX, Ans1ImageX, plate1X},{Ans2BoxX, Ans2ImageX, plate2X},{Ans3BoxX, Ans3ImageX, plate3X}})
    --coordinateOrder = fisherYates({{120, 120, 120},{280, 280, 280},{440, 440, 440}}) --shortened due to redundency
    coordinateOrder = fisherYates({120,280,440})
    Ans1BoxX=   coordinateOrder[1]
    Ans1ImageX= coordinateOrder[1]
    plate1X =   coordinateOrder[1]

    Ans2BoxX =  coordinateOrder[2]
    Ans2ImageX= coordinateOrder[2]
    plate2X =   coordinateOrder[2]

    Ans3BoxX =  coordinateOrder[3]
    Ans3ImageX= coordinateOrder[3]
    plate3X =   coordinateOrder[3]

    print("CoordTest1: Box:"..Ans1BoxX.."; Image:"..Ans1ImageX.."; plate:"..plate1X..";")


    --Create new Plates, Answer Images, and Answer Boxes (respectively)
    --Plate Images
    plate1 = display.newImage("images/plate.png",plate1X, plateY)
    plate1:scale(plateScale, plateScale)
    plate2 = display.newImage("images/plate.png",plate2X, plateY)
    plate2:scale(plateScale, plateScale)
    plate3 = display.newImage("images/plate.png",plate3X, plateY)
    plate3:scale(plateScale, plateScale)
    
    --Answer Images
    Ans1Image = display.newImage(question[num].a1, Ans1ImageX, AnsImageY)
    Ans1Image:scale(AnsImageScale,AnsImageScale)
    Ans1Image:translate(AnsImageTranslateX,AnsImageTranslateY)

    Ans2Image = display.newImage(question[num].a2, Ans2ImageX,AnsImageY)
    Ans2Image:scale(AnsImageScale,AnsImageScale)
    Ans2Image:translate(AnsImageTranslateX,AnsImageTranslateY)

    Ans3Image = display.newImage(question[num].a3, Ans3ImageX, AnsImageY)
    Ans3Image:scale(AnsImageScale,AnsImageScale)
    Ans3Image:translate(AnsImageTranslateX,AnsImageTranslateY)


    --Answer Boxes (invisible)
    Ans1Box = display.newRect(Ans1BoxX,AnsBoxY,AnsBoxSize,AnsBoxSize)
    --Ans1Box:setFillColor(1,0,0)
    Ans1Box.alpha = 0.01
    Ans2Box = display.newRect(Ans2BoxX,AnsBoxY,AnsBoxSize,AnsBoxSize)
    --Ans2Box:setFillColor(1,0,0)
    Ans2Box.alpha = 0.01
    Ans3Box = display.newRect(Ans3BoxX,AnsBoxY,AnsBoxSize,AnsBoxSize)
    --Ans3Box:setFillColor(1,0,0)
    Ans3Box.alpha = 0.01

    --Answer Box Listeners
    Ans1Box:addEventListener("tap", Ans1BoxListener)
    Ans2Box:addEventListener("tap", Ans2BoxListener)
    Ans3Box:addEventListener("tap", Ans3BoxListener)


    --Add Question Text
    questionText = display.newText(question[num].qj , questionTextX, questionTextY, native.systemFont, 20)
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
        countText = display.newText(""..(questionsEndIndex-questionsStartIndex+1).." / "..(questionsEndIndex-questionsStartIndex+1), 30, scoreTextY-5, native.systemFontBold, 13)
    else
        countText = display.newText(""..questionCounter.." / "..(questionsEndIndex-questionsStartIndex+1), 30, scoreTextY-5, native.systemFontBold, 13)
    end
    countText:setFillColor(0,0,0)

    --Register start time
    start=now()
end

--Function to begin the game won procedures. NOTE: this is win method. No lose state.
function gameOver()

    print("GAME WON and OVER!")

    Ans1Box:removeEventListener("tap", Ans1Box)
    Ans2Box:removeEventListener("tap", Ans1Box)
    Ans3Box:removeEventListener("tap", Ans1Box)
    removeAllDisplayObjects()

    --performance Score calculation
    -- Constant 5 based on max performance of 5 * (<1/2sec answers @ 100pts) = 500 Win State
    performanceScore = (winState * maxCombo) + math.floor((5/questionCounter)*winState)
    print("PerformanceScore : "..performanceScore..";")


    local gameOverOptions = {
        effect = "fade",
        time = 500,
        params = {
            retryScene = "game3v2",
            gameName = "Food Vocab",
            finalScore = performanceScore,
            finalScoreUnit = "Points",
            finalDescription = "You earned "..performanceScore.." points, for reaching "..winState.." in "..questionCounter.." question!",
            --app 42 info
            app42GameName = "Food_Vocab"
        }
    }

    --Change Scenes and Delay Removal
    storyboard.gotoScene("numbers.numbersScorePage", gameOverOptions)
    delayedSceneRemoval()
end   

--Function to evaluate the player-selected answer, update score, and choose next state.
function evaluateAnswer()
	--Register Finish Time
	finish=now()

	--Test Print times
	local totalTime = (finish*1000) - (start*1000)
	--print("Start: "..start..".\nFinish: "..finish..".")
	--print("Time to answer question: "..totalTime.." milliseconds.")

	--Check correct
    if chosenAns == correctAns then
        --Print/Sound Correct
        audio.play(audioCorrect,{channel=4})
        print("Correct Answer")
        --Increment playerCombo
        --If player had correct answers combo before
        if playerCombo >= 0 then
        	--'right after rights'
        	playerCombo=playerCombo+1
        else
        	--'right after wrongs'
        	playerCombo=1
        end	
        --updateScore()
        updateScore(true,totalTime,playerCombo)
    else
        --Print/Sound Incorrect
        audio.play(audioIncorrect,{channel=4})
        print("Wrong Answer")
        --Reset playerCombo, and updateScore()
        if playerCombo <= 0 then
        	--'wrong after wrongs'
        	playerCombo=playerCombo-1
        else
        	--'wrong after rights'
        	playerCombo=-1
        end	
        updateScore(false,totalTime,playerCombo)
       
    end

    --Test print combo
    print("playerCombo: "..playerCombo..".")

    --Clear question and score timers
    clearQuestion()

    --And if the player's score is at/above the winState value
    if score >= winState then
        --player wins the game. NOTE: gameOver is the game won, because there is no way to lose in this game: it's pure repitition.
        gameOver()
    else    
        --Not enough points to win.
        --Generate the next question
        generateQuestion()  --r?
    end
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


-------------------------------------------
--LISTENERS
-------------------------------------------

--Answer Box Listeners 1 - 3
function Ans1BoxListener()
    audio.play(audioClick,{channel=3})
    local function animate(event)
        transition.from(plate1,{time=200,x=plate1X,y=plateY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 1 Pressed")
    chosenAns = 1
    timer.performWithDelay(200,evaluateAnswer) --timer to allow animation to finish
end

function Ans2BoxListener()
    audio.play(audioClick,{channel=3})
    local function animate(event)
        transition.from(plate2,{time=200,x=plate2X,y=plateY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 2 Pressed")
    chosenAns = 2
    timer.performWithDelay(200,evaluateAnswer) --timer to allow animation to finish
end

function Ans3BoxListener()
    audio.play(audioClick,{channel=3})
    local function animate(event)
        transition.from(plate3,{time=200,x=plate3X,y=plateY,xScale=0.9,yScale=0.9})
    end
    timer.performWithDelay(1,animate) --timer required to animate properly.
    print("Answer Box 3 Pressed")
    chosenAns = 3
    timer.performWithDelay(200,evaluateAnswer) --timer to allow animation to finish
end

--Audio Box Listener
function AudioBoxListener()
    local function animate(event)
        transition.from(audioBox,{time=1000,x=audioBoxX,y=audioBoxY,xScale=audioBoxScale-0.05,yScale=audioBoxScale-0.05})
    end  
    --Start Audio
    audio.play(audioSample,{channel=2})
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
	--bg = display.newImage("art/Game3/sushibar.png", centerX,centerY+(30*yscale))
	bg = display.newImage("art/Game3/sushibar.png", backgroundX, backgroundY)
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