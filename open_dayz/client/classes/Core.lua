-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/Core.lua
-- *  PURPOSE:     Core class
-- *
-- ****************************************************************************
Core = inherit(Object)

function Core:constructor()
	-- Small hack to get the global core immediately
	core = self

	-- Initialize debug system
	Debugging:new()
	Version:new()
	
	-- Initialize Server
	server = Server:new()
	
	-- Initialize config system
	self.m_MainConfig = ConfigXML:new("clientconfig.xml")
	
	-- Initialize GUI system
	GUIRenderer.constructor()
	GUICursor:new()
	ClickHandler:new()
	
	-- Initialize GUI forms
	if DEBUG then
		GUITool:new()
	end
	self.m_Forms = {}
	self.m_Forms.Login = FormLogin:new()
	
	-- Initialize HUD system
	HUDArea:new()
	Speedometer:new()
	
	FirstPersonMode:new()

	-- Initialize RPC system
	RPCHandler:new()
	PlayerRPC:new()
	ServerRPC:new()
	NpcRPC:new()
	VehicleRPC:new()
	
	-- Initialize managers
	PlayerManager:new()
	TranslationManager:new()
	TransferManager:new()
	NPCManager:new()
	ShaderManager:new()
	ModManager:new()
	Weather:new()
end

function Core:destructor()
	delete(GUICursor:getSingleton())
	delete(Speedometer:getSingleton())
	
	-- Delete managers
	delete(PlayerManager)
	delete(TranslationManager)
	delete(TransferManager)
	delete(NPCManager)
	delete(ShaderManager)
	delete(ModManager)
end

function Core:onConfigRetrieve()
	Weather:getSingleton():rebuild()
end

function Core:set(group, key, value)
	return self.m_MainConfig:set(group, key, value)
end

function Core:get(group, key)
	return self.m_MainConfig:get(group, key)
end

function Core:getForm(formName)
	return self.m_Forms[formName]
end
