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
				
				Talked_Pre_Quest = false,
				Quest_Given = false,
				Boss_Encountered = false,
				Boss_Defeated = false,
				Shopkeeper_Rescued = false
			}
		else
			SV.ModData_EvolutionItemTrader = {
				Initialized = true,
				
				Talked_Pre_Quest = true,
				Quest_Given = true,
				Boss_Encountered = true,
				Boss_Defeated = true,
				Shopkeeper_Rescued = true
			}
		end
	else
		print("Savevars already initialized")
	end
	
	-- Spawn NPCs
	base_camp_2_evoshop.Spawn_Shopkeepers(map)
end

function base_camp_2.EvolutionShopPreQuestExpoBrother_Action(obj, activator)
	base_camp_2_evoshop.Interact_EvolutionShopPreQuestExpo(obj, activator)
end
function base_camp_2.EvolutionShopPreQuestExpoSister_Action(obj, activator)
	base_camp_2_evoshop.Interact_EvolutionShopPreQuestExpo(obj, activator)
end

function base_camp_2.EvolutionShopQuestStartBrother_Action(obj, activator)
	base_camp_2_evoshop.Interact_QuestGiver(obj, activator)
end
function base_camp_2.EvolutionShopQuestStartSister_Action(obj, activator)
	base_camp_2_evoshop.Interact_QuestGiver(obj, activator)
end
function base_camp_2.EvolutionShopQuestStartCriminal_Action(obj, activator)
	base_camp_2_evoshop.Interact_QuestGiver(obj, activator)
end

function base_camp_2.EvolutionShopQuestWaitingBrother_Action(obj, activator)
	base_camp_2_evoshop.Interact_QuestWaiting(obj, activator)
end

function base_camp_2.EvolutionShopQuestCompleteBrother_Action(obj, activator)
	base_camp_2_evoshop.Interact_QuestComplete(obj, activator)
end
function base_camp_2.EvolutionShopQuestCompleteSister_Action(obj, activator)
	base_camp_2_evoshop.Interact_QuestComplete(obj, activator)
end

function base_camp_2.EvolutionShopItemBuyer_Action(obj, activator)
	base_camp_2_evoshop.Interact_ItemBuyer(obj, activator)
end
function base_camp_2.EvolutionShopItemSeller_Action(obj, activator)
	base_camp_2_evoshop.Interact_ItemSeller(obj, activator)
end

return base_camp_2