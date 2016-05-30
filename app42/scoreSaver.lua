--ScoreSaver.lua
--This file is suppose to help you save the user's score.
--By being required by a level, this file can interact with App42, instead of each level having to do it.
---------------------------------------------------------------------
local composer = require( "composer" )
local myData = require("mydata")
local App42API = require("App42-Lua-API.App42API")
local tools=require("app42.App42Tools") --this is for App42:Initialize

-----------------------------------------------------------------------
--Global Variables
local app42GameCallBack
local app42ScoreCallBack

local gameService = App42API.buildGameService()  --For Games
local scoreBoardService = App42API.buildScoreBoardService()   --For Leaderboard



------------------------------------------------RUN-----------------------------------------------------------

--function to run
function run()
	local fxn =
		function(res)
			--dummy
		end
	runInitialTest(fxn)
end


------------------------------------------------Games-----------------------------------------------------------

--Get the total number of all games.
function getGamesCount(fxn)
	--callback
	app42GameCallBack = {}
	local result
	--
	gameService:getAllGamesCount(app42GameCallBack)
	function app42GameCallBack:onSuccess(object)
	    --print("Total Records is "..object:getTotalRecords())
	    --set the count
	    result=object:getTotalRecords()
	    --return result
	    fxn(result)
	end
	function app42GameCallBack:onException(exception)
	    print("Failed to get Games Count.")
	    --print("Message is : "..exception:getMessage())
	    --print("App Error code is : "..exception:getAppErrorCode())
	    --print("Detail is : "..exception:getDetails())

	    --return nil
	    result=nil
	    fxn(result)
	end
end

--Get the list of all games
function getGamesList(fxn)
	--
	local app42GameListCallBack = {}
	local result = {}
	--
	gameService:getAllGames(app42GameListCallBack)
	function app42GameListCallBack:onSuccess(object)
	    if table.getn(object) > 1 then
	        for i=1,table.getn(object) do
	           --add the game to result
				result[i]=object[i]:getName()
	        end
	    else
	    	--add the game to result
			result[1]=object[i]:getName()
	    end
	    --return result
	    fxn(result)
	end

	function app42GameListCallBack:onException(exception)
	    print("Failed to get Games List.")
	    --print("Message is : "..exception:getMessage())
	    --print("App Error code is : "..exception:getAppErrorCode())
	    --print("Http Error code is "..exception:getHttpErrorCode())
	    --print("Detail is : "..exception:getDetails())
	    result=nil
	    fxn(result)
	end
end

--------------------------------------Save (save scores)-------------------------------------------

--This function saves a user's score
function saveUserScore(gameName, userName, scoreValue)

	--Notification
	--print("   Attempting to save score of "..scoreValue)

	--callback
	app42ScoreCallBack = {}
	local result
	--
	scoreBoardService:saveUserScore(gameName,userName,scoreValue,app42ScoreCallBack)
	function app42ScoreCallBack:onSuccess(object)
		print("      -Score Saved: Value="..object:getScoreList():getValue()..";")
		result=true
		--print("      -Score Saved [ID:"..object:getScoreList():getScoreId().."]: "..object:getName()..", from "..object:getScoreList():getUserName()..", value "..object:getScoreList():getValue()..";")
	    --print("Game name is "..object:getName())
	    --print("userName is : "..object:getScoreList():getUserName())
	    --print("score is : "..object:getScoreList():getValue())
	    --print("scoreId is : "..object:getScoreList():getScoreId())
	end
	function app42ScoreCallBack:onException(exception)
	    print("      -Score "..scoreValue.." NOT Saved correctly.")
	    result=false
	    --print("Message is : "..exception:getMessage())
	    --print("App Error code is : "..exception:getAppErrorCode())
	    --print("Http Error code is "..exception:getHttpErrorCode())
	    --print("Detail is : "..exception:getDetails())
	end
	--return result
	return result
end


------------------------------------------------Rankings/Rankers -----------------------------------------------------------

--getHighestScoresByUser
function getHighestScoresByUser(gameName, username, fxn)

	--callback
	app42ScoreCallBack = {}
	--
	local result
	--
	scoreBoardService:getHighestScoreByUser(gameName,username,app42ScoreCallBack)
	function app42ScoreCallBack:onSuccess(object)
	   result=object:getScoreList():getValue()
	   fxn(result)
	end
	function app42ScoreCallBack:onException(exception)
		print("Failed to get highscore for user "..username..".")
	    result=nil
	    fxn(result)
	end
end


