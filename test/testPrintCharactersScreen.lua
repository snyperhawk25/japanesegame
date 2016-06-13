--NumbersScorePage.lua
--This file is for displaying the final score of the numbers game.

--b For testing vocab words and questions.
local voco = require("vocab")
local quest = require("questions")
local widget = require("widget")
require("app42.customLevelReader")
local myData = require("mydata")


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

function checkQuestionString()

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

--tests printing katakana literal. Yes it works!
function checkJapanesePrint()
	myString="ボヨヨヨヨヨヨヨヨヨヨぁぁぁ"
end


function testingGR()
	initializeGameReader()
	myString="Begin\n"
	for i=1,table.getn(myData.custom.All),1 do
		myString=myString..
		myData.custom.All[i][1].."\n"..
		myData.custom.All[i][2].."\n"..
		myData.custom.All[i][3].."\n"..
		myData.custom.All[i][4].."\n"..
		myData.custom.All[i][5].."\n"..
		myData.custom.All[i][6].."\n"..
		myData.custom.All[i][7].."\n"..
		myData.custom.All[i][8]
	end
end	

-- ScrollView listener
local function scrollListener( event )

    local phase = event.phase
    if ( phase == "began" ) then --print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then --print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then --print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end

    return true
end

-- Create the widget
local scrollView = widget.newScrollView(
    {
        x=centerX,
        y=centerY,
        --top = 100,
        --left = 10,
        width = (centerX*2)-50,
        height = (centerY*2)-25,
        scrollWidth = 600,
        scrollHeight = 5000,
        horizontalScrollDisabled = true,
        isBounceEnabled = true,
        listener = scrollListener
    }
)

-- Create a image and insert it into the scroll view
--local background = display.newImageRect( "assets/scrollimage.png", 768, 1024 )



--CREATE SCENE
function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
	--bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)

	-- title = display.newImage("images/title.png", centerX,centerY-100*yscale)
	-- title:scale(0.6*xscale,0.6*yscale)
	-- screenGroup:insert(title)

	testingGR()
	myText = display.newText(myString, centerX, centerY-5, native.systemFont, 24)
	myText:setFillColor(0)
	scrollView:insert(myText)
	screenGroup:insert(scrollView)

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