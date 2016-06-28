-----------------------------------------------------------------------------------------
-- //!@# In progress
-- This is the main class. It initializes the database, as well as the unicode-table for japanese characters.
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
require "dbFile" --where all the db commands come from

audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode)  --allows device audio to continue uninterrupted 
display.setStatusBar( display.HiddenStatusBar )  --hides the status bar on the top of the device


local centerX = display.contentCenterX
local centerY = display.contentCenterY

local storyboard = require( "storyboard" )

--//!@# Required For Numbers Games
--this methods gives appropriate x and y scale values for use when displaying text, images, etc. based
--on the devices screen size. This way everything shows up the same on all devices
--B: This method doesnt work with Corona's content scaling.
--It, and its variables are not used in game2-game4.
function toScale()
	local iphone5x = 640
	local iphone5y = 1136
	local x = display.pixelWidth
	local y = display.pixelHeight
	xscale = y/iphone5y		--opposite since this game is letterbox
	yscale = x/iphone5x

	print("PHONE MODEL: "..system.getInfo("model")..".")

	if string.sub(system.getInfo("model"),1,4) == "iPad" and display.pixelHeight>1500 then
		xscale = xscale/1.9
		yscale = yscale/1.9
	end
	if string.sub(system.getInfo("model"),1,5) == "Droid" then
		xscale = xscale*1.44
		yscale = yscale*1.44
	end
	if string.sub(system.getInfo("model"),1,9) == "Nexus One" then
		xscale = xscale*1.4
		yscale = yscale*1.4
	end
	if string.sub(system.getInfo("model"),1,2) == "GT" then
		xscale = xscale*0.9
		yscale = yscale*0.9
	end
	if string.sub(system.getInfo("model"),1,9) == "Sensation" then
		xscale = xscale*1.2
		yscale = yscale*1.2
	end
end
--toScale() --//!@#should be used for the numbers games.

--database setup starts here
local tablesetup = [[CREATE TABLE IF NOT EXISTS score (id INTEGER PRIMARY KEY, amount INTEGER);]]
db:exec( tablesetup )


---------------------------------------
--App42
----------------------------------------
local App42API = require("App42-Lua-API.App42API")
require("app42.app42UserCheck")
require("app42.aliasLocationWriter")
require("app42.downloadCustomGameLevel")
require("app42.scoreSaver")
require("app42.customLevelReader")

--Step 1) User Authenticate
userAuthenticate()

--Step 2) Download Nina's Custom Game Levels
cgl_downloadFile()

--DEV STEP. FORCE UPLOAD TO SERVER
--cgl_uploadFile()

--Step 3) Initialize Leaderboard
runInitialTest()
--initializeLeaderboards()

--Step 4) Read Custom Levels into myData
initializeGameReader()

---TESTING NEW READER
--require("test.testReader")
--initializeGameReader()



---------------------------------------

physics = require "physics"	 --need physics to handle collisions. start/stop with physics.start() and physics.stop()
physics.start()
physics.setGravity(0,0) --dont want gravity... might want it later but not yet 

