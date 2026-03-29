-- TODO : If the data loaded unsuccessfully, flag it (using a table) so that on leave the data is 
-- attempted to be fetched one last time. If success, add the fetched data to the 
-- current value before saving. Then, save the new value.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local DataStoreService = game:GetService("DataStoreService")

local DATASTORENAME = "Money"
local DataStore = DataStoreService:GetDataStore(DATASTORENAME)

local PlayersGenerating = {}
local PlayersMailbox = {}

-- Builds leaderstats for the player and loads their money
function BuildLeaderstats(Player: Player) : Folder
	-- Load money from DataStore
	local MoneyData = nil
	local Success, ErrorMessage = pcall(function()
		MoneyData = DataStore:GetAsync(Player.UserId .. "-" .. DATASTORENAME)
	end)

	if not Success then
		warn("There was a problem loading data for player (possibly first timej) " .. Player.Name .. ": " .. tostring(ErrorMessage))
		MoneyData = 0
	end

	if MoneyData == nil then
		warn("No money data found for " .. Player.Name .. "; defaulting to 0")
		MoneyData = 0
	end

	-- Create leaderstats folder
	local LeaderstatsFolder = Instance.new("Folder")
	LeaderstatsFolder.Name = "leaderstats"
	LeaderstatsFolder.Parent = Player

	local Money = Instance.new("IntValue")
	Money.Name = "Money"
	Money.Value = MoneyData
	Money.Parent = LeaderstatsFolder

	-- Start automatic mailbox money generation
	BeginGeneration(Player)

	return LeaderstatsFolder
end

-- Starts money generation in player's mailbox
function BeginGeneration(Player)
	local Mailbox = PlayersMailbox[Player]
	if not Mailbox then return end

	PlayersGenerating[Player] = true

	-- Part that holds MoneyGui Billboard
	local GuiPart = Mailbox:WaitForChild("MoneyGuiPart")
	
	-- Money Value Mailboxes hold
	local MoneyValue = Mailbox:WaitForChild("Money")
	
	-- The Billboard GUI
	local MoneyGui = GuiPart:WaitForChild("MoneyGui")
	
	-- The TextLabel apart of the GUI
	local TextLabel = MoneyGui:WaitForChild("TextLabel")

	task.spawn(function()
		while PlayersGenerating[Player] do
			MoneyValue.Value += 1
			TextLabel.Text = "$" .. MoneyValue.Value
			task.wait(1)
		end
	end)
end

-- Player joins
Players.PlayerAdded:Connect(function(Player)
	local Mailbox = Workspace:WaitForChild(Player.Name .. "sMailbox")
	PlayersMailbox[Player] = Mailbox

	local LeaderstatsFolder = BuildLeaderstats(Player)
	local TouchedConnection

	local function OnCharacterAdded(Character)
		-- Disconnect old connection to prevent memory leaks
		if TouchedConnection then
			TouchedConnection:Disconnect()
			TouchedConnection = nil
		end

		local Debounce = false
		
		-- TODO: This connection does not need to keep being recreated
		-- and destroyed if the script was structured different.
		
		-- The only reason I was doing this was to get the character. BUT
		-- I can just do - local Character = player.Character or player.CharacterAdded:Wait()
		-- instead so i don't keep recreqting the touched event inside the CharacterAdded connection
		TouchedConnection = Mailbox.Threshold.Touched:Connect(function(Hit)
			if Debounce then return end

			local HitPlayer = Players:GetPlayerFromCharacter(Hit.Parent)
			if HitPlayer == Player then
				Debounce = true
				
				-- Mailbox.Money.Value is the value constantly being updated
				-- thanks to BeginGeneration(Player)
				-- So... When the Mailbox is touched, the leaderstats value
				-- is kept up to date by adding the value on the mailbox
				-- to the player's leaderstats
				LeaderstatsFolder.Money.Value += Mailbox.Money.Value
				Mailbox.Money.Value = 0
				task.wait(2)
				Debounce = false
			end
		end)
	end

-- Remember, the function above was just a declaration. Meaning it doesn't get
-- used until passed through the CharacterAdded connection
	Player.CharacterAdded:Connect(OnCharacterAdded)
	if Player.Character then
		OnCharacterAdded(Player.Character)
	end
end)

-- Player leaves
Players.PlayerRemoving:Connect(function(Player)
	PlayersGenerating[Player] = nil

	local CurrentMoneyValue = Player.leaderstats.Money.Value

	local Success, ErrorMessage = pcall(function()
		DataStore:SetAsync(Player.UserId .. "-" .. DATASTORENAME, CurrentMoneyValue)
	end)

	if Success then
		print("Player left; saved Money: " .. CurrentMoneyValue)
	else
		warn("There was a problem saving data for " .. Player.Name .. ": " .. tostring(ErrorMessage))
	end

	PlayersMailbox[Player] = nil
end)