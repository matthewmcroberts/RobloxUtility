local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MatchmakingModule = require(ReplicatedStorage.Modules.MatchmakingModule)
local Part = script.Parent

local Debounce = false
Part.Touched:Connect(function(Hit)
	if Debounce then
		return
	end
	
	Debounce = true
	local Character = Hit.Parent
	local Humanoid = Character:FindFirstChild("Humanoid")
	if Humanoid then
		local Player = Players:GetPlayerFromCharacter(Character)
		MatchmakingModule.Enqueue(Player)
	else 
		print(Hit.Name .. "could not be enqueued because it is not a player.")
	end
	
	task.wait(1)
	Debounce = false
end)