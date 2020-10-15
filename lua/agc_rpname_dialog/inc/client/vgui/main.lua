local PANEL = {}

function PANEL:Init()

	self.FirstNameIsOk = true
	self.LastNameIsOk = true

	self.IconOkPath = "icon16/tick.png"
	self.IconFailPath = "icon16/cross.png"
	
	self.ButtonColorEnabled = Color( 155, 50, 50, 250 ) 
	self.ButtonColorDisabled = Color( 30, 30, 30, 40 )
	
	self.ButtonCurrentColor = self.ButtonColorEnabled
	
	self.FirstNamePreText = "Firstname"
	self.LastNamePreText = "Lastname"
	
	self.playerHasRPName = DarkRP_NameChangeSystem:HasRPName(LocalPlayer())
	
	local welcomeText = "" 
	if not self.playerHasRPName then
		welcomeText = string.format("Hello %s,\n\nOMG, you just joined the server! Awesome!\nPlease choose first a roleplay name to continue\n(since this a roleplay server \'lul\')", LocalPlayer():Name())
	else
		welcomeText = string.format("Hello %s,\n\nYou want to change your name? You did a bad decision?\nNo Problemo! Just change it!", LocalPlayer():Name())
		self.FirstNamePreText = LocalPlayer():getDarkRPVar("firstname")
		self.LastNamePreText = LocalPlayer():getDarkRPVar("lastname")
	end
	
	local mameChooseRuleText = string.format("Character length can be just between %s and %s.\nYou can add one space to take names like: Robert 'De Niro' or one '-' for names like: 'Amy-Jane' Grace", DarkRP_NameChangeSystem:GetConfigVar("MinCaracters"), DarkRP_NameChangeSystem:GetConfigVar("MaxCaracters"))
	
	surface.CreateFont( "ArialNew", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 25,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )


	self.width = 600
	self.height = 350

	//self:SetPos(ScrW() / 2  -  self.width / 2, ScrH() / 2 - self.height / 2)
	self:SetSize(self.width, self.height)
	self:SetVisible( true )
	self:SetDraggable( false )
	self:ShowCloseButton( false )
	self:SetTitle("")
	self:Center()
	//self:SetBackgroundBlur(true)
	self:MakePopup()

	self.inputWidth = 125
	self.inputHeight = 20

	self.DescriptionLabel = vgui.Create( "DLabel", self ) -- create the form as a child of frame
	self.DescriptionLabel:SetFont( "ArialNew" )
	self.DescriptionLabel:SetText( welcomeText )
	self.DescriptionLabel:SizeToContents()
	SetCenterOffset(self.DescriptionLabel, 0, -100)


	self.NamePanel = vgui.Create("DPanel", self)
	self.NamePanel:SetPos(10, self:GetTall() / 2 - 20)
	self.NamePanel:SetSize(self.width - 20,  self:GetTall() / 2 + 10 )
	self.NamePanel.Paint = function(self, w,h)
			draw.RoundedBox( 0, 0, 0, w, h, Color( 150, 150, 150, 150 ) )
	end

	self.icon = vgui.Create("AvatarImage", self.NamePanel)

	self.icon:SetSize(200, 200)
	self.icon:SetPlayer(LocalPlayer(), 84)
	SetCenterOffset(self.icon, -210, 0)

	self.FirstName_InputField = vgui.Create( "DTextEntry", self.NamePanel ) -- create the form as a child of frame
	self.FirstName_InputField:SetSize( self.inputWidth, self.inputHeight )
	self.FirstName_InputField:SizeToContentsX(0)
	self.FirstName_InputField:SetText( self.FirstNamePreText )
	SetCenterOffset(self.FirstName_InputField, 0, -50)
	self.FirstName_InputField.HasFirstFocus = false
	self.FirstName_InputField.OnGetFocus = function( newSelf )
		if( not newSelf.HasFirstFocus ) then
			if not self.playerHasRPName then
				newSelf:SetText("")
			end
			newSelf.HasFirstFocus = true
			self:OnChangeAnyEntry()
		end
	end
	self.FirstName_InputField.OnChange = function() self:OnChangeAnyEntry() end

	self.FirstName_Label = vgui.Create("DLabel", self.NamePanel)
	self.FirstName_Label:SetText( "Firstname" )
	self.FirstName_Label:SetColor( Color (0,0,0) )
	self.FirstName_Label:SetPos(self.FirstName_InputField.x, self.FirstName_InputField.y + -self.FirstName_InputField:GetTall())

	self.FirstName_InputField_State_IconImage = vgui.Create( "DImage", self.NamePanel )
	self.FirstName_InputField_State_IconImage:SetImage(self.IconOkPath)
	self.FirstName_InputField_State_IconImage:SetSize(16,16)
	SetCenterOffset(self.FirstName_InputField_State_IconImage, self.FirstName_InputField:GetWide() / 2 + 10, -50)
	
	self.LastName_InputField = vgui.Create( "DTextEntry", self.NamePanel ) -- create the form as a child of frame
	self.LastName_InputField:SetSize( self.inputWidth, self.inputHeight)
	self.LastName_InputField:SetContentAlignment(8)
	self.LastName_InputField:CenterHorizontal(0.5)
	self.LastName_InputField:SetText( self.LastNamePreText )
	SetCenterOffset(self.LastName_InputField, 0, -5)
	self.LastName_InputField.HasFirstFocus = false
	self.LastName_InputField.OnGetFocus = function( newSelf )
		if( not newSelf.HasFirstFocus ) then
			if not self.playerHasRPName then
				newSelf:SetText("")
			end
			newSelf.HasFirstFocus = true
			self:OnChangeAnyEntry()
		end
	end
	self.LastName_InputField.OnChange = function() self:OnChangeAnyEntry() end

	self.Name_Label = vgui.Create("DLabel", self.NamePanel)
	self.Name_Label:SetText( "Lastname" )
	self.Name_Label:SetColor( Color (0,0,0) )
	self.Name_Label:SizeToContentsX(500)
	self.Name_Label:SetPos(self.LastName_InputField.x, self.LastName_InputField.y + -self.Name_Label:GetTall())
	
	self.LastName_InputField_State_IconImage = vgui.Create( "DImage", self.NamePanel )
	self.LastName_InputField_State_IconImage:SetImage(self.IconOkPath)
	self.LastName_InputField_State_IconImage:SetSize(16,16)
	SetCenterOffset(self.LastName_InputField_State_IconImage, self.LastName_InputField:GetWide() / 2 + 10, -5)

	self.LastnameLabelWarning = vgui.Create("DLabel", self.NamePanel)
	self.LastnameLabelWarning:SetText( "Test label" )
	self.LastnameLabelWarning:SetColor( Color (230,0,0) )
	self.LastnameLabelWarning:SizeToContentsX(500)
	SetCenterOffset2(self.LastnameLabelWarning, self.Name_Label, 5, 5)

	self.NameChooseRulesLabel = vgui.Create( "DLabel", self.NamePanel ) -- create the form as a child of frame
	self.NameChooseRulesLabel:SetFont( "Arial" )
	self.NameChooseRulesLabel:SetSize(180, 300)
	self.NameChooseRulesLabel:SetText( mameChooseRuleText )
	self.NameChooseRulesLabel:SetWrap(true)
	--self.NameChooseRulesLabel:SetAutoStretchVertical(true)
	SetCenterOffset(self.NameChooseRulesLabel, 190, -28)
	
	local buttonWidth = 80
	local buttonHeight = 30

	self.ConfirmButton = vgui.Create( "DButton", self.NamePanel ) -- create the form as a child of frame
	self.ConfirmButton:SetSize( self.LastName_InputField:GetWide(), buttonHeight)
	self.ConfirmButton:SetText("Confirm")
	self.ConfirmButton:SetTextColor(Color(255,255,255))
	self.ConfirmButton:SetEnabled(true)
	SetCenterOffset(self.ConfirmButton, 0, 40)
	self.ConfirmButton.DoClick = function()
		-- Dark RP Set name
		self:OnConfirmButton()
	end
	self.ConfirmButton.Paint = function(newSelf,w,h)
		draw.RoundedBox( 0, 0, 0, w, h, self.ButtonCurrentColor  )
	end
