AddCSLuaFile()
local basefoldername = "agc_rpname_dialog"
/* 
Scannt nach client, shared, server (= target) ordner
Sendet und bindet je nach dem die Dateien. 
*/
local function ScanForIncludes(path, target)
	local files, dir = file.Find(path .. "/*", "LUA")
	for k,v in pairs(files) do 
		local buildpath = path .. "/" .. v
		
		if SERVER then
			if("client" == target) then 
				AddCSLuaFile(buildpath)
			elseif "server" == target then
				include(buildpath)
			elseif "shared" == target then
				AddCSLuaFile(buildpath)
				include(buildpath)
			end
		elseif CLIENT then
			if("client" == target) or ("shared" == target) then
				include(buildpath)
			end
		end
	end
	
	for k,v in pairs(dir) do
		
		ScanForIncludes(path .. "/" .. v, target)
	end
end
 
if SERVER then
	ScanForIncludes(basefoldername .. "/inc/shared", "shared")
	ScanForIncludes(basefoldername .. "/inc/client", "client")
	ScanForIncludes(basefoldername .. "/inc/server", "server")
end
 
if CLIENT then
	ScanForIncludes(basefoldername .. "/inc/shared", "shared")
	ScanForIncludes(basefoldername .. "/inc/client", "client")
end
 
 

--
-- local function SharedInclude(path)
-- 	AddCSLuaFile(path)
-- 	include(path)
-- end
--
-- SharedInclude(basefoldername .. "/shared.lua")
--
--
-- if SERVER then
-- 	AddCSLuaFile(basefoldername .. "vgui/main.lua")
-- 	include(basefoldername .. "/sv_init.lua")
-- end
--
-- if CLIENT then
-- 	include(basefoldername .. "/vgui/main.lua")
-- 	include(basefoldername .. "/cl_init.lua")
-- end
