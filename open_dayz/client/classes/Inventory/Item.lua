-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Item.lua
-- *  PURPOSE:     Item class
-- *
-- ****************************************************************************
Item = inherit(Object)
Item.m_ItemId = ITEM_NONE

function Item:derived_constructor()
	self.m_Data = {}
	self.m_InventoryInfo = {}
end

function Item.applySync(syncinfo)
	local id = syncinfo.id
	local i = Items[id].Class:new(id)
	
	i.m_Data = syncinfo
	i.m_Data.id = nil
	
	return i
end

function Item:setInventory(inv, slot, index)
	self.m_InventoryInfo = { inv, slot, index }
end

function Item:dataField(name, sync, clientchange, default)
	self.m_Data[name] = { sync = sync, cc = clientchange, value = default }
end

function Item:get(name)
	return self.m_Data[name]
end

function Item:set(name, value)
	assert(self.m_Data[name].cc)
	self.m_Data[name] = value
	self:change()
end

function Item:change()
	self.m_InventoryInfo[1]:change(self.m_InventoryInfo[2], self.m_InventoryInfo[3])
end

function Item:syncdata()
	local sdata = {}
	for k, v in pairs(self.m_Data) do
		if v.cc then
			sdata[k] = v.value
		end
	end
	return sdata
end

function Item:use()
	-- Implement this function in derived classes
	-- By default this resolves to "no action"
end