end


function SetCenterOffset(panel, offset_x, offset_y)
	local P = panel:GetParent()
	panel:SetPos(P:GetWide() / 2 + offset_x - panel:GetWide() / 2, P:GetTall() / 2 + offset_y - panel:GetTall() / 2)
end

function SetCenterOffset2(panel, otherPanel, offset_x, offset_y)
	local P = otherPanel
	panel:SetPos(P.x + offset_x - panel:GetWide() / 2, P.y + offset_y - panel:GetTall() / 2)
end

function PANEL:OnConfirmButton()
	local firstName = string.Trim(self.FirstName_InputField:GetValue())
	local lastName = string.Trim(self.LastName_InputField:GetValue())
	local fullname = firstName .. " " .. lastName

	if (DarkRP_NameChangeSystem:IsNameTooLong(fistname) or DarkRP_NameChangeSystem:IsNameTooShort(firstName)) or (DarkRP_NameChangeSystem:IsNameTooLong(lastName) or DarkRP_NameChangeSystem:IsNameTooShort(lastName)) then
		Derma_Message(
			"Character length can be just between ".. DarkRP_NameChangeSystem:GetConfigVar("MinCaracters") .. " and " .. DarkRP_NameChangeSystem:GetConfigVar("MaxCaracters") .. ".",
			"Something went wrong",
			"OK"
		)
	return end

	if fullname == LocalPlayer():Name() then
		self:Close()
		return false
	end
	
	DarkRP_NameChangeSystem:IsNameTaken(fullname, function(isTaken) 
		if isTaken then
			Derma_Message(
					"Already taken. Try another name!",
					"Something went wrong",
					"OK"
				)
		else
			net.Start("agc_rpname_dialog_RPChangeName")
				net.WriteString(fullname)
				net.WriteString(firstName)
				net.WriteString(lastName)
			net.SendToServer()
			self:Close()
		end
	end)
