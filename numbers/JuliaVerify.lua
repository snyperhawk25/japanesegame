--JuliaVerify.lua
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local string=""

--numbers1
local function num1()
	local r1,ha,ma

	local function generateAnswers(input)
		--b NOTE: Only acceptable values are [1-12]:[00 or 30]. These values are distrubuted from 0 to 23, where 0 is converted to 12.
		r1 = input*30
		ha = math.floor(r1/60) --hours answer
		ma = ((r1/30)%2)*30 

		
		--b Correct for 0:00 --> 12:00 
		if ha == 0 then 
			ha = 12
		end

		--b Correct Minute Answer Text if time is :30
		local han = " "..syl[47][2]..syl[83][2]
		local matext=""
		if ma == 30 then
			matext = han
		end
		return ""..ha..":"..ma.."="..syl[90+ha][1]..syl[24][2]..matext
	end
	--Main
	
	local firstNumIndex=13
	local lastNumIndex=23
	for i=firstNumIndex,lastNumIndex,1 do
		if i%2==0 then
			string = string.."\n"
		end	
		string = string..generateAnswers(i).."   "
	end

end

local function num2()
	local num1,answer,answernum
	local function generateAnswers(input)
		if input>=10 then
			num1 = input
			answer = syl[num1+90][1]
			answernum = num1
		else
			num1=input
			answer = syl[num1+90][1]
			answernum = num1
		end
		return answer
	end

	local firstNumIndex=0
	local lastNumIndex=20
	for i=firstNumIndex,lastNumIndex,1 do
		if i%3==0 then
			string = string.."\n"
		end	
		string = string..i..") "..generateAnswers(i).."  "
	end

end	



function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
	screenGroup:insert(bg)
	--num1()
	num2()
	local myText = display.newText(string, 200,100, native.systemFont, 24)
	myText:setFillColor(0)
	screenGroup:insert(myText)

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