require 'origin.common'
local base_camp_2_evoshop = require 'evolution_item_trader.ground.base_camp_2.base_camp_2_evoshop'

local base_camp_2 = {} -- you can name this whatever you want I believe, but doing map_namespace is usually what I do

local base_Init = CURMAPSCR.Init
function base_camp_2.Init(map)
	base_Init(map) -- call the base function
	--print("Evolution shop code")
	
	-- Initialize save data
	if SV.ModData_EvolutionItemTrader == nil then
		print("Initializing savevars")
		if SV.Experimental then
			SV.ModData_EvolutionItemTrader = {
				Initialized = true,
				
				Quest_Given = false,
				Shopkeeper_Rescued = false
			}
		else
			SV.ModData_EvolutionItemTrader = {
				Initialized = true,
				
				Quest_Given = true,
				Shopkeeper_Rescued = true
			}
		end
	else
		print("Savevars already initialized")
	end
	
	-- Spawn NPCs
	base_camp_2_evoshop.Spawn_Shopkeepers(map)
end

function base_camp_2.EvolutionShopQuestGiver_Action(obj, activator)
	base_camp_2_evoshop.Interact_QuestGiver(obj, activator)
end
function base_camp_2.EvolutionShopQuestTarget_Action(obj, activator)
	base_camp_2_evoshop.Interact_QuestComplete(obj, activator)
end

function base_camp_2.EvolutionShopItemBuyer_Action(obj, activator)
	base_camp_2_evoshop.Interact_ItemBuyer(obj, activator)
end
function base_camp_2.EvolutionShopItemSeller_Action(obj, activator)
	base_camp_2_evoshop.Interact_ItemSeller(obj, activator)
end

return base_camp_2