--returns the ranks number of a specifed user for a specified game
function getUserRanking(gameName, userName, fxn)
	--callback
	app42ScoreCallBack = {}
	--return rank
	local rank = 0

	print("get user "..userName.." \ngame: "..gameName)
	scoreBoardService:getUserRanking(gameName,userName,app42ScoreCallBack)
	function app42ScoreCallBack:onSuccess(object)
	    if table.getn(object:getScoreList()) > 1 then
	        for i=1,table.getn(object:getScoreList()) do
	        	--//!@# given by the API. This gets the very last value
	        	rank = object:getScoreList()[i]:getValue()
	        end
	    else
	    	rank = object:getScoreList():getValue()
	    end
	    --return
	    fxn(rank)
	end
	function app42ScoreCallBack:onException(exception)
	    print("Failed to get rank for user: "..userName)
		fxn(nil)
	end
end

--Returns the Top N Score Rankings (Username and Score) for a game
function getTopNRankings(gameName, max, fxn)
	--callback
	app42ScoreCallBack = {}
	local result = {}
	--
	--print("Getting Top "..max.." Rankings for Game "..gameName..".")
	--
	scoreBoardService:getTopNRankings(gameName,max,app42ScoreCallBack)
	function App42CallBack:onSuccess(object)
	    if table.getn(object:getScoreList()) > 1 then
	        for i=1,table.getn(object:getScoreList()) do
	            --populate the return array with values
	        	result[i] = {}
	        	--Username is first element
	        	result[i][1] = object:getScoreList()[i]:getUserName()
	        	--Score is  secind element
	        	result[i][2] = object:getScoreList()[i]:getValue()
	        end
	    else
	       --populate array[1] with values
	        	result[1] = {}
	        	--Username is first element
	        	result[1][1] = object:getScoreList():getUserName()
	        	--Score is  secind element
	        	result[1][2] = object:getScoreList():getValue()
	    end
	    --return result
	    fxn(result)
	end
	function app42ScoreCallBack:onException(exception)
		print("FAILED: Get Top "..max.." Rankings for Game "..gameName..".")
		--return nil
		result=nil
		fxn(result)
	end
end


function getTopNRankers(gameName, max, fxn)
	--
	app42ScoreCallBack = {}
	--return Array results
	local result = {}
	local size --test
	print("Getting Top "..max.." Rankers for Game "..gameName..".")

	--app42
	scoreBoardService:getTopNRankers(gameName,max,app42ScoreCallBack)

	function app42ScoreCallBack:onSuccess(object)
	    if table.getn(object:getScoreList()) > 1 then
	        for i=1,table.getn(object:getScoreList()) do
	        	--populate the return array with values
	        	result[i] = {}
	        	--Username is first element
	        	result[i][1] = object:getScoreList()[i]:getUserName()
	        	--Score is  secind element
	        	result[i][2] = object:getScoreList()[i]:getValue()
	        end
		else
			--populate array[1] with values
			result[1] = {}
			--Username is first element
			result[1][1] = object:getScoreList():getUserName()
			--Score is  secind element
			result[1][2] = object:getScoreList():getValue()
		end
		--return result
	    fxn(result)
	end
	function app42ScoreCallBack:onException(exception)
		print("Failed to get Top "..max.." Rankers for game "..gameName..".")
	    --print("Message is : "..exception:getMessage())
	    --print("App Error code is : "..exception:getAppErrorCode())
	    --print("Http Error code is "..exception:getHttpErrorCode())
	    --print("Detail is : "..exception:getDetails())

	    --return nil
	    result=nil
	    fxn(result)
	end
end

--This function returns highscores from firstScoreIndex to (firstScoreIndex + numberOfScores)
function getHighscoresByIndex(gameName, firstScoreIndex, numberOfScores, fxn)
	local result = {}
	--First, call getTopNRankings() for up to (firstScoreIndex+numOFScores)

	local variableName = function(result)
		--Second, collect scores from temp
		local delta=firstScoreIndex-1
		for i=firstScoreIndex,(firstScoreIndex+numberOfScores),1 do
			result[i-delta] = {}
			result[i-delta][1]=temp[i][1]
			--result[i-delta][2]=temp[i][2]
		end
		fxn(result)
	end
	getTopNRankings(gameName,(firstScoreIndex+numberOfScores), variableName)
end

------------------------------------------------Print Methods -----------------------------------------------------------

