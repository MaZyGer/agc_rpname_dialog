
local function openDialog()
		local panel = vgui.Create( "ChangeNameMainWindow" )
end

hook.Add("InitPostEntity", "agc_rpname_dialog_RPChangeName", function()
	if not DarkRP_NameChangeSystem:HasRPName(LocalPlayer()) then
		openDialog()
	end
end)

net.Receive("agc_rpname_dialog_RPChangeName", function(len)
	openDialog()
end)