-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUIForms/FormLogin.lua
-- *  PURPOSE:     Login form
-- *
-- ****************************************************************************
FormLogin = inherit(GUIForm)

function FormLogin:constructor()
	-- Call base class constructor
	GUIForm.constructor(self, screenWidth/2 - 600/2, screenHeight/2 - 383/2, 600, 383)

	-- Create GUI elements
	self.m_Window       = GUIWindow:new(0, 0, self.m_Width, self.m_Height, "Login", false, false, self)
	self.m_LabelTitle	= GUILabel:new(90, 50, 300, 70, "Please sign in", 3, self.m_Window)
	self.m_EditUsername = GUIEdit:new(130, 131, 340, 37, self.m_Window)
	self.m_EditPassword = GUIEdit:new(130, 179, 340, 37, self.m_Window)
	self.m_CheckLogin  = GUICheckbox:new(131, 226, 129, 18, "Save Login", self.m_Window)
	self.m_ButtonLogin  = GUIButton:new(130, 270, 153, 37, "Login", self.m_Window)

	-- Apply "properities"
	self.m_EditUsername:setCaption("Username")
	self.m_EditUsername:setFont("arial")
	self.m_EditPassword:setCaption("Password")
	self.m_EditPassword:setFont("tahoma")
	self.m_EditPassword:setMasked()
	self.m_EditUsername:setFontSize(1.5)
	self.m_EditPassword:setFontSize(1.5)
	self.m_ButtonLogin:setFont("tahoma")
	
	-- Check for saved data
	if core:get("login", "remember") then
		self.m_CheckLogin:setChecked(true)
	end
	if core:get("login", "password") then
		outputDebug(core:get("login", "password"))
		self.m_EditPassword:setText(core:get("login", "password"))
		self.m_PasswordAlreadyHashed = true
	end
	if core:get("login", "username") then
		self.m_EditUsername:setText(core:get("login", "username"))
	end

	-- Add event handlers
	self.m_ButtonLogin.onLeftClick = bind(FormLogin.ButtonLogin_Click, self)
	self.m_EditPassword.onEditInput = function() self.m_PasswordAlreadyHashed = false end

	showCursor(true)
end

function FormLogin:destructor()
end

function FormLogin:ButtonLogin_Click()
	if self.m_EditUsername:getText() ~= "" and self.m_EditPassword:getText() ~= "" then
		localPlayer:login(self.m_EditUsername:getText(), self.m_EditPassword:getText(), self.m_CheckLogin:isChecked(), self.m_PasswordAlreadyHashed)
	else
		MessageBox:new("Please insert a valid username and password")
	end
end
