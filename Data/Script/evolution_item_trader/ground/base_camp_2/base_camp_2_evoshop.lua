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
	local flareon = base_camp_2_evoshop.SpawnPokemon("flareon", 0, "normal", Gender.Male, 712, 560, Direction.Down, "EvolutionShopItemBuyer")
	local glaceon = base_camp_2_evoshop.SpawnPokemon("glaceon", 0, "normal", Gender.Female, 736, 560, Direction.Down, "EvolutionShopItemSeller")
	
	if not SV.ModData_EvolutionItemTrader.Shopkeeper_Rescued then
		
		GROUND:Hide("EvolutionShopItemBuyer")
		GROUND:Hide("EvolutionShopItemSeller")
		
		-- If we haven't reached Canyon Camp yet, have the two mention the quest setup
		if SV.canyon_camp.ExpositionComplete == false then
			base_camp_2_evoshop.SpawnPokemon("eevee", 0, "normal", Gender.Male, 712, 592, Direction.Right, "EvolutionShopPreQuestExpoBrother")
			base_camp_2_evoshop.SpawnPokemon("eevee", 0, "normal", Gender.Female, 736, 592, Direction.Left, "EvolutionShopPreQuestExpoSister")
		-- If we have, offer to start the quest
		elseif SV.ModData_EvolutionItemTrader.Quest_Given == false then
			base_camp_2_evoshop.SpawnPokemon("eevee", 0, "normal", Gender.Male, 708, 592, Direction.DownRight, "EvolutionShopQuestStartBrother")
			base_camp_2_evoshop.SpawnPokemon("eevee", 0, "normal", Gender.Female, 740, 592, Direction.DownLeft, "EvolutionShopQuestStartSister")
			base_camp_2_evoshop.SpawnPokemon("cacnea", 0, "normal", Gender.Male, 724, 612, Direction.Up, "EvolutionShopQuestStartCriminal")
		elseif SV.ModData_EvolutionItemTrader.Boss_Defeated == false then
			base_camp_2_evoshop.SpawnPokemon("eevee", 0, "normal", Gender.Male, 724, 592, Direction.Down, "EvolutionShopQuestWaitingBrother")
		else
			base_camp_2_evoshop.SpawnPokemon("eevee", 0, "normal", Gender.Male, 712, 592, Direction.Right, "EvolutionShopQuestCompleteBrother")
			base_camp_2_evoshop.SpawnPokemon("glaceon", 0, "normal", Gender.Female, 736, 592, Direction.Left, "EvolutionShopQuestCompleteSister")
		end
		
	end
	
	-- Create shop stall
	local shop_sprite = ""
	if not SV.ModData_EvolutionItemTrader.Shopkeeper_Rescued then
		shop_sprite = "Eevee_Shop_Tent"
	else
		shop_sprite = "Evoshop_Tent"
	end
	animation_data = RogueEssence.Content.ObjAnimData(shop_sprite, 60)
	shop_stall_obj = RogueEssence.Ground.GroundObject(animation_data, Dir8.None, Rect(0, 0, 0, 0), RogueElements.Loc(0, 74), true, "EvolutionShopStall")
	shop_stall_obj.MapLoc = RogueElements.Loc(680, 564)
	GAME:GetCurrentGround():AddTempObject(shop_stall_obj)
	
	-- Create carpet
	animation_data = RogueEssence.Content.ObjAnimData("Evoshop_Carpet", 60)
	shop_stall_carpet = RogueEssence.Ground.GroundObject(animation_data, Dir8.None, Rect(0, 0, 0, 0), RogueElements.Loc(0, 0), true, "EvolutionShopCarpet")
	shop_stall_carpet.MapLoc = RogueElements.Loc(696, 523)
	GAME:GetCurrentGround():AddTempObject(shop_stall_carpet)
	
	-- Move over player teammates
	local teammate = CH("Assembly9")
	if teammate ~= nil then
		GROUND:TeleportTo(teammate, teammate.Position.X - 16, teammate.Position.Y - 104, Direction.Left)
	end
	if teammate ~= nil then
	local teammate = CH("Assembly24")
		GROUND:TeleportTo(teammate, teammate.Position.X + 8, teammate.Position.Y + 16, Direction.Down)
	end
	
