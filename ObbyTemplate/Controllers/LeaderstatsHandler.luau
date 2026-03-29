local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
	local LeaderstatsFolder = Instance.new("Folder")
	LeaderstatsFolder.Name = "leaderstats"
	LeaderstatsFolder.Parent = Player
	
	local StageNumber = Instance.new("IntValue")
	StageNumber.Name = "Stage"
	StageNumber.Parent = LeaderstatsFolder
	StageNumber.Value = 0
end)