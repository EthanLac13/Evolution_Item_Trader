require 'origin.common'

-- Thanks to Palika for this code
function BATTLE_SCRIPT.EvoTraderGlaceonInteract(owner, ownerChar, context, args)
	local chara = context.User
	local target = context.Target
	local action_cancel = context.CancelState
	local turn_cancel = context.TurnCancel
	
	action_cancel.Cancel = true

	if COMMON.CanTalk(target) then
		
		UI:SetSpeaker(target)

		local ratio = target.HP * 100 // target.MaxHP
		
		local talk_string = ""
		
		if ratio <= 25 then
			UI:SetSpeakerEmotion("Pain")
			talk_string = "[tmp] Glaceon Low HP"
		elseif ratio <= 50 then
			UI:SetSpeakerEmotion("Worried")
			talk_string = "[tmp] Glaceon Half HP"
		else
			talk_string = "[tmp] Glaceon Full HP"
		end
		
		local oldDir = target.CharDir
		DUNGEON:CharTurnToChar(target, chara)
	
		UI:WaitShowDialogue(STRINGS:Format(talk_string))
	
		target.CharDir = oldDir
	else
	
		UI:ResetSpeaker()
	
		local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
		chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
	
		UI:WaitShowDialogue(chosen_quote)
	
	end
end