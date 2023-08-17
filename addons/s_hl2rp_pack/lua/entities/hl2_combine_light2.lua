
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Комбайн лама (Большая)"
ENT.Author			= "FiLzO"
ENT.Information		= ""
ENT.Category		= "Терминалы"

ENT.Spawnable		= true
ENT.AdminOnly		= false

if SERVER then

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_light001b.mdl")
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
		local FlashBase = ents.Create("env_projectedtexture")
		local Pos,Ang=self:GetBonePosition(0) --head
		local Right=Ang:Right()
		local Up=Ang:Up()
		local Forward=Ang:Forward()
		FlashBase:LookupBone(6)
		FlashBase:SetParent(self)
		FlashBase:SetPos(Pos-Forward*0+Right*0+Up*10)
		FlashBase:SetKeyValue('lightcolor', "147 226 240")
		FlashBase:SetKeyValue('lightfov', '110')
		FlashBase:SetKeyValue('farz', '1024')
		FlashBase:SetKeyValue('nearz', '2')
		FlashBase:SetKeyValue('shadowquality', '1')
		FlashBase:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
		Ang:RotateAroundAxis(Up,0)
		Ang:RotateAroundAxis(Right,180)
		Ang:RotateAroundAxis(Forward,0)
		Ang:RotateAroundAxis(Ang:Right(),0)
		FlashBase:SetAngles(Ang)
		FlashBase:Spawn()
		FlashBase:Activate()	
		self.lighteffect = ents.Create("light_dynamic")
		self.lighteffect:SetPos( self:GetPos() )
		self.lighteffect:SetOwner( self:GetOwner() )
		self.lighteffect:SetParent(self)
		self.lighteffect:SetKeyValue( "_light", "147 226 240 255" )  
		self.lighteffect:SetKeyValue("distance", "50" )
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
