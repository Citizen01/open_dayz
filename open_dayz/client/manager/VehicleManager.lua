-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/manager/VehicleManager.lua
-- *  PURPOSE:     Vehicle manager
-- *
-- ****************************************************************************
VehicleManager = inherit(Singleton)

function VehicleManager:constructor()
	
end

function VehicleManager.enumToComponent(ev)
	return VehicleManager.VehicleComponents[ev]
end

function VehicleManager.componentToEnum(c)
	return table.find(VehicleManager.VehicleComponents, c)
end

VehicleManager.VehicleComponents = {
	[VEHICLE_COMPONENT_DOOR_LF] = "door_lf_dummy";
	[VEHICLE_COMPONENT_DOOR_RF] = "door_rf_dummy";
	[VEHICLE_COMPONENT_DOOR_LR] = "door_lr_dummy";
	[VEHICLE_COMPONENT_DOOR_RR] = "door_rr_dummy";
	[VEHICLE_COMPONENT_EXHAUST] = "exhaust_ok";
	[VEHICLE_COMPONENT_BUMP_FRONT] = "bump_front_dummy";
	[VEHICLE_COMPONENT_BUMP_REAR] = "bump_rear_dummy";
	[VEHICLE_COMPONENT_BONNET] = "bonnet_dummy";
	[VEHICLE_COMPONENT_BOOT] = "boot_dummy";
	[VEHICLE_COMPONENT_CHASSIS] = "chassis_dummy";
	[VEHICLE_COMPONENT_WINDSCREEN] = "windscreen_dummy";
	[VEHICLE_COMPONENT_WHEEL_LF] = "wheel_lf_dummy";
	[VEHICLE_COMPONENT_WHEEL_RF] = "wheel_rf_dummy";
	[VEHICLE_COMPONENT_WHEEL_LB] = "wheel_lb_dummy";
	[VEHICLE_COMPONENT_WHEEL_RB] = "wheel_rb_dummy";
}