--Print HighScores to console
function printHighScores(gameName)

	app42ScoreCallBack = {}

	print("\nSTEP Y] Attempting To Print Game "..gameName.." Highscores")
	scoreBoardService:getTopRankings(gameName,app42ScoreCallBack)
	function app42ScoreCallBack:onSuccess(object)
		print(object:getName().." HIGHSCORES")
		print("\n===================="..gameName.."=============================")
		print("# Records: "..table.getn(object:getScoreList())..".\n")
	    if table.getn(object:getScoreList()) > 1 then
	        for i=1,table.getn(object:getScoreList()) do
	        	print("----------------------")
	            print("Username: "..object:getScoreList()[i]:getUserName())
	            print("Score: "..object:getScoreList()[i]:getValue())
	            print("----------------------")
	            print(" ")
	        end
	    else
	    	print("----------------------.")
	        print("Username: "..object:getScoreList():getUserName())
	        print("Score: "..object:getScoreList():getValue())
	        print("----------------------")
	        print(" ")
	    end
	    print("=================================================\n")
	end
	function app42ScoreCallBack:onException(exception)
		print("Couldn't Print Game "..gameName.." highscores.")
	    --print("Message is : "..exception:getMessage())
	    --print("App Error code is : "..exception:getAppErrorCode())
	    --print("Http Error code is "..exception:getHttpErrorCode())
	    --print("Detail is : "..exception:getDetails())
	end

end



--############################################################################
--################# DEV METHODS ##############################################
--############################################################################

--DEV METHOD: Initial Run Test
function runInitialTest(fxn)
	--create Leaderboards
	initializeLeaderboards()
	--Add Scores to all of the games.
	--fillAllGamesWithScores(1)
end


--DEV METHOD: This is to initialize our "games"
--Updated for JapaneseGame KissaVocab
function initializeLeaderboards()

	--Variables
	local gameName
	local description
	local app42CallBack = {}
		
	--CallBack Functions
	function app42CallBack:onSuccess(object)
		print("   Added Game \'"..object:getName().."\'.")
	end
	function app42CallBack:onException(exception)
		print("   <> Error Adding Game "..gameName..", Code "..exception:getAppErrorCode()..".")
	end

	--CREATING GAMES

	--Vocab + Dynamic
	print("STEP 2.1] Creating Vocab Games")
	--Game2.lua ("Vocab")
	gameName = "Item_Vocab"
	description = "This is the vocab game for generic items."
	gameService:createGame(gameName,description,app42CallBack)
	--Game3v2.lua ("Foof Vocab")
	gameName = "Food_Vocab"
	description = "This is the vocab game for food items."
	gameService:createGame(gameName,description,app42CallBack)
	--Game4.lua ("Dynamic Vocab")
	gameName = "Dynamic_Vocab"
	description = "This is the dynamic vocab game with questions updated by Nina Langton."
	gameService:createGame(gameName,description,app42CallBack)
	--Notify Vocabs Done
	print("   Done Creating Vocab Games")

	--Numbers Game
	print("STEP 2.2] Creating Numbers Games.")
	--Update Name and Description
	gameName = "Numbers_Game"
	description = "This is the Numbers Game."
	gameService:createGame(gameName,description,app42CallBack)
	--Notify Numbers Done
	print("   Done Creating Numbers Games.")

end



--DEV METHOD: make a set of test Scores
function setSomeTestScores(gameName, numberOfEntries)
	print("Setting "..numberOfEntries.." Test Scores for "..gameName)
	local randomScore=0
	local nameOfTheGame=gameName

	for i=1,numberOfEntries,1 do
		randomScore=math.random(500)+500
		--saveUserScore(nameOfTheGame,myData.App42Username.."_"..i,randomScore)
		saveUserScore(nameOfTheGame,myData.App42Username,randomScore)
	end

end

--DEV METHOD: Fills all Games with Score Records
function fillAllGamesWithScores(numScores)
	--For all 4 games at the moment.
	setSomeTestScores("Food_Vocab", numScores)
	setSomeTestScores("Item_Vocab", numScores)
	setSomeTestScores("Dynamic_Vocab", numScores)
	setSomeTestScores("Numbers_Game", numScores)
end


--############################################################################
--################# END OF DEV METHODS #######################################
--############################################################################


----------------------------------Aggragate Functions -----------------------------------------

--this function is for collecting a user's score and rank for a particular game.
function getUserResults(gameName, username, fxn)
	--
	local result

	--create custom functions
	--RANK
	local rank=function(score)
			return function(rank)
				fxn(rank, score)
			end
		end --userScore

	--SCORE
	local score=function(result)
		getUserRanking(gameName, username, rank(result))--check later !@#
	end


	--fetch user's score
	getHighestScoresByUser(gameName,username,score) --check later !@#

end
