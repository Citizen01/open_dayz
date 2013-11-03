-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/classes/Vehicle.lua
-- *  PURPOSE:     Vehicle element class
-- *
-- ****************************************************************************
Vehicle = inherit(MTAElement)
registerElementClass("vehicle", Vehicle)

function Vehicle:constructor()
	self.m_Fuel = 100
	self.m_MissingComponents = {}
	
	
end

function Vehicle:destructor()
	
end

function Vehicle:sendInitialSync(player)
	-- Send missing vehicle component list
	if #self.m_MissingComponents > 0 then
		self:rpc(RPC_VEHICLE_REMOVE_COMPONENTS, self.m_MissingComponents)
	end
end

function Vehicle:onStartEnter(player, seat, jacked, door)
	-- Todo: Use a bind instead
	if not self:startEngine() then
		player:sendMessage(_("The engine could not be started due to broken or missing components. Please find and collect them first!", player), 255, 0, 0)
	end
	
end

function Vehicle:getFuel()
	return self.m_Fuel
end

function Vehicle:setFuel(fuel)
	checkArgs("Vehicle:setFuel", "number")
	self.m_Fuel = fuel
	
	if getVehicleOccupant(self) then
		self:rpc(getVehicleOccupant(self), RPC_VEHICLE_SET_FUEL, self.m_Fuel)
	end
end

function Vehicle:startEngine()
	-- In case of any broken or missing component, don't start
	if #self.m_MissingComponents > 0 then
		return false
	end
	
	self:rpc(RPC_VEHICLE_STARTENGINE, true) -- HOW-TO?
	--setVehicleEngineState(self, true)
	return true
end

function Vehicle:removeComponent(component)
	table.insert(self.m_MissingComponents, component)
	
	self:rpc(RPC_VEHICLE_REMOVE_COMPONENTS, {component})
end

function Vehicle:addComponent(component)
	local index = table.find(self.m_MissingComponents, component)
	if index then
		table.remove(self.m_MissingComponents, index)
	else
		return false
	end
	
	self:rpc(RPC_VEHICLE_ADD_COMPONENT, component)
	return true
end

function Vehicle:generateMissingComponents()
	for component, componentName in enumFields("vehiclecomponent") do
		if math.random(1, 3) == 1 then
			self:removeComponent(component)
		end
	end
end
