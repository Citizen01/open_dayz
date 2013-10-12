-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUI/MessageBoxs/MessageBox.lua
-- *  PURPOSE:     Message box class
-- *
-- ****************************************************************************
MessageBox = inherit(DxElement)
inherit(GUIFontContainer, MessageBox)

function MessageBox:drawThis()
	-- Draw background
	dxDrawRectangle(self.m_AbsoluteX, self.m_AbsoluteY, self.m_Width, self.m_Height, tocolor(0, 0, 0, 200))
	
	-- Draw icon
	dxDrawImage(self.m_AbsoluteX + 10, self.m_AbsoluteY + self.m_Height/2 - 100/2, 100, 100, self.m_ImagePath)
	
	-- Draw message text
	dxDrawText(self.m_Text, self.m_AbsoluteX + 120, self.m_AbsoluteY + 10, self.m_AbsoluteX + self.m_Width - 5, self.m_AbsoluteY + self.m_Height - 10, Color.White, self.m_FontSize, self.m_Font, "left", "top", false, true)
end
