ESX = {}
ESX.Players = {}
ESX.UsableItemsCallbacks = {}
ESX.Items = {}
ESX.ServerCallbacks = {}
ESX.TimeoutCount = -1
ESX.CancelledTimeouts = {}
ESX.Pickups = {}
ESX.PickupId = 0
ESX.Jobs = {}
--ESX.RegisteredCommands = {}

AddEventHandler('esx:getSharedObject', function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end

local function StartDBSync()
	Citizen.CreateThread(function()
		Citizen.Wait(Config.TimeSaveBdd * 60 * 1000)
		ESX.SavePlayers()
	end)
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for k,v in ipairs(result) do
			ESX.Items[v.name] = {
				label = v.label,
				weight = v.weight,
				rare = v.rare,
				canRemove = v.can_remove
			}
		end
	end)

	local Jobs = {}
	local Jobs2 = {}
	MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
		for k,v in ipairs(jobs) do
			Jobs[v.name] = v
			Jobs[v.name].grades = {}
		end
	-- job2
	MySQL.Async.fetchAll('SELECT * FROM jobs2', {}, function(jobs2)
		for k,v in ipairs(jobs2) do
			Jobs2[v.name] = v
			Jobs2[v.name].grades = {}
		end
	
		MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
			for k,v in ipairs(jobGrades) do
				if Jobs[v.job_name] then
					Jobs[v.job_name].grades[tostring(v.grade)] = v
				else
					print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
				end
			end
		-- job2
		MySQL.Async.fetchAll('SELECT * FROM job2_grades', {}, function(jobGrades)
			for k,v in ipairs(jobGrades) do
				if Jobs2[v.job_name] then
					Jobs2[v.job_name].grades[tostring(v.grade)] = v
				else
					print(('[^3WARNING^7] Ignoring job2 grades for ^5"%s"^0 due to missing job'):format(v.job_name))
				end
			end
	
			for k2,v2 in pairs(Jobs) do
				if ESX.Table.SizeOf(v2.grades) == 0 then
					Jobs[v2.name] = nil
					print(("grade : %s"):format(v2.grades))
					print(('[^3WARNING^7] Ignoring job ^5"%s"^0due to no job grades found'):format(v2.name))
				end
			end
			-- job2
			for k2,v2 in pairs(Jobs2) do
				if ESX.Table.SizeOf(v2.grades) == 0 then
					Jobs2[v2.name] = nil
					print(("grade2 : %s"):format(v2.grades))
					print(('[^3WARNING^7] Ignoring job2 ^5"%s"^0due to no job grades found'):format(v2.name))
				end
			end

			ESX.Jobs = Jobs
			ESX.Jobs2 = Jobs2
			print("Métiers : "..ESX.Table.SizeOf(ESX.Jobs))
			print("Organisation : "..ESX.Table.SizeOf(ESX.Jobs2))
			print('[^2INFO^7] ESX ^5Legacy^0 initialized')
			StartDBSync()
			StartPayCheck()
			end) 
		end) 
	end) 
  end) 
end)



RegisterServerEvent('esx:clientLog')
AddEventHandler('esx:clientLog', function(msg)
	if Config.EnableDebug then
		print(('[^2TRACE^7] %s^7'):format(msg))
	end
end)

RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(name, requestId, ...)
	local playerId = source

	ESX.TriggerServerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('esx:serverCallback', playerId, requestId, ...)
	end, ...)
end)