end

function PANEL:OnChangeAnyEntry()
	local firstName = string.Trim(self.FirstName_InputField:GetValue())
	local lastName = string.Trim(self.LastName_InputField:GetValue())
	local fullname = firstName .. " " .. lastName
	
	local len1 = string.len(firstName)
	local len2 = string.len(lastName)
	
	local OkSoundPath = "buttons/button14.wav"
	local FailSoundPath = "buttons/button16.wav"
	
	local firstNameOK = false
	local lastNameOK = false
	local allowConfirmButton = true
	

	if (DarkRP_NameChangeSystem:IsNameTooLong(firstName)) then 
		-- later for animation things
	elseif (DarkRP_NameChangeSystem:IsNameTooShort(firstName)) then
		-- later for animation things
	elseif not DarkRP_NameChangeSystem:IsValidName(firstName) then 
		-- later for animation things
	else
		firstNameOK = true
	end

	
	if (DarkRP_NameChangeSystem:IsNameTooLong(lastName)) then 
		-- later for animation things
	elseif (DarkRP_NameChangeSystem:IsNameTooShort(lastName)) then 
		-- later for animation things
	elseif not DarkRP_NameChangeSystem:IsValidName(lastName) then 
		-- later for animation things
	else
		lastNameOK = true
	end
	
	if firstNameOK && not self.FirstNameIsOk then
		self.FirstNameIsOk = true
		surface.PlaySound(OkSoundPath)
		self.FirstName_InputField_State_IconImage:SetImage(self.IconOkPath)
	elseif not firstNameOK && self.FirstNameIsOk then
		self.FirstNameIsOk = false
		surface.PlaySound(FailSoundPath)
		self.FirstName_InputField_State_IconImage:SetImage(self.IconFailPath)
	end
	
	if lastNameOK && not self.LastNameIsOk then
		self.LastNameIsOk = true
		surface.PlaySound(OkSoundPath)
		self.LastName_InputField_State_IconImage:SetImage(self.IconOkPath)
	elseif not lastNameOK && self.LastNameIsOk then 
		self.LastNameIsOk = false
		surface.PlaySound(FailSoundPath)
		self.LastName_InputField_State_IconImage:SetImage(self.IconFailPath)
	end
	
	allowConfirmButton = firstNameOK && lastNameOK

	if not allowConfirmButton && not self.ConfirmButton:GetDisabled() then
		self.ConfirmButton:SetEnabled(allowConfirmButton)
		self.ButtonCurrentColor = self.ButtonColorDisabled
		
		self.ConfirmButton.Paint =  function(newSelf, w,h)
			draw.RoundedBox( 0, 0, 0, w, h, self.ButtonCurrentColor )
		end
		
	elseif allowConfirmButton && self.ConfirmButton:GetDisabled() then
		self.ConfirmButton:SetEnabled(allowConfirmButton)
		self.ButtonCurrentColor = self.ButtonColorEnabled
		
		self.ConfirmButton.Paint = function(newSelf, w,h)
			draw.RoundedBox( 0, 0, 0, w, h, self.ButtonCurrentColor )
		end
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox( 5, 0, 0, w, h, Color( 100, 100, 100, 185 ) )
	--draw.RoundedBox( 5, 2, 2, w-5, h-5, Color( 15, 15, 15, 10 ) )
end
vgui.Register("ChangeNameMainWindow", PANEL, "DFrame")
