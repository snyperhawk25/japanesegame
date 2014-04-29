require "sqlite3"

-----Database Stuff goes here

local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path )   
 
--Handle the applicationExit event to close the db
function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end

--this methods awards points to the user
function awardPoints(amount)
	local points = 0
	for row in db:nrows("SELECT * FROM score;") do
		if row.amount~=nil then
			points = row.amount
		end
	end
	points = points+amount
	local tablefill =[[Delete from score]]
	db:exec( tablefill )

	tablefill =[[INSERT INTO score VALUES (NULL, ']]..points..[['); ]]
	db:exec( tablefill )

end
--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )
