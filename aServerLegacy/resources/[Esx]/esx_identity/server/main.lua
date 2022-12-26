ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source, callback)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex, height FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].firstname ~= nil then
			local data = {
				identifier	= result[1].identifier,
				firstname	= result[1].firstname,
				lastname	= result[1].lastname,
				dateofbirth	= result[1].dateofbirth,
				sex			= result[1].sex,
				height		= result[1].height
			}

			callback(data)
		else
			local data = {
				identifier	= '',
				firstname	= '',
				lastname	= '',
				dateofbirth	= '',
				sex			= '',
				height		= ''
			}

			callback(data)
		end
	end)
end

function setIdentity(identifier, data, callback)
	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function updateIdentity(playerId, data, callback)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= xPlayer.identifier,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(rowsChanged)
		if callback then
			TriggerEvent('esx_identity:characterUpdated', playerId, data)
			callback(true)
		end
	end)
end

function deleteIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= xPlayer.identifier,
		['@firstname']		= '',
		['@lastname']		= '',
		['@dateofbirth']	= '',
		['@sex']			= '',
		['@height']			= '',
	})
end

RegisterServerEvent('esx_identity:setIdentity1')
AddEventHandler('esx_identity:setIdentity1', function(data, myIdentifiers)
	local xPlayer = ESX.GetPlayerFromId(source)
	setIdentity(myIdentifiers.steamid, data, function(callback)
		if callback then
			TriggerClientEvent('esx_identity:identityCheck', myIdentifiers.playerid, true)
			TriggerEvent('esx_identity:characterUpdated', myIdentifiers.playerid, data)
		else
			xPlayer.showNotification(_U('failed_identity'))
		end
	end)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local myID = {
		steamid = xPlayer.identifier,
		playerid = playerId
	}

	TriggerClientEvent('esx_identity:saveID', playerId, myID)

	getIdentity(playerId, function(data)
		if data.firstname == '' then
			TriggerClientEvent('esx_identity:identityCheck', playerId, false)
			TriggerClientEvent('esx_identity:showRegisterIdentity', playerId)
			--xPlayer.setMoney(500)
			--xPlayer.setAccountMoney('bank', 900)
			--print('test2')
		else
			TriggerClientEvent('esx_identity:identityCheck', playerId, true)
			TriggerEvent('esx_identity:characterUpdated', playerId, data)
			--print('\n^2Un joueurs vien de Spawn en ville^7\n') --quand le joueurs pope
		end
	end)
end)

AddEventHandler('esx_identity:characterUpdated', function(playerId, data)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		xPlayer.setName(('%s %s'):format(data.firstname, data.lastname))
		xPlayer.set('firstName', data.firstname)
		xPlayer.set('lastName', data.lastname)
		xPlayer.set('dateofbirth', data.dateofbirth)
		xPlayer.set('sex', data.sex)
		xPlayer.set('height', data.height)
	end
end)

-- Set all the client side variables for connected users one new time
AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(3000)
		local xPlayers = ESX.GetPlayers()

		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

			if xPlayer then
				local myID = {
					steamid  = xPlayer.identifier,
					playerid = xPlayer.source
				}
	
				TriggerClientEvent('esx_identity:saveID', xPlayer.source, myID)
	
				getIdentity(xPlayer.source, function(data)
					if data.firstname == '' then
						TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, false)
						TriggerClientEvent('esx_identity:showRegisterIdentity', xPlayer.source)
					else
						TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, true)
						TriggerEvent('esx_identity:characterUpdated', xPlayer.source, data)
					end
				end)
			end
		end
	end
end)

local spawnCoords = vector3(704.659, 4183.545, 40.7)
RegisterNetEvent('register:players')
AddEventHandler('register:players', function(raisonRegister)
	print("^1passer server^7")
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyPed = GetPlayerPed(source)
	local plyCoords = GetEntityCoords(plyPed, false)
	local dist = #(plyCoords - spawnCoords)
	local NamePlayer = GetPlayerName(source)

	if dist <= 25.0 then
		TriggerClientEvent('esx_identity:showRegisterIdentity', source)
		print("\n\nLe joueur ^1"..NamePlayer.."^7 à fait un /register.\nRaison : ^2"..raisonRegister.."^7\n\n")
		TriggerEvent('Players_register_perso_Logs', "9807270", "Un joueur c'est /REGISTER", "\n``Le joueur`` →  "..NamePlayer.."\n``ID In-Game`` →  ( "..source.." )\n``Raison`` →  "..raisonRegister.."")

	else
		TriggerClientEvent('esx:showAdvancedNotification', source, "AhéroChromeRP", "~r~AVERTISSEMENT",'~r~→ Action Impossible ←~s~\n~b~Vous devez être au spawn & prévenir un Staff~s~\n(~o~Sinon vous serez sanctionné~s~)' , 'CHAR_SOCIAL_CLUB', 7)
	end
end)

--TriggerEvent('es:addGroupCommand','dvrlebgchar', 'user', function(xPlayer, args, showError)
--	getIdentity(xPlayer.source, function(data)
--		if data.firstname == '' then
--			xPlayer.showNotification(_U('not_registered'))
--		else
--			xPlayer.showNotification(_U('active_character', data.firstname, data.lastname))
--		end
--	end)
--end, false)
--
--TriggerEvent('es:addGroupCommand','dvrchardel', 'user', function(xPlayer, args, showError)
--	getIdentity(xPlayer.source, function(data)
--		if data.firstname == '' then
--			xPlayer.showNotification(_U('not_registered'))
--		else
--			deleteIdentity(xPlayer.source)
--			xPlayer.showNotification(_U('deleted_character'))
--			TriggerClientEvent('esx_identity:showRegisterIdentity', xPlayer.source)
--		end
--	end)
--end, false)