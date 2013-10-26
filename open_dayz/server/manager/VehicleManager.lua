-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        server/manager/VehicleManager.lua
-- *  PURPOSE:     Vehicle manager
-- *
-- ****************************************************************************
VehicleManager = inherit(Singleton)

function VehicleManager:constructor()
	-- Add events
	addEventHandler("onVehicleStartEnter", root, function(...) source:onStartEnter(...) end)
	
	-- Generate random missing components
	--setTimer(function()
	for k, vehicle in ipairs(getElementsByType("vehicle")) do
		vehicle:generateMissingComponents()
	end
	--end, 2000, 1)
end
