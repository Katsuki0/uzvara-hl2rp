AddCSLuaFile("shared.lua")
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_metalcan002a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self.health = 10
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmg)
	self.health = self.health - dmg:GetDamage()
	if ( self.health <= 0 ) then
		self:Remove()
	end
end
function ENT:Use(activator, caller)
    caller:setSelfDarkRPVar("Energy", math.Clamp((caller:getDarkRPVar("Energy") or 0) + 100, 0, 100))
    umsg.Start("AteFoodIcon", caller)
    umsg.End()

    self:Remove()
    activator:EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav", 100, 100)
end

function ENT:OnRemove()
end
