require 'origin.common'
require 'origin.menu.InventorySelectMenu'
require 'evolution_item_trader.menu.EvolutionItemSaleMenu'

local base_camp_2_evoshop = {}

local items_to_buy = {
	{ Index = "evo_chipped_pot", Amount = 1, Price = 18},
	{ Index = "evo_cracked_pot", Amount = 1, Price = 18},
	{ Index = "evo_dawn_stone", Amount = 1, Price = 15},
	{ Index = "evo_deep_sea_scale", Amount = 1, Price = 18},
	{ Index = "evo_deep_sea_tooth", Amount = 1, Price = 18},
	{ Index = "evo_dubious_disc", Amount = 1, Price = 21},
	{ Index = "evo_dusk_stone", Amount = 1, Price = 15},
	{ Index = "evo_electirizer", Amount = 1, Price = 21},
	{ Index = "evo_fire_stone", Amount = 1, Price = 15},
	{ Index = "held_hard_stone", Amount = 1, Price = 18},
	{ Index = "evo_ice_stone", Amount = 1, Price = 15},
	{ Index = "evo_kings_rock", Amount = 1, Price = 18},
	{ Index = "evo_leaf_stone", Amount = 1, Price = 15},
	{ Index = "evo_link_cable", Amount = 1, Price = 15},
	{ Index = "evo_lunar_ribbon", Amount = 1, Price = 15},
	{ Index = "evo_magmarizer", Amount = 1, Price = 21},
	{ Index = "held_metal_coat", Amount = 1, Price = 18},
	{ Index = "evo_moon_stone", Amount = 1, Price = 15},
	{ Index = "evo_prism_scale", Amount = 1, Price = 18},
	{ Index = "evo_protector", Amount = 1, Price = 21},
	{ Index = "evo_razor_claw", Amount = 1, Price = 18},
	{ Index = "evo_razor_fang", Amount = 1, Price = 18},
	{ Index = "evo_reaper_cloth", Amount = 1, Price = 21},
	{ Index = "evo_shiny_stone", Amount = 1, Price = 15},
	{ Index = "evo_sun_ribbon", Amount = 1, Price = 15},
	{ Index = "evo_sun_stone", Amount = 1, Price = 15},
	{ Index = "evo_thunder_stone", Amount = 1, Price = 15},
	{ Index = "evo_up_grade", Amount = 1, Price = 18},
	{ Index = "evo_water_stone", Amount = 1, Price = 15}
}
local accepted_items = {
	"evo_chipped_pot",
	"evo_cracked_pot",
	"evo_dawn_stone",
	"evo_deep_sea_scale",
	"evo_deep_sea_tooth",
	"evo_dubious_disc",
	"evo_dusk_stone",
	"evo_electirizer",
	"evo_fire_stone",
	"held_hard_stone",
	"evo_ice_stone",
	"evo_kings_rock",
	"evo_leaf_stone",
	"evo_link_cable",
	"evo_lunar_ribbon",
	"evo_magmarizer",
	"held_metal_coat",
	"evo_moon_stone",
	"evo_prism_scale",
	"evo_protector",
	"evo_razor_claw",
	"evo_razor_fang",
	"evo_reaper_cloth",
	"evo_shiny_stone",
	"evo_sun_ribbon",
	"evo_sun_stone",
	"evo_thunder_stone",
	"evo_up_grade",
	"evo_water_stone"
}

function base_camp_2_evoshop.SpawnPokemon(species, form, skin, gender, x, y, direction, instanceID, nameColor, name)
	local entityName = name
	if name == nil then
		entityName = _DATA:GetMonster(species).Name:ToLocal()
	end
	
	if instanceID == nil then
		instanceID = _DATA:GetMonster(species).Name:ToString()
	end
	if nameColor == nil then
		nameColor = "#00FFFF"
	end
	
	local monster = RogueEssence.Dungeon.MonsterID(species, form, skin, gender)
	chara = RogueEssence.Ground.GroundChar(monster, RogueElements.Loc(x, y), direction, "[color=" .. nameColor .. "]" .. entityName .. "[color]", instanceID)
	chara:ReloadEvents()
	GAME:GetCurrentGround():AddTempChar(chara)
	chara:OnMapInit()
	local result = RogueEssence.Script.TriggerResult()
	TASK:WaitTask(chara:RunEvent(RogueEssence.Script.LuaEngine.EEntLuaEventTypes.EntSpawned, result, chara))
	return chara
	
