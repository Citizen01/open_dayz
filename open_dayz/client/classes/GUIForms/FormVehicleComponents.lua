-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/GUIForms/FormVehicleComponents.lua
-- *  PURPOSE:     Vehicle components form
-- *
-- ****************************************************************************
FormVehicleComponents = inherit(GUIForm)

function FormVehicleComponents:constructor(vehicle)
	-- Call base class constructor
	GUIForm.constructor(self, screenWidth/2 - 370/2, screenHeight/2 - 450/2, 370, 450)
	self.m_Vehicle = vehicle

	-- Create GUI elements
	self.m_Window         = GUIWindow:new(0, 0, self.m_Width, self.m_Height, _"Vehicle components", true, true, self)
	self.m_LabelTitle	  = GUILabel:new(10, 40, 300, 30, _"Vehicle components:", 1.5, self.m_Window)
	self.m_GridComponents = GUIGridList:new(10, 70, 350, 320, self.m_Window)
	self.m_ButtonAdd      = GUIButton:new(10, 400, 170, 40, _"Add", self.m_Window)
	self.m_ButtonCancel   = GUIButton:new(190, 400, 170, 40, _"Cancel", self.m_Window)
	
	-- Add gridlist columns
	self.m_GridComponents:addColumn(_"Name", 0.6)
	self.m_GridComponents:addColumn(_"Available?", 0.3)
	
	-- Add gridlist items
	for component, visible in pairs(getVehicleComponents(vehicle)) do
		self.m_GridComponents:addItem(component, visible and "Yes" or "No") -- todo: Use friendly names
	end

	-- Add events
	self.m_ButtonAdd.onLeftClick = bind(FormVehicleComponents.ButtonAdd_Click, self)
	self.m_ButtonCancel.onLeftClick = bind(FormVehicleComponents.ButtonCancel_Click, self)
	
	showCursor(true)
end

function FormVehicleComponents:ButtonAdd_Click()
	local item = self.m_GridComponents:getSelectedItem()
	if item then
		local e = VehicleManager.componentToEnum(item:getColumnText(1))
		if e and self.m_Vehicle then
			localPlayer:rpc(RPC_PLAYER_VEHICLE_COMPONENT_REQUEST, self.m_Vehicle, e)
		end
	else
		ErrorBox:new(_"Please select an item")
	end
end

function FormVehicleComponents:ButtonCancel_Click()
	self:close(true)
end
