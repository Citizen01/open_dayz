-- Tempoary Login while we have no GUI
addCommandHandler("inventory_list", 
	function(_, user, pw)
		outputChatBox("There's "..tostring(_.m_Inventory:getItem(ITEM_SLOT_GENERIC, 1) or "nothing").." in your inventory")
		outputChatBox("That item is a "..tostring(_.m_Inventory:getItem(ITEM_SLOT_GENERIC, 1):getName()))
	end
)

addCommandHandler("inventory_pizza", 
	function(_, user, pw)
		_.m_Inventory:setItem(Items.PIZZA.UID, ITEM_SLOT_GENERIC, 1)
		outputChatBox("Pizza for you!")
	end
)

