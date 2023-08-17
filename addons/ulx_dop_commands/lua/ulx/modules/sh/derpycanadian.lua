local CATEGORY_NAME = "DerpyCanadian's Commands"

function ulx.respawn( calling_ply, target_ply )
    if not target_ply:Alive() then
	    target_ply:Spawn()
		ulx.fancyLogAdmin( calling_ply, true, "#A Respawned #T", target_ply )
	end
end

local respawn = ulx.command( CATEGORY_NAME, "ulx respawn", ulx.respawn,
"!respawn", true )
respawn:addParam{ type=ULib.cmds.PlayerArg }
respawn:defaultAccess( ULib.ACCESS_ADMIN )
respawn:help( "Respawns target player" )

function ulx.addons( calling_ply )

	calling_ply:SendLua([[gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=753434873" )]])
	
end

local addons = ulx.command( CATEGORY_NAME, "ulx addons", ulx.addons,
 "!addons", true )
addons:defaultAccess( ULib.ACCESS_ALL )
addons:help( "View addon information." )

function ulx.cleanup( calling_ply )

	game.CleanUpMap()
	
	ulx.fancyLogAdmin( calling_ply, "#A Cleaned Up Everything" )
	
end
local cleanup = ulx.command( CATEGORY_NAME, "ulx cleanup", ulx.cleanup, "!cleanup" )
cleanup:defaultAccess( ULib.ACCESS_SUPERADMIN )
cleanup:help( "Cleans Up All Props, Entities Etc." )


function ulx.ipban( calling_ply, minutes, ip )

	if not ULib.isValidIP( ip ) then
	
		ULib.tsayError( calling_ply, "Invalid ip address." )
		
		return
		
	end

	local plys = player.GetAll()
	
	for i=1, #plys do
	
		if string.sub( tostring( plys[ i ]:IPAddress() ), 1, string.len( tostring( plys[ i ]:IPAddress() ) ) - 6 ) == ip then
			
			ip = ip .. " (" .. plys[ i ]:Nick() .. ")"
			
			break
			
		end
		
	end

	RunConsoleCommand( "addip", minutes, ip )
	RunConsoleCommand( "writeip" )

	ulx.fancyLogAdmin( calling_ply, true, "#A banned ip address #s for #i minutes", ip, minutes )
	
	if ULib.fileExists( "cfg/banned_ip.cfg" ) then
		ULib.execFile( "cfg/banned_ip.cfg" )
	end
	
end
local ipban = ulx.command( CATEGORY_NAME, "ulx ipban", ulx.ipban )
ipban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.allowTimeString, min=0 }
ipban:addParam{ type=ULib.cmds.StringArg, hint="address" }
ipban:defaultAccess( ULib.ACCESS_SUPERADMIN )
ipban:help( "Bans ip address." )

hook.Add( "Initialize", "ipbans", function()
	if ULib.fileExists( "cfg/banned_ip.cfg" ) then
		ULib.execFile( "cfg/banned_ip.cfg" )
	end
end )

function ulx.ipunban( calling_ply, ip )

	if not ULib.isValidIP( ip ) then
	
		ULib.tsayError( calling_ply, "Invalid ip address." )
		
		return
		
	end

	RunConsoleCommand( "removeip", ip )
	RunConsoleCommand( "writeip" )

	ulx.fancyLogAdmin( calling_ply, true, "#A unbanned ip address #s", ip )
	
end
local ipunban = ulx.command( CATEGORY_NAME, "ulx ipunban", ulx.ipunban )
ipunban:addParam{ type=ULib.cmds.StringArg, hint="address" }
ipunban:defaultAccess( ULib.ACCESS_SUPERADMIN )
ipunban:help( "Unbans ip address." )


function ulx.getip( calling_ply, target_ply )

	calling_ply:SendLua([[SetClipboardText("]] .. tostring(string.sub( tostring( target_ply:IPAddress() ), 1, string.len( tostring( target_ply:IPAddress() ) ) - 6 )) .. [[")]])

	ulx.fancyLog( {calling_ply}, "IP Address of #T Copied", target_ply )
	
end
local getip = ulx.command( CATEGORY_NAME, "ulx getip", ulx.getip, "!getip", true )
getip:addParam{ type=ULib.cmds.PlayerArg }
getip:defaultAccess( ULib.ACCESS_SUPERADMIN )
getip:help( "Copies a player's IP address." )