end

function base_camp_2_evoshop.Spawn_Shopkeepers(map)
	
	-- Create shopkeepers
	local flareon = base_camp_2_evoshop.SpawnPokemon("flareon", 0, "normal", Gender.Male, 712, 592, Direction.Down, "EvolutionShopItemBuyer")
	local glaceon = base_camp_2_evoshop.SpawnPokemon("glaceon", 0, "normal", Gender.Female, 736, 592, Direction.Down, "EvolutionShopItemSeller")
	
	if not SV.ModData_EvolutionItemTrader.Shopkeeper_Rescued then
		
		GROUND:Hide("EvolutionShopItemBuyer")
		GROUND:Hide("EvolutionShopItemSeller")
		
		local eevee = base_camp_2_evoshop.SpawnPokemon("eevee", 0, "normal", Gender.Male, 712, 592, Direction.Down, "EvolutionShopQuestGiver")
		
		-- Only spawn Glaceon if the quest is complete
		local questname = "Evolution_Item_Trader_Quest"
		local quest = SV.missions.Missions[questname]
		
		if quest ~= nil then
			if quest.Complete == COMMON.MISSION_COMPLETE then
				GROUND:TeleportTo(eevee, 712, 592, Direction.Right)
				local glaceon = base_camp_2_evoshop.SpawnPokemon("glaceon", 0, "normal", Gender.Female, 736, 592, Direction.Left, "EvolutionShopQuestTarget")
			end
		end
		
	end
	
	-- Create shop stall
	animation_data = RogueEssence.Content.ObjAnimData("FRLG_Market_Stall", 60)
	shop_stall_obj = RogueEssence.Ground.GroundObject(animation_data, Dir8.None, Rect(0, 32, 96, 32), RogueElements.Loc(0, 48), true, "EvolutionShopStall")
	shop_stall_obj.MapLoc = RogueElements.Loc(684, 560)
	GAME:GetCurrentGround():AddTempObject(shop_stall_obj)
	
end


function base_camp_2_evoshop.Interact_QuestGiver(obj, activator)
	UI:SetSpeaker(obj)
		
	local questname = "Evolution_Item_Trader_Quest"
	local quest = SV.missions.Missions[questname]
	
	if not SV.ModData_EvolutionItemTrader.QuestGiven then
		
		GROUND:CharTurnToChar(obj, activator)
		UI:WaitShowDialogue(STRINGS.MapStrings['Evoshop_Quest_Intro'])
		
		-- Create mission and add it to active missions
		COMMON.CreateMission(questname,
			{ Complete = COMMON.MISSION_INCOMPLETE, Type = COMMON.SIDEQUEST_TYPE_RESCUE,
			DestZone = "depleted_basin", DestSegment = 0, DestFloor = 6,
			FloorUnknown = false,
			TargetSpecies = RogueEssence.Dungeon.MonsterID("glaceon", 0, "normal", Gender.Female),
			ClientSpecies = RogueEssence.Dungeon.MonsterID("eevee", 0, "normal", Gender.Male) }
		)
		SV.ModData_EvolutionItemTrader.QuestGiven = true
		
	else
		
		if not SV.ModData_EvolutionItemTrader.Shopkeeper_Rescued then
			if quest.Complete == COMMON.MISSION_INCOMPLETE then
				GROUND:CharTurnToChar(obj, activator)
				UI:WaitShowDialogue(STRINGS.MapStrings['Evoshop_Quest_Given'])
			else
				base_camp_2_evoshop.Interact_QuestComplete(obj, activator)
			end
		end
		
	end
	UI:ResetSpeaker()
end

