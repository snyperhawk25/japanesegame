---------------------------------------------------------------------------------
--
-- numbers6.lua
-- Notes:
-- Need a screen to land on after win state and to display points on.
-- Create a reset function() to reset bl1-4 after playing game
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require("test.shufflingTest")

local a={-200,-90,55,200} 
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

local audioClick = audio.loadSound("audio/click1.wav")

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local function goToMenu()
    storyboard.gotoScene("menu")
    storyboard.removeScene("numbers.numbers6")
end

--Function to delay this scene's removal.
local function delayedSceneRemoval()
    local function removeSceneListener(event)
        storyboard.removeScene("numbers6")
    end
    timer.performWithDelay(500, removeSceneListener)
end

local function restart()
	storyboard.purgeScene("numbers.numbers6")
	storyboard.gotoScene("numbers.numbers1")
end

--DEPRICATED
--local function goToScorePage()
--	print("\nGoing to score page\n")
--	storyboard.purgeScene("numbers.numbers6")
--	storyboard.removeScene("numbers.numbers6")
--	storyboard.gotoScene("numbers.numbersScorePage","zoomOutInFadeRotate",1000)
--end

local function correct(n)
	local screenGroup = n
	screenGroup:remove(myText)
	
	local instructions = "Awesome. You defused the bomb"
	myText = display.newText(instructions, centerX, centerY+140,400,200, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

	awardPoints(100) --award points for completing minigame (score is currently not displayed anywhere)

end

local function incorrect1(n)
	local screenGroup = n
	screenGroup:remove(myText)
	
	screenGroup:insert(bubble)

	local instructions = "Oh no! You entered an incorrect number and the bomb blew up! Mission failed."
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
				--click sfx
				if not toggle1 then
					local function playSound()
						audio.play(audioClick,{channel=3})
					end
					timer.performWithDelay(20,playSound)
				end
				toggle1 = true

			end
		end
		if hasCollided(focus,bl2) then
			if focus.num~=bl2.num then
				incorrect(endgroup)
			else
				--click sfx
				if not toggle2 then
					local function playSound()
						audio.play(audioClick,{channel=3})
					end
					timer.performWithDelay(20,playSound)
				end
				toggle2 = true
			end
		end
		if hasCollided(focus,bl3) then
			if focus.num~=bl3.num then
				incorrect(endgroup)
			else
				--click sfx
				if not toggle3 then
					local function playSound()
						audio.play(audioClick,{channel=3})
					end
					timer.performWithDelay(20,playSound)
				end
				toggle3 = true
			end
		end
		if hasCollided(focus,bl4) then
			if focus.num~=bl4.num then
				incorrect(endgroup)
			else
				--click sfx
				if not toggle4 then
					local function playSound()
						audio.play(audioClick,{channel=3})
					end
					timer.performWithDelay(20,playSound)
				end
				toggle4 = true
			end
		end
		if toggle1 and toggle2 and toggle3 and toggle4 then
			--b TESTPRINT
			print("You Did It! All four toggles are ture")
			

			--Paramenters for Score Page
			local gameOverOptions = {
		        effect = "fade",
		        time = 500,
		        params = {
		            --var1 = "test",
		            retryScene = "numbers.numbers1",
		            gameName = "Time Is Numbered",
		            finalScore = 100,
		            finalScoreUnit = "%",
		            finalDescription = "You managed to defuse the bomb and save the day. Well done!",
		            --app 42 info
		            app42GameName = "TimeIsNumbered"
		        }
		    }

		    --Change Scenes and Delay Removal
		    storyboard.gotoScene("numbers.numbersScorePage", gameOverOptions)
		    delayedSceneRemoval()

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

--To reset the sign and text objects after success //!@# IN PROGRESS
local function resetObjects()
	print("\nReseting Object x,y Positions\n")
	asign.x=centerX+a[1]
	asign.y=85
	atext.x=centerX+a[1]
	atext.y=85

	bsign.x=centerX+a[2]
	bsign.y=85
	btext.x=centerX+a[2]
	btext.y=85

	csign.x=centerX+a[3]
	csign.y=85
	ctext.x=centerX+a[3]
	ctext.y=85

	dsign.x=centerX+a[1]
	dsign.y=85
	dtext.x=centerX+a[1]
	dtext.y=85

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

	--was a here.
	--local b = {}
	--local count = 4

	-- while (count>0) do --randomize the array of x values
	-- 	local r = math.random(1,count)
	-- 	b[count] = a[r]
	-- 	table.remove(a, r)
	-- 	count=count-1
	-- end

	--b Override Randomizer
	--count = 4
	--a={-200,-90,55,200}
	--for i=1,count,1 do
	--	b[i]=a[i]
	--end	


	--Shuffle
	--local b = fisherYates({-200,-90,55,200})
	local b = {-200,-90,55,200} --//!@#Removed Randomizer


	bl1= display.newImage("images/numbers/bomblistener.png",centerX-155,centerY+0)
	bl1:scale(0.35,0.28)
	bl1.num = num1
	screenGroup:insert(bl1)

	bl2= display.newImage("images/numbers/bomblistener.png",centerX-66,centerY+0)
	bl2:scale(0.35,0.28)
	bl2.num = num2
	screenGroup:insert(bl2)

	bl3= display.newImage("images/numbers/bomblistener.png",centerX+16,centerY+0)
	bl3:scale(0.35,0.28)
	bl3.num = num3
	screenGroup:insert(bl3)

	bl4= display.newImage("images/numbers/bomblistener.png",centerX+100,centerY+0)
	bl4:scale(0.35,0.28)
	bl4.num=num4
	screenGroup:insert(bl4)

	asign = display.newImage("images/bubble.png",centerX+b[1],85)
	asign:scale(0.125,0.09)
	asign.dragtext = "a"
	asign.num = num1
	asign:addEventListener("touch",drag)
	screenGroup:insert(asign)


	atext = display.newText(answer,centerX+b[1],85,native.systemFontBold,13)
	atext:setFillColor(0)
	screenGroup:insert(atext)

	bsign = display.newImage("images/bubble.png",centerX+b[2],85)
	bsign:scale(0.125,0.09)
	bsign.dragtext = "b"
	bsign.num = num2
	bsign:addEventListener("touch",drag)
	screenGroup:insert(bsign)

	btext = display.newText(opt1,centerX+b[2],85,native.systemFontBold,13)
	btext:setFillColor(0)
	screenGroup:insert(btext)

	csign = display.newImage("images/bubble.png",centerX+b[3],85)
	csign:scale(0.125,0.09)
	csign.dragtext = "c"
	csign.num = num3
	csign:addEventListener("touch",drag)
	screenGroup:insert(csign)

	ctext = display.newText(opt2,centerX+b[3],85,native.systemFontBold,13)
	ctext:setFillColor(0)
	screenGroup:insert(ctext)

	dsign = display.newImage("images/bubble.png",centerX+b[4],85)
	dsign:scale(0.125,0.09)
	dsign.dragtext = "d"
	dsign.num = num4
	dsign:addEventListener("touch",drag)
	screenGroup:insert(dsign)

	dtext = display.newText(opt3,centerX+b[4],85,native.systemFontBold,13)
	dtext:setFillColor(0)
	screenGroup:insert(dtext)


	bubble = display.newImage("images/bubble.png", centerX,centerY+90)
	bubble:scale(0.74,0.43)
	screenGroup:insert(bubble)

	local instructions = "The code is ".. num1.. "-".. num2.. "-".. num3.. "-".. num4.. ". Drag the numbers into their correct positions to defuse the bomb. Be careful, one wrong input will make it explode!"
	myText = display.newText(instructions, centerX, centerY+140,400,200, native.systemFont, 18 )
	myText:setFillColor(0)
	screenGroup:insert(myText)

end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	endgroup = screenGroup
	bg = display.newImage("images/numbers/bombbg.png",centerX,centerY)
	bg:scale(0.6,0.6)
	screenGroup:insert(bg)


	bomb = display.newImage("images/numbers/bomb.png",centerX,centerY-25)
	bomb:scale(0.6,0.6)
	screenGroup:insert(bomb)



	generateAnswers()
	showAnswers(screenGroup)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	resetObjects()
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	--resetObjects()
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