-- ****************************************************************************
-- *
-- *  PROJECT:     Open MTA:DayZ
-- *  FILE:        client/classes/LocalPlayer.lua
-- *  PURPOSE:     Local player class
-- *
-- ****************************************************************************
LocalPlayer = inherit(Player)

function LocalPlayer:constructor()
	self.m_Hunger = 100
	self.m_Thirst = 100
	self.m_Locale = "en"
end

function LocalPlayer:destructor()
	
end

function LocalPlayer:login(username, password, remember, passwordAlreadyHashed)
	if not passwordAlreadyHashed then
		password = sha256("dayz.."..password)
	end
	
	core:set("login", "remember", remember == true)
	core:set("login", "password", remember and password)
	core:set("login", "username", remember and username)
	
	-- Trigger Server RPC
	self:rpc(RPC_PLAYER_LOGIN, username, password)
end

function LocalPlayer:register(username, password)
	password = sha256("dayz.."..password)
	
	-- generate a salt
	local salt = md5(math.random())
	
	-- Trigger Server RPC
	self:rpc(RPC_PLAYER_REGISTER, username, password, salt)
end

function LocalPlayer:onLogin()
	HUDArea:getSingleton():show()
	core:getForm("Login"):close()
	MessageBox:new("Successfully logged in")
end

function LocalPlayer:rpc(rpc, ...)
	assert(rpc, "Missing RPC called")
	triggerServerEvent("onRPC", resourceRoot, rpc, self, ...)
end

function LocalPlayer:sendMessage(text, r, g, b, ...)
	outputChatBox(text:format(...), r, g, b, true)
end

function LocalPlayer:getLocale()
	return self.m_Locale
end

function LocalPlayer:getHunger()
	return self.m_Hunger
end

function LocalPlayer:getThirst()
	return self.m_Thirst
end
