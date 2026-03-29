local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DeleteCarEvent = ReplicatedStorage:WaitForChild("DeleteCar")
local Player = game.Players.LocalPlayer

game.Workspace.ChildAdded:Connect(function(Added)
	if Added.Name == Player.Name .. 'sCar' then
		script.Parent.Visible = true
	end
end)

script.Parent.MouseButton1Down:Connect(function() 
	local Car = game.Workspace:FindFirstChild(Player.Name .. 'sCar')
	if Car then
		script.Parent.Visible = false
		if Player.Character.Humanoid.SeatPart ~= nil and player.Character.Humanoid.SeatPart:IsA("VehicleSeat") then
			player.Character.Humanoid.Sit = false
		end
		
		wait()
		DeleteCarEvent:FireServer(Car)
	end
end)