--syl {english, hiragana, katakana}
syl ={}
syl[1] = {'SML A','\227\129\129','\227\130\161'}
syl[2] = {'A','\227\129\130','\227\130\162'}
syl[3] = {'SML I','\227\129\131','\227\130\163'}
syl[4] = {'I','\227\129\132','\227\130\164'}
syl[5] = {'SML U','\227\129\133','\227\130\165'}
syl[6] = {'U','\227\129\134','\227\130\166'}
syl[7] = {'SML E','\227\129\135','\227\130\167'}
syl[8] = {'E','\227\129\136','\227\130\168'}
syl[9] = {'SML O','\227\129\137','\227\130\169'}
syl[10] = {'O','\227\129\138','\227\130\170'}
syl[11] = {'KA','\227\129\139','\227\130\171'}
syl[12] = {'GA','\227\129\140','\227\130\172'}
syl[13] = {'KI','\227\129\141','\227\130\173'}
syl[14] = {'GI','\227\129\142','\227\130\174'}
syl[15] = {'KU','\227\129\143','\227\130\175'}
syl[16] = {'GU','\227\129\144','\227\130\176'}
syl[17] = {'KE','\227\129\145','\227\130\177'}
syl[18] = {'GE','\227\129\146','\227\130\178'}
syl[19] = {'KO','\227\129\147','\227\130\179'}
syl[20] = {'GO','\227\129\148','\227\130\180'}
syl[21] = {'SA','\227\129\149','\227\130\181'}
syl[22] = {'ZA','\227\129\150','\227\130\182'}
syl[23] = {'SI','\227\129\151','\227\130\183'}
syl[24] = {'ZI','\227\129\152','\227\130\184'}
syl[25] = {'SU','\227\129\153','\227\130\185'}
syl[26] = {'ZU','\227\129\154','\227\130\186'}
syl[27] = {'SE','\227\129\155','\227\130\187'}
syl[28] = {'ZE','\227\129\156','\227\130\188'}
syl[29] = {'SO','\227\129\157','\227\130\189'}
syl[30] = {'ZO','\227\129\158','\227\130\190'}
syl[31] = {'TA','\227\129\159','\227\130\191'}
syl[32] = {'DA','\227\129\160','\227\131\128'}
syl[33] = {'TI','\227\129\161','\227\131\129'}
syl[34] = {'DI','\227\129\162','\227\131\130'}
syl[35] = {'SML TU','\227\129\163','\227\131\131'}
syl[36] = {'TU','\227\129\164','\227\131\132'}
syl[37] = {'DU','\227\129\165','\227\131\133'}
syl[38] = {'TE','\227\129\166','\227\131\134'}
syl[39] = {'DE','\227\129\167','\227\131\135'}
syl[40] = {'TO','\227\129\168','\227\131\136'}
syl[41] = {'DO','\227\129\169','\227\131\137'}
syl[42] = {'NA','\227\129\170','\227\131\138'}
syl[43] = {'NI','\227\129\171','\227\131\139'}
syl[44] = {'NU','\227\129\172','\227\131\140'}
syl[45] = {'NE','\227\129\173','\227\131\141'}
syl[46] = {'NO','\227\129\174','\227\131\142'}
syl[47] = {'HA','\227\129\175','\227\131\143'}
syl[48] = {'BA','\227\129\176','\227\131\144'}
syl[49] = {'PA','\227\129\177','\227\131\145'}
syl[50] = {'HI','\227\129\178','\227\131\146'}
syl[51] = {'BI','\227\129\179','\227\131\147'}
syl[52] = {'PI','\227\129\180','\227\131\148'}
syl[53] = {'HU','\227\129\181','\227\131\149'}
syl[54] = {'BU','\227\129\182','\227\131\150'}
syl[55] = {'PU','\227\129\183','\227\131\151'}
syl[56] = {'HE','\227\129\184','\227\131\152'}
syl[57] = {'BE','\227\129\185','\227\131\153'}
syl[58] = {'PE','\227\129\186','\227\131\154'}
syl[59] = {'HO','\227\129\187','\227\131\155'}
syl[60] = {'BO','\227\129\188','\227\131\156'}
syl[61] = {'PO','\227\129\189','\227\131\157'}
syl[62] = {'MA','\227\129\190','\227\131\158'}
syl[63] = {'MI','\227\129\191','\227\131\159'}
syl[64] = {'MU','\227\130\128','\227\131\160'}
syl[65] = {'ME','\227\130\129','\227\131\161'}
syl[66] = {'MO','\227\130\130','\227\131\162'}
syl[67] = {'SML YA','\227\130\131','\227\131\163'}
syl[68] = {'YA','\227\130\132','\227\131\164'}
syl[69] = {'SML YU','\227\130\133','\227\131\165'}
syl[70] = {'YU','\227\130\134','\227\131\166'}
syl[71] = {'SML YO','\227\130\135','\227\131\167'}
syl[72] = {'YO','\227\130\136','\227\131\168'}
syl[73] = {'RA','\227\130\137','\227\131\169'}
syl[74] = {'RI','\227\130\138','\227\131\170'}
syl[75] = {'RU','\227\130\139','\227\131\171'}
syl[76] = {'RE','\227\130\140','\227\131\172'}
syl[77] = {'RO','\227\130\141','\227\131\173'}
syl[78] = {'SML WA','\227\130\142','\227\131\174'}
syl[79] = {'WA','\227\130\143','\227\131\175'}
syl[80] = {'WI','\227\130\144','\227\131\176'}
syl[81] = {'WE','\227\130\145','\227\131\177'}
syl[82] = {'WO','\227\130\146','\227\131\178'}
syl[83] = {'N','\227\130\147','none'}

