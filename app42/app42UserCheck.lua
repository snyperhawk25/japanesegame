--From 419B

--local composer = require( "composer" )
local myData = require("mydata")
local App42API = require("App42-Lua-API.App42API")
local tools=require("app42.App42Tools") --this is for App42:Initialize
--//!@# ? helpful? 
local al=require("app42.aliasLocationWriter")
------------------------------------------
--Variables
local deviceID
local userService  = App42API:buildUserService()

----------------------------------------------------------


local function randomCharactersAlias(length)
  local seed=math.randomseed(os.clock())
  --function
  --ascii A = 65 +26= 91
    randomText = function ()
    local randText = ""
    for k = 1, length do
      local tval = math.floor(math.random(1, 26))
      randText = randText .. string.char(tval+65)
    end
    return randText
  end
  return randomText(length)
end

--Gets the devices user information
function getDeviceID()
	myData.App42Password="password"
	myData.App42Email="randomEmail"..randomCharactersAlias(8).."@gmail.com"
	--myData.App42Username = system.getInfo("deviceID")

	--//!@#crossover to alias location writer. Check if alias text exists, else makes one wiht random characters
	myData.App42Username = getAlias()
	return myData.App42Username
end



function checkForExistingUser()
	local App42CallBack = {}
	function App42CallBack:onSuccess(object)
	--User Existed on device already. Success.
	    print("   Username Found: "..object:getUserName())
	    --print("  session id is "..object:getSessionId())
	    myData.App42SessionID=object:getSessionId()
	end

	function App42CallBack:onException(exception)
		print("   Authentication Failed.")
	    --print("   Message is : "..exception:getMessage())
	    print("   App Error code is : "..exception:getAppErrorCode())
	    --print("   Http Error code is "..exception:getHttpErrorCode())
	    print("   Detail is : "..exception:getDetails())
	    --We check to make sure the error message throw warrents the creation of a new user (ie. a first time player needs a user account)
	    createUser()
	end
	--This function is to check for the presence of a User ID (the device number) that will be used as the user for App42
	userService:authenticate(myData.App42Username,myData.App42Password,App42CallBack)
end


function createUser()
	--this method creates a user on App42
	local userName  = myData.App42Username
	local pwd = myData.App42Password
	local emailId = myData.App42Email
	--new callback for user creation process, to identify success/errors with creation specifically
	local App42CreateUserCallback = {}
	function App42CreateUserCallback:onSuccess(object)
	      print("   Created User "..object:getUserName())
	end
	function App42CreateUserCallback:onException(exception)
	      print("   User Creation Failed for "..myData.App42Username)
	      print("   Error message: "..exception:getMessage())
	      print("   App Error code is : "..exception:getAppErrorCode())
	      print("   Http Error code is "..exception:getHttpErrorCode())
	      print("   Detail is : "..exception:getDetails())
	end
	--create the user
	userService:createUser(userName,pwd,emailId,App42CreateUserCallback)
end


-----------------------------------------------------------------------

--This is the main function that runs this user check lua file
function userAuthenticate()
	print("[App42UserCheck.lua]")
	print("STEP 1] User Authentication")
	--Gets user alias, else makes one
	getDeviceID()
	--Makes sure user exists, else adds it
	checkForExistingUser()
	print("STEP 1] COMPLETE")
end
