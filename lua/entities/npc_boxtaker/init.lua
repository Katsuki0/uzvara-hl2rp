/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/Humans/Group02/male_08.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetHullSizeNormal()

	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()

	self:SetMaxYawSpeed(90)
	self:SetSequence("idle")
end

function ENT:AcceptInput(ply, caller, activator)
	local sell =  math.random( 1, 1 )
    if IsValid( caller ) and caller:IsPlayer() then
		if(caller:GetNWBool("MRPJobBoxSystem") == true) then
			caller:SetNWBool("MRPJobBoxSystem",false)
			caller:addMoney(sell)
			caller:SendLua("GAMEMODE:AddNotify(\"Вы получили - "..sell.." KWD\", NOTIFY_GENERIC, 10)")
			caller:ConCommand( "say /me отдал коробку кладовщику")
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