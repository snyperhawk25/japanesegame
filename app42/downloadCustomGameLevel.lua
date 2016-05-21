--downloadCustomGameLevel.lua
--to download from our upload service
---------------------------------------------------------------------
local composer = require( "composer" )
local myData = require("Code.mydata")
local App42API = require("App42-Lua-API.App42API")
local tools=require("App42Tools") --this is for App42:Initialize
require("Code.Game2.gameReader")
----------------------------------------------------------------------- 
local ACL= require("App42-Lua-API.ACL")   
require("App42-Lua-API.UploadFileType")   
require("App42-Lua-API.Permission") 
local g2reader=require("Code.Game2.gameReader")
--------------------------------------
--------------------------------
--Global Variables
local uploadService  = App42API:buildUploadService()  

local cgl_nameOfFile = "customGameLevels"
local cgl_nameOfFileWithTxt = "customGameLevels.txt"
local filePath = system.pathForFile(cgl_nameOfFileWithTxt,system.DocumentsDirectory)
local fileType = UploadFileType.TXT
local description = "the custom game file"


--------------------------------------Upload-----------------------------------------------------------------


--This uploads the file
function cgl_uploadFile2()

	--notification
	print("FileName: "..cgl_nameOfFileWithTxt.."\nFilepath: "..filePath.."\nFileType: "..tostring(fileType).."\nDescription: "..description)

	local App42CallBack = {}

	--test sys.DocDir
	uploadService:uploadFile(cgl_nameOfFileWithTxt,filePath,fileType,description,App42CallBack)  

	function App42CallBack:onSuccess(object)     
		print("Upload Success.")
	    --print("fileName is :".. object:getFileList():getName());   
	    --print("Type is :".. object:getFileList():getType());       
	    ---print("Url is :".. object:getFileList():getUrl());    
	    --print("fileDescription is: ".. object:getFileList():getDescription());           
	end    
	function App42CallBack:onException(exception)  
		print("Upload failure.")
	    print("Message is : "..exception:getMessage())  
	    print("App Error code is : "..exception:getAppErrorCode())  
	    print("Http Error code is "..exception:getHttpErrorCode())  
	    print("Detail is : "..exception:getDetails())  
	end  
end

--------------------------------------Download------------------------------------------------------------


local networkListener = function( event )
	    if ( event.isError ) then
	        print( "Network error - download failed" )
	    elseif ( event.phase == "began" ) then
	        print( "Progress Phase: began" )
	    elseif ( event.phase == "ended" ) then
	    	--file download success
	        print("File Downloaded!")
	        --Once downloadd, call the GameReader to read in the new file.
			initializeGameReader()
	    end
end

local networkDownload = function(url)
	--if url good
	if url~=nil then
		local params = {}
		params.progress = true
		params.timeout = 15  --changed from 30


		--test cgl_nameOfFileWithTxt
		network.download(
			url,
			"GET",
		    networkListener,
		    params,
		    cgl_nameOfFileWithTxt,
		    system.DocumentsDirectory
		)
	end
end

function cgl_app42download(fxn)
	local App42CallBack = {}
	--test withtxt
	uploadService:getFileByName(cgl_nameOfFileWithTxt,App42CallBack)  
	--
	function App42CallBack:onSuccess(object)     
		print("File Found..")
	    --print("fileName is :".. object:getFileList():getName());   
	    --print("Type is :".. object:getFileList():getType());       
	    --print("Url is :".. object:getFileList():getUrl());    
	    --print("Description is: ".. object:getFileList():getDescription());

	   	fxn(object:getFileList():getUrl())

	end    
	function App42CallBack:onException(exception)  
		print("Download File Failed.")
	    print("\t<> Message is : "..exception:getMessage())  
	    print("\t<> App Error code is : "..exception:getAppErrorCode())  
	    print("\t<> Http Error code is "..exception:getHttpErrorCode())  
	    print("\t<> Detail is : "..exception:getDetails())  
	    --return nil
	    fxn(nil)
	end
end

--this is the one to call. Who ya gonna call? cgl_downloadFile()
function cgl_downloadFile()
	cgl_app42download(networkDownload)
end


-------------------------------Delete From Server-----------------------------------------------------

--used to be delete from remote
function cgl_uploadFile()
	local App42CallBack = {}
	local result=false
	uploadService:removeFileByName(cgl_nameOfFileWithTxt,App42CallBack)  
	function App42CallBack:onSuccess(object)          
	    print("Remote File Deleted.")
		--print("Response is :"..object:getStrResponse()); 
		result=true
		--move to original upload
		cgl_uploadFile2()
	end    
	function App42CallBack:onException(exception)  
		print("Failed to Delete Remote File.")
	    print("Message is : "..exception:getMessage())  
	    print("App Error code is : "..exception:getAppErrorCode())  
	    print("Http Error code is "..exception:getHttpErrorCode())  
	    print("Detail is : "..exception:getDetails())  
	    --move to original upload
		cgl_uploadFile2()
	end
	--return success boolean
	return result       
end	


-------------------------------------------------------------------
--------------Test Cases------------------------------
--------------------------------------------------------

function testUpload()
	--make a change locally to custom game
	local newQuestion = "6666666\nTestUpload added?\nYes\nYup\nAbsolutely\nWithout A Doubt...\nD\nHard\n"
	--add changes
	addToFile(newQuestion)
	--OLD delte remote
	--cgl_deleteRemoteFile()
	--upload new file
	cgl_uploadFile()

	--check server for 6666666
end

function testDownload()
	--make a change locally to custom game
	local newQuestion = "77777777\nTestDownload added?\nYes\nYup\nAbsolutely\nWithout A Doubt...\nD\nHard\n"
	--add changes
	addToFile(newQuestion)
	--Download new file
	cgl_downloadFile()
	--check to make sure no 7777777777
end