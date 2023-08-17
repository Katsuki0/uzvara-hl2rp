if SERVER then util.AddNetworkString("SpawnFOV") end

function PlayerInitialSpawnNOCRP(ply)
	ply:SetNWBool("Fresh",true)
	net.Start( "SpawnFOV" )	
		net.WriteVector(ply:GetPos())
		net.WriteAngle(ply:GetAngles())
	net.Send(ply)
	umsg.Start( "SpawnMenu", ply )
	umsg.End( )
end
hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawnNOCRP", PlayerInitialSpawnNOCRP )

concommand.Add("openstartmenu", function( ply )
	umsg.Start( "SpawnMenu", ply )
	umsg.End( )
end)
