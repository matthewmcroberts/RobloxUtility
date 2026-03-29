local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DeletePartEvent = ReplicatedStorage:FindFirstChild("DeletePart")

local SpawnButton = script.Parent

local Player = Players.LocalPlayer

SpawnButton.MouseButton1Click:Connect(function()
	DeletePartEvent:FireServer(Player)
end)