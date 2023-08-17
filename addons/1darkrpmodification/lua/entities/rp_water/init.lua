AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_takeoutcarton001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	
	timer.Simple(1000000000, function()
		if IsValid( self ) then
			self:Remove()
		end
	end)
end

function ENT:Use( activator )
	if activator:Team() == TEAM_ZOMBIE then activator:SendLua("GAMEMODE:AddNotify(\"Вы не можете использовать это будучи зомбированным!\", NOTIFY_GENERIC, 1)") return end
	activator:setSelfDarkRPVar( "Energy", math.Clamp( ( activator:getDarkRPVar("Energy") or 100 ) + math.floor(math.random(35, 35)), 0, 100 ) )
	activator:EmitSound("physics/metal/soda_can_impact_soft2.wav", 50, math.random(90,120))
	self:Remove() 
end

function ENT:OnTakeDamage( dmginfo )
	self:EmitSound("physics/metal/soda_can_impact_hard1.wav", 50, math.random(90,120))
	self:Remove()
end