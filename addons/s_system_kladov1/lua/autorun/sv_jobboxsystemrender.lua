/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/

hook.Add( "PostPlayerDraw" , "MRPJobBoxSystem" , function( ply )
	if IsValid(ply.JobBoxSystemMDL) then else ply.JobBoxSystemMDL = ClientsideModel( "models/props_junk/cardboard_box003b.mdl") end
	local JobBoxSystemMDL = ply.JobBoxSystemMDL
	JobBoxSystemMDL:SetNoDraw( true )
	
	local offsetvec = Vector( 0, 20, 0 )
	local offsetang = Angle( 0, -90, -90 )
	if(ply:GetNWBool("MRPJobBoxSystem") == true) then	
		local boneid = ply:LookupBone( "ValveBiped.Bip01_Spine2" )

		if not boneid then
			return
		end

		local matrix = ply:GetBoneMatrix( boneid )

		if not matrix then
			return
		end

		local newpos, newang = LocalToWorld( offsetvec, offsetang, matrix:GetTranslation(), matrix:GetAngles() )

		JobBoxSystemMDL:SetPos( newpos )
		JobBoxSystemMDL:SetAngles( newang )
		JobBoxSystemMDL:SetupBones()
		JobBoxSystemMDL:DrawModel()
	end
end)
/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/