
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Комбайн лама (Настенная)"
ENT.Author			= "FiLzO"
ENT.Information		= ""
ENT.Category		= "Half-Life 2"

ENT.Spawnable		= true
ENT.AdminOnly		= false

if SERVER then

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_light002a.mdl")
	self:SetNoDraw(false)
	self:DrawShadow(true)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	local phys1 = self:GetPhysicsObject()
	
if ( IsValid( phys1 ) ) then
	
	phys1:Sleep()

end

timer.Simple(1, function()
		if IsValid (self) then
		self:EmitSound("buttons/lightswitch2.wav", 100, 100)
		self.lighteffect = ents.Create("light_dynamic")
		self.lighteffect:SetPos( self:GetPos() )
		self.lighteffect:SetOwner( self:GetOwner() )
		self.lighteffect:SetParent(self)
		self.lighteffect:SetKeyValue( "_light", "147 226 240 255" )  
		self.lighteffect:SetKeyValue("distance", "500" )
		self.lighteffect:Spawn()		
		end
		end)

end
function ENT:Think()
end
function ENT:OnRemove()
if IsValid (self.lighteffect) then
	self.lighteffect:Fire( "Kill", 1, 0 )
	end
end
end
