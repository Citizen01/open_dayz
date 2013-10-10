-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Inventory.lua
-- *  PURPOSE:     Inventory class
-- *
-- ****************************************************************************
Inventory = inherit(Exported)
Inventory.Mapping = {}

function Inventory:constructor(id)
	self.m_Content = {} 
	self.m_Content[ITEM_SLOT_GENERIC] = {} 
	self.m_Players = {}
	
	if not id then
		sql:queryExec("INSERT INTO ??_inventory(Data) VALUES(?);", sql:getPrefix(), "")
		id = sql:lastInsertId()
	end
	self.m_Id = id
	Inventory.Mapping[id] = self
end

function Inventory.fromId(id)
	return Inventory.Mapping[id]
end

function Inventory:destructor()
	
end

function Inventory:load(id)
	self.m_Id = self.m_Id or id
	assert(self.m_Id)
	
	local data = sql:queryFetchSingle("SELECT Data FROM ??_inventory WHERE Id = ?;", sql:getPrefix(), self.m_Id)
	local json = fromJSON(data.Data)
	for _slot, v in pairs(json) do
		local slot = tonumber(_slot)
		self.m_Content[slot] = {}
		for _index, v2 in pairs(v) do
			local index = tonumber(_index)
			local id = v2.id
			self.m_Content[slot][index] = (Items[id].Class or Item):new(id)
			self.m_Content[slot][index]:setInventory(self, slot, index)
			for key, value in pairs(v2) do 
				if key ~= "id" then
					if self.m_Content[slot][index].m_Data[key] then
						self.m_Content[slot][index].m_Data[key].value = value
					else
						outputDebug("SQL contains additional item variable "..key.." which is not specified in the Item class")
					end
				end
			end
		end
	end
end

function Inventory:save()
	local data = {}
	for slot, sdata in pairs(self.m_Content) do
		for index, item in pairs(sdata) do
			local dbi = item:dbdata()
			data[slot] = {}
			data[slot][index] = dbi
		end
	end
	local datastr = toJSON(data)
	
	sql:queryExec("UPDATE ??_inventory SET Data = ? WHERE Id = ?;", sql:getPrefix(), datastr, self.m_Id)
end

function Inventory:purge()
	sql:queryExec("DELETE FROM ??_inventory WHERE Id = ?;", self.m_Id)
end

function Inventory:setItem(item, slot, index)
	-- slot is either ITEM_SLOT_GENERIC or the item slot for the item
	assert(slot == ITEM_SLOT_GENERIC or slot == Items[item].slot)
	assert(self.m_Content[slot])
	
	self.m_Content[slot][index] = (Items[item].Class or Item):new(item)
	
	self.m_Content[slot][index]:setInventory(self, slot, index)
	return true
end

function Inventory:getItem(slot, index)
	if not self.m_Content[slot] then return end
	
	return self.m_Content[slot][index]
end

function Inventory:findItem(itemid, slot, num)
	if not num then num = 0 end
	
	if slot then
		for index, item in pairs(self.m_Content[slot]) do
			if item.id == itemid then
				if num > 0 then
					num = num -1
				else
					return slot, index
				end
			end
		end
	else
		for index, item in pairs(self.m_Content[ITEM_SLOT_GENERIC]) do
			if item.id == itemid then
				if num > 0 then
					num = num -1
				else
					return slot, index
				end
			end
		end
		for index, item in pairs(self.m_Content[Items[itemid].slot]) do
			if item.id == itemid then
				if num > 0 then
					num = num -1
				else
					return slot, index
				end
			end
		end		
	end
	
	return false
end

function Inventory:hasItem(item, slot)
	return self:findItem(item, slot) ~= false
end

-- Sync Code --
function Inventory:change(slot, index)
	-- Ignore changes if we have noone to sync them to
	if #self.m_Players == 0 then return end
	
	-- Increase Revision
	local info = self.m_Content[slot][index]:syncinfo()
	local update = { slot, index, info }
	
	-- sbx320: ToDo - maybe limit syncs per second to avoid spamming sync info
	self:sync(nil, update)
end

function Inventory:sync(player, update)
	if not player then
		for k, v in pairs(self.m_Players) do
			self:sync(v, update)
		end
		return
	end
	
	player:rpc(RPC_INVENTORY_SYNC, self.m_Id, update)
end

function Inventory:fullsync(player, syncinfo)
	if not syncinfo then
		syncinfo = {}
		for k, v in pairs(self.m_Content) do
			syncinfo[k] = {}
			for k2, v2 in pairs(v) do
				syncinfo[k][k2] = v2:syncdata()
			end
		end
	end
	
	if not player then
		for k, v in pairs(self.m_Players) do
			self:sync(v)
		end
		return
	end
	
	player:rpc(RPC_INVENTORY_FULLSYNC, self.m_Id, syncinfo)
end

function Inventory:receiveSync(slot, index, value)
	for k, v in pairs(value) do
		if self.m_Content[slot][index].m_Data[k].cc then
			self.m_Content[slot][index].m_Data[k].value = v
		else
			-- ToDo: Report Anticheat violation 
			--  (Client attempted to change value which is not marked as changeable)
			return
		end
	end
	
	-- If we have more than one remote client, sync the data to everyone
	if #self.m_Players > 1 then
		self:change(slot, index)
	end
end

function Inventory:open(player)
	-- Verify that the player is not already in our list
	for k, v in pairs(self.m_Players) do
		if v == player then return false end
	end
	self.m_Players[#self.m_Players+1] = player
	self:fullsync(player)
	return true
end

function Inventory:close(player)
	-- Verify that the player is in our list
	for k, v in pairs(self.m_Players) do
		if v == player then
			self.m_Players[k] = nil
			return true
		end
	end
	return false
end

