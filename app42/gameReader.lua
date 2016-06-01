--GameReader.lua
--this class will read/update the levels for Game 2
local composer = require( "composer" )
local myData = require("mydata")
----------------------------------------------------------


local nameOfFile = "customGameLevels.txt"



--test questions
local newQuestionEasy = "123456789\nThis is a test question. Answer = A.\nMe\nNot me\nMe neither\nCertainly not me\nA\nEasy\n"
local newQuestionMedium = "234567891\nThis is a test question. Answer = A.\nMe\nNot me\nMe neither\nCertainly not me\nA\nMedium\n"
local newQuestionHard = "345678912\nThis is a test question. Answer = A.\nMe\nNot me\nMe neither\nCertainly not me\nA\nHard\n"
--levels will be the array with the game information
local numQuestions = 0
--define custom array (unsorted) within myData
myData.custom = {}
myData.custom.All = {}
--define custom arras within myData
myData.custom.Easy = {}
myData.custom.Medium = {}
myData.custom.Hard = {}



function initializeGameReader()
	--Console Notify
	print("[gameReader.lua]")
	print("Game 2 Custom Levels: "..tostring(gR_doesFileExist(nameOfFile, system.DocumentsDirectory)))

	--Check If File Exists In System
	if gR_doesFileExist(nameOfFile, system.DocumentsDirectory)==true then
		--Exists. Read in.
		gR_readFile()
	else
		--DNE. Create Default
		gR_writeDefaultFile()
	end

	--test
	--printMyDataDifs()
end

--Function to check whether a specified file, at a specified path, exists.
function gR_doesFileExist( fname, path )
    local result = false
    -- Locate path for file
    local filePath = system.pathForFile( fname, path )
    --If path is good
    if ( filePath ) then
    	--Attempt to read
        local file, errorString = io.open( filePath, "r" )
        if file then
  			--Read posssible. Return True and close file handle
            result = true
            file:close()
        end
    end
    return result
end

--This function reads the contents of the file. (//!@# update method params)
function gR_readFile()
	--Local Variables
	local levels = {}
	local fileText = ""
	--reset NumQuestions
	numQuestions=0
	--static filepath
	local filePath = system.pathForFile(nameOfFile, system.DocumentsDirectory)
	  if ( filePath ) then
	      local file, errorString = io.open( filePath, "r" ) --open

	      if not file then
	          -- Error occurred; output the cause
	          print( "File error: " .. errorString )
	      else
	      	--ready to read file
	      	local contents = file:read("*l")

	      	--while loop to read all of the components of one question
	      	while contents~=nil do

	      		--increment numQuestions (our loop counter) first
	      		 numQuestions=numQuestions+1

	      		--next, set up levels[i] array
	      		levels[numQuestions] = {}

	      		--1) QUESTION ID (qid)
				--contents already fetched for first item.
	      			--Store ID
	      			levels[numQuestions][1]=contents
	      			fileText=fileText..contents
	      			--print("i: "..numQuestions.." Contents: "..contents)

	      		--2) READ QUESTION
				contents = file:read("*l")
	      			--Store Question
	      			levels[numQuestions][2]=contents
	      			fileText=fileText.."\n"..contents
	      			--print("i: "..numQuestions.." Contents: "..contents)

	      		--3) A Value
	      		contents = file:read("*l")
	      			--Store Question
	      			levels[numQuestions][3]=contents
	      			fileText=fileText.."\n"..contents
	      			--print("i: "..numQuestions.." Contents: "..contents)

	      		--4) B Value
	      		contents = file:read("*l")
	      			--Store Question
	      			levels[numQuestions][4]=contents
	      			fileText=fileText.."\n"..contents
	      			--print("i: "..numQuestions.." Contents: "..contents)

	      		--5) C Value
	      		contents = file:read("*l")
	      			--Store Question
	      			levels[numQuestions][5]=contents
	      			fileText=fileText.."\n"..contents
	      			--print("i: "..numQuestions.." Contents: "..contents)

	      		--6) D value
	      		contents = file:read("*l")
	      			--Store Question
	      			levels[numQuestions][6]=contents
	      			fileText=fileText.."\n"..contents
	      			--print("i: "..numQuestions.." Contents: "..contents)

	      		--7) Answer To Question
	      		contents = file:read("*l")
	      			--Store Question
	      			levels[numQuestions][7]=contents
	      			fileText=fileText.."\n"..contents
	      			--print("i: "..numQuestions.." Contents: "..contents)

	      		--8) Difficulty
	      		contents = file:read("*l")
	      			--Store Question
	      			levels[numQuestions][8]=contents
	      			fileText=fileText.."\n"..contents
	      			--print("i: "..numQuestions.." Contents: "..contents)

	      		 --Lastly, addvance the file read for loop condition
	      		 contents = file:read("*l")
	      		 --and add the newline if needed
	      		 if(contents~=nil) then
	      		 	fileText=fileText.."\n"
	      		 end
	        end

	        -- Close the file objects
	          file:close()
	          file=nil
	          errorString=nil
	    end

	 --Finally, save levels array to myData.custom.All
	  myData.custom.All=levels

	end

	--Before returning text, sort and file into myData
	gL_sort(levels)

	--return fileText --//1@# is this necessary/used anywhere?
	  return fileText