function base_camp_2_evoshop.Interact_QuestComplete(obj, activator)
	
	local player = CH("PLAYER")
	local brother = CH("EvolutionShopQuestGiver")
	local sister = CH("EvolutionShopQuestTarget")
	
	GAME:CutsceneMode(true)
	GAME:FadeOut(false, 20)
	
	-- Set NPC positions
	GROUND:TeleportTo(player, 724, 624, Direction.Up)
	GAME:WaitFrames(20)
	
	GAME:FadeIn(20)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Brother_1"])
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Sister_1"])
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Brother_2"])
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Sister_2"])
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Brother_3"])
	GAME:WaitFrames(10)
	
	GROUND:MoveToPosition(sister, sister.Position.X - 8, sister.Position.Y, false, 0.5)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_CH02_Box_Open")
	GAME:WaitFrames(30)
	GROUND:AnimateToPosition(sister, "Walk", Dir8.Left, sister.Position.X + 8, sister.Position.Y, 1.0, 0.5, 0)
	GAME:WaitFrames(5)
	
	GROUND:CharAnimateTurnTo(brother, Direction.Up, 4)
	GROUND:MoveToPosition(brother, brother.Position.X - 4, brother.Position.Y - 12, false, 1.5)
	GROUND:MoveToPosition(brother, brother.Position.X - 12, brother.Position.Y - 12, false, 1.5)
	GROUND:MoveToPosition(brother, brother.Position.X - 160, brother.Position.Y, false, 1.5)
	GAME:WaitFrames(60)
	
	SOUND:PlayBattleSE("EVT_Evolution_Start")
	brother.Data.BaseForm = MonsterID("flareon", 0, "normal", Gender.Male)
	brother.Data.Nickname = _DATA:GetMonster("flareon").Name:ToLocal()
	
	GAME:WaitFrames(90)
	
	GROUND:MoveToPosition(brother, brother.Position.X + 176, brother.Position.Y + 24, false, 1.5)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Brother_4"])
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurn(brother, Direction.Down, 4, false)
	GAME:WaitFrames(5)
	GROUND:CharAnimateTurn(sister, Direction.Down, 4, true)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Brother_5"])
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Sister_3"])
	GAME:WaitFrames(10)
	
	GROUND:CharTurnToCharAnimated(brother, sister, 4)
	GAME:WaitFrames(5)
	GROUND:CharTurnToCharAnimated(sister, brother, 4)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Brother_6"])
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Sister_4"])
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue(STRINGS.MapStrings["Evoshop_Quest_Complete_Brother_7"])
	GAME:WaitFrames(10)
	
	GAME:FadeOut(false, 20)
	
	-- Hide old quest NPCs
	GROUND:Hide("EvolutionShopQuestGiver")
	GROUND:Hide("EvolutionShopQuestTarget")
	
	-- Spawn shop NPCs
	GROUND:Unhide("EvolutionShopItemBuyer")
	GROUND:Unhide("EvolutionShopItemSeller")
	
	-- Set quest as complete and end cutscene
	COMMON.CompleteMission("Evolution_Item_Trader_Quest")
	SV.ModData_EvolutionItemTrader.Shopkeeper_Rescued = true
	GAME:CutsceneMode(false)
	
	GAME:FadeIn(20)
	
end

function base_camp_2_evoshop.Interact_ItemBuyer(obj, activator)
	
	local state = 0
	local repeated = false
	local cart = {}
	
	UI:SetSpeaker(obj)
	
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Intro'])
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Intro_Return'])
			end
			local shop_choices = {STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Option_Sell']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
				if bag_count > 0 then
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Sell'], STRINGS:LocalKeyString(26)))
					state = 1
				else
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Bag_Empty']))
				end
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Info']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			local result = InventorySelectMenu.run("Select Evolution Items",
				function(item_slot)
					if item_slot.IsEquipped then
						return false
					else
						local item = _DATA.Save.ActiveTeam:GetInv(item_slot.Slot)
						local item_id = item.ID
						-- Search for the item in accepted item list
						for i = 1, #accepted_items do
							if accepted_items[i] == item_id then
								return true
							end
						end
						return false
					end
				end
			)
			if #result > 0 then
				cart = result
				state = 2
			else
				state = 0
			end
		elseif state == 2 then
			local total = #cart * 3
			local msg
			if #cart == 1 then
				local item
				if cart[1].IsEquipped then
					item = GAME:GetPlayerEquippedItem(cart[1].Slot)
				else
					item = GAME:GetPlayerBagItem(cart[1].Slot)
				end
				msg = STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Sell_One'], total, item:GetDisplayName())
			else
				msg = STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Sell_Multi'], total)
			end
			UI:ChoiceMenuYesNo(msg, false)
			UI:WaitForChoice()
			result = UI:ChoiceResult()
			
			if result then
				for ii = #cart, 1, -1 do
					if cart[ii].IsEquipped then
						GAME:TakePlayerEquippedItem(cart[ii].Slot, true)
					else
						GAME:TakePlayerBagItem(cart[ii].Slot, true)
					end
					GAME:GivePlayerItem("loot_heart_scale", 3)
				end
				SOUND:PlayBattleSE("DUN_Money")
				cart = {}
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Buyer_Sell_Complete']))
				state = 0
			else
				state = 1
			end
		end
	end
	UI:ResetSpeaker()
	
