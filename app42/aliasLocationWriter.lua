--aliasLocationWriter.lua
--manage the alias.txt file
--------------------------------------------------
local composer = require( "composer" )
local myData = require("mydata")
--------------------------------------------------
--NAME OF THE alias FILE
local nameOfFile="alias.txt"
local aliasPath = system.DocumentsDirectory

local function randomCharactersAlias(length)
  local seed=math.randomseed(os.clock())
  --function
  --ascii A = 65 +26= 91
    randomText = function ()
    local randText = ""
    for k = 1, length do
      local tval = math.floor(math.random(1, 26))
      randText = randText .. string.char(tval+64) --64 ? because of 1 index?
    end
    return randText
  end
  return randomText(length)
end

---//!@# new to kissa vocab
local function randomNumbersAlias(length)
  local seed=math.randomseed(os.clock())
  --function
    randomNum = function ()
    local randNumString = ""
    for k = 1, length do
      local randNum = math.floor(math.random(0, 9))
      randNumString = randNumString .. randNum
    end
    return randNumString
  end
  return randomNum(length)
end

--this function get the user's alias string (nil if DNE)
function getAlias()
  local userAlias

  --First, check if file exists
	local aliasLocation =  aliasLocationWriter_doesFileExist(nameOfFile, aliasPath)
	if aliasLocation then
    --Alias exists. Read from file
    userAlias = aliasLocationWriter_readFile(nameOfFile,aliasPath)
    --save alias into myData.App42Username
    myData.App42Username=userAlias
	else
    --Alia doesnt exist.
    --userAlias=randomCharactersAlias(8) --old
    userAlias=randomNumbersAlias(8) --new
    myData.App42Username=userAlias
    aliasLocationWriter_writeFile(userAlias)
    print("Alias Does Not Exist. Creating one: "..userAlias)
  end
  --return the alias
  return userAlias
end

--function to check if alias file exists
function aliasLocationWriter_doesFileExist( fname, path )
    local result = false
    -- Path for the file
    local filePath = system.pathForFile( fname, path )
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" ) --read
        if file then
          result=true
        end
    end
    --return boolean
    return result
end

--function to read alias file
function aliasLocationWriter_readFile(fname, path)
  local result = ""
  local filePath = system.pathForFile( fname, path )
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" ) --read

        if not file then
            -- Error occurred; output the cause
            print( "Alias File Read Error. ")
        else
            -- File exists! Read from file
            if fname == nameOfFile then
              --read one line
              result = file:read("*l") --Reads the line from the current file position, and moves file position to next line.
              --Reset myData username
              myData.App42Username=result
            end
            --print( "alias File Found: " .. fname.."\n\tValue: "..myData.App42Username)
        end
        -- Close the file handle
        file:close()
    end
  --return result
  return result

end

--function to write new alias path to alias file.
function aliasLocationWriter_writeFile(text)
  local path = system.pathForFile(nameOfFile, aliasPath)
  local file, errorString = io.open( path,  "w+") --All existing data is removed if file exists or new file is created with read write permissions.
  if not file then
    --Error not handled
    --print("File error: " .. errorString)
    file:write(text)
    io.close(file)
  else
    file:write(text)
    io.close(file)
  end
  file = nil

  --read text after write, to update myData
  aliasLocationWriter_readFile(nameOfFile,aliasPath)

end 