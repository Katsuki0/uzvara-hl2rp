/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/

hook.Add("PlayerDeath", "MRPJobBoxSystemDeath", function(ply)
	ply:SetNWBool("MRPJobBoxSystem", false)
end)

timer.Create( "TimerMRPJobBoxSystem", 0,0,function()
	for k,ply in pairs(player.GetAll()) do
		
		if(ply:GetNWBool("MRPJobBoxSystem")==true && ply:KeyDown(IN_SPEED))then
			ply:SetNWBool("MRPJobBoxSystem", false)
			ply:ConCommand( "say /me уронил коробку")
		end

		if(ply:GetNWBool("MRPJobBoxSystem")==true && ply:KeyDown(IN_JUMP)) then
			ply:SetNWBool("MRPJobBoxSystem", false)
			ply:ConCommand( "say /me уронил коробку")
		end
	end
end)

/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/