end

function base_camp_2_evoshop.Interact_ItemSeller(obj, activator)
	
	local state = 0
	local repeated = false
	local cart = {}
	
	local chara = obj
	UI:SetSpeaker(chara)
	
	while state > -1 do
		if state == 0 then
			local msg = STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Intro'])
			if repeated == true then
				msg = STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Intro_Return'])
			end
			local shop_choices = {STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Option_Buy']),
			STRINGS:FormatKey("MENU_INFO"),
			STRINGS:FormatKey("MENU_EXIT")}
			UI:BeginChoiceMenu(msg, shop_choices, 1, 3)
			UI:WaitForChoice()
			local result = UI:ChoiceResult()
			repeated = true
			if result == 1 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Buy'], STRINGS:LocalKeyString(26)))
				state = 1
			elseif result == 2 then
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Info']))
			else
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Goodbye']))
				state = -1
			end
		elseif state == 1 then
			local result = EvolutionItemSaleMenu.run("Purchase Evolution Items", true, "Confirm", items_to_buy)
			if #result > 0 then
				local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
				local bag_cap = GAME:GetPlayerBagLimit()
				if bag_count == bag_cap then
					UI:SetSpeakerEmotion("Angry")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Bag_Full']))
					UI:SetSpeakerEmotion("Normal")
				else
					cart = result
					state = 2
				end
			else
				state = 0
			end
		elseif state == 2 then
			local total = 0
			for ii = 1, #cart, 1 do
				total = total + cart[ii].Price
			end
			
			local total_heart_scales = 0
			for ii = 0, GAME:GetPlayerBagCount() - 1 do
				print(GAME:GetPlayerBagItem(ii))
				if GAME:GetPlayerBagItem(ii).ID == "loot_heart_scale" then
					total_heart_scales = total_heart_scales + GAME:GetPlayerBagItem(ii).Amount
				end
			end
			print(total_heart_scales)
			
			local msg
			if total > total_heart_scales then
				UI:SetSpeakerEmotion("Angry")
				UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Buy_No_Money']))
				UI:SetSpeakerEmotion("Normal")
				state = 1
			else
				if #cart == 1 then
					local name = RogueEssence.Dungeon.InvItem(cart[1].Index):GetDisplayName()
					msg = STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Buy_One'], total, name)
				else
					msg = STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Buy_Multi'], total)
				end
				UI:ChoiceMenuYesNo(msg, false)
				UI:WaitForChoice()
				result = UI:ChoiceResult()
				
				if result then
					-- Take Heart Scales from the player's bag
					for ii = 1, total, 1 do
						local item_slot = GAME:FindPlayerItem("loot_heart_scale", true, true)
						GAME:TakePlayerBagItem(item_slot.Slot, false)
					end
					-- Give items
					for ii = 1, #cart, 1 do
						local item = RogueEssence.Dungeon.InvItem(cart[1].Index, false, cart[1].Amount)
						GAME:GivePlayerItem(item)
					end
					cart = {}
					
					SOUND:PlayBattleSE("DUN_Money")
					UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Evoshop_Seller_Buy_Complete']))
					state = 0
				else
					state = 1
				end
			end
		end
	end
	UI:ResetSpeaker()
end

return base_camp_2_evoshop