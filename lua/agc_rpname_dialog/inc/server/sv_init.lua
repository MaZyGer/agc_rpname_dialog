util.AddNetworkString("agc_rpname_dialog_RPChangeName")
util.AddNetworkString("agc_rpname_rpname_taken_check")

-- Create sql entrie
local function createPlayerRoleplayname(ply, firstname, lastname)
	MySQLite.query([[REPLACE INTO darkrp_rpnames VALUES(]] ..
			ply:SteamID64() .. [[, ]] ..
			MySQLite.SQLStr(firstname)  .. [[, ]] ..
			MySQLite.SQLStr(lastname)  .. ");")
end

-- look for player entry
local function retrieveRPName(ply, returnSuccess, returnError)
	local query = "SELECT * FROM darkrp_rpnames WHERE uid = " .. ply:SteamID64() .. ";"
	MySQLite.query(query, function(data)
		if(data ~= nil) then
			returnSuccess(data[1])
		else
			returnError()
		end
    end, 
	function(err)
		print("Error: ")
		print(err)
	end)
end

-- If player set the name via dialog (clientsided vgui) this will get called on the server
local function OnPlayerSetName(len, ply)
	local plyRPName = string.Trim(net.ReadString())
	local firstName = string.Trim(net.ReadString())
	local lastName = string.Trim(net.ReadString())
	
	DarkRP.retrieveRPNames(plyRPName, function(isTaken)
		if not isTaken then
			ply:setRPName(plyRPName)
			ply:setDarkRPVar("hasrpname", 1)
			ply:setDarkRPVar("firstname", firstName)
			ply:setDarkRPVar("lastname", lastName)
		  
			createPlayerRoleplayname(ply, firstName, lastName)
		end
	end)
end
net.Receive("agc_rpname_dialog_RPChangeName", OnPlayerSetName)


-- Trigger if player is spawned
local function OnPlayerSpawn(ply)
	retrieveRPName(ply, function(data) 
		ply:setDarkRPVar("hasrpname", 1)
		ply:setDarkRPVar("firstname", data.firstname)
		ply:setDarkRPVar("lastname", data.lastname)
	end,  
	function() 
		ply:setDarkRPVar("hasrpname", 0)
		ply:setDarkRPVar("firstname", "")
		ply:setDarkRPVar("lastname", "")
	end)
end
hook.Add("PlayerInitialSpawn", "agc_rpname_dialog_OnInitialSpawn", OnPlayerSpawn)

local function OnDarkRPDatabaseInitialized()
	-- if table not exists so create one
	queryCreate = [[
            CREATE TABLE IF NOT EXISTS darkrp_rpnames(
                uid BIGINT NOT NULL PRIMARY KEY,
				firstname VARCHAR(45),
				lastname VARCHAR(45)
            );
        ]]
	MySQLite.query(queryCreate)
	
	-- --------- Currently Not needed -------------
	-- now we load names from the list for the server
    -- MySQLite.query([[SELECT * FROM darkrp_player;]], function(data)
        -- for k, v in pairs(data or {}) do
            -- table.insert(DarkRP_NameChangeSystem["rpnames"], {v.uid, v.firstname, v.lastname})
        -- end
    -- end)
	------------- end ----------------------------
	
	DarkRP.defineChatCommand("changerpname", function(ply) 
		net.Start("agc_rpname_dialog_RPChangeName")
		net.Send(ply)
	end)
end
hook.Add("DatabaseInitialized", "agc_rpname_dialog_loadnames", OnDarkRPDatabaseInitialized)

local function OnPlayerChangeRPName(ply, name)
	//DarkRP.notify(ply, 1, 10, "Sorry you can't do that")
		net.Start("agc_rpname_dialog_RPChangeName")
		net.Send(ply)
	return false, "Disabled. Use RPName Dialog (it will open itself)"
end

hook.Add("CanChangeRPName", "agc_on_rpname_change", OnPlayerChangeRPName)




net.Receive("agc_rpname_rpname_taken_check", function(len, ply)
	local name = net.ReadString()
	DarkRP.retrieveRPNames(name, function(isTaken)
		net.Start("agc_rpname_rpname_taken_check")
			net.WriteBool(isTaken)
		net.Send(ply)
	end)
end)