end

-- Dialogue before quest is available
function base_camp_2_evoshop.Interact_EvolutionShopPreQuestExpo(obj, activator)
	
	local eevee_brother = CH("EvolutionShopPreQuestExpoBrother")
	local eevee_sister = CH("EvolutionShopPreQuestExpoSister")
	
	if SV.ModData_EvolutionItemTrader.Talked_Pre_Quest == false then
		
		GROUND:CharTurnToCharAnimated(eevee_brother, activator, 4)
		GAME:WaitFrames(5)
		GROUND:CharTurnToCharAnimated(eevee_sister, activator, 4)
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_brother, "glowing", 1)
		UI:SetSpeaker(eevee_brother)
		UI:WaitShowDialogue("Hiya![pause=20] This is the [color=#00FF00]Eevee[color] Shop!")
		UI:WaitShowDialogue("I'm [color=#00FFFF]Eevee[color],[pause=10] and this is my sister,[pause=10] [color=#00FFFF]Eevee[color]!")
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_sister, "glowing", 1)
		UI:SetSpeaker(eevee_sister)
		UI:WaitShowDialogue("Right now,[pause=10] we're still deciding on what to sell.")
		UI:WaitShowDialogue("Once we've saved up enough,[pause=10] we're going to find a [color=#00FF00]Kecleon[color] shop that sells evolution stones.")
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_brother, "glowing", 1)
		UI:SetSpeaker(eevee_brother)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Oh,[pause=10] I can't wait to become a [color=#00FF00]Glaceon[color]![pause=0] My breath feels cold just thinking about it!")
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_sister, "glowing", 1)
		UI:SetSpeaker(eevee_sister)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("Not if my fire breath heats it up first!")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("If you check back later,[pause=10] our shop might be open then.")
		GAME:WaitFrames(10)
		
		SV.ModData_EvolutionItemTrader.Talked_Pre_Quest = true
		
		GROUND:CharTurnToCharAnimated(eevee_brother, eevee_sister, 4)
		GAME:WaitFrames(5)
		GROUND:CharTurnToCharAnimated(eevee_sister, eevee_brother, 4)
		GAME:WaitFrames(10)
		
		UI:ResetSpeaker()
		
	else
		
		GROUND:CharSetEmote(eevee_brother, "glowing", 1)
		UI:SetSpeaker(eevee_brother)
		UI:SetSpeakerEmotion("Worried")
		UI:WaitShowDialogue("Hmmm...[pause=30] [color=#00FFFF]Kecleon[color]'s shop already has everything we could get our paws on...")
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_sister, "glowing", 1)
		UI:SetSpeaker(eevee_sister)
		UI:WaitShowDialogue("Maybe we could...[pause=0] Hmmm...")
		GAME:WaitFrames(10)
		
	end
	
end

