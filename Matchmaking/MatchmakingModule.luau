local TeleportService = game:GetService("TeleportService")

local MatchmakingModule = {}

local BATCHSIZE = 1
local Queue = {}

function MatchmakingModule.Enqueue(Player: Player)
	for _, QueuePlayer in pairs(Queue) do
		if QueuePlayer == Player then
			print("Attempted to enqueue " .. " but, they were already in the queue.")
			return
		end
	end
	
	table.insert(Queue, Player)
	print(Player.Name .. " has been inserted into the queue.")
	
	MatchmakingModule.AttemptTeleport()
end

function MatchmakingModule.Remove(Player: Player)
	for i, QueuePlayer in pairs(Queue) do
		if QueuePlayer == Player then
			table.remove(Queue, i)
			print(Player.Name .. " has been removed from the queue.")
			return
		end
	end
	print("Attempted to remove " .. Player.Name .. " but they were not in the queue.")
end

function MatchmakingModule.AttemptTeleport()	
	if #Queue >= BATCHSIZE then
		local PlayersToTeleport = {}
		
		for i = 1, BATCHSIZE do
			-- 1 here because everytime an element is removed, it shifts everything else by 1. so i wouldn't make sense, we always want to remove the first and not skip any
		   table.insert(PlayersToTeleport, table.remove(Queue, 1))
		end
		
		for _, Player in pairs(PlayersToTeleport) do
			print("teleporting " .. Player.Name)
			-- INSERT TELEPORT SERVICE HERE
		end
	else
		print("Not enough players yet to teleport. Waiting for " .. BATCHSIZE .. " players")
	end
end

return MatchmakingModule
