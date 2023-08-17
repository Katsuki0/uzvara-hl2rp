/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_junk/cardboard_box003b.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:AcceptInput(ply, caller, activator)
    if IsValid( caller ) and caller:IsPlayer() then
		if(caller:Team() == TEAM_GRUZHCHIK) then
			if(caller:GetNWBool("MRPJobBoxSystem") == false) then
				caller:SetNWBool("MRPJobBoxSystem",true)
				caller:ConCommand( "say /me поднял коробку")
			end
		end
	end
end
 
function ENT:Think()

end
 
/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/