-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/HUD/HUDRadar.lua
-- *  PURPOSE:     HUD radar class
-- *
-- ****************************************************************************
HUDRadar = inherit(Object)

function HUDRadar:constructor()
	TransferManager:getSingleton():requestFilesAsOnce({"files/images/HUD/Radar.jpg"}, bind(HUDRadar.load, self))
	showPlayerHudComponent("radar", false)
	
	self.m_Texture = nil
	self.m_Width, self.m_Height = 394, 224
	self.m_ImageWidth, self.m_ImageHeight = 6000, 6000
	self.m_Zoom = 1
end

function HUDRadar:load()
	self.m_Texture = dxCreateTexture("files/images/HUD/Radar.jpg")
	self.m_ImageWidth, self.m_ImageHeight = dxGetMaterialSize(self.m_Texture)
	
	addEventHandler("onClientRender", root, bind(self.draw, self))
end

function HUDRadar:draw()
	-- Draw the rectangle (the border)
	dxDrawRectangle(20, screenHeight-250, 400, 230, Color.Black)
	
	-- Draw the map
	local _, _, rotation = getElementRotation(localPlayer)
	local posX, posY, posZ = getElementPosition(localPlayer)
	local mapX = posX / (6000 /self.m_ImageWidth)  + self.m_ImageWidth/2  - self.m_Width/self.m_Zoom/2
	local mapY = posY / (-6000/self.m_ImageHeight) + self.m_ImageHeight/2 - self.m_Height/self.m_Zoom/2
	
	dxDrawImageSection(23, screenHeight-247, self.m_Width, self.m_Height, mapX, mapY, self.m_Width/self.m_Zoom, self.m_Height/self.m_Zoom, self.m_Texture)
	
	-- Draw the player blip
	dxDrawRectangle(20+self.m_Width/2, screenHeight-247+self.m_Height/2, 5, 5, Color.Red)
end

function HUDRadar:setZoom(zoom)
	self.m_Zoom = zoom
end

function HUDRadar:getZoom()
	return self.m_Zoom
end