-- Dialogue to give the quest
function base_camp_2_evoshop.Interact_QuestGiver(obj, activator)
	
	if SV.ModData_EvolutionItemTrader.Quest_Given == false then
		local player = CH("PLAYER")
		local eevee_brother = CH("EvolutionShopQuestStartBrother")
		local eevee_sister = CH("EvolutionShopQuestStartSister")
		local cacnea = CH("EvolutionShopQuestStartCriminal")
		
		GAME:CutsceneMode(true)
		GAME:FadeOut(false, 20)
		
		-- Set camera position
		GAME:MoveCamera(732, 636, 1, false)
		
		-- Set NPC positions
		GROUND:TeleportTo(player, 684, 632, Direction.UpRight)
		GAME:WaitFrames(20)
		
		GAME:FadeIn(20)
		
		GROUND:CharSetEmote(eevee_brother, "glowing", 1)
		UI:SetSpeaker(eevee_brother)
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("Wow![pause=20] And they're just lying around on the ground?!")
		GAME:WaitFrames(10)
			
		UI:SetSpeaker(cacnea)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("You betcha'![pause=0] [color=#FFCEFF]Fire Stones[color],[pause=10] [color=#FFCEFF]Ice Stones[color]...[pause=30] any kind of stone you want!")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("We're going on an expedition to a side path deeper in [color=#FFC663]Depleted Basin[color].")
		UI:WaitShowDialogue("If you come along,[pause=10] we'll let you keep half the take!")
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_sister, "glowing", 1)
		UI:SetSpeaker(eevee_sister)
		UI:SetSpeakerEmotion("Happy")
		UI:WaitShowDialogue("I can't wait to get started!")
		GAME:WaitFrames(10)
		
		GROUND:EntTurn(eevee_sister, Direction.Left)
		GAME:WaitFrames(10)
		GROUND:EntTurn(eevee_brother, Direction.Right)
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_sister, "glowing", 1)
		UI:SetSpeaker(eevee_sister)
		UI:WaitShowDialogue("Will you stay and look after the shop while I go along with [color=#00FFFF]Cacnea[color]'s crew?")
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_brother, "glowing", 1)
		UI:SetSpeaker(eevee_brother)
		UI:SetSpeakerEmotion("Sad")
		UI:WaitShowDialogue("Awww,[pause=10] I wanted to go too...")
		UI:SetSpeakerEmotion("Normal")
		UI:WaitShowDialogue("But I will.[pause=0] I'll make sure nothing happens while you're gone.")
		GAME:WaitFrames(10)
		
		GROUND:EntTurn(eevee_sister, Direction.DownLeft)
		GAME:WaitFrames(10)
		GROUND:EntTurn(eevee_brother, Direction.DownRight)
		GAME:WaitFrames(10)
		
		GROUND:CharSetEmote(eevee_sister, "glowing", 1)
		UI:SetSpeaker(eevee_sister)
		UI:WaitShowDialogue("All right.[pause=0] We're ready to go any time.")
		GAME:WaitFrames(10)
			
		UI:SetSpeaker(cacnea)
		UI:WaitShowDialogue("Great![pause=20] Just follow me.")
		GAME:WaitFrames(10)
		
		local coro1 = TASK:BranchCoroutine(function() -- Cacnea turns and walks away
			GROUND:CharAnimateTurnTo(cacnea, Direction.Left, 4)
			GAME:WaitFrames(4)
			GROUND:MoveToPosition(cacnea, cacnea.Position.X - 240, cacnea.Position.Y, false, 1.25)
		end)
		local coro2 = TASK:BranchCoroutine(function() -- Eevee sister walks away
			GAME:WaitFrames(30)
			GROUND:MoveToPosition(eevee_sister, eevee_sister.Position.X - 4, eevee_sister.Position.Y + 10, false, 1.25)
			GROUND:MoveToPosition(eevee_sister, eevee_sister.Position.X - 6, eevee_sister.Position.Y + 6, false, 1.25)
			GROUND:MoveToPosition(eevee_sister, eevee_sister.Position.X - 10, eevee_sister.Position.Y + 4, false, 1.25)
			GROUND:MoveToPosition(eevee_sister, eevee_sister.Position.X - 240, eevee_sister.Position.Y, false, 1.25)
		end)
		local coro3 = TASK:BranchCoroutine(function() -- Eevee brother turns to watch
			GAME:WaitFrames(60)
			GROUND:CharAnimateTurnTo(eevee_brother, Direction.Left, 30)
		end)
		local coro4 = TASK:BranchCoroutine(function() -- Eevee brother speaks
			GAME:WaitFrames(110)
			GROUND:CharSetEmote(eevee_brother, "glowing", 1)
			UI:SetSpeaker(eevee_brother)
			UI:WaitShowDialogue("Bye![pause=20] Have a nice trip!")
		end)
		TASK:JoinCoroutines({coro1,coro2,coro3,coro4})
		GAME:WaitFrames(10)
		
		GAME:FadeOut(false, 20)
		
		GROUND:Hide("EvolutionShopQuestStartSister")
		GROUND:Hide("EvolutionShopQuestStartCriminal")
		
		GAME:WaitFrames(20)
		SV.ModData_EvolutionItemTrader.Quest_Given = true
		GAME:CutsceneMode(false)
		GAME:MoveCamera(0, 0, 1, true)
		
		GAME:FadeIn(20)
	else
		local player = CH("PLAYER")
		local eevee_brother = CH("EvolutionShopQuestStartBrother")
		
		GROUND:CharTurnToCharAnimated(eevee_brother, player, 4)
		
		UI:SetSpeaker(eevee_brother)
		UI:WaitShowDialogue("[color=#00FFFF]Eevee[color] is so lucky![pause=0] Getting to go on an adventure like that...")
		UI:SetSpeakerEmotion("Inspired")
		UI:WaitShowDialogue("And then,[pause=10] when she comes back...[pause=0] We're gonna get to evolve!!")
		GAME:WaitFrames(10)
		
		GROUND:CharAnimateTurnTo(eevee_brother, Direction.Left, 4)
	end
	
