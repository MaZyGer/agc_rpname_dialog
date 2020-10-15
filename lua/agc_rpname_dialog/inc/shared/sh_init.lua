DarkRP_NameChangeSystem = {}

DarkRP_NameChangeSystem["Config"] = {
	["MaxCaracters"] = 30,
	["MinCaracters"] = 3,
	["ChangeNameCost"] = 2500, //Cost to change name.
}

DarkRP_NameChangeSystem["rpnames"] = { 
	-- {
		-- ["UID"],
		-- ["FIRSTNAME"],
		-- ["LASTNAME"],
	-- }
}


function DarkRP_NameChangeSystem:GetConfigVar(varname)
	return self["Config"][varname] or 0
end


function DarkRP_NameChangeSystem:HasRPName(ply)
	return ply:getDarkRPVar("hasrpname") == 1
end

function DarkRP_NameChangeSystem:IsNameTooShort(name)
	name = name or ""

	local minLen = self:GetConfigVar("MinCaracters")
	local len = string.len(name)
	
	if(len < minLen) then
		return true
	end
		
	return false
	
end

function DarkRP_NameChangeSystem:IsNameTooLong(name)
	name = name or ""
	
	local maxLen =  self:GetConfigVar("MaxCaracters")
	local len = string.len(name)

	if(len > maxLen) then
		return true
	end
		
	return false
end

-- Checks for this validations (not full name. Just for first or lastname)
-- Can just letters no numbers. Can have one space or "-"
-- Examples
-- 	"Anna" 				is valid 
-- 	"Ann-Lynn" 			is valid
-- 	"Ann Lynn" 			is valid
-- 	"De Niro" 			is valid
-- 	"Robert De Niro" 	not valid (because can only have on space or "-")
-- 	"Alpha123" 			not valid because it has numbers.
function DarkRP_NameChangeSystem:IsValidName(name)
	if not string.match(name, "^[a-zA-ZЀ-џüÜöÖÄä]+[- ]?[a-zA-ZЀ-џüÜöÖÄä]+$") then 
		return false
	else
		return true
	end
end

-- function DarkRP_NameChangeSystem:SetRPName(UID, Firstname, Lastname)
	-- DarkRP_NameChangeSystem["rpnames"][uid] = 
	-- {
		-- ["Firstname"] = Firstname,
		-- ["Lastname"] = Lastname
	-- }
-- end

function DarkRP_NameChangeSystem:IsNameTaken(fullname, callback)
	if CLIENT then
		net.Start("agc_rpname_rpname_taken_check")
			net.WriteString(fullname)
		net.SendToServer()
	
		net.Receive("agc_rpname_rpname_taken_check", function(len)
			local isTaken = net.ReadBool()
			callback(isTaken)
		end)
	end
	
	if SERVER then
		DarkRP.retrieveRPNames(name, function(isTaken)
			callback(isTaken)
		end)
	end
end

hook.Add("DarkRPFinishedLoading", "agc_rpname_dialog_OnDarkRPLoaded", function()
	DarkRP.registerDarkRPVar("hasrpname", net.WriteBit, net.ReadBit)
	--DarkRP.registerDarkRPVar("firstname", net.WriteString, net.WriteString) 
	--DarkRP.registerDarkRPVar("lastname", net.WriteString, net.WriteString) 	
end)