--Generic Numbers Start Here
syl[90] = {syl[76][2]..syl[3][2]} --
syl[91] = {syl[4][2]..syl[33][2]}
syl[92] = {syl[43][2]}
syl[93] = {syl[21][2]..syl[83][2]}
syl[94] = {"よん"} --Julia: "よん , yon" (originally: syl[23][2])
syl[95] = {syl[20][2]}
syl[96] = {syl[77][2]..syl[15][2]}
syl[97] = {"なな"} -- Julia: "なな　(nana)" (originally: syl[23][2]..syl[33][2]})
syl[98] = {syl[47][2]..syl[33][2]}
syl[99] = {"きゅう"} --Julia: きゅう(kyuu)  (originally: syl[15][2])
syl[100] = {syl[24][2]..syl[69][2]..syl[6][2]} --ju (10)
syl[101] = {syl[100][1]..syl[91][1]} --ex. 10 + 1
syl[102] = {syl[100][1]..syl[92][1]}
syl[103] = {syl[100][1]..syl[93][1]}
syl[104] = {syl[100][1]..syl[94][1]}
syl[105] = {syl[100][1]..syl[95][1]}
syl[106] = {syl[100][1]..syl[96][1]}
syl[107] = {syl[100][1]..syl[97][1]}
syl[108] = {syl[100][1]..syl[98][1]}
syl[109] = {syl[100][1]..syl[99][1]} --19 is said two ways.
syl[110] = {syl[92][1]..syl[100][1]}


--Numbers1.lua; Clock Numbers Start here
--Approved by Nina/Julia
--Additional (formal) resources: http://japanese-lesson.com/vocabulary/words/time.html

--Original
syl[120] = {"12:00","じゅうにじ","jyuuniji"}
syl[121] = {"12:30","じゅうにじはん","jyuunijihan"}
syl[122] = {"1:00","いちじ","ichiji"}
syl[123] = {"1:30","いちじはん","ichijihan"}
syl[124] = {"2:00","にじ","niji"}
syl[125] = {"2:30","にじはん","nijihan"}
syl[126] = {"3:00","さんじ","sanji"}
syl[127] = {"3:30","さんじはん","sanjihan"}
syl[128] = {"4:00","よじ","yoji"}
syl[129] = {"4:30","よじはん","yojihan"} --Julia: (this one can be easily mistaken) check for extra "ん" in the question apparently Nina June 21st
syl[130] = {"5:00","ごじ","goji"}
syl[131] = {"5:30","ごじはん","gojihan"}
syl[132] = {"6:00","ろくじ","rokuji"}
syl[133] = {"6:30","ろくじはん","rokujihan"}
syl[134] = {"7:00","しちじ","shichiji"}
syl[135] = {"7:30","しちじはん","shichiji"}
syl[136] = {"8:00","はちじ","hachiji"}
syl[137] = {"8:30","はちじはん","hachijihan"}
syl[138] = {"9:00","くじ","kuji"}
syl[139] = {"9:30","くじはん","kujihan"}
syl[140] = {"10:00","じゅうじ","jyuuji"}
syl[141] = {"10:30","じゅうじはん","jyuujihan"}
syl[142] = {"11:00","じゅういちじ","jyuuichiji"}
syl[143] = {"11:30","じゅういちじはん","jyuuichihan"}




--this tells the program where to go next, after everything is initialized
--storyboard.gotoScene( "menu")
storyboard.gotoScene( "splash","fade",500)

