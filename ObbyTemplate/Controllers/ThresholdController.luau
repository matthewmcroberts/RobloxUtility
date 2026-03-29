local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CheckpointModule = require(ReplicatedStorage.Module.CheckpointModule)

local Stages = workspace:WaitForChild("Stages")

for _, Stage in pairs(Stages:GetChildren()) do
	if Stage.Name == "Start" then
		continue
	end

	local ThresholdPart = Stage:WaitForChild("Threshold")

	ThresholdPart.Touched:Connect(function(hit)
		-- prevent multi-fire from multiple limbs
		if hit.Name ~= "HumanoidRootPart" then return end

		local character = hit.Parent
		if not character then return end

		local player = Players:GetPlayerFromCharacter(character)
		if not player then return end

		CheckpointModule.UpdateCurrentStage(player, Stage)
	end)
end