-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/manager/NPCManager.lua
-- *  PURPOSE:     Class to manage NPC objects
-- *
-- ****************************************************************************
NPCManager = inherit(Singleton)

function NPCManager:constructor()
	self.m_NPCTypes = {}
	
	-- Register npc types
	self:registerNPCType(Zombie)
end

function NPCManager:addNPCByRef(npc, npcType)
	-- npc is the ped element -> we call enew, so that NPC:constructor will be calle
	enew(npc, self.m_NPCTypes[npcType])
end

function NPCManager:registerNPCType(classt)
	self.m_NPCTypes[classt.getNPCType()] = classt
end
