---------------------------------------------------------------------------------
--
-- numbers4.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
--require "dbFile"
require("test.shufflingTest")


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
local answerGiven

local audioClick = audio.loadSound("audio/click1.wav")

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local transitionOptions = {
	effect="zoomOutInFadeRotate",
	time=1000,
}
local menuTransition = {
	effect="fade",
	time=500,
}

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("numbers.numbers4")
    end
    timer.performWithDelay(1000, removeSceneListener)
end

local function goToMenu()
	local function playSound()
		audio.play(audioClick,{channel=3})
	end
	timer.performWithDelay(20,playSound)
    storyboard.gotoScene("menu", menuTransition)
    --storyboard.removeScene("numbers.numbers4")
    delayedSceneRemoval()
end


local function restart()
	local function playSound()
		audio.play(audioClick,{channel=3})
	end
	timer.performWithDelay(20,playSound)
	storyboard.purgeScene("numbers.numbers4")
	storyboard.gotoScene("numbers.numbers1", transitionOptions)
end




local function incorrect1(n)
	local screenGroup = n
	screenGroup:remove(myText)
	
	screenGroup:insert(bubble)

	local instructions = "Oh no! You went to the wrong room and the bomb blew up! Mission failed."
	myText = display.newText(instructions, centerX, centerY+180,400,200, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	reText = display.newImage("images/Restart.png",display.contentWidth-50,30)
	reText:scale(0.4,0.4)
	reText:addEventListener("tap",restart)
	screenGroup:insert(reText)

	menu = display.newImage("images/Menu.png",display.contentWidth-50,60)
	menu:scale(0.4,0.4)
	menu:addEventListener("tap",goToMenu)
	screenGroup:insert(menu)
end

local function incorrect(n)
	local screenGroup = n
	
	local function playSound()
		audio.play(audioClick,{channel=3})
	end
	timer.performWithDelay(20,playSound)

	explosion = display.newImage("images/numbers/explosion.png",centerX,centerY)
	explosion:scale(0.2,0.2)
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

local function correct(n)
	local function playSound()
		audio.play(audioClick,{channel=3})
	end
	timer.performWithDelay(20,playSound)

	storyboard.purgeScene("numbers.numbers4")
	storyboard.gotoScene("numbers.numbers5","zoomOutInFadeRotate",1000)

end

local function generateAnswers()
jucheck = math.random(1,2)
	if jucheck == 1 then


		num1 = math.random(1,9)
		answer = syl[num1+90][1]
		answernum = num1

		num2 = math.random(1,9)
		while num2==num1 do
			num2 = math.random(1,9)
		end
		opt1 = syl[num2+90][1]

		num3 = math.random(1,9)
		while num3==num2 or num3==num1 do
			num3 = math.random(1,9)
		end
		opt2 = syl[num3+90][1]

		num4 = math.random(1,9)
		while num4==num3 or num4==num2 or num4==num1 do
			num4 = math.random(1,9)
		end
		opt3 = syl[num4+90][1]

	else

		num1 = math.random(10,20)
		answer = syl[num1+90][1]
		answernum = num1

		num2 = math.random(10,20)
		while num2==num1 do
			num2 = math.random(10,20)
		end
		opt1 = syl[num2+90][1]

		num3 = math.random(10,20)
		while num3==num2 or num3==num1 do
			num3 = math.random(10,20)
		end
		opt2 = syl[num3+90][1]

		num4 = math.random(10,20)
		while num4==num3 or num4==num2 or num4==num1 do
			num4 = math.random(10,20)
		end
		opt3 = syl[num4+90][1]

	end

end

local function showAnswers(n)
	local screenGroup = n

	--Shuffle
	local b = fisherYates({-160,-60,10,90})
	--local b = {-160,-60,10,90} --//!@#Randomizer

	--A
	asign = display.newImage("images/numbers/sign.png",centerX+b[1],85)
	asign:scale(0.4,0.5)
	local function  myFunction()
		if answerGiven==false then
			correct(screenGroup)
			answerGiven= true
		end
	end
	asign:addEventListener("tap",myFunction)
	screenGroup:insert(asign)

	atext = display.newText(answer,centerX+b[1],85,native.systemFont,16)
	atext:setFillColor(0)
	screenGroup:insert(atext)

	if asign.x==centerX-60 or asign.x==centerX+10 then
		asign:scale(0.85,0.85)
		asign.y=asign.y+20
		atext:scale(0.85,0.85)
		atext.y = atext.y+20
	end

	--B
	bsign = display.newImage("images/numbers/sign.png",centerX+b[2],85)
	bsign:scale(0.4,0.5)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	bsign:addEventListener("tap",myFunction)
	screenGroup:insert(bsign)

	btext = display.newText(opt1,centerX+b[2],85,native.systemFont,16)
	btext:setFillColor(0)
	screenGroup:insert(btext)

	if bsign.x==centerX-60 or bsign.x==centerX+10 then
		bsign:scale(0.85,0.85)
		bsign.y=bsign.y+20
		btext:scale(0.85,0.85)
		btext.y = btext.y+20
	end

	--C
	csign = display.newImage("images/numbers/sign.png",centerX+b[3],85)
	csign:scale(0.4,0.5)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	csign:addEventListener("tap",myFunction)
	screenGroup:insert(csign)

	ctext = display.newText(opt2,centerX+b[3],85,native.systemFont,16)
	ctext:setFillColor(0)
	screenGroup:insert(ctext)

	if csign.x==centerX-60 or csign.x==centerX+10 then
		csign:scale(0.85,0.85)
		csign.y=csign.y+20
		ctext:scale(0.85,0.85)
		ctext.y = ctext.y+20
	end

	--D
	dsign = display.newImage("images/numbers/sign.png",centerX+b[4],85)
	dsign:scale(0.4,0.5)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	dsign:addEventListener("tap",myFunction)
	screenGroup:insert(dsign)

	dtext = display.newText(opt3,centerX+b[4],85,native.systemFont,16)
	dtext:setFillColor(0)
	screenGroup:insert(dtext)

	if dsign.x==centerX-60 or dsign.x==centerX+10 then
		dsign:scale(0.85,0.85)
		dsign.y=dsign.y+20
		dtext:scale(0.85,0.85)
		dtext.y = dtext.y+20
	end

	--Bubble
	bubble = display.newImage("images/bubble.png", centerX,centerY+100)
	bubble:scale(0.74,0.25)
	screenGroup:insert(bubble)

	local instructions = "The bomb is in room ".. answernum.. ". Go and defuse the bomb."
	myText = display.newText(instructions, centerX, centerY+180,400,200, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)


end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/numbers/hallway.png",centerX,centerY)
	bg:scale(0.6,0.6)
	screenGroup:insert(bg)

	answerGiven = false
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