-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Vehicle.lua
-- *  PURPOSE:     Vehicle element class
-- *
-- ****************************************************************************
Vehicle = inherit(MTAElement)
registerElementClass("vehicle", Vehicle)

function Vehicle:constructor()
	self.m_Fuel = 100
	self.m_EngineState = false;

	-- Add event handlers
	addEventHandler("onClientVehicleEnter", self, bind(self.Event_vehicleEnter, self))
	addEventHandler("onClientVehicleExit", self, bind(self.Event_vehicleExit, self))
end

function Vehicle:destructor()
	
end

function Vehicle:getFuel()
	return self.m_Fuel
end

function Vehicle:startEngine()
	-- In case of any component is broken or missing, don't start
	self.m_EngineState = true
	setVehicleEngineState(self, true)
	return true
end

function Vehicle:stopEngine()
	-- In case of any component is broken or missing, don't start
	self.m_EngineState = false
	setVehicleEngineState(self, false)
	return true
end

function Vehicle:Event_vehicleEnter(player, seat)
	if player == localPlayer then
		self.m_FuelTimer = setTimer(function() self.m_Fuel = self.m_Fuel - 0.05 end, 2000, 0)
		self.m_EngineTimer = setTimer(setVehicleEngineState, 100, 1, self, self.m_EngineState)
	end
end

function Vehicle:Event_vehicleExit(player, seat)
	if player == localPlayer then
		-- First some clean-ups
		if self.m_FuelTimer and isTimer(self.m_FuelTimer) then
			killTimer(self.m_FuelTimer)
		end
		if self.m_EngineTimer and isTimer(self.m_EngineTimer) then
			killTimer(self.m_EngineTimer)
		end
		
		-- Do the exit sync
		self:rpc(RPC_VEHICLE_EXIT_SYNC, self:getFuel())
	
	end
end

function Vehicle:openComponentsGUI()
	FormVehicleComponents:new(self)
end

function Vehicle:removeComponent(ecomponent)
	setVehicleComponentVisible(self, VehicleManager.enumToComponent(ecomponent), false)
end

function Vehicle:addComponent(ecomponent)
	setVehicleComponentVisible(self, VehicleManager.enumToComponent(ecomponent), true)
end
