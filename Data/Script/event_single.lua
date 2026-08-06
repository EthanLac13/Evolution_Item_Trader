require 'origin.common'

function SINGLE_CHAR_SCRIPT.SpawnDesiccatedBasinAllies(owner, ownerChar, context, args)
	if context.User == nil then -- This code was modified from Halcyon's Lotus-spawning code
		print("Spawn Glaceon")
		
		local mon_id = RogueEssence.Dungeon.MonsterID("glaceon", 0, "normal", Gender.Female)
		local glaceon = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 35, "snow_cloak", 0)
		glaceon.Discriminator = _DATA.Save.Rand:Next()
		local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("AllyInteract")
		glaceon.ActionEvents:Add(talk_evt)
		
		glaceon.Level = 35
		glaceon.IsPartner = false
		glaceon.MaxHPBonus = 20
		glaceon.AtkBonus = 20
		glaceon.DefBonus = 20
		glaceon.MAtkBonus = 20
		glaceon.MDefBonus = 20
		glaceon.SpeedBonus = 20
		
		glaceon:ReplaceSkill("icy_wind", 0, true)
		glaceon:ReplaceSkill("helping_hand", 1, true)
		glaceon:ReplaceSkill("barrier", 2, true)
		glaceon:ReplaceSkill("sand_attack", 3, false)
		
		GAME:AddPlayerGuest(glaceon)
		glaceon:FullRestore()
		glaceon:RefreshTraits()
		
		print("Spawned Glaceon")
	end
end