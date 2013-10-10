-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Inventory.lua
-- *  PURPOSE:     Inventory class
-- *
-- ****************************************************************************
Inventory = inherit(Object)
Inventory.Mapping = {}

function Inventory:constructor(id)
	self.m_Open = false
	self.m_Id = id
	self.m_Content = {}
	Inventory.Mapping[id] = self
end

function Inventory.fromId(id)
	-- Return if we know about that Inventory
	if Inventory.Mapping[id] then
		return Inventory.Mapping[id]
	else
		-- Else: Create it transparently for the caller
		return Inventory:new(id)
	end
end

function Inventory:open()
	if self.m_Open then return end
	
	server:rpc(RPC_INVENTORY_OPEN, self.m_Id)
end

function Inventory:close()
	if not self.m_Open then return end
	
	server:rpc(RPC_INVENTORY_CLOSE, self.m_Id)
end

function Inventory:getItem(slot, index)
	assert(self.m_Open)
	if not self.m_Content[slot] then return end
	
	return self.m_Content[slot][index]
end

function Inventory:findItem(itemid, slot, num)
	assert(self.m_Open)
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
					return ITEM_SLOT_GENERIC, index
				end
			end
		end
		for index, item in pairs(self.m_Content[Items[itemid].slot]) do
			if item.id == itemid then
				if num > 0 then
					num = num -1
				else
					return Items[itemid].slot, index
				end
			end
		end		
	end
	
	return false
end

function Inventory:hasItem(item, slot)
	assert(self.m_Open)
	return self:findItem(item, slot) ~= false
end

function Inventory:fullsyncReceive(syncinfo)
	-- Assume the server is right to sync this
	self.m_Open = true
	
	-- Delete old content
	for k, v in pairs(self.m_Content) do
		for k2, item in pairs(v) do
			delete(item)
		end
	end
	
	for slot, v in pairs(syncinfo) do
		self.m_Content[slot] = {}
		for index, item in pairs(v) do
			self.m_Content[slot][index] = Item.applySync(item)
			self.m_Content[slot][index]:setInventory(self, slot, index) 
		end
	end
end

function Inventory:syncReceive(syncinfo)
	-- syncinfo = { slot, index, info }
	self.m_Content[syncinfo[1]][syncinfo[2]] = Item.applySync(syncinfo[3])
	self.m_Content[syncinfo[1]][syncinfo[2]]:setInventory(self, syncinfo[1], syncinfo[2]) 
end

function Inventory:change(slot, index)
	server:rpc(RPC_INVENTORY_SYNC, self.m_Id, slot, index, self.m_Content[slot][index])
end
