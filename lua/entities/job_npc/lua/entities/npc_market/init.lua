AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
	self:SetModel("models/player/zelpa/female_04_b_extended.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetHullSizeNormal()

	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()

	self:SetMaxYawSpeed(90)

	self:SetSequence("idle")
	util.AddNetworkString( "BuyFirstTovar" )
	util.AddNetworkString( "BuySecondTovar" )


end
util.AddNetworkString( "OpenSellerMenu" )

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		umsg.Start("OpenSellerMenu", Caller)
		umsg.End()
	end
end
 
function ENT:Think()
  
end


net.Receive( "BuyFirstTovar", function( len, ply )
	local weapon = "weapon_flash"
	local test = net.ReadString()
	if ply:canAfford(test) && !ply:HasWeapon( weapon ) then
		ply:addMoney(-test)
		ply:Give(weapon)
	else
		DarkRP.notify(ply, 1, 3, "У вас не хватает денег на это или у вас это уже есть.")
	end
end)