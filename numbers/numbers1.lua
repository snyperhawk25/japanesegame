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
local r1
local ha
local ma
local r2
local ha1
local ma1
local r3
local ha2
local ma2
local r4
local ha3
local ma3
local hourtime
local minutetime
local minute1
local hour1
local matext=""
local ma1text=""
local ma2text=""
local ma3text=""
local answerGiven
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


local function rotate() --set up the times
	minute1:rotate(6*r1)
	hour1:rotate(0.5*r1)
	
	hourtime =(0.5*(r1))%12
	minutetime = (6*(r1))%30
	--b test
	print("\nRotate()\nhourtime: "..hourtime.."\nminutetime: "..minutetime..".\n")
end


local function displayClocks(n)
	local screenGroup = n
	clock1 = display.newImage("images/numbers/clock.png", centerX, centerY-60*yscale)
	clock1:scale(0.7*yscale,0.7*yscale)
	screenGroup:insert(clock1)

	minute1 = display.newImage("images/numbers/minute.png", centerX, centerY-60*yscale, native.systemFont, 18)
	minute1:scale(0.8*xscale,0.8*yscale)
	minute1.anchorY = 1
	screenGroup:insert(minute1)

	hour1 = display.newImage("images/numbers/hour.png", centerX, centerY-60*yscale)
	hour1:scale(0.6*xscale,0.6*yscale)
	hour1.anchorY = 1
	screenGroup:insert(hour1)

	rotate()
end



local function generateAnswers()
	--b NOTE: Only acceptable values are [1-12]:[00 or 30]. These values are distrubuted from 0 to 23, where 0 is converted to 12.
	math.randomseed( os.time() )

	--b ANSWER 0
	r1 = math.random(23)*30
	ha = math.floor(r1/60) --hours answer
	ma = ((r1/30)%2)*30 

	--b ANSWER 1
	r2 = math.random(23)*30
	ha1 = math.floor(r2/60) --hours answer
	ma1 = ((r2/30)%2)*30  --minutes answer

	--b If Answer 1 is same as 0, regenerate 1
	while(((ha1*60)+ma1 == (ha*60)+ma)) do
		r2 = math.random(23)*30
		ha1 = math.floor(r2/60) --hours answer
		ma1 = ((r2/30)%2)*30  --minutes answer
	end

	--b ANSWER 2
	r3 = math.random(23)*30
	ha2 = math.floor(r3/60) --hours answer
	ma2 = ((r3/30)%2)*30

	--b If ANSWER 2 same as 0 or 1, regenrate 2
	while( ((ha2*60)+ma2 == (ha*60)+ma) or ((ha2*60)+ma2 == (ha1*60)+ma1) ) do
		r3 = math.random(23)*30
		ha2 = math.floor(r3/60) --hours answer 
		ma2 = ((r3/30)%2)*30
	end
	
	--b ANSWER 3
	r4 = math.random(23)*30
	ha3 = math.floor(r4/60) --hours answer
	ma3 =  ((r4/30)%2)*30

	--b If ANSWER 3 same as 0, 1, or 2, regenrate 3
	while((((ha3*60)+ma3 == (ha*60)+ma)or((ha3*60)+ma3 == (ha1*60)+ma1))or((ha3*60)+ma3 == (ha2*60)+ma2)) do
		r4 = math.random(23)*30
		ha3 = math.floor(r4/60) --hours answer
		ma3 =  ((r4/30)%2)*30 
	end
	
	--b Correct for 0:00 --> 12:00 
	if ha == 0 then 
		ha = 12
	end
	if ha1 == 0 then 
		ha1 = 12
	end
	if ha2 == 0 then 
		ha2 = 12
	end
	if ha3 == 0 then 
		ha3 = 12
	end

	--b Correct Minute Answer Text if time is :30
	local han = " "..syl[47][2]..syl[83][2]
	if ma == 30 then
		matext = han
	end
	if ma1 == 30 then
		ma1text = han
	end
	if ma2 == 30 then
		ma2text = han
	end
	if ma3 == 30 then
		ma3text = han
	end

	--btest TEST PRINT
	print("\nGENERATE_ANSWERS():\nAnswer0\nha="..ha..". ma="..ma.."\t"..ha..":"..ma.."\nAnswer1\nha1="..ha1..". ma1="..ma1.."\t"..ha1..":"..ma1.."\nAnswer2\nha2="..ha2..". ma2="..ma2.."\t"..ha2..":"..ma2.."\nAnswer3\nha3="..ha3..". ma3="..ma3.."\t"..ha3..":"..ma3.."\n")

end

local function goToMenu()

    storyboard.gotoScene("menu")
    storyboard.removeScene("numbers.numbers1")
end



local function restart()
	storyboard.purgeScene("numbers.numbers1")
	storyboard.reloadScene()
end




local function incorrect1(n)
	local screenGroup = n
	screenGroup:remove(myText)
	
	screenGroup:insert(bubble)

	local instructions = "You chose the wrong time and the bomb blew up. Mission failed."
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
	storyboard.purgeScene("numbers.numbers1")
	storyboard.gotoScene("numbers.numbers2","zoomOutInFadeRotate",1000)
	
end


local function showAnswers(n)
	local screenGroup = n

	--b Randomize x,y values, put into "b"
	local a={{-200,65},{-200,120},{200,120},{200,65}}
	local b = {}
	local count = 4
	print("\nShowAnswers():")
	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = a[r]
		--btest TEST PRINT
		print("b["..count.."] is a["..r.."];\t"..a[r][1]..","..a[r][2]..".")
		table.remove(a, r)
		count=count-1
	end

	--b REMOVING RANDOMIZER
	local b = a

	--btest TEST PRINT
	--correct box to click //!@#resume
	print("b11:"..b[1][1].."b12:"..b[1][2]..".")
	if(b[1][2]<65) then
		if(b[1][1]>0) then
			print("-- Click Top Right --")
		else
			print("-- Click Top Left --")
		end	
	else
		if(b[1][1]>0) then
			print("-- Click Bottom Right --")
		else
			print("-- Click Bottom Left --")
		end
	end	
	--b A - Correct
	asign = display.newImage("images/bubble.png",centerX+b[1][1]*xscale,b[1][2]*yscale)
	asign:scale(0.24*xscale,0.14*yscale)
	local function  myFunction()
		if answerGiven==false then
			correct()
			answerGiven= true
		end
	end
	asign:addEventListener("tap",myFunction)
	screenGroup:insert(asign)


	atext = display.newText(syl[90+ha][1]..syl[24][2]..matext,centerX+b[1][1]*xscale,b[1][2]*yscale,native.systemFont,18)
	atext:setFillColor(0)
	screenGroup:insert(atext)

	--b B - Incorrect
	bsign = display.newImage("images/bubble.png",centerX+b[2][1]*xscale,b[2][2]*yscale)
	bsign:scale(0.24*xscale,0.14*yscale)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	bsign:addEventListener("tap",myFunction)
	screenGroup:insert(bsign)

	btext = display.newText(syl[90+ha1][1]..syl[24][2]..ma1text,centerX+b[2][1]*xscale,b[2][2]*yscale,native.systemFont,18)
	btext:setFillColor(0)
	screenGroup:insert(btext)

	--b C - Incorrect
	csign = display.newImage("images/bubble.png",centerX+b[3][1]*xscale,b[3][2]*yscale)
	csign:scale(0.24*xscale,0.14*yscale)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	csign:addEventListener("tap",myFunction)
	screenGroup:insert(csign)

	ctext = display.newText(syl[90+ha2][1]..syl[24][2]..ma2text,centerX+b[3][1]*xscale,b[3][2]*yscale,native.systemFont,18)
	ctext:setFillColor(0)
	screenGroup:insert(ctext)

	--b D - Incorrect
	dsign = display.newImage("images/bubble.png",centerX+b[4][1]*xscale,b[4][2]*yscale)
	dsign:scale(0.24*xscale,0.14*yscale)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	dsign:addEventListener("tap",myFunction)
	screenGroup:insert(dsign)

	dtext = display.newText(syl[90+ha3][1]..syl[24][2]..ma3text,centerX+b[4][1]*xscale,b[4][2]*yscale,native.systemFont,18)
	dtext:setFillColor(0)
	screenGroup:insert(dtext)

	--b Text Bubble
	bubble = display.newImage("images/bubble.png", centerX,centerY+90*yscale)
	bubble:scale(0.74*xscale,0.43*yscale)
	screenGroup:insert(bubble)

	local instructions = "Your mission is to defuse a bomb. It must happen before the given time. What time does the clock read?"
	myText = display.newText(instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	bg = display.newImage("images/numbers/clockbg.png",centerX,centerY)
	bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	answerGiven = false

	generateAnswers()
	displayClocks(screenGroup)
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