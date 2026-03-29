local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CheckpointUtil = require(ReplicatedStorage.Utils.CheckpointUtil)

Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		local Stage = CheckpointUtil.GetStage(Player)
		local Spawnplate = Stage:WaitForChild("SpawnPlate")
		
		if not Spawnplate then 
			print("No spawn plate found for " .. Stage.Name)
		end
		
		Character:MoveTo(Spawnplate.Position)
	end)
end)