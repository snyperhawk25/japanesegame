--NumbersScorePage.lua
--This file is for displaying the final score of the numbers game.

--b For testing vocab words and questions.
local voco = require("vocab")
local quest = require("questions")



local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"

--Variables

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local myString = ""


--b Print Syl Array
function printSylArray()
	--size
	---print("\ntable.getn()="..table.getn(syl)..".")

	-- local first=81
	-- local last=83

	-- --Letters
	-- for i=first,last,1 do
	-- 	if syl[i] then
	-- 		myString = myString..
	-- 		"\nsyl["..i.."]: 1) "..syl[i][1]..
	-- 		"   2)"..syl[i][2]..
	-- 		"   3)"..syl[i][3]
	-- 	end
	-- end

	--Numbers
	local firstNumIndex=90
	local lastNumIndex=110
	for i=firstNumIndex,lastNumIndex,1 do
		myString=myString.."\nsyl["..i.."]:  #"..(i-firstNumIndex).."     "..syl[i][1]
	end
end
--console print characters.
--printSylArray()

function checkString()

	--Questions.lua (for non-numbers game)
	local first=11
	local last=20
	myString=""
	for i=first,last,1 do
		myString=myString.."\nQuestion "..i..")  "..question[i].q
	end

	-- myString=myString..
	-- "\nhiragana[vu] = "..hiragana["vu"].. 
	-- "\nhiragana[ka_small] = "..hiragana["ka_small"]..
	-- "\nhiragana[ke_small] = "..hiragana["ke_small"]
end

function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
	--bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	-- title = display.newImage("images/title.png", centerX,centerY-100*yscale)
	-- title:scale(0.6*xscale,0.6*yscale)
	-- screenGroup:insert(title)

	--myString
	checkString()
	myText = display.newText(myString, centerX, centerY-5, native.systemFont, 24)
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