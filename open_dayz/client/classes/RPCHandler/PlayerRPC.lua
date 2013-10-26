-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/RPCHandler/PlayerRPC.lua
-- *  PURPOSE:     Player RPC class
-- *
-- ****************************************************************************
PlayerRPC = inherit(RPC)

function PlayerRPC:constructor()
	-- Object creation RPCs
	self:register(RPC_NPC_CREATE, PlayerRPC.npcCreate)
	self:register(RPC_ZOMBIE_CREATE, PlayerRPC.zombieCreate)

	self:register(RPC_PLAYER_LOGIN, PlayerRPC.playerLogin)
	self:register(RPC_PLAYER_REGISTER, PlayerRPC.playerRegister)
	self:register(RPC_PLAYER_MESSAGE, PlayerRPC.playerMessage)
	
	self:register(RPC_TRANSFER_REQUEST_FILELIST, PlayerRPC.transferRequestFilelist)
	self:register(RPC_TRANSFER_REQUEST_FILES, PlayerRPC.transferRequestFiles)
	
	-- Sync RPCs
	self:register(RPC_PLAYER_NECESSITIES_SYNC, PlayerRPC.playerNecessitiesSync)
	
	self:register(RPC_INVENTORY_FULLSYNC, PlayerRPC.inventoryFullSync)
	self:register(RPC_INVENTORY_SYNC, PlayerRPC.inventorySync)
	self:register(RPC_INVENTORY_CLOSE, PlayerRPC.inventoryClose)
end

function PlayerRPC.toElement(element)
	-- Our first parameter is an element, so we are able to return it directly
	return element
end

function PlayerRPC.npcCreate(npc)
	NPCManager:getSingleton():addNPCByRef(npc, "NPC") -- Todo
end

function PlayerRPC.zombieCreate(zombie)
	ZombieManager:getSingleton():addZombieByRef(zombie, "Zombie") -- Todo
end

function PlayerRPC.playerLogin(player, status, reason, locale)
	if status == RPC_STATUS_ERROR then
		if reason == RPC_STATUS_ALREADY_LOGGED_IN then
			localPlayer:sendMessage(_"Login failed. You're already logged in!", 255, 0, 0)
			return
		elseif reason == RPC_STATUS_INVALID_USERNAME or reason == RPC_STATUS_INVALID_PASSWORD then
			localPlayer:sendMessage(_"Login failed. Invalid username / password!", 255, 0, 0)
			return
		end
	elseif status == RPC_STATUS_SUCCESS then
		localPlayer:setLocale(locale)
		localPlayer:sendMessage(_"Sucessfully logged in!")
		localPlayer:onLogin()
	end
end

function PlayerRPC.playerRegister(player, status, reason)
	if status == RPC_STATUS_ERROR then
		if reason == RPC_STATUS_ALREADY_LOGGED_IN then
			localPlayer:sendMessage(_"Registration failed. You're already logged in!", 255, 0, 0)
			return
		elseif reason == RPC_STATUS_DUPLICATE_USER then
			localPlayer:sendMessage(_"Registration failed. A user with the desired name already exists!", 255, 0, 0)
			return
		end
	elseif status == RPC_STATUS_SUCCESS then
		localPlayer:sendMessage(_"Sucessfully registered!")
		localPlayer:onLogin()
	end
end

function PlayerRPC.playerMessage(player, messageType, text, timeout)
	if messageType == RPC_STATUS_MESSAGE_INFO then
		InfoBox:new(text, timeout)
	elseif messageType == RPC_STATUS_MESSAGE_WARNING then
		WarningBox:new(text, timeout)
	elseif messageType == RPC_STATUS_MESSAGE_ERROR then
		ErrorBox:new(text, timeout)
	elseif messageType == RPC_STATUS_MESSAGE_SUCCESS then
		SuccessBox:new(text, timeout)
	end
end

function PlayerRPC.transferRequestFilelist(player, filelist)
	TransferManager:getSingleton():receiveOnConnectList(filelist)
end

function PlayerRPC.transferRequestFiles(player, filelist)
	TransferManager:getSingleton():receiveFiles(filelist)
end

function PlayerRPC.playerNecessitiesSync(player, hunger, thirst)
	player.m_Hunger = hunger
	player.m_Thirst = thirst
	
	-- Update HUD cache
	HUDArea:getSingleton():updateArea()
end

function PlayerRPC.inventorySync(player, id, syncinfo)
	Inventory.fromId(id):syncReceive(syncinfo)
end

function PlayerRPC.inventoryFullSync(player, id, syncinfo)
	Inventory.fromId(id):fullsyncReceive(syncinfo)
end

function PlayerRPC.inventoryClose(player, id)
	Inventory.fromId(id):remoteClose()
end
