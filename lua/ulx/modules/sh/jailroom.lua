local CATEGORY_NAME = "jail"

------------------------------ Jail ------------------------------

function ulx.jailroom(ply, target, seconds, reason, unjail)
	for i=1, #target do
		if unjail == false then
			local v = target[i]
			JailRoom(v, seconds)
			if reason then
				local str = "#A teleported player #T to jailroom for #i seconds. Reason: #s"
				ulx.fancyLogAdmin(ply, str, target, seconds, reason)
			else
				local str = "#A teleported player #T to jail for #i seconds. Reason: not specified!"
				ulx.fancyLogAdmin(ply, str, target, seconds)
			end
		else
			local v = target[i]
			local str = "#A pulled player #T out of jailroom"
			ulx.fancyLogAdmin(ply, str, target)
			UnJail(v)
		end
	end
end
local jailroom = ulx.command(CATEGORY_NAME, "ulx jailroom", ulx.jailroom, "!jailroom")
jailroom:addParam{ type=ULib.cmds.PlayersArg }
jailroom:addParam{ type=ULib.cmds.NumArg, min=0, default=0, hint="seconds", ULib.cmds.round, ULib.cmds.optional }
jailroom:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine}
jailroom:addParam{ type=ULib.cmds.BoolArg, invisible=true }
jailroom:defaultAccess( ULib.ACCESS_ADMIN )
jailroom:help( "Sends the player to jail.by Lemos" )
jailroom:setOpposite( "ulx unroom", {_, _, _, _, true}, "!unroom" )



function JailRoom(ply, seconds, after_relog)
	if ply.jailed == true then return end
	ply.LastPos = ply:GetPos()
	ply.jailed = true
	ply.timer = seconds
	ply.RestrictWeapons = {}
	for _,ent in pairs (ply:GetWeapons()) do
		ply.RestrictWeapons[ent:GetClass()] = true
	end
	ply:SetPos(Vector(817.393311, -73.033020, 444.031250)) -- jail's position
	ply:StripWeapons()
	if timer.Exists(ply:UniqueID().."ulxJailTimer") then
		timer.Remove(ply:UniqueID().."ulxJailTimer")
	end
	timer.Create(ply:UniqueID().."ulxJailTimer",seconds,1,function ()
		if ply:IsValid() and after_relog == true then
			UnJail(ply, true)
		elseif ply:IsValid() then
			UnJail(ply)
		end
	end)
end

function UnJail(ply, after_relog)
	if ply.jailed == true then
		if after_relog == true then
			ply.jailed = false
			ply:Spawn()
			ply.LastPos = nil
			ply.RestrictWeapons = {}
		else
			ply.jailed = false
			ply:SetPos(ply.LastPos)
			ply.LastPos = nil
		end
		timer.Remove(ply:UniqueID().."ulxJailTimer")
		for k,v in pairs (ply.RestrictWeapons) do
			ply:Give(k)
		end
	end
end

hook.Add("PlayerSpawn","ulxSpawnInJailIfDead",function (ply)
	print ("Spawn hook")
	if ply.jailed == true then
		timer.Simple(1,function ()
			ply:SetPos(Vector(1873.590210, -1541.968750, 524.031250))
		end)
	end
end)


hook.Add("CanPlayerSuicide","ulxSuicedeCheck",function (ply)
	if ply.jailed == true then
		return false
	end
end)

hook.Add("PlayerSpawnProp","ulxBlockSpawnIfInJail",function (ply)
	if ply.jailed == true then
		return false
	end
end)

hook.Add("PlayerCanPickupWeapon","ulxJailPickUpWeapon",function (ply)
	if ply.jailed == true then
		return false
	end
end)

hook.Add("PlayerCanPickupItem","ulxPickUpRest",function (ply)
	if ply.jailed == true then
		return false
	end
end)


if SERVER then
	hook.Add("OnGamemodeLoaded","ulxDataLoad",function ()
		sql.Query("CREATE TABLE IF NOT EXISTS jailed(steamid VARCHAR(20) PRIMARY KEY, time BIGINT)")
	end)

	hook.Add("PlayerInitialSpawn","ulxDataLoadToPlayer",function (ply)
		if ply:IsValid() then
			local query = sql.Query("SELECT * FROM jailed WHERE steamid = "..sql.SQLStr(ply:SteamID()))
			if query then
				JailRoom(ply, query[1]['time'], true)
				sql.Query("DELETE FROM jailed WHERE steamid = '"..ply:SteamID().."'")
				timer.Simple(5,function ()
					ply:ChatPrint("You came out with servers with active punishment. Punishment returned!")
				end)
			end
		end
	end)

	hook.Add("PlayerDisconnected","ulxColumntIfNeed",function (ply)
		if ply.jailed == true then
			sql.Query( "INSERT INTO jailed ( steamid, time ) VALUES ( '" .. ply:SteamID() .. "', '"..ply.timer.."' )" )
			DarkRP.notifyAll(0,4,"The player under the nickname "..ply:Nick().." stormed down while serving his sentence. He will be punished at the first appearance")
		end
	end)

	concommand.Add("debug_jail_insert",function (ply,cmd ,arg )
		local query = sql.Query( "INSERT INTO jailed ( steamid, time ) VALUES ( '" .. ply:SteamID() .. "', '"..ply.timer.."' )" )
		-- PrintTable (query)
			print (query)
	end)

	concommand.Add("debug_jail",function (ply,cmd ,arg )
		local query = sql.Query("SELECT * FROM jailed WHERE steamid = "..sql.SQLStr(ply:SteamID()))
		-- PrintTable (query)
		print (query[1]['time'])
		print (query)
	end)

end