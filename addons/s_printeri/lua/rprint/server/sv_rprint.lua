
rPrint.RegisterEventCallback( "PostConfigLoaded", "sv_rprint_install_cleanup", function()
	if rPrint.RemovePrintersOnDisconnect then
		timer.Create( "sv_rprint_cleanup_printers", 5, 0, function()
			for _, ent in pairs( ents.GetAll() ) do
				if IsValid( ent ) and ent.Base == "rprint_base" and ent.Getowning_ent and !IsValid( ent:Getowning_ent() ) then
					ent:Remove()
				end
			end
		end )
	else
		hook.Add( "PlayerInitialSpawn", "sv_rprint_reassign_printers", function( ply )
			local sid = ply:SteamID()

			for _, ent in pairs( ents.GetAll() ) do
				if IsValid( ent ) and ent.Base == "rprint_base" and ent.OwnerSteamID == sid then
					ent:Setowning_ent( ply )
				end
			end
		end )
	end
end )


function rPrint.CanAfford( ply, amt )
	local func = ply.CanAfford or ply.canAfford

	return func and func( ply, amt )
end

function rPrint.AddMoney( ply, amt )
	local func = ply.AddMoney or ply.addMoney

	if func then
		func( ply, amt )
	end
end
