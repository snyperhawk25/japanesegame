--customLevelReader.lua
--this class will read/update the levels for Game4 (Dynamic_Vocab)
local myData = require("mydata")
----------------------------------------------------------
--Variables
local nameOfFile = "customGameLevels.txt"

--levels will be the array with the game information
local numQuestions = 0
--define custom array (unsorted) within myData
myData.custom = {}
--define custom arras within myData
myData.custom.All = {}
myData.custom.Easy = {}
myData.custom.Medium = {}
myData.custom.Hard = {}



function initializeGameReader()
	--at startup of Logical Overflow, read in the file
	print("[customLevelReader.lua]")
	--print("Game4 Custom Levels: "..tostring(gR_doesFileExist(nameOfFile, system.DocumentsDirectory)))
	print("Game4 Custom Levels: "..tostring(gR_doesFileExist(nameOfFile, system.DocumentsDirectory)))

	--check if file exists
	if gR_doesFileExist(nameOfFile, system.DocumentsDirectory)==true then
		--custom Game 2 levels exist
		--set Game 2 values appropriately

		--read questions
		gR_readFile()

		--//!@#BETA Print Out Level Information
		gR_testPrintLevels()

	else
		--no custom levels downloaded
		--set Game 2 values appropriately
		print("ALERT: No custom game level file found")
		--set up default file
		--gR_writeDefaultFile()

	end
end

function gR_doesFileExist( fname, path )
    local results = false
    -- Path for the file
    local filePath = system.pathForFile( fname, path )
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )
        if not file then
            result=false
        else
            results = true
            -- Close the file handle
            file:close()
        end
    end
    return results
end


function gR_readFile()
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
	      	--while loop to read all of the components of one level
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

	--//!@#BETA Removing unused sort feature.
	--Before returning text, sort and file into myData
	--gL_sort(levels)

	--return fileText
	return fileText
end

--NOT WORRIED ABOUT WRITING FILES (UNLESS FOR DEV)
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

--Modify the existing customLevels.txt file. 
--//!@# BROKEN
function gR_addToFile(changes)
	--Get the text of the file from readFile
	local fileText = gR_readFile()
	fileText = fileText.."\n"..changes
	--write changes to file
	gR_writeFile(fileText)
	--fileText=nil
end

--Function to delete local file
function gR_deleteFile()
  local destDir = system.DocumentsDirectory
  local result, reason = os.remove( system.pathForFile( nameOfFile, destDir ) )
	if result then
	   print( nameOfFile..": Removed." )
	else
	   print( nameOfFile..": File does not exist.", reason )
	end
end

--Depricated due to error and unused in beta
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
	for l=1,table.getn(arr),1 do
		--get hold of diffculty param 8
		local dif=arr[l][8]

		--if non-nil value
		if dif~= nil then
			--dificulties
			if dif=="Easy" or dif=="easy" then
				myData.custom.Easy[i]=arr[l]
				i=i+1
			elseif dif=="Medium" or dif=="medium" then
				myData.custom.Medium[j]=arr[l]
				j=j+1
			elseif dif=="Hard" or dif=="hard" then
				myData.custom.Hard[k]=arr[l]
				k=k+1
			else
				--ERROR
				print("Error in gL_sort. dif="..tostring(dif))
			end

		end
	end
	--Print Array numbers
	print("- myData.custom.All: "..table.getn(myData.custom.All)..".")
	print("Below Difficulty Arrays are NOT being used. They should be 0:")
	print("- myData.custom.Easy: "..table.getn(myData.custom.Easy)..".")
	print("- myData.custom.Medium: "..table.getn(myData.custom.Medium)..".")
	print("- myData.custom.Hard: "..table.getn(myData.custom.Hard)..".")

end




--######################################################
--#################### Dev Methods #########################
--######################################################





function gR_testPrintLevels()
	print("TEST: Printing Levels Array...")
	for i=1,numQuestions,1 do
		print("---------------------------------------")
		print("Level "..i..", QID: "..myData.custom.All[i][1])
		print("Question: "..myData.custom.All[i][2])
		print("A) "..myData.custom.All[i][3])
		print("B) "..myData.custom.All[i][4])
		print("C) "..myData.custom.All[i][5])
		print("D) "..myData.custom.All[i][6])
		print("Correct Answer: "..myData.custom.All[i][7])
		print("Difficulty: "..myData.custom.All[i][8])
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
