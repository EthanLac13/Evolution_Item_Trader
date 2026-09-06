require 'origin.common'

-- Thanks to Palika for this code
function BATTLE_SCRIPT.EvoTraderGlaceonInteract(owner, ownerChar, context, args)
	print("Script executed")
	
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
			talk_string = "No...[pause=0] No...!"
		elseif ratio <= 50 then
			UI:SetSpeakerEmotion("Determined")
			talk_string = "These guys are tough,[pause=10] but I won't give up!"
		else
			UI:SetSpeakerEmotion("Angry")
			talk_string = "I'll back you up![pause=20] Let's make these guys pay!"
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