--------------------------------------------------------------------------------------------------]]

Amethyst = Amethyst or {}

--[[ -----------------------------------------------------------------------------------------------

					NETWORK STRINGS

@desc: 				Setup all script network strings.
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

util.AddNetworkString("SendMessageToPlayer")
util.AddNetworkString("AmethystMessageSet")
util.AddNetworkString("Amethyst_PushNotification")
util.AddNetworkString("Amethyst_PStats")
util.AddNetworkString("Amethyst_DebugAdd")
util.AddNetworkString("Amethyst_FetchLogs")

local Player = FindMetaTable( "Player" )

function Amethyst:Broadcast(...)
	local args = {...}
	net.Start( "AmethystMessageSet" )
	net.WriteTable( args )
	net.Broadcast()
end

function Player:PlayerMsg(...)
	local args = {...}
	net.Start( "AmethystMessageSet" )
	net.WriteTable( args )
	net.Send( self )
end

function Player:SendMessage(...)
	local args = {...}
	net.Start( "SendMessageToPlayer" )
	net.WriteTable( args )
	net.Send( self )
end

function Amethyst:PStats_SendStats( pl, pPlayer )
	net.Start( "Amethyst_PStats" )
	net.WriteEntity( pPlayer )
	net.WriteTable( pPlayer.PStats )
	net.Send( pl )
end



--[[ -----------------------------------------------------------------------------------------------

					FUNCTION -> PLAYER DATA SETUP

@desc: 				Checks for player statistics folder when the server is booted.
@conditions:		None
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

function Amethyst:PDataSetup()
	local FetchLogsPath = Amethyst.Script.PathLogs or "amethyst/logs"
	local FetchPStatsPath = Amethyst.Script.PathPStats or "amethyst/pstats"

	if not file.Exists( Amethyst.Script.Folder, "DATA" ) then
		file.CreateDir( Amethyst.Script.Folder )
	end

	if not file.Exists( FetchLogsPath, "DATA" ) then
		file.CreateDir( FetchLogsPath )
		if Amethyst.Settings.Devmode.Enabled then
			Amethyst:AddDevLog("Directory " .. FetchLogsPath .. " created successfully.", 3, true)
		end
	end

	if not file.Exists( FetchPStatsPath, "DATA" ) then
		file.CreateDir( FetchPStatsPath )
		if Amethyst.Settings.Devmode.Enabled then
			Amethyst:AddDevLog("Directory " .. FetchPStatsPath .. " created successfully.", 3, true)
		end
	end
end
Amethyst:PDataSetup()

--[[ -----------------------------------------------------------------------------------------------

					HOOK -> PlayerInitialSpawn

@desc: 				Checks for player statistics file on player initial spawn
					Saves action_connections each time a player connects to the server.
@conditions:		Amethyst.Settings.StatsEnabled = true
@params 			ent( ply )
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

function Amethyst:PlayerJoin( ply )
	if not IsValid(ply) then return end

	if Amethyst.Settings.StatsEnabled and Amethyst.Settings.StatsKeepLifetime then
		local fetchPStats_path = Amethyst.Script.PathPStats .. "/" .. ply:SteamID64() .. ".txt"

		if not file.Exists( fetchPStats_path, "DATA" ) then
			for k, v in pairs(Amethyst.Settings.StatsList) do
				ply:PStats_Add( k, 0 )
			end
			if Amethyst.Settings.Devmode.Enabled then
				Amethyst:AddDevLog("Created new statistics file for player ["..  ply:Nick() .. ":@STEAMID_"..  ply:SteamID64() .. "]", 3, true)
			end
			ply:PStats_Save()
		end

		local fetchPData_src 	= file.Read( fetchPStats_path, "DATA" ) or ""
		local fetchPData 		= glon.decode( fetchPData_src ) or {}
		ply.PStats 	= fetchPData.PStats
	end

	if Amethyst.Settings.StatsEnabled then
		ply:PStats_Add( "action_connections", 1 )
	end

end
hook.Add( "PlayerInitialSpawn", "Amethyst:PlayerJoin", function( ply ) Amethyst:PlayerJoin( ply ) end )

--[[ -----------------------------------------------------------------------------------------------

					HOOK -> PlayerDeath

@desc: 				Saves kills and deaths for a player.
@conditions:		Amethyst.Settings.StatsEnabled = true
@params 			ent( ply ), ent( inflictor), ent( attacker )
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

function Amethyst:PlayerDeath( ply, inflictor, attacker )
	if not IsValid(ply) then return end
	if not Amethyst.Settings.StatsEnabled then return end

	ply:PStats_Add( "action_deaths", 1 )
	if IsValid( attacker ) and attacker:IsPlayer() and ply != attacker and ply:IsPlayer() then
		attacker:PStats_Add( "action_kills", 1 )
	end
end
hook.Add( "PlayerDeath", "Amethyst:PlayerDeath", function( ply, inflictor, attacker ) Amethyst:PlayerDeath( ply, inflictor, attacker ) end )

--[[ -----------------------------------------------------------------------------------------------

					HOOK -> PlayerHurt

@desc: 				Saves damage inflicted and damage taken within PlayerHurt hook.
@conditions:		Amethyst.Settings.StatsEnabled = true
@params 			ent( ply ), ent( attacker), int( healthRemaining ), int( damagetaken )
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

function Amethyst:PlayerHurt( ply, attacker, healthRemaining, damageTaken )
	if not IsValid(ply) then return end
	if not Amethyst.Settings.StatsEnabled then return end

	ply:PStats_Add( "action_damagetaken", math.floor(damageTaken) )
	if IsValid( attacker ) and attacker:IsPlayer() then
		attacker:PStats_Add( "action_damageinf", math.floor(damageTaken) )
	end
end
hook.Add( "PlayerHurt", "Amethyst:PlayerHurt", function( ply, attacker, healthRemaining, damageTaken ) Amethyst:PlayerHurt( ply, attacker, healthRemaining, damageTaken ) end )

--[[ -----------------------------------------------------------------------------------------------

					HOOK -> PlayerDisconnect

@desc: 				Save player statistics when player disconnects from server.
@conditions:		Amethyst.Settings.StatsEnabled = true
@params 			ent( ply )
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

function Amethyst:PlayerDisconnect( ply )
	if not IsValid(ply) then return end

	if Amethyst.Settings.StatsEnabled then
		ply:PStats_Save()
	end
end
hook.Add( "PlayerDisconnect", "Amethyst:PlayerDisconnect", function( ply ) Amethyst:PlayerDisconnect( ply ) end )

--[[ -----------------------------------------------------------------------------------------------

					HOOK -> OnPlayerChnagedTeam

@desc: 				Count how many times a person has changed teams.
@conditions:		Amethyst.Settings.StatsEnabled = true
@params 			ent( ply )
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

function Amethyst:OnPlayerChangedTeam( ply )
	if not IsValid(ply) then return end

	if Amethyst.Settings.StatsEnabled then
		ply:PStats_Add( "action_jobswitches", 1 )
	end
end
hook.Add( "OnPlayerChangedTeam", "Amethyst:OnPlayerChangedTeam", function( ply ) Amethyst:OnPlayerChangedTeam( ply ) end )

--[[ -----------------------------------------------------------------------------------------------

					HOOK -> PlayerSay -> RecordPlayerMessages

@desc: 				Counts how many messages a player has sent to other players.
@conditions: 		Any messages seen as commands starting in ! will be ignored.
					String must be larger than 1 character.
					Amethyst.Settings.StatsEnabled = true
@params 			ent( ply ), str( text )
@assoc 				Server
--------------------------------------------------------------------------------------------------]]

local function RecordPlayerMessages(ply, text)
	if not IsValid(ply) or not text then return end

	local ChatString 	= string.sub(string.lower(text), 1, 1)
	local ChatLen 		= string.len( text )

	if ChatString != "!" and ChatLen > 1 then
		if Amethyst.Settings.StatsEnabled then
			ply:PStats_Add( "action_messages", 1 )
		end
	end
end
hook.Add( "PlayerSay", "RecordPlayerMessages", RecordPlayerMessages )

--[[ -----------------------------------------------------------------------------------------------

					DEBUG -> ADD ENTRY

@desc: 				Counts how many messages a player has sent to other players.
@conditions: 		Any messages seen as commands starting in ! will be ignored.
					String must be larger than 1 character.
					Amethyst.Settings.StatsEnabled = true
@params 			int( len), ent( ply )
@assoc 				Server
--------------------------------------------------------------------------------------------------]]

net.Receive("Amethyst_DebugAdd", function( len, ply )

	local DataTheme 	= net.ReadString()
	local DataID 		= net.ReadString()
	local DataDefault 	= net.ReadString()

	Amethyst:AddDevLog("Missing Object in theme [" .. DataTheme .. "] Cannot find:" .. DataID, 2, true)

end)

--[[ -----------------------------------------------------------------------------------------------

					DEBUG -> FETCH LOGS

@desc: 				Counts how many messages a player has sent to other players.
@conditions: 		Any messages seen as commands starting in ! will be ignored.
					String must be larger than 1 character.
					Amethyst.Settings.StatsEnabled = true
@params 			int( len), ent( ply )
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

net.Receive("Amethyst_FetchLogs", function( len, ply )

	if IsValid(ply) then

		local fetchSavePath 	= Amethyst.Script.PathLogs or "amethyst/logs"

		local doLogSplice 		= 1
		local dateFormat 		= os.date(Amethyst.Settings.Devmode.FolderFormat or "%m-%d-%Y")
		local logFormat 		= os.date(Amethyst.Settings.Devmode.LogFormat or "%I:%M:%S")
		local FetchLogMaxSize 	= 16 * 16

		if (file.IsDir(fetchSavePath .. "/" .. dateFormat, "DATA")) then
			local files = file.Find(fetchSavePath .. "/" .. dateFormat .. "/*.txt", "DATA")

			if (table.Count(files) > 0) then
				local FetchLogSize = file.Size(fetchSavePath .. "/" .. dateFormat .. "/log_" .. #files .. ".txt", "DATA")

				if (FetchLogSize >= FetchLogMaxSize) then
					doLogSplice = table.Count(files) + 1
				end
			end
		else
			file.CreateDir(fetchSavePath .. "/" .. dateFormat, "DATA")
		end

		local LogFile = fetchSavePath .. "/" .. dateFormat .. "/log_" .. doLogSplice .. ".txt"
		if (file.Exists(LogFile, "DATA")) then

			local content = file.Read(LogFile, "DATA")
			local CompiledTable = string.Explode("\n", content)

			local ent = net.ReadEntity()
			net.Start( "Amethyst_FetchLogs")
			net.WriteEntity( ply )
			net.WriteTable( CompiledTable )
			net.Send( ply )
		end

	end

end )

--[[ -----------------------------------------------------------------------------------------------

					DEBUG -> NOTIFICATION SYSTEM

@desc: 				Counts how many messages a player has sent to other players.
@conditions: 		Any messages seen as commands starting in ! will be ignored.
					String must be larger than 1 character.
					Amethyst.Settings.StatsEnabled = true
@params 			int( len), ent( ply )
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

net.Receive("Amethyst_PushNotification", function( len, ply )

	if ( ply.NotificationCooldown or 0 ) > CurTime() then ply:ChatPrint( "[Amethyst] You cannot send another notification this quickly! Wait ".. math.Round( ply.NotificationCooldown - CurTime() ) .." seconds!" ) return end

	local ntype 		= net.ReadUInt(4)
	local playeronly 	= net.ReadBool()
	local title 		= net.ReadString()
	local message 		= net.ReadString()
	local delay 		= net.ReadInt(5) or 10

	if message and message == "" or !message then return end

	ntype = ntype or 1
	playeronly = playeronly or false

	if playeronly then
		net.Start("Amethyst_PushNotification")
			net.WriteEntity(ply)
			net.WriteUInt(ntype, 4)
			net.WriteBool(playeronly)
			net.WriteString(title)
			net.WriteString(message)
			net.WriteUInt(delay, 5)
		net.Send(ply)
	else
		net.Start("Amethyst_PushNotification")
			net.WriteEntity(ply)
			net.WriteUInt(ntype, 4)
			net.WriteBool(playeronly)
			net.WriteString(title)
			net.WriteString(message)
			net.WriteUInt(delay, 5)
		net.Broadcast()
	end

	ply.NotificationCooldown = CurTime() + (Amethyst.Settings.Notifications.CooldownTimer or 60)

end )

--[[ -----------------------------------------------------------------------------------------------

					PLAYER STATISTICS -> AUTO-SAVE

@desc: 				Saves player statistics every [x] seconds
@conditions: 		Amethyst.Settings.StatsEnabled = true
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

local DataSaveLast = 0
local DataSaveDelay = Amethyst.Settings.StatsSaveTimer or 120
local function PlayerData_Save()
	if not Amethyst.Settings.StatsEnabled then return end
	local doTimeNow = CurTime()
	if doTimeNow - DataSaveLast >= DataSaveDelay then
		for _, v in ipairs( player.GetHumans() ) do
			v:PStats_Save()
		end
		DataSaveLast = doTimeNow
	end
end
hook.Add( "Think", "PData_Save", PlayerData_Save )

--[[ -----------------------------------------------------------------------------------------------

					PLAYER STATISTICS -> SHUTDOWN

@desc: 				Saves player statistics once a server shutdown is toggled.
@conditions: 		Amethyst.Settings.StatsEnabled = true
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

function Amethyst:Shutdown()
	if not Amethyst.Settings.StatsEnabled then return end
	for _, v in ipairs( player.GetHumans() ) do
		v:PStats_Save()
	end
end
hook.Add( "ShutDown", "Amethyst:Shutdown", function( ) Amethyst:Shutdown( ) end )

--[[ -----------------------------------------------------------------------------------------------

					PLAYER STATISTICS -> FORCE-SAVE

@desc: 				Forces server to save all players statistics on the fly.
@conditions: 		Amethyst.Settings.StatsEnabled = true
@params 			ent( ply )
@usage 				[Console] -> amethyst_pstats_save
@assoc 				Server

--------------------------------------------------------------------------------------------------]]

local function PStats_ForceSave( ply )
	local ranByConsole = ply:EntIndex() == 0 and true or false

	if not Amethyst.Settings.StatsEnabled then
		if Amethyst.Settings.Devmode.Enabled then
			Amethyst:AddDevLog("Save failed [statistics disabled in config]", 3, true)
		end
		return
	end

	if (IsValid( ply ) and ply:IsAdmin()) or (ranByConsole) then
		for _, v in ipairs( player.GetHumans() ) do
			v:PStats_Save()
		end

		if Amethyst.Settings.Devmode.Enabled then
			local doSaveSuccess = "Force saved player statistics to file by"
			if ranByConsole then
				Amethyst:AddDevLog(doSaveSuccess .. " [CONSOLE]", 3, true)
			else
				Amethyst:AddDevLog(doSaveSuccess .. " ["..  ply:Nick() .. ":@STEAMID_"..  ply:SteamID64() .. "]", 3, true)
			end
		end
	else
		if Amethyst.Settings.Devmode.Enabled then
			Amethyst:AddDevLog("Force save failed [player who wanted to save was either not a valid player or not an admin]", 2, true)
		end
	end
end
concommand.Add( "amethyst_pstats_save", PStats_ForceSave )

function Amethyst.GetLatestBuild( ply )

	local ranByConsole = ply:EntIndex() == 0 and true or false

    http.Fetch( Amethyst.Script.UpdateCheck,
		function( body, len, headers, code )
			local entry 			= util.JSONToTable( body )
			local releaseTable 		= entry[string.lower(Amethyst.Script.Name)]["update"][1]
			local release_date 		= releaseTable["release"]
			local release_version 	= releaseTable["version"]
			local release_sf_id 	= releaseTable["sf_id"]

			ply:PlayerMsg( Amethyst.Messages.BCColorServer or Color( 255, 0, 0 ), "[PRIVATE] ", Amethyst.Messages.BCColorName or Color( 77, 145, 255 ), "[" .. Amethyst.Script.Name .. "]", Amethyst.Messages.BCColorMsg or Color( 255, 255, 255 ), " Latest Version " .. release_version .. " | Current Version " .. Amethyst.Script.Build )

		end,
		function( error )
			ply:PlayerMsg( Amethyst.Messages.BCColorServer or Color( 255, 0, 0 ), "[PRIVATE] ", Amethyst.Messages.BCColorName or Color( 77, 145, 255 ), "[" .. Amethyst.Script.Name .. "]", Amethyst.Messages.BCColorMsg or Color( 255, 255, 255 ), " Could not gather update information. Please try again later." )
		end
	)

end
concommand.Add( "amethyst_version", function( ply ) Amethyst.GetLatestBuild( ply ) end )

--[[ PLAYER SAY ------------------------------------------------------------------------------------
Activated when a script chat command is input.
--------------------------------------------------------------------------------------------------]]

hook.Add("PlayerSay","Amethyst.Request",function( ply, text )
	local text = string.lower(text)
	if text == "!buy" then
		ply:ConCommand("amethyst")
		return false
	end
end)