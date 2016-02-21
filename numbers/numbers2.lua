---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
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
local answerGiven
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function goToMenu()

    storyboard.gotoScene("menu")
    storyboard.removeScene("numbers.numbers2")
end

local function restart()
	storyboard.purgeScene("numbers.numbers2")
	storyboard.gotoScene("numbers.numbers1")
end




local function incorrect1(n)
	local screenGroup = n
	screenGroup:remove(myText)
	
	screenGroup:insert(bubble)

	local instructions = "Oh no! You went to the wrong building and the bomb blew up! Mission failed."
	myText = display.newText(instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, native.systemFont, 18 )
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
	explosion:scale(0.2,0.2)
	screenGroup:insert(explosion)

	local function boom()
		explosion:scale(1.15*xscale,1.15*xscale)
	end

	timer1 = timer.performWithDelay(50,boom,20)

	local function myFunction()
		incorrect1(screenGroup)
	end
	timer2 = timer.performWithDelay(1500,myFunction)
	
end 

local function correct(n)
	storyboard.purgeScene("numbers.numbers2")
	storyboard.gotoScene("numbers.numbers3","zoomOutInFadeRotate",1000)

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

	local a={-220,-90,55,210}
	local b = {}
	local count = 4

	-- while (count>0) do --randomize the array of x values
	-- 	local r = math.random(1,count)
	-- 	b[count] = a[r]
	-- 	table.remove(a, r)
	-- 	count=count-1
	-- end

	--b Remove Randomization
	count=4
	a={-220,-90,55,210}
	for i=1,count,1 do
		b[i] = a[i]
	end	

	--A
	asign = display.newImage("images/numbers/sign.png",centerX+b[1]*xscale,85*yscale)
	asign:scale(0.4*xscale,0.3*yscale)
	local function  myFunction()
		if answerGiven==false then
			correct(screenGroup)
			answerGiven= true
		end
	end
	asign:addEventListener("tap",myFunction)
	screenGroup:insert(asign)


	atext = display.newText(answer,centerX+b[1]*xscale,85*yscale,native.systemFont,16)
	atext:setFillColor(0)
	screenGroup:insert(atext)

	--B
	bsign = display.newImage("images/numbers/sign.png",centerX+b[2]*xscale,85*yscale)
	bsign:scale(0.4*xscale,0.3*yscale)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	bsign:addEventListener("tap",myFunction)
	screenGroup:insert(bsign)

	btext = display.newText(opt1,centerX+b[2]*xscale,85*yscale,native.systemFont,16)
	btext:setFillColor(0)
	screenGroup:insert(btext)

	--C 
	csign = display.newImage("images/numbers/sign.png",centerX+b[3]*xscale,85*yscale)
	csign:scale(0.4*xscale,0.3*yscale)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	csign:addEventListener("tap",myFunction)
	screenGroup:insert(csign)

	ctext = display.newText(opt2,centerX+b[3]*xscale,85*yscale,native.systemFont,16)
	ctext:setFillColor(0)
	screenGroup:insert(ctext)

	--D
	dsign = display.newImage("images/numbers/sign.png",centerX+b[4]*xscale,85*yscale)
	dsign:scale(0.4*xscale,0.3*yscale)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	dsign:addEventListener("tap",myFunction)
	screenGroup:insert(dsign)

	dtext = display.newText(opt3,centerX+b[4]*xscale,85*yscale,native.systemFont,16)
	dtext:setFillColor(0)
	screenGroup:insert(dtext)

	
	bubble = display.newImage("images/bubble.png", centerX,centerY+90*yscale)
	bubble:scale(0.74*xscale,0.43*yscale)
	screenGroup:insert(bubble)

	local instructions = "The bomb is on this street in building ".. answernum.. ". Go to that building and defuse the bomb."
	myText = display.newText(instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)


end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/numbers/streetmap.png",centerX,centerY)
	bg:scale(0.6*xscale,0.6*yscale)
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