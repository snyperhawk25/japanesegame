
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require "dbFile"

--Variables

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local myArray1={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30}
local myArray2


--Function to shuffle arry by Fisher-Yates "inside out". **1-Indexed, the lua standard**
function fisherYates(arr)
	local length = table.getn(arr) --array length
	local t --temp
	local i --element
	--While remaining elements,
	while length > 1 do
		--print("< length = "..length.." >")
		--1) pick a remaining element
		i=math.ceil(math.random()*length) --changed to .ceil for 1-Indexed
		--if i==0 then
		--	print("random i= 0 ERROR!!!")
		--else
		--	print("random i= "..i..".")
		--end
		
		--2) decrement length
		length=length-1
		--3) swap it with current element
		t=arr[length]
		arr[length]=arr[i]
		arr[i]=t
	end
end

--Function to create (array between two values) and shuffle by Fisher-Yates "inside out". **1-Indexed, the lua standard**
function fisherYatesNumbers(start, ending)
	--Create and fill array
	local arr = {}
	local j
	for j=0,ending-start,1 do
		table.insert(arr,start+j)
		--print("array["..j.."]="..start+j)
	end
	--FY
	local length = table.getn(arr) --array length
	local t --temp
	local i --element
	--While remaining elements,
	while length > 1 do
		--print("< length = "..length.." >")
		--1) pick a remaining element
		i=math.ceil(math.random()*length) --changed to .ceil for 1-Indexed
		--if i==0 then
		--	print("random i= 0 ERROR!!!")
		--else
		--	print("random i= "..i..".")
		--end
		
		--2) decrement length
		length=length-1
		--3) swap it with current element
		t=arr[length]
		arr[length]=arr[i]
		arr[i]=t
	end
	return arr
end

--Function to create (array between two values, with first number ~= last number of previous array) and shuffle by Fisher-Yates "inside out". **1-Indexed, the lua standard**
function fisherYatesNumbers(start, ending, prevArr)
	--Create and fill array
	local arr = {}
	local j
	for j=0,ending-start,1 do
		table.insert(arr,start+j)
		--print("array["..j.."]="..start+j)
	end
	--Loop FY until
	repeat
		local length = table.getn(arr) --array length
		print("length: "..length)
		local t --temp
		local i --element
		--While remaining elements,
		while length > 1 do
			--print("< length = "..length.." >")
			--1) pick a remaining element
			i=math.ceil(math.random()*length) --changed to .ceil for 1-Indexed
			--if i==0 then
			--	print("random i= 0 ERROR!!!")
			--else
			--	print("random i= "..i..".")
			--end
			
			--2) decrement length
			length=length-1
			--3) swap it with current element
			t=arr[length]
			arr[length]=arr[i]
			arr[i]=t
		end
		--TEST
		local len2 = #prevArr
		print("len2="..len2)
		print("prevArr[]="..prevArr[1]..prevArr[2]..prevArr[3]..prevArr[4]..";")
		print("prevArr[]="..prevArr[1].."-"..prevArr[len2]..";")
		print("arr[]="..arr[1]..arr[2]..arr[3]..arr[4])
		print("arr[]="..arr[1].."-"..arr[length+1-1]) --//!@#will not grab proper final index 'arr[length]'
		print("Condition: "..arr[1] ~= prevArr[ending-start+1]..";")
	until arr[1]~=prevArr[#prevArr+1] -- +1 for lua 1-Index
	return arr
end
---------------------------------------------------------------------------------------

--Initialize myArray2 elements
function setMyArray2(n)
	local a = {}
	for i=1,n,1 do
		a[i]=i
	end
	return a
end

--Prints the elements of an array.
function printArray(arr)
	print("-----------------------------\nprintArray) table.getn(arr) "..table.getn(arr)..".")
	for i=1,table.getn(arr),1 do
		if arr[i]==nil then
			print("***Arr["..i.."] is nil.*****")
		else
			print("Arr "..i..") "..arr[i]..".")
		end
	end
end





function scene:createScene( event )
	local screenGroup = self.view

	bg = display.newImage("images/bg.png", centerX,centerY+(30*yscale))
	--bg:scale(0.6*xscale,0.6*yscale)
	screenGroup:insert(bg)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	--//!@#
	--math.randomseed(os.time())
	--myArray2=setMyArray2(17)
	--fisherYates(myArray2)
	--printArray(myArray2)

	math.randomseed(os.time())
	--myArray2=fisherYatesNumbers(24,39)
	myArray2=fisherYatesNumbers(4,7,{4,7,5,6})
	printArray(myArray2)
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