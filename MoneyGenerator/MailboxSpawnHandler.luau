local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        local PlayerMailbox = ServerStorage:FindFirstChild("Mailbox")

        local ClonePlayerMailbox = PlayerMailbox:Clone()
        ClonePlayerMailbox.Name = Player.Name .. "sMailbox"

        local GuiPart = ClonePlayerMailbox:FindFirstChild("PlayerNameGuiPart")
        local GuiPartTextLabel = GuiPart.PlayerNameGui.TextLabel
        GuiPartTextLabel.Text = Player.Name .. "'s"

        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        ClonePlayerMailbox.Parent = workspace

        local SpawnPosition = HumanoidRootPart.Position
            + (HumanoidRootPart.CFrame.LookVector * 25) - Vector3.new(0, 2.5, 0)

        -- Set position and rotate 180 degrees to face the player
		ClonePlayerMailbox:PivotTo(
            CFrame.new(SpawnPosition) * CFrame.Angles(0, math.rad(180), 0)
        )
    end)
end)