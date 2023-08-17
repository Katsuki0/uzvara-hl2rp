
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Фонарь"
ENT.Author			= "FiLzO"
ENT.Information		= ""
ENT.Category		= "Терминалы"

ENT.Spawnable		= true
ENT.AdminOnly		= false

sound.Add( {
	name = "SpotlightOnOff.Play",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = { 100, 100 },
	sound = "light.wav"
} )

C_SpotLenght = CreateConVar( "hl2_spotlight_lenght", "1024", FCVAR_NOTIFY, "Spotlight lenght. Def: 1024." )
C_SpotWidth = CreateConVar( "hl2_spotlight_width", "50", FCVAR_NOTIFY, "Spotlight width. Def: 50." )

if SERVER then

function ENT:Initialize()
	
	self:SetModel("models/props_wasteland/light_spotlight01_lamp.mdl")
	self:SetNoDraw(false)
	self:DrawShadow(true)
	self:SetSkin(0)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self.spotlight = ents.Create("point_spotlight")
	self.spotlight:SetPos( self:GetPos() + Vector(0,0,4) )
	self.spotlight:SetAngles( self:GetAngles() )
	self.spotlight:SetKeyValue( "spawnflags", "1" )
	self.spotlight:SetKeyValue( "spotlightlength", C_SpotLenght:GetInt() )
	self.spotlight:SetKeyValue( "spotlightwidth", C_SpotWidth:GetInt() )
	self.spotlight:SetOwner( self.Owner )
	self.spotlight:SetParent(self)
	self.spotlight:Spawn()
	self.spotlight:Activate()
	local spotlight_name = "spotlight" .. self.spotlight:EntIndex()
	self.spotlight:SetName( spotlight_name )
	self.Start = false
end
function ENT:Think()
	if IsValid (self.spotlight) then
	end
	if !IsValid (self.spotlight) then
	self:Remove()
	end
end

function ENT:Use(activator)
if activator:IsPlayer() then
if self.Active == true then
self.Active = false
self.spotlight:Fire("lighton")
self:EmitSound("SpotlightOnOff.Play")
self:SetSkin(0)
else
self.Active = true
self.spotlight:Fire("lightoff")
self:EmitSound("SpotlightOnOff.Play")
self:SetSkin(1)
end
end
end

function ENT:OnRemove()
	if IsValid (self.spotlight) then
	self.spotlight:SetParent()
	self.spotlight:Fire("lightoff")
	self.spotlight:Fire("kill",self.spotlight, 0.5)
end
end
end