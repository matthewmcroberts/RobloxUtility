local CheckpointModule = {}

local PlayersCurrentStage = {}

function CheckpointModule.GetCurrentStage(Player: Player)
	-- Check to see if the player's stage is cached before looping
	local Cached = PlayersCurrentStage[Player]
	if Cached then
		return Cached
	end

	local Stages = workspace:WaitForChild("Stages")
	local Leaderstats = Player:WaitForChild("leaderstats")
	
	-- Player's current stage value in leaderstats
	local CurrentStageValue = Leaderstats:WaitForChild("Stage").Value

	for _, Stage in pairs(Stages:GetChildren()) do
		local StageNumber = Stage:FindFirstChild("StageNumber")
		if StageNumber and StageNumber.Value == CurrentStageValue then
			PlayersCurrentStage[Player] = Stage
			return Stage
		end
	end

	warn("Could not find a stage for - " .. Player.Name)
	return nil
end

-- The parameter Stage in this case is the workspace folder whose threshold was touched
function CheckpointModule.UpdateCurrentStage(Player: Player, Stage: Folder)
	local Leaderstats = Player:WaitForChild("leaderstats")
	local LeaderstatsStage = Leaderstats:WaitForChild("Stage")

	LeaderstatsStage.Value = Stage.StageNumber.Value
	PlayersCurrentStage[Player] = Stage
end

function CheckpointModule.ClearPlayer(Player: Player)
	PlayersCurrentStage[Player] = nil
end

return CheckpointModule