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
local endgroup
local toggle1 = false
local toggle2 = false
local toogle3 = false
local toggle4 = false
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY


local function restart()
	storyboard.purgeScene("numbers.numbers6")
	storyboard.gotoScene("numbers.numbers1")
end



local function incorrect1(n)
	local screenGroup = n
	screenGroup:remove(myText)
	
	screenGroup:insert(bubble)

	local instructions = "Oh no! You entered an incorrect number and the bomb blew up! Mission failed."
	myText = display.newText(instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	reText = display.newText("Restart?",display.contentWidth-50*xscale,30*yscale, native.systemFont, 18 )
	reText:setFillColor(0)
	reText:addEventListener("tap",restart)
	screenGroup:insert(reText)
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



local function hasCollided(obj1, obj2)
    if obj1 == nil then
        return false
    end
    if obj2 == nil then
        return false
    end

    local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
    return (left or right) and (up or down)
end

local function checkEnd(focus)

	if (hasCollided(focus,bl1) and hasCollided(focus,bl2)) or (hasCollided(focus,bl3) and hasCollided(focus,bl2)) or (hasCollided(focus,bl3) and hasCollided(focus,bl4)) then
	else

		if hasCollided(focus,bl1) then
			if focus.num~=bl1.num then
				incorrect(endgroup)
			else
				toggle1 = true
			end
		end
		if hasCollided(focus,bl2) then
			if focus.num~=bl2.num then
				incorrect(endgroup)
			else
				toggle2 = true
			end
		end
		if hasCollided(focus,bl3) then
			if focus.num~=bl3.num then
				incorrect(endgroup)
			else
				toggle3 = true
			end
		end
		if hasCollided(focus,bl4) then
			if focus.num~=bl4.num then
				incorrect(endgroup)
			else
				toggle4 = true
			end
		end
		if toggle1 and toggle2 and toggle3 and toggle4 then
			storyboard.gotoScene("numbers.numbers1")
		end
  	end
end

local function drag(event)
	if event.phase == "began" then
		focus = event.target
		focus.markX = focus.x    -- store x location of object
        focus.markY = focus.y
       	
	end
	if event.phase == "moved" then
        local x = (event.x - event.xStart) + focus.markX
        local y = (event.y - event.yStart) + focus.markY
        
        focus.x, focus.y = x, y  
        if focus.dragtext=="a" then
        	atext.x, atext.y = x,y
        end
         if focus.dragtext=="b" then
        	btext.x, btext.y = x,y
        end
         if focus.dragtext=="c" then
        	ctext.x, ctext.y = x,y
        end
         if focus.dragtext=="d" then
        	dtext.x, dtext.y = x,y
        end

    end

    if event.phase == "ended" or event.phase == "cancelled" then
    	checkEnd(focus)
    end

 
end






local function correct(n)
	local screenGroup = n
	screenGroup:remove(myText)
	
	local instructions = "Awesome."
	myText = display.newText(instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	awardPoints(100) --award points for completing minigame (score is currently not displayed anywhere)

end

local function generateAnswers()

	num1 = math.random(1,20)
	answer = syl[num1+90][1]
	answernum = num1

	num2 = math.random(1,20)
	while num2==num1 do
		num2 = math.random(1,20)
	end
	opt1 = syl[num2+90][1]

	num3 = math.random(1,20)
	while num3==num2 or num3==num1 do
		num3 = math.random(1,20)
	end
	opt2 = syl[num3+90][1]

	num4 = math.random(1,20)
	while num4==num3 or num4==num2 or num4==num1 do
		num4 = math.random(1,20)
	end
	opt3 = syl[num4+90][1]

end

local function showAnswers(n)
	local screenGroup = n

	local a={-200,-90,55,200}
	local b = {}
	local count = 4

	while (count>0) do --randomize the array of x values
		local r = math.random(1,count)
		b[count] = a[r]
		table.remove(a, r)
		count=count-1
	end


	bl1= display.newImage("images/numbers/bomblistener.png",centerX-155*xscale,centerY+0*yscale)
	bl1:scale(0.35*xscale,0.28*yscale)
	bl1.num = num1
	screenGroup:insert(bl1)

	bl2= display.newImage("images/numbers/bomblistener.png",centerX-66*xscale,centerY+0*yscale)
	bl2:scale(0.35*xscale,0.28*yscale)
	bl2.num = num2
	screenGroup:insert(bl2)

	bl3= display.newImage("images/numbers/bomblistener.png",centerX+16*xscale,centerY+0*yscale)
	bl3:scale(0.35*xscale,0.28*yscale)
	bl3.num = num3
	screenGroup:insert(bl3)

	bl4= display.newImage("images/numbers/bomblistener.png",centerX+100*xscale,centerY+0*yscale)
	bl4:scale(0.35*xscale,0.28*yscale)
	bl4.num=num4
	screenGroup:insert(bl4)

	asign = display.newImage("images/bubble.png",centerX+b[1]*xscale,85*yscale)
	asign:scale(0.1*xscale,0.082*yscale)
	asign.dragtext = "a"
	asign.num = num1
	asign:addEventListener("touch",drag)
	screenGroup:insert(asign)


	atext = display.newText(answer,centerX+b[1]*xscale,85*yscale,native.systemFont,14)
	atext:setFillColor(0)
	screenGroup:insert(atext)

	bsign = display.newImage("images/bubble.png",centerX+b[2]*xscale,85*yscale)
	bsign:scale(0.1*xscale,0.082*yscale)
	bsign.dragtext = "b"
	bsign.num = num2
	bsign:addEventListener("touch",drag)
	screenGroup:insert(bsign)

	btext = display.newText(opt1,centerX+b[2]*xscale,85*yscale,native.systemFont,14)
	btext:setFillColor(0)
	screenGroup:insert(btext)

	csign = display.newImage("images/bubble.png",centerX+b[3]*xscale,85*yscale)
	csign:scale(0.1*xscale,0.082*yscale)
	csign.dragtext = "c"
	csign.num = num3
	csign:addEventListener("touch",drag)
	screenGroup:insert(csign)

	ctext = display.newText(opt2,centerX+b[3]*xscale,85*yscale,native.systemFont,14)
	ctext:setFillColor(0)
	screenGroup:insert(ctext)

	dsign = display.newImage("images/bubble.png",centerX+b[4]*xscale,85*yscale)
	dsign:scale(0.1*xscale,0.082*yscale)
	dsign.dragtext = "d"
	dsign.num = num4
	dsign:addEventListener("touch",drag)
	screenGroup:insert(dsign)

	dtext = display.newText(opt3,centerX+b[4]*xscale,85*yscale,native.systemFont,14)
	dtext:setFillColor(0)
	screenGroup:insert(dtext)


	bubble = display.newImage("images/bubble.png", centerX,centerY+90*yscale)
	bubble:scale(0.74*xscale,0.43*yscale)
	screenGroup:insert(bubble)

	local instructions = "The code is ".. num1.. "-".. num2.. "-".. num3.. "-".. num4.. ". Drag the numbers into their correct positions to defuse the bomb. Be careful, one wrong input will make it explode!"
	myText = display.newText(instructions, centerX, centerY+140*yscale,400*xscale,200*yscale, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)



end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	endgroup = screenGroup
	bg = display.newImage("images/numbers/bombbg.png",centerX,centerY)
	bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)


	bomb = display.newImage("images/numbers/bomb.png",centerX,centerY-25*yscale)
	bomb:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bomb)



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