end

-- Dialogue from Eevee brother while waiting for quest to be complete
function base_camp_2_evoshop.Interact_QuestWaiting(obj, activator)
	
	GROUND:CharTurnToCharAnimated(obj, activator, 4)
	
	UI:SetSpeaker(obj)
	UI:WaitShowDialogue("It's been a while since my sister went out with [color=#00FFFF]Cacnea[color].[pause=30] I hope she's doing okay...")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("He said they were headed to a side path deep in [color=#FFC663]Depleted Basin[color].[pause=0] It sounds pretty dangerous.")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("He was saying they'd be going alongside three other [color=#00FF00]Cacnea[color],[pause=10] though.[pause=0] So I guess I shouldn't worry...")
	GAME:WaitFrames(10)
	
	UI:ResetSpeaker()
	GROUND:CharAnimateTurnTo(obj, Direction.Down, 4)
			
end

function base_camp_2_evoshop.Interact_QuestComplete(obj, activator)
	
	local player = CH("PLAYER")
	local brother = CH("EvolutionShopQuestCompleteBrother")
	local sister = CH("EvolutionShopQuestCompleteSister")
	
	GAME:CutsceneMode(true)
	GAME:FadeOut(false, 20)
	
	GAME:MoveCamera(732, 608, 1, false)
	
	-- Set NPC positions
	GROUND:TeleportTo(player, 724, 624, Direction.Up)
	GAME:WaitFrames(20)
	
	GAME:FadeIn(20)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("Wow![pause=20] And you fought all of them off?!")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowTimedDialogue("Yes,[pause=10] but I couldn't have done it without-", 20)
	GAME:WaitFrames(10)
	
	GROUND:CharTurnToCharAnimated(sister, player, 4)
	GROUND:CharSetEmote(sister, "notice", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim")
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(brother, player, 4)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue(STRINGS:Format("Oh![pause=20] It's the leader of {0}!", GAME:GetTeamName()))
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Thank you again for having saved me from that gang of thugs.")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah![pause=20] You're the coolest!")
	GAME:WaitFrames(10)
	
	GROUND:CharTurnToCharAnimated(sister, brother, 4)
	GAME:WaitFrames(10)
	GROUND:CharTurnToCharAnimated(brother, sister, 4)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue("Eevee...")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue("Yeah?")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("I'm...[pause=0] I'm sorry I wasn't able to bring you an [color=#FFCEFF]Ice Stone[color].")
	UI:WaitShowDialogue("[color=#00FFFF]Cacturne[color]'s goons were so strong,[pause=10] and I had to evolve to fend them off.")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("[color=#00FFFF]Eevee[color]...[pause=0] Well,[pause=10] [color=#00FFFF]Glaceon[color] now...[pause=0] I'm just glad you're safe.")
	UI:WaitShowDialogue("If something bad had happened to you while you were out there...")
	UI:SetSpeakerEmotion("Sad")
	UI:WaitShowDialogue("Oh,[pause=10] I'd never be able to forgive myself.")
	UI:WaitShowDialogue("And I don't want you to have to go back there to find an evolution stone for me.")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("Well,[pause=10] then...[pause=0] How are you going to evolve?")
	UI:WaitShowDialogue("You wanted to become a [color=#00FF00]Glaceon[color],[pause=10] so...")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue("Do you have any other evolution stones?")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue("Well,[pause=10] I did have one,[pause=10] but...")
	GAME:WaitFrames(10)
	
	GROUND:MoveToPosition(sister, sister.Position.X - 8, sister.Position.Y, false, 0.5)
	GAME:WaitFrames(10)
	SOUND:PlayBattleSE("EVT_CH02_Box_Open")
	GAME:WaitFrames(30)
	GROUND:AnimateToPosition(sister, "Walk", Dir8.Left, sister.Position.X + 8, sister.Position.Y, 1.0, 0.5, 0)
	GAME:WaitFrames(5)
	
	UI:SetSpeaker(sister)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("It's a [color=#FFCEFF]Fire Stone[color].[pause=0] Not the one you wanted.")
	UI:WaitShowDialogue("We could sell it to make progress towards buying another [color=#FFCEFF]Ice Stone[color],[pause=10] maybe...")
	GAME:WaitFrames(10)
	
	GROUND:CharAnimateTurnTo(brother, Direction.Left, 4)
	GAME:WaitFrames(6)
	GROUND:MoveToPosition(brother, brother.Position.X - 24, brother.Position.Y, false, 1.5)
	
	GROUND:CharSetEmote(sister, "exclaim", 1)
	SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised")
	GAME:WaitFrames(30)
	
	UI:SetSpeaker(sister)
	UI:SetSpeakerEmotion("Surprised")
	UI:WaitShowDialogue("[color=#00FFFF]Eevee[color]! Where are you going?")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue("To Luminous Spring. I'm gonna use this [color=#FFCEFF]Fire Stone[color] and evolve into a [color=#00FF00]Flareon[color].")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("But...[pause=0] You don't want to be a [color=#00FF00]Flareon[color]!")
	GAME:WaitFrames(20)
	
	GROUND:CharAnimateTurnTo(brother, Direction.Right, 6)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue("You didn't want to be a [color=#00FF00]Glaceon[color],[pause=10] either.[pause=0] But,[pause=10] from what you said...")
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("It sounds like you're an amazing [color=#00FF00]Glaceon[color]![pause=30] Freezing that bad guy solid!")
	UI:SetSpeakerEmotion("Normal")
	UI:WaitShowDialogue("So,[pause=10] if you're such a great [color=#00FF00]Glaceon[color]...[pause=0] I'm going to be the best [color=#00FF00]Flareon[color] I can be for you.")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue("...")
	UI:WaitShowDialogue("...All right.")
	GAME:WaitFrames(10)
	
	GROUND:MoveToPosition(brother, brother.Position.X - 216, brother.Position.Y - 24, false, 1.5)
	GAME:WaitFrames(60)
	
	SOUND:PlayBattleSE("EVT_Evolution_Start")
	brother.Data.BaseForm = MonsterID("flareon", 0, "normal", Gender.Male)
	brother.Data.Nickname = _DATA:GetMonster("flareon").Name:ToLocal()
	
	GAME:WaitFrames(90)
	
	GROUND:MoveToPosition(brother, brother.Position.X + 240, brother.Position.Y + 24, false, 1.5)
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Let's do our best,[pause=10] as always!")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("Yeah!")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue("Though,[pause=10] now that we've both evolved...")
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("What are we going to do with the shop?[pause=30] We were raising money to buy evolution stones...")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue("Well,[pause=10] what you said got me thinking...")
	UI:WaitShowDialogue("Imagine how many other Pokémon must be in our old situation,[pause=10] where they couldn't find evolution items.")
	UI:WaitShowDialogue("What if we could find a way to help them?[pause=0] We could sell evolution items to them ourselves.")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:SetSpeakerEmotion("Worried")
	UI:WaitShowDialogue("And how would we get them in the first place?")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue("We could buy them off of other Pokémon who do have them.")
	UI:WaitShowDialogue("We don't need Poké so much now,[pause=10] but you know what we do need?[pause=0] Heart Scales.")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue("That's...")
	UI:SetSpeakerEmotion("Joyous")
	UI:WaitShowDialogue("Haha![pause=20] That's true![pause=0] I don't actually know how to breathe fire yet!")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(sister)
	UI:WaitShowDialogue("If we want to learn more moves,[pause=10] and be the best [color=#00FF00]Flareon[color] and [color=#00FF00]Glaceon[color] we can be,[pause=10] we need Heart Scales.")
	GAME:WaitFrames(10)
	
	UI:SetSpeaker(brother)
	UI:WaitShowDialogue("All right,[pause=10] then![pause=20] It's official!")
	UI:WaitShowDialogue("The Eevee Shop is now closed...")
	GAME:WaitFrames(10)
	
	GAME:FadeOut(false, 20)
	
	-- Swap out the evolution shop for a new one
	GROUND:Hide("EvolutionShopStall")
	animation_data = RogueEssence.Content.ObjAnimData("Evoshop_Tent", 60)
	shop_stall_obj = RogueEssence.Ground.GroundObject(animation_data, Dir8.None, Rect(0, 0, 0, 0), RogueElements.Loc(0, 74), true, "EvolutionShopStall2")
	shop_stall_obj.MapLoc = RogueElements.Loc(680, 564)
	GAME:GetCurrentGround():AddTempObject(shop_stall_obj)
	GAME:WaitFrames(10)
	
	-- Play some noises
	SOUND:PlayBattleSE("_UNK_DUN_Punch")
	GAME:WaitFrames(15)
	SOUND:PlayBattleSE("_UNK_DUN_Punch")
	GAME:WaitFrames(15)
	SOUND:PlayBattleSE("_UNK_DUN_Punch")
	GAME:WaitFrames(25)
	SOUND:PlayBattleSE("_UNK_DUN_Clank")
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("_UNK_DUN_Clank")
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("_UNK_DUN_Punch")
	GAME:WaitFrames(20)
	SOUND:PlayBattleSE("_UNK_DUN_Splash")
	GAME:WaitFrames(30)
	
	GAME:FadeIn(20)
	GAME:WaitFrames(20)
	
	UI:SetSpeaker(brother)
	UI:SetSpeakerEmotion("Happy")
	UI:WaitShowDialogue("But the Evo Shop is now open for business!")
	GAME:WaitFrames(10)
	
	GAME:FadeOut(false, 20)
	
	-- Hide old quest NPCs
	GROUND:Hide("EvolutionShopQuestCompleteBrother")
	GROUND:Hide("EvolutionShopQuestCompleteSister")
	
	-- Spawn shop NPCs
	GROUND:Unhide("EvolutionShopItemBuyer")
	GROUND:Unhide("EvolutionShopItemSeller")
	
	-- Reset camera
	GAME:MoveCamera(0, 0, 1, true)
	
	-- Set quest as complete and end cutscene
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