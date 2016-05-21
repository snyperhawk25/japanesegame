--game4.lua dynamic content game
--based on gameV2 from 419B

local composer = require( "composer" )
local scene = composer.newScene()
local myData = require("mydata")
local widget = require( "widget" )
local g2reader=require("app42.gameReader")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

local currentDifficulty
local difficulties = {}
difficulties[1] = "Easy"
difficulties[2] = "Medium"
difficulties[3] = "Hard"
local letters = {}
letters[1] = "A)"
letters[2] = "B)"
letters[3] = "C)"
letters[4] = "D)"
local questionsAnswered
local sessionSize = 10
local question
local answerButtons = {}
local correctAnswer
local questionGroups = {}
local currentQuestion
local timesWrong
local consecutiveRight
local maxBeforeChange = 2
local background
local popup

local checkAnswer = {}

---------------------------------------------------------------------------------
local function removeEverything()
  question:removeSelf()
  question = nil
  for i=1,4 do
    answerButtons[i + 1]:removeSelf()
    answerButtons[i + 1] = nil
  end
end


local function getQuestion()
  currentQuestion = math.random(table.getn(questionGroups[currentDifficulty]))
  print("Question Selected: "..currentQuestion.." "..questionGroups[currentDifficulty][currentQuestion][2])
end

local function sortQuestions()
  questionGroups[1] = myData.custom.Easy
  questionGroups[2] = myData.custom.Medium
  questionGroups[3] = myData.custom.Hard
end

local function CreateQuestion()
    local options =
    {
      --parent = textGroup,
      text = questionGroups[currentDifficulty][currentQuestion][2],
      x = display.contentCenterX,
      width = display.contentWidth - 50,     --required for multi-line and alignment
      height = 30,
      font = native.systemFontBold,
      fontSize = 18,
    }

    question = display.newText( options )
    question.anchorY = 0
    question.y = topAlignAxis
    question:setFillColor( 1, 0, 0 )
end


local function createQuestionButton(index)
  local name = letters[index].." "..questionGroups[currentDifficulty][currentQuestion][2 + index]
  print("Creating Button"..name)
  event = checkAnswer(index)
  local t = 0
  if(index == 2 or index == 4) then
    t = 34
  end
  l = (math.ceil(index/2)*(display.contentWidth/2)+8)
  print("left = "..l)
  print("top = "..t)
  return widget.newButton{
          label = name,
          left = l,
          id = name..index,
          top = t,
         onRelease = event,
          --properties for a rounded rectangle button...
         shape="roundedRect",
         width = display.contentWidth/2 - 14,
         height = 30,
         cornerRadius = 2,
         fillColor = { default={ 0.2, 0.27, 0.24}, over={ 0.2, 0.27, 0.24} },
         strokeColor = { default={ 0,0, 0 }, over={ 0,0,0} },
         strokeWidth = 4
      }
end

local function createQuestionButtons()
  answerButtons[1] = display.newGroup()
  for i=1,4 do
    answerButtons[i + 1] = createQuestionButton(i)
    answerButtons[1]:insert(answerButtons[i + 1])
  end
  answerButtons[1].x = -1*(display.contentWidth/2)
  answerButtons[1].y = display.contentHeight - 100
  return answerButtons[1]
end

local function setUpPage()
  local sceneGroup = scene.view
  print("Setting Up Page")
  print("Difficulty= "..difficulties[currentDifficulty])
  getQuestion()
  createQuestionButtons()
  CreateQuestion()
  sceneGroup:insert(question)
  sceneGroup:insert(answerButtons[1])
  correctAnswer = questionGroups[currentDifficulty][currentQuestion][7]
end


checkAnswer = function (index)
  return function()
    if(letters[index] == correctAnswer .. ")") then

      if(timesWrong > maxBeforeChange and currentDifficulty > 1)then
        timesWrong = 0
        currentDifficulty = currentDifficulty - 1
        popup = native.showAlert("Adaptive Difficulty", "You appear to be having a hard time so we've bumped the difficulty down a bit.")
      end
      if(timesWrong == 0) then
        consecutiveRight = consecutiveRight + 1
      end
      if (consecutiveRight > maxBeforeChange and currentDifficulty < 3) then
        consecutiveRight = 0
        currentDifficulty = currentDifficulty + 1
        popup = native.showAlert("Adaptive Difficulty", "This difficulty seems to easy for you so we've bumped the difficulty up a bit.")
      end
      questionsAnswered = questionsAnswered + 1
      if(questionsAnswered <= sessionSize) then
        removeEverything()
        setUpPage()
      else
        local options = {
          effect = "fade",
          time = 1000
        }
        composer.gotoScene("Code.Game2.title", options)
      end

    else
      timesWrong = timesWrong + 1
    end
  end
end
-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
     currentDifficulty = 2
     gR_readFile()
     sortQuestions()
     setUpPage()
     questionsAnswered = 0
     wrongAnswer = 0
     timesWrong = 0
     consecutiveRight = 0
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
     removeEverything()
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
