local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SpawnPartEvent = ReplicatedStorage:FindFirstChild("SpawnPart")
local DeletePartEvent = ReplicatedStorage:FindFirstChild("DeletePart")

local SpawnedParts = {}

SpawnPartEvent.OnServerEvent:Connect(function(Player: Player)
	print("Fired spawn part listener")
	local Character = Player.Character
	local Humanoid = Character:FindFirstChild("HumanoidRootPart")
	
	local Part = Instance.new("Part", game.Workspace)
	Part.Name = Player.Name .. "'s Part"
	Part.Position = Humanoid.Position
	
	if not SpawnedParts[Player] then
		SpawnedParts[Player] = {}
	end
	
	table.insert(SpawnedParts[Player], Part)
end)

DeletePartEvent.OnServerEvent:Connect(function(Player: Player)	
	if #SpawnedParts[Player] >= 1 then
		local PartRemoved = table.remove(SpawnedParts[Player], #SpawnedParts[Player])
		PartRemoved:Destroy()
		print(PartRemoved.Name .. " was removed. Size: " .. #SpawnedParts[Player])
	else
		print(Player.Name .. " has no parts to remove. Ignoring.")
	end
end)