-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/MessageBoxs/InfoBox.lua
-- *  PURPOSE:     Success box class
-- *
-- ****************************************************************************
SuccessBox = inherit(MessageBox)

function SuccessBox:constructor(text, timeout)
	DxElement.constructor(self, screenWidth - 380, screenHeight - 160, 360, 140)
	GUIFontContainer.constructor(self, text, 1.4, "default")
	self.m_ImagePath = "files/images/MessageBoxs/Success.png"
	timeout = timeout and timeout >= 50 and timeout or 3000
	setTimer(function() delete(self) end, timeout, 1)
	playSound("files/audio/Message.mp3")
end