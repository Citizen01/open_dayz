-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/RPCHandler/PlayerRPC.lua
-- *  PURPOSE:     Player RPC class
-- *
-- ****************************************************************************
PlayerRPC = inherit(RPC)

function PlayerRPC:constructor()
	self:register(RPC_PLAYER_READY, PlayerRPC.playerReady)
	self:register(RPC_PLAYER_LOGIN, PlayerRPC.playerLogin)
	self:register(RPC_PLAYER_REGISTER, PlayerRPC.playerRegister)
	self:register(RPC_SERVER_GET_FULL_CONFIG, PlayerRPC.playerGetFullConfig)
	self:register(RPC_TRANSFER_REQUEST_FILELIST, PlayerRPC.playerRequestFilelist)
	self:register(RPC_TRANSFER_REQUEST_FILES, PlayerRPC.playerRequestFiles)
	self:register(RPC_INVENTORY_SYNC, PlayerRPC.inventorySync)
	self:register(RPC_INVENTORY_OPEN, PlayerRPC.inventoryOpen)
	self:register(RPC_INVENTORY_CLOSE, PlayerRPC.inventoryClose)
end

function PlayerRPC.playerReady(player, client)
	-- Send initial syncs to this player
	client:sendInitialSyncs()
end

function PlayerRPC.playerLogin(player, client, username, password)
	client:login(username, password)
end

function PlayerRPC.playerRegister(player, client, username, password, salt)
	client:register(username, password, salt)
end

function PlayerRPC.playerGetFullConfig(player, client)
	client:rpc(RPC_SERVER_GET_FULL_CONFIG, core:getClientConfig())
end

function PlayerRPC.playerRequestFilelist(player, client)
	client:rpc(RPC_TRANSFER_REQUEST_FILELIST, TransferManager:getSingleton():getOnConnectList())
end

function PlayerRPC.playerRequestFiles(player, client, files)
	TransferManager:getSingleton():getFile(client, files)
end

function PlayerRPC.inventorySync(player, client, id, slot, index, data)
	Inventory.fromId(id):receiveSync(slot, index, data)
end

function PlayerRPC.inventoryOpen(player, client, id)
	Inventory.fromId(id):open(client)
end

function PlayerRPC.inventoryClose(player, client, id)
	Inventory.fromId(id):close(client)
	
	-- Respond to the client that the inventory may be closed
	client:rpc(RPC_INVENTORY_CLOSE, id)
end

function PlayerRPC.toElement(element)
	-- Our first parameter is an element, so we are able to return it directly
	return element
end
