function ulx.cleardecals(calling_ply)
	for k,v in pairs(player.GetAll()) do
		v:ConCommand("r_cleardecals")
	end
	ulx.fancyLogAdmin( calling_ply, "#A cleared decals.")
end
local cleardecals = ulx.command("Cleanup Kit", "ulx cleardecals", ulx.cleardecals, "!cleardecals")
cleardecals:defaultAccess( ULib.ACCESS_ADMIN )
cleardecals:help( "Убрать все декалии." )

function ulx.clearragdolls(calling_ply)
	for k,v in pairs(player.GetAll()) do
		v:SendLua([[for k,v in pairs(ents.FindByClass('class C_ClientRagdoll')) do v:Remove() end]])
	end
	ulx.fancyLogAdmin( calling_ply, "#A cleared clientside ragdolls.")
end
local clearragdolls = ulx.command("Cleanup Kit", "ulx clearragdolls", ulx.clearragdolls, "!clearragdolls")
clearragdolls:defaultAccess( ULib.ACCESS_ADMIN )
clearragdolls:help( "Убрать регдоллы на стороне клиента." )

function ulx.stopsound(calling_ply)
	for k,v in pairs(player.GetAll()) do
		v:SendLua([[RunConsoleCommand("stopsound")]])
	end
	ulx.fancyLogAdmin( calling_ply, "#A ran stopsound on all players.")
end
local stopsound = ulx.command("Cleanup Kit", "ulx stopsound", ulx.stopsound, "!stopsound")
stopsound:defaultAccess( ULib.ACCESS_ADMIN )
stopsound:help( "Запусть stopsound для всех игроков." )


function ulx.cleanprops(calling_ply,target_ply)
	for k,v in pairs(ents.FindByClass("prop_fix")) do
		if (v.Owner and v.Owner == target_ply) or (v.FPPOwnerID and v.FPPOwnerID == target_ply:SteamID()) then
			v:Remove()
		end
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A Удалил все пропы #T", target_ply )
end
local cleanprops = ulx.command("Cleanup Kit", "ulx cleanprops", ulx.cleanprops, "!cleanprops")
cleanprops:addParam{ type=ULib.cmds.PlayerArg }
cleanprops:defaultAccess( ULib.ACCESS_ADMIN )
cleanprops:help( "Удалить все пропы игроку." )

function ulx.cleanupall( calling_ply )

	for k, v in pairs(player.GetAll()) do
		v:SendLua([[ LocalPlayer():ConCommand("gmod_cleanup") ]])
	end
	ulx.fancyLogAdmin( calling_ply, "#A Удалил пропы всех игроков !" )
	
end
local cleanupall = ulx.command("Cleanup Kit", "ulx cleanupall", ulx.cleanupall, "!cleanupall" )
cleanupall:defaultAccess( ULib.ACCESS_ADMIN )
cleanupall:help( "Удалить все пропы игроков на сервере." )


function ulx.reconnect(calling_ply,target_ply)
	target_ply:SendLua([[RunConsoleCommand("retry")]])
	ulx.fancyLogAdmin( calling_ply, "#A reconnected #T", target_ply )
end
local reconnect = ulx.command("Cleanup Kit", "ulx reconnect", ulx.reconnect, "!reconnect")
reconnect:addParam{ type=ULib.cmds.PlayerArg }
reconnect:defaultAccess( ULib.ACCESS_ADMIN )
reconnect:help( "Релог игрока." )