end

--******Remove Unnecessary Funtion*********

function gR_writeFile(text)
  --first Delete (just in case)
  gR_deleteFile()
  local path = system.pathForFile(nameOfFile, system.DocumentsDirectory)
  local file, errorString = io.open( path,  "w")
  if not file then
    file:write(text)
    io.close(file)
  else
    file:write(text)
    io.close(file)
  end
  file = nil
  --We need to reread in order to update the myData
  gR_readFile()
end


--******Remove Unnecessary Funtion*********

--Modify the existing customLevels.txt file. //!@# BROKEN
function gR_addToFile(changes)
	--Get the text of the file from readFile
	local fileText = gR_readFile()
	fileText = fileText.."\n"..changes
	--write changes to file
	gR_writeFile(fileText)
	--fileText=nil
end


--This function delete the file from the System. (//!@# update method params, after examining usage)
function gR_deleteFile()
  local destDir = system.DocumentsDirectory
  local result, reason = os.remove( system.pathForFile( nameOfFile, destDir ) )
	if result then
	   print( nameOfFile..": Removed." )
	else
	   print( nameOfFile..": File does not exist.", reason )
	end
end


--This function sorts all of the questions from the incomming array into the myData.custom array categories.
--Note: Categories are static, but make dynamic later.
function gL_sort(arr)

	--TEST print out incoming array
	--for y=1,table.getn(arr) do
	--	for z=1,table.getn(arr[y]) do
	--		print("E-"..y.."-"..z..": "..tostring(arr[y][z]))
	--	end
	--end


	--incrementors
	local i=1 --easy
	local j=1 --medium
	local k=1 --hard
	
	myData.custom.Easy = {}
	myData.custom.Medium = {}
	myData.custom.Hard = {}
	for l=1,table.getn(arr) do
		--get hold of diffculty param 8
		local dif=arr[l][8]
		--test print di
		--print("dif="..dif)

		--if valid value
		if dif~= nil then
			--switch for dificulty

			if dif=="Easy" then
				myData.custom.Easy[i]=arr[l]
				i=i+1
			elseif dif=="Medium" then
				myData.custom.Medium[j]=arr[l]
				j=j+1
			elseif dif=="Hard" then
				myData.custom.Hard[k]=arr[l]
				k=k+1
			else
				--ERROR
				print("***Error in sorting. dif="..tostring(dif))
			end

		end
	end

end




--######################################################
--#################### Dev Methods #########################
--######################################################





function gR_testPrintLevels()
	print("TEST: Printing Levels Array...")
	for i=1,numQuestions,1 do
		print("---------------------------------------")
		print("Level "..i..", QID: "..myData.Game2.customLevels[i][1])
		print("Question: "..myData.Game2.customLevels[i][2])
		print("A) "..myData.Game2.customLevels[i][3])
		print("B) "..myData.Game2.customLevels[i][4])
		print("C) "..myData.Game2.customLevels[i][5])
		print("D) "..myData.Game2.customLevels[i][6])
		print("Correct Answer: "..myData.Game2.customLevels[i][7])
		print("Difficulty: "..myData.Game2.customLevels[i][8])
	end
	print("---------------------------------------")

end

function gR_writeDefaultFile()
  print("<> CREATING CUSTOM GAME LEVELS FILE...")
  --use WriteFile method
  gR_writeFile(newQuestionEasy..newQuestionMedium..newQuestionHard)
  print("<> DONE CGL.txt...")
end


function printMyDataDifs()
	local arr={}
	arr[1]={}
	arr[1][1]="ho"
	arr[1][2]="ho"
	arr[1][3]="ho"

	local size = table.getn(arr[1])
	--TEST
	print("TEST: size=("..size..")")

	--Easy
	print("EASY myData id ("..table.getn(myData.custom.Easy).."):")
	for i=1,table.getn(myData.custom.Easy) do
		print(myData.custom.Easy[i][1])
	end
	--Medium
	print("MEDIUM myData id ("..table.getn(myData.custom.Medium).."):")
	for j=1,table.getn(myData.custom.Medium) do
		print(myData.custom.Medium[j][1])
	end
	--Hard
	print("HARD myData id ("..table.getn(myData.custom.Hard).."):")
	for k=1,table.getn(myData.custom.Hard) do
		print(myData.custom.Hard[k][1])
	end
end

--######################################################
--######################################################
--######################################################




--1) qid
--2) Question
--3) A value
--4) B value
--5) C value
--6) D value
--7) Answer
--8) Difficulty