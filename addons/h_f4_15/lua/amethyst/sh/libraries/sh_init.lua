/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


Amethyst = Amethyst or {}

local Player = FindMetaTable( "Player" )

function Player:PStats_Save()
	if not self:IsValid() then
		if Amethyst.Settings.Devmode.Enabled then
			Amethyst:AddDevLog("Save Failed: Invalid player referenced", 2, true)
		end
		return
	end
	if not Amethyst.Settings.StatsEnabled then return end

	local PStats_Steam64 	= self:SteamID64()
	local PStats_Table 		= { steamid = steamid }
	PStats_Table.PStats 	= self.PStats
	local PStats_Data 		= glon.encode( PStats_Table )

	file.Write( Amethyst.Script.PathPStats .. "/" .. PStats_Steam64 .. ".txt", PStats_Data )

	if Amethyst.Settings.Devmode.Enabled then
		Amethyst:AddDevLog("Saved player statistics to file", 3, false)
	end
end

function Player:PStats_Add( strAction, intValue )
	if CLIENT then return end
	if not Amethyst.Settings.StatsEnabled then return end
	strAction = string.lower( strAction )
	intValue = intValue or 1

	self.PStats = self.PStats or {}
	if !self.PStats[strAction] then
		self.PStats[strAction] = 0
	end
	self.PStats[strAction] = self.PStats[strAction] + intValue
end

function Player:PStats_Get( strAction, default )
	self.PStats = self.PStats or {}
	strAction = string.lower( strAction )

	if !self.PStats[strAction] then
		self.PStats[strAction] = default
	end
	return self.PStats[strAction]
end

function Player:PStats_Set( strAction, intValue )
	if CLIENT then return end
	if not Amethyst.Settings.StatsEnabled then return end
	strAction = string.lower( strAction )

	self.PStats = self.PStats or {}
	if !self.PStats[strAction] then
		self.PStats[strAction] = 0
	end
	self.PStats[strAction] = intValue
end

function Player:PStats_Call()
	return self.PStats or {}
end

if SERVER then
	function Player:PStats_Send( ply )
		self.PStats = self.PStats or {}
		Amethyst:PStats_SendStats( ply, self )
	end

	concommand.Add( "pstats_requestdata",
	function( ply, _, args )
		local ent = Entity( tonumber(args[1]) )
		if IsValid( ent ) then
			ent:PStats_Send( ply )
		end
	end )
end

function Amethyst:RegisterPlugin( tblPlugin )

	if not tblPlugin then
		rLib.logs.register( 4, true, "Register Plugin-> table not specified." )
		return
	end

	local checkRegistered = false
	for k, v in pairs( Amethyst.Plugins ) do
		if ( v.Name == tblPlugin.Name ) then
			checkRegistered = true
			break
		end
	end

	if checkRegistered then return end

	table.insert( Amethyst.Plugins, tblPlugin )
	rLib.logs.register( 1, false, "Plugin [%s] detected.", tblPlugin.Name )
end
hook.Add( "xtask.plugins.register", "xtask.plugins.register", Amethyst.RegisterPlugin )

function Amethyst:SendNotification( ply, ntype, playeronly, message )

	if !message then return end

	ntype = ntype or 1
	playeronly = playeronly or false

	if playeronly then
		net.Start("Amethyst_SendNotification")
			net.WriteUInt(ntype, 4)
			net.WriteBool(playeronly)
			net.WriteString(message)
		net.Send(ply)
	else
		net.Start("Amethyst_SendNotification")
			net.WriteUInt(ntype, 4)
			net.WriteBool(playeronly)
			net.WriteString(message)
		net.Broadcast()
	end

end

local function PStats_KeyActions(ply, key)
	if Amethyst.Settings.StatsEnabled then
		if key == IN_JUMP then
			ply:PStats_Add( "action_jumps", 1 )
		elseif key == IN_DUCK then
			ply:PStats_Add( "action_duck", 1 )
		elseif key == IN_RELOAD then
			ply:PStats_Add( "action_reloads", 1 )
		elseif key == IN_USE then
			ply:PStats_Add( "action_use", 1 )
		end
	end
end
hook.Add( "KeyPress", "PStats_KeyActions", PStats_KeyActions )

local function PStats_Footsteps(ply, pos, foot, sound, volume, rf)
	if Amethyst.Settings.StatsEnabled then
		ply:PStats_Add( "action_steps", 1 )
	end
end
hook.Add( "PlayerFootstep", "PStats_Footsteps", PStats_Footsteps )

function Amethyst:PStats_EntityFireBullets( ply, tbl )
	if (IsValid(ply) and ply:IsPlayer()) and (Amethyst.Settings.StatsEnabled) then
		ply:PStats_Add( "action_bulletsfired", 1 )
	end
end
hook.Add( "EntityFireBullets", "PStats_EntityFireBullets", function( ply, tbl ) Amethyst:PStats_EntityFireBullets( ply, tbl ) end )

function Amethyst:PrecacheModels()
    for k, v in ipairs( RPExtraTeams ) do
        if type( v.model ) == "table" then
            for k, model in pairs( v.model ) do
                util.PrecacheModel( model )
                if Amethyst.Settings.Devmode.Enabled then
                    Amethyst:AddDevLog("Precached player model ["..  model .. "]", 3, false)
                end
            end
        else
            util.PrecacheModel( v.model )
            if Amethyst.Settings.Devmode.Enabled then
                Amethyst:AddDevLog("Precached player model ["..  v.model .. "]", 3, false)
            end
        end
    end
    MsgC(Color( 0, 255, 0 ),  "[" .. Amethyst.Script.Name .."] Precache Complete \n")
end
hook.Add( "InitPostEntity", "PrecacheModels", Amethyst.PrecacheModels )

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/