Config = {}
Config.Locale = 'fr'

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money')
}

Config.StartingAccountMoney 	= {bank = 10000}

Config.EnableSocietyPayouts 	= true -- pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud            	= false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight            	= 50   -- the max inventory weight without backpack
Config.PaycheckInterval         = 7 * 60000 -- how often to recieve pay checks in milliseconds
Config.EnableDebug              = false -- Use Debug options?
Config.EnableDefaultInventory   = true -- Display the default Inventory ( F2 )
Config.EnableWantedLevel    	= true -- les flic sur le serveur
Config.EnablePVP                = true -- Allow Player to player combat

Config.Multichar                = false -- Enable support for esx_multicharacter
Config.Identity                 = false -- Select a characters identity data before they have loaded in (this happens by default with multichar)


-- Suplément :
Config.TimeSaveBdd = 5 -- temps en minutes pour sauvegarder la bdd
Config.DisableHealthRegeneration  = true -- Le joueur ne régénère plus sa santé
Config.DisableVehicleRewards      = true -- Désactive le fait que le joueur récupère les armes des véhicules
Config.DisableNPCDrops            = true -- empêche les PNJ de laisser tomber des armes à leur mort
Config.DisableWeaponWheel         = false -- Désactive la ROUELLETTE SOURIS et TAB d'arme par défaut
Config.DisableAimAssist           = false -- désactive l'assistance AIM (principalement sur les contrôleurs)
Config.RemoveHudCommonents = {
	[1] = false, --WANTED_STARS,
	[2] = false, --WEAPON_ICON
	[3] = false, --CASH
	[4] = false,  --MP_CASH
	[5] = false, --MP_MESSAGE
	[6] = false, --VEHICLE_NAME
	[7] = false,-- AREA_NAME
	[8] = false,-- VEHICLE_CLASS
	[9] = false, --STREET_NAME
	[10] = false, --HELP_TEXT
	[11] = false, --FLOATING_HELP_TEXT_1
	[12] = false, --FLOATING_HELP_TEXT_2
	[13] = false, --CASH_CHANGE
	[14] = false, --RETICLE
	[15] = false, --SUBTITLE_TEXT
	[16] = false, --RADIO_STATIONS
	[17] = false, --SAVING_GAME,
	[18] = false, --GAME_STREAM
	[19] = false, --WEAPON_WHEEL
	[20] = false, --WEAPON_WHEEL_STATS
	[21] = false, --HUD_COMPONENTS
	[22] = false, --HUD_WEAPONS
}
