-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/RPCHandler/VehicleRPC.lua
-- *  PURPOSE:     Vehicle RPC class
-- *
-- ****************************************************************************
VehicleRPC = inherit(RPC)

function VehicleRPC:constructor()
	self:register(RPC_VEHICLE_STARTENGINE, VehicleRPC.startEngine)
	self:register(RPC_VEHICLE_ENTER_SYNC, VehicleRPC.vehicleEnterSync)
	self:register(RPC_VEHICLE_SET_FUEL, VehicleRPC.vehicleSetFuel)
	self:register(RPC_VEHICLE_REMOVE_COMPONENTS, VehicleRPC.vehicleRemoveComponents)
	self:register(RPC_VEHICLE_ADD_COMPONENT, VehicleRPC.vehicleAddComponent)
end

function VehicleRPC.toElement(element)
	return element
end

function VehicleRPC.startEngine(vehicle, fuel)
	vehicle:startEngine()
end

function VehicleRPC.vehicleEnterSync(vehicle, fuel)
	vehicle.m_Fuel = fuel -- Since we do not want to allow access via addon we have to modify it directly here
end

function VehicleRPC.vehicleSetFuel(vehicle, fuel)
	vehicle.m_Fuel = fuel
	
end

function VehicleRPC.vehicleRemoveComponents(vehicle, components)
	for k, v in ipairs(components) do
		vehicle:removeComponent(v)
	end
end

function VehicleRPC.vehicleAddComponent(vehicle, component)
	vehicle:addComponent(component)
end
