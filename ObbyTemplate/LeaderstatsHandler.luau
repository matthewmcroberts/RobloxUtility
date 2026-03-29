local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
	local Leaderstats = Instance.new("Folder", Player)
	Leaderstats.Name = "leaderstats"
	
	local Stage = Instance.new("IntValue")
	Stage.Parent = Leaderstats
	Stage.Name = "Stage"
	Stage.Value = 1
end)