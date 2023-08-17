
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Огонь"
ENT.Author			= "FiLzO"
ENT.Information		= ""
ENT.Category		= "Терминалы"

ENT.Spawnable		= true
ENT.AdminOnly		= true

sound.Add( {
	name = "FireLoop.Play",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = { 100, 100 },
	sound = "ambient/fire/fire_small1.wav"
} )

C_FireSize = CreateConVar( "hl2_fire_size", "64", FCVAR_NOTIFY, "Fire size. Def: 64." )
C_FireGlow = CreateConVar( "hl2_fire_glow", "230", FCVAR_NOTIFY, "Fire glow size. Def: 230." )

if SERVER then

function ENT:Initialize()
	
	self:SetModel("models/Items/AR2_Grenade.mdl")
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self.fire = ents.Create("env_fire")
	self.fire:SetPos( self:GetPos())
	self.fire:SetAngles( self:GetAngles() )
	self.fire:SetKeyValue( "spawnflags", "1" )
	self.fire:SetKeyValue( "firesize", C_FireSize:GetInt() )
	self.fire:SetKeyValue( "firetype", "0" )
	self.fire:SetOwner( self.Owner )
	self.fire:SetParent(self)
	self.fire:Spawn()
	self.fire:Activate()
	local fire_name = "fire" .. self.fire:EntIndex()
	self.fire:SetName( fire_name )
	self.Start = false
	
	self.lighteffect = ents.Create("light_dynamic")
	self.lighteffect:SetPos( self:GetPos() )
	self.lighteffect:SetOwner( self:GetOwner() )
	self.lighteffect:SetParent(self)
	self.lighteffect:SetKeyValue( "_light", "255 85 0 255" )  
	self.lighteffect:SetKeyValue("distance", C_FireGlow:GetInt() )
	
end
function ENT:Think()
	if IsValid (self.fire) then
	timer.Simple(2, function()
	if IsValid (self.fire) and self.Start == false then
	self.Start = true
	self.fire:EmitSound("FireLoop.Play")
	self.fire:EmitSound("ambient/fire/ignite.wav", 100, 100)
	self.fire:Fire("StartFire")
	self.lighteffect:Spawn()
	end
	end)
	end
	if !IsValid (self.fire) then
	self.lighteffect:Fire( "Kill", 1, 0 )
	self.fire:StopSound("FireLoop.Play")
	self:Remove()
	end
end
function ENT:OnRemove()
	if IsValid (self.fire) then
	self.lighteffect:Fire( "Kill", 1, 0 )
	self.fire:StopSound("FireLoop.Play")
	self.fire:Remove()
	end
end
end