-- ****************************************************************************
-- *
-- *  PROJECT:     	Open MTA:DayZ
-- *  FILE:        	client/classes/Nametags.lua
-- *  PURPOSE:     	Player Nametags
-- *
-- ****************************************************************************
Nametags = inherit(Singleton)

function Nametags:constructor()
	self.m_PlayersInRange = {}
	self.fRender = bind(self.mainRender, self)
	self.m_ColShape = createColSphere(0, 0, 0, server:get("nametagradius"))
	attachElements(self.m_ColShape, localPlayer)
	
	-- add event handler
	addEventHandler("onClientColShapeHit", self.m_ColShape, function(element, dimension)
		if getElementType(element) == "player" and element ~= localPlayer then
			self:addPlayer(element)
		end
	end)
	
	addEventHandler("onClientColShapeLeave", self.m_ColShape, function(element, dimension)
		if getElementType(element) == "player" then
			self:removePlayer(element)
		end
	end)
end

function Nametags:destructor()
	removeEventHandler("onClientRender", root, self.fRender)
end

function Nametags:addPlayer(player)
	if #self.m_PlayersInRange == 0 then
		addEventHandler("onClientRender", root, self.fRender)
	end
	
	table.insert(self.m_PlayersInRange, player)
end

function Nametags:removePlayer(player)
	local key = table.find(self.m_PlayersInRange, player)
	if key then
		table.remove(self.m_PlayersInRange, key)
	end
	
	if #self.m_PlayersInRange == 0 then
		removeEventHandler("onClientRender", root, self.fRender)
	end
end

function Nametags:mainRender()
	for key, player in ipairs(self.m_PlayersInRange) do
		if player ~= localPlayer then
			local x, y, z = getElementPosition(player)
			local sx, sy = getScreenFromWorldPosition ( x, y, z + 1, 1000, true )
			local health = getElementHealth(player)
			if health > 0 and sx then
				dxDrawText ( getPlayerName(player), sx - 2, sy - 2, sx, sy, tocolor(255-255*(health/100), 255*(health/100), 0), 1.125, "arial", "center", "center" )
			end
		end
	end
end