---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
require "dbFile"


local answer --answer
local answernum --answer
local opt1 --options
local opt2
local opt3
local num1
local num2
local num3
local num4
local myText
local bubble
local dig1
local dig2
local dig3
local dig4
local dig5
local dig6
local dig7
local phonenumber
local hiragananumber

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function goToMenu()

    storyboard.gotoScene("menu")
    storyboard.removeScene("numbers.numbers5")
end

local function restart()
	storyboard.purgeScene("numbers.numbers5")
	storyboard.gotoScene("numbers.numbers1")
end




local function incorrect1(n)
	local screenGroup = n
	screenGroup:remove(myText)
	
	screenGroup:insert(bubble)

	local instructions = "Oh no! You dialed the wrong number and the bomb blew up! Mission failed."
	myText = display.newText(instructions, centerX, centerY+150*yscale,400*xscale,200*yscale, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	reText = display.newImage("images/Restart.png",display.contentWidth-50*xscale,30*yscale)
	reText:scale(0.4,0.4)
	reText:addEventListener("tap",restart)
	screenGroup:insert(reText)

	menu = display.newImage("images/Menu.png",display.contentWidth-50*xscale,60*yscale)
	menu:scale(0.4,0.4)
	menu:addEventListener("tap",goToMenu)
	screenGroup:insert(menu)
end

local function incorrect(n)
	local screenGroup = n
	
	explosion = display.newImage("images/numbers/explosion.png",centerX,centerY)
	explosion:scale(0.2*xscale,0.2*yscale)
	screenGroup:insert(explosion)

	local function boom()
		explosion:scale(1.15,1.15)
	end

	timer1 = timer.performWithDelay(50,boom,20)

	local function myFunction()
		incorrect1(screenGroup)
	end
	timer2 = timer.performWithDelay(1500,myFunction)
	
end 

local function correct()
	storyboard.purgeScene("numbers.numbers5")
	storyboard.gotoScene("numbers.numbers6","zoomOutInFadeRotate",1000)

end

local function checkEndGame(n)
	
	if answertext.text==hiragananumber then
		correct()
	else
		incorrect(n)
	end
end

local function generateAnswers()

	dig1 = math.random(0,9)
	dig2 = math.random(0,9)
	dig3 = math.random(0,9)
	dig4 = math.random(0,9)
	dig5 = math.random(0,9)
	dig6 = math.random(0,9)
	dig7 = math.random(0,9)
	phonenumber = dig1..dig2..dig3.."-"..dig4..dig5..dig6..dig7
	hiragananumber = syl[90+dig1][1]..syl[90+dig2][1]..syl[90+dig3][1]..syl[90+dig4][1]..syl[90+dig5][1]..syl[90+dig6][1]..syl[90+dig7][1]
	
end

local function recordPress(num)
	
	answertext.text = answertext.text..syl[90+num][1]
end

local function showAnswers(n)
	local screenGroup = n

	buttons = {}
	buttonbgs = {}
	--1 to 9
	for i = 0,2,1 do
		for j = 1,3,1 do
			local function myFunction(event)
				if event.phase == "ended" then
					recordPress((3*i)+j)
				end
			end
			buttonbgs[(3*i)+j] = widget.newButton
			{
			    defaultFile = "images/numbers/button.png",
			    overFile = "images/numbers/buttonpressed.png",
			    onEvent = myFunction
			}
			buttonbgs[(3*i)+j].x = 50*j*xscale
			buttonbgs[(3*i)+j].y = centerY-30*yscale-50*i*yscale
			buttonbgs[(3*i)+j]:scale(0.14*xscale,0.14*yscale)
			
			screenGroup:insert(buttonbgs[(3*i)+j])
			buttons[(3*i)+j] = display.newText(syl[90+(3*i+j)][1],50*j*xscale,centerY-30*yscale-50*i*yscale, native.systemFont,20)
			buttons[(3*i)+j]:setFillColor(0)
			screenGroup:insert(buttons[(3*i)+j])
		end
	end
	

	--b Zero Button
	local function myFunction(event)
		if event.phase == "ended" then
			recordPress(0)
		end
	end
	zerobg = widget.newButton
		{
		    defaultFile = "images/numbers/button.png",
		    overFile ="images/numbers/buttonpressed.png",
		    onEvent = myFunction
		}
	zerobg.x = 100*xscale
	zerobg.y = centerY+20*yscale
	zerobg:scale(0.14*xscale,0.14*yscale)
	zerobutton = display.newText(syl[90][1],100*xscale,centerY+20*yscale,native.systemFont,24)
	zerobutton:setFillColor(0)

	screenGroup:insert(zerobg)
	screenGroup:insert(zerobutton)


	--b Call Button
	local function myFunction(event)
		if event.phase == "ended" then
			checkEndGame(screenGroup)
		end
	end
	callbg = widget.newButton
		{
		    defaultFile = "images/numbers/button.png",
		    overFile ="images/numbers/buttonpressed.png",
		    onEvent = myFunction
		}
	callbg.x = centerX+100*xscale
	callbg.y = centerY-50*yscale
	callbg:scale(0.3*xscale,0.14*yscale)
	callbutton = display.newText("Call",centerX+100*xscale,centerY-50*yscale,native.systemFont,24)
	callbutton:setFillColor(0)

	screenGroup:insert(callbg)
	screenGroup:insert(callbutton)

	--b Clear Button
	local function myFunction(event)
		if event.phase == "ended" then
			answertext.text=""
		end
	end

	clearbg = widget.newButton
		{
		    defaultFile = "images/numbers/button.png",
		    overFile ="images/numbers/buttonpressed.png",
		    onEvent = myFunction
		}
	clearbg.x = centerX+100*xscale
	clearbg.y = centerY+10*yscale
	clearbg:scale(0.3*xscale,0.14*yscale)
	clearbutton = display.newText("Clear",centerX+100*xscale,centerY+10*yscale,native.systemFont,24)
	clearbutton:setFillColor(0)

	screenGroup:insert(clearbg)
	screenGroup:insert(clearbutton)


	--b Bubble

	bubble = display.newImage("images/bubble.png", centerX,centerY+100*yscale)
	bubble:scale(0.74*xscale,0.43*yscale)
	screenGroup:insert(bubble)

	local instructions = "You need to get the defuse code. Call your contact at ".. phonenumber.. " to get the defuse code."
	myText = display.newText(instructions, centerX, centerY+150*yscale,400*xscale,200*yscale, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)


	input = display.newImage("images/bubble.png", centerX+100*xscale,centerY-120*yscale)
	input:scale(0.5*xscale,0.15*yscale)
	screenGroup:insert(input)

	answertext = display.newText("", centerX+100*xscale, centerY-120*yscale,native.systemFont, 18 )
	answertext:setFillColor(0)
	screenGroup:insert(answertext)


end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/numbers/phonebg.png",centerX,centerY)
	bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	generateAnswers()
	showAnswers(screenGroup)
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