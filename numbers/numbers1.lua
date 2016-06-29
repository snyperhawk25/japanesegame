---------------------------------------------------------------------------------
--
-- numbers1.lua
--REWRITTING TO FIX THE CLOCK LOGIC.
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
local r1 = 0
local ha
local ma = 0
local r2 = 0
local ha1
local ma1 =0
local r3 = 0
local ha2
local ma2 =0
local r4 = 0
local ha3
local ma3 = 0
local minute1
local hour1
local matext=""
local ma1text=""
local ma2text=""
local ma3text=""
local answerGiven
local audioClick = audio.loadSound("audio/click1.wav")
audio.setVolume(1.0)
local centerX = display.contentCenterX
local centerY = display.contentCenterY

--Function to rotate the clock's arms to the correct time
local function rotate() 
	--Hour Hand (30 degrees / hour)
	hour1:rotate(30*ha)
	--Minute Hand (Only rotate if :30)
	if ma==30 then
		minute1:rotate(180)
	end
end

--Function to show the clock.
local function displayClocks(screen)
	--Clock Face
	clock1 = display.newImage("images/numbers/clock.png", centerX, centerY-60)
	clock1:scale(0.7,0.7)
	screen:insert(clock1)
	--Minute Hand
	minute1 = display.newImage("images/numbers/minute.png", centerX, centerY-60, native.systemFont, 18)
	minute1:scale(0.8,0.8)
	minute1.anchorY = 1
	screen:insert(minute1)
	--Hour Hand
	hour1 = display.newImage("images/numbers/hour.png", centerX, centerY-60)
	hour1:scale(0.6,0.6)
	hour1.anchorY = 1
	screen:insert(hour1)
	
	--Finally, rotate the arms to the proper positions 
	rotate()
end


--Fuction to generate the four unique answers, and assign the proper r,ha, and ma values
local function generateAnswers()
	--b NOTE: Only acceptable values are [1-12]:[00 or 30]. These values are distrubuted from 0 to 23, where 0 is converted to 12.
	--Get New Seed
	math.randomseed( os.time() )

	--Generate All 4 answers (inefficiently); 0-23
	local it=0
	repeat
		it=it+1
		r1 = math.random(24)-1
		r2 = math.random(24)-1
		r3 = math.random(24)-1
		r4 = math.random(24)-1
		print("loops="..it)
	until (r1 ~= r2) and (r2 ~= r3) and (r3 ~= r4) 	

	print("Here Are Todays Numbers..."..r1..","..r2..","..r3..","..r4..".")
	
	--Sort out hours
	ha=math.floor(r1/2)
	ha1=math.floor(r2/2)
	ha2=math.floor(r3/2)
	ha3=math.floor(r4/2)

	--Sort out min
	if r1%2~=0 then ma = 30 end
	if r2%2~=0 then ma1 = 30 end
	if r3%2~=0 then ma2 = 30 end
	if r3%2~=0 then ma3 = 30 end

	--Test Print
	print("\n\n\nGENERATE_ANSWERS():\nAnswer0\nr1="..r1..". ha="..ha..". ma="..ma.."\t"..ha..":"..ma.."\nAnswer1\nr2="..r2..". ha1="..ha1..". ma1="..ma1.."\t"..ha1..":"..ma1.."\nAnswer2\nr3="..r3..". ha2="..ha2..". ma2="..ma2.."\t"..ha2..":"..ma2.."\nAnswer3\nr4="..r4..". ha3="..ha3..". ma3="..ma3.."\t"..ha3..":"..ma3.."\n\n\n")
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

	local instructions = "You chose the wrong time. The bomb exploded. Game Over."
	myText = display.newText(instructions, centerX, centerY+140,400,200, native.systemFont, 18 )
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
	
	audio.play(audioClick)

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
	audio.play(audioClick)	storyboard.purgeScene("numbers.numbers1")
	storyboard.gotoScene("numbers.numbers2","zoomOutInFadeRotate",1000)
	
end


local function showAnswers(screenGroup)
	
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

	-- --b REMOVING RANDOMIZER
	--local b = a
	b={{-200,65},{-200,120},{200,120},{200,65}}


	--b A - Correct
	asign = display.newImage("images/bubble.png",centerX+b[1][1],b[1][2])
	asign:scale(0.24,0.14)
	local function  myFunction()
		if answerGiven==false then
			correct()
			answerGiven= true
		end
	end
	asign:addEventListener("tap",myFunction)
	screenGroup:insert(asign)


	atext = display.newText(syl[120+r1][1]..syl[120+r1][2],centerX+b[1][1],b[1][2],native.systemFont,18)
	atext:setFillColor(0)
	screenGroup:insert(atext)

	--b B - Incorrect
	bsign = display.newImage("images/bubble.png",centerX+b[2][1],b[2][2])
	bsign:scale(0.24,0.14)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	bsign:addEventListener("tap",myFunction)
	screenGroup:insert(bsign)

	btext = display.newText(syl[120+r2][1]..syl[120+r2][2],centerX+b[2][1],b[2][2],native.systemFont,18)
	btext:setFillColor(0)
	screenGroup:insert(btext)

	--b C - Incorrect
	csign = display.newImage("images/bubble.png",centerX+b[3][1],b[3][2])
	csign:scale(0.24,0.14)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	csign:addEventListener("tap",myFunction)
	screenGroup:insert(csign)

	ctext = display.newText(syl[120+r3][1]..syl[120+r3][2],centerX+b[3][1],b[3][2],native.systemFont,18)
	ctext:setFillColor(0)
	screenGroup:insert(ctext)

	--b D - Incorrect
	dsign = display.newImage("images/bubble.png",centerX+b[4][1],b[4][2])
	dsign:scale(0.24,0.14)
	local function  myFunction()
		if answerGiven==false then
			incorrect(screenGroup)
			answerGiven= true
		end
	end
	dsign:addEventListener("tap",myFunction)
	screenGroup:insert(dsign)

	dtext = display.newText(syl[120+r4][1]..syl[120+r4][2],centerX+b[4][1],b[4][2],native.systemFont,18)
	dtext:setFillColor(0)
	screenGroup:insert(dtext)

	--b Text Bubble
	bubble = display.newImage("images/bubble.png", centerX,centerY+90)
	bubble:scale(0.74,0.43)
	screenGroup:insert(bubble)

	local instructions = "You see a clock on the wall, but it is not set to the correct time. You hear a very suspicious ticking sound coming from the clock, making you suddenly nervous. What time is shown on the clock?"
	myText = display.newText(instructions, centerX, centerY+140,400,200, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)
end


function scene:createScene( event )
	local screenGroup = self.view
	--Background
	bg = display.newImage("images/numbers/clockbg.png",centerX,centerY)
	bg:scale(0.6,0.6)
	screenGroup:insert(bg)

	--Set Values
	answerGiven = false

	--Compute Question
	generateAnswers()

	--Display Info
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
	--Dispose audio
	audio.dispose(audioClick)
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