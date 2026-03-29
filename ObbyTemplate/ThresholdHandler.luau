local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CheckpointUtil = require(ReplicatedStorage.Utils.CheckpointUtil)
local ThresholdHandler = require(ReplicatedStorage.Handlers.ThresholdHandler)

local function onThresholdTouched(player, stage)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end
	local stageStat = leaderstats:FindFirstChild("Stage")
	if not stageStat then return end

	if stageStat.Value > 3 then
		print(player.Name .. " has finished the course.")
	else
		stageStat.Value += 1
		print("Player stage incremented by 1")
	end
end

Players.PlayerAdded:Connect(function(player)
	ThresholdHandler.RegisterPlayer(player, CheckpointUtil.GetAllStages(), onThresholdTouched)
end)

Players.PlayerRemoving:Connect(function(player)
	ThresholdHandler.UnregisterPlayer(player)
end)