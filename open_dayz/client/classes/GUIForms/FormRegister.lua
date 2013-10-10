-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUIForms/FormRegister.lua
-- *  PURPOSE:     Register form
-- *
-- ****************************************************************************
FormRegister = inherit(GUIForm)

function FormRegister:constructor()
	-- Call base class constructor
	GUIForm.constructor(self, screenWidth/2 - 600/2, screenHeight/2 - 383/2, 600, 383)

	-- Create GUI elements
	self.m_Window       = GUIWindow:new(0, 0, self.m_Width, self.m_Height, "Registration", true, true, self)
	self.m_LabelTitle	= GUILabel:new(80, 50, 380, 70, "Please fill in the form", 3, self.m_Window)
	self.m_EditUsername = GUIEdit:new(130, 131, 340, 37, self.m_Window)
	self.m_EditPassword1 = GUIEdit:new(130, 179, 340, 37, self.m_Window)
	self.m_EditPassword2 = GUIEdit:new(130, 227, 340, 37, self.m_Window)
	self.m_ButtonRegister= GUIButton:new(130, 290, 153, 37, "Register", self.m_Window)

	-- Apply "properities"
	self.m_Window:setAlpha(255)
	self.m_EditUsername:setCaption("Username")
	self.m_EditUsername:setFont("arial")
	self.m_EditUsername:setFontSize(1.5)
	self.m_EditPassword1:setCaption("Password")
	self.m_EditPassword1:setFont("tahoma")
	self.m_EditPassword1:setMasked()
	self.m_EditPassword1:setFontSize(1.5)
	self.m_EditPassword2:setCaption("Confirm the password")
	self.m_EditPassword2:setFont("tahoma")
	self.m_EditPassword2:setMasked()
	self.m_EditPassword2:setFontSize(1.5)
	self.m_ButtonRegister:setFont("tahoma")
	
	-- Add event handlers
	self.m_ButtonRegister.onLeftClick = bind(FormRegister.ButtonRegister_Click, self)

	showCursor(true)
end

function FormRegister:ButtonRegister_Click()
	if not self.m_EditUsername:isEmpty() and not self.m_EditPassword1:isEmpty() and not self.m_EditPassword2:isEmpty() then
		if self.m_EditPassword1:getText() == self.m_EditPassword2:getText() then
			localPlayer:register(self.m_EditUsername:getText(), self.m_EditPassword1:getText())
			delete(self)
		else
			MessageBox:new("The entered passwords do not match. Please try again!")
		end
	else
		MessageBox:new("Please fill in all fields")
	end
end
