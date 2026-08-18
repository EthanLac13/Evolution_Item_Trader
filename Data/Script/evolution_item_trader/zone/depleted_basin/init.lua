require 'origin.common'

local depleted_basin = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function depleted_basin.Init(zone)
	DEBUG.EnableDbgCoro() --Enable debugging this coroutine
	PrintInfo("=>> Init_depleted_basin")
	

end

function depleted_basin.Rescued(zone, name, mail)
	COMMON.Rescued(zone, name, mail)
end

function depleted_basin.EnterSegment(zone, rescuing, segmentID, mapID)
	if rescuing ~= true then
		COMMON.BeginDungeon(zone.ID, segmentID, mapID)
	end
end

function depleted_basin.ExitSegment(zone, result, rescue, segmentID, mapID)
	DEBUG.EnableDbgCoro() --Enable debugging this coroutine
	PrintInfo("=>> ExitSegment_depleted_basin result "..tostring(result).." segment "..tostring(segmentID))
	
	-- Get rid of guest Glaceon
	if segmentID == 6 then
		GAME:RemovePlayerGuest(0)
	end
	
	--first check for rescue flag; if we're in rescue mode then take a different path
	local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
	if exited == true then
		--do nothing
	elseif result ~= RogueEssence.Data.GameProgress.ResultType.Cleared then
		COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
	else
		if segmentID == 0 then
			COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 5, 2)
		elseif segmentID == 5 then
			if SV.ModData_EvolutionItemTrader ~= nil then
				PrintInfo(SV.ModData_EvolutionItemTrader.Boss_Defeated)
				if SV.ModData_EvolutionItemTrader.Boss_Defeated == true then
					COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 5, 2)
				else
					GAME:EnterGroundMap("desiccated_basin_cutscene", "Entrance")
				end
			else
				COMMON.EndDungeonDay(result, 'guildmaster_island', -1, 5, 2)
			end
		elseif segmentID == 6 then
			SV.ModData_EvolutionItemTrader.Boss_Defeated = true
			GAME:EnterGroundMap("desiccated_basin_cutscene", "Entrance")
		else
			PrintInfo("No exit procedure found!")
			COMMON.EndDungeonDay(result, SV.checkpoint.Zone, SV.checkpoint.Segment, SV.checkpoint.Map, SV.checkpoint.Entry)
		end
	end
	
end

return depleted_basin
