-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/MessageBox.lua
-- *  PURPOSE:     Message box class
-- *
-- ****************************************************************************
MessageBox = inherit(DxElement)
inherit(GUIFontContainer, MessageBox)

function MessageBox:constructor(text, timeout)
	DxElement.constructor(self, screenWidth - 380, screenHeight - 160, 360, 140)
	GUIFontContainer.constructor(self, text, 1.4, "default")
	
	timeout = timeout or 3000
	setTimer(function()	delete(self) end, timeout, 1)
	
	playSound("files/audio/Message.mp3")
end

function MessageBox:drawThis()
	-- Draw background
	dxDrawRectangle(self.m_AbsoluteX, self.m_AbsoluteY, self.m_Width, self.m_Height, tocolor(0, 0, 0, 200))
	
	-- Draw icon
	dxDrawImage(self.m_AbsoluteX + 10, self.m_AbsoluteY + self.m_Height/2 - 100/2, 100, 100, "files/images/Info.png")
	
	-- Draw message text
	dxDrawText(self.m_Text, self.m_AbsoluteX + 120, self.m_AbsoluteY + 10, self.m_AbsoluteX + self.m_Width - 5, self.m_AbsoluteY + self.m_Height - 10, Color.White, self.m_FontSize, self.m_Font, "left", "top", false, true)
end
