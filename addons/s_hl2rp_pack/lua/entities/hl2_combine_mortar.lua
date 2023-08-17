
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Мортира"
ENT.Author			= "FiLzO"
ENT.Information		= ""
ENT.Category		= "Терминалы"

ENT.Spawnable		= true
ENT.AdminOnly		= true

if SERVER then

function ENT:Initialize()
	
	self:SetModel("models/weapons/shell.mdl")
	self:SetNoDraw(true)
	self:DrawShadow(false)
	
	self.mortarmodel = ents.Create("prop_dynamic")
	self.mortarmodel:SetKeyValue("StartDisabled", "0")
	self.mortarmodel:SetKeyValue("solid", "6")
	self.mortarmodel:SetKeyValue("model", "models/props_combine/combine_mortar01a.mdl")
	self.mortarmodel:SetKeyValue( "targetname", tostring(self.mortarmodel) )
	self.mortarmodel:SetPos(self:GetPos() + Vector(0,0,-10))
	self.mortarmodel:SetAngles(self:GetAngles())
	self.mortarmodel:Spawn()
	
	self.controlvol = ents.Create("trigger_multiple")
	self.controlvol:SetKeyValue("StartDisabled", "0")
	self.controlvol:SetKeyValue("rendermode", "10");
	self.controlvol:SetKeyValue( "targetname", tostring(self.controlvol) )
	self.controlvol:SetKeyValue( "rendermode" , "10")
	self.controlvol:SetKeyValue( "spawnflags" , "513")
	self.controlvol:SetKeyValue("model", "models/props_wasteland/cargo_container01.mdl")
	self.controlvol:SetPos(self:GetPos())
	self.controlvol:SetParent(self.mortarmodel)
	self.controlvol:Spawn()
	
    self.mortar = ents.Create("func_tankmortar")
	self.mortar:SetPos(self:GetPos())
	self.mortar:SetKeyValue("targetname" , tostring(self.mortar) )
	self.mortar:SetKeyValue("renderfx" , "0")
	self.mortar:SetKeyValue("rendermode" , "10")
	self.mortar:SetKeyValue("renderamt" , "255")
	self.mortar:SetKeyValue("rendercolor" , "255 255 255")
	self.mortar:SetKeyValue("disablereceiveshadows" , "0")
	self.mortar:SetKeyValue("disableshadows" , "0")
	self.mortar:SetKeyValue("yawrate" , "100")
	self.mortar:SetKeyValue("yawrange" , "180")
	self.mortar:SetKeyValue("yawtolerance" , "15")
	self.mortar:SetKeyValue("pitchrate" , "100")
	self.mortar:SetKeyValue("pitchrange" , "180")
	self.mortar:SetKeyValue("pitchtolerance" , "15")
	self.mortar:SetKeyValue("barrel" , "0")
	self.mortar:SetKeyValue("barrely" , "0")
	self.mortar:SetKeyValue("barrelz" , "16")
	self.mortar:SetKeyValue("spritescale" , "1")
	self.mortar:SetKeyValue("firerate" , "3")
	self.mortar:SetKeyValue("bullet_damage" , "20")
	self.mortar:SetKeyValue("bullet_damage_vs_player" , "20")
	self.mortar:SetKeyValue("persistence" , "1")
	self.mortar:SetKeyValue("persistence2" , "0")
	self.mortar:SetKeyValue("firespread" , "2")
	self.mortar:SetKeyValue("minRange" , "0")
	self.mortar:SetKeyValue("maxRange" , "9999")
	self.mortar:SetKeyValue("gun_yaw_pose_center" , "0")
	self.mortar:SetKeyValue("gun_pitch_pose_center" , "0")
	self.mortar:SetKeyValue("ammo_count" , "-1")
	self.mortar:SetKeyValue("LeadTarget" , "No")
	self.mortar:SetKeyValue("playergraceperiod" , "0")
	self.mortar:SetKeyValue("playerlocktimebeforefire" , "0")
	self.mortar:SetKeyValue("ignoregraceupto" , "768")
	self.mortar:SetKeyValue("effecthandling" , "0")
	self.mortar:SetKeyValue("iMagnitude" , "100")
	self.mortar:SetKeyValue("firedelay" , "1.2")
	self.mortar:SetKeyValue("warningtime" , "1")
	self.mortar:SetKeyValue("gun_barrel_attach" , tostring(self.mortarmodel) )
	self.mortar:SetKeyValue("firevariance" , "10")
	self.mortar:SetKeyValue("spawnflags" , "32865")
	self.mortar:SetKeyValue("model" , "models/props_c17/oildrum001.mdl")
	self.mortar:SetKeyValue("firestartsound" , "Weapon_Mortar.Single")
	self.mortar:SetKeyValue("incomingsound" , "Weapon_Mortar.Incomming")
	self.mortar:SetKeyValue("control_volume" , tostring(self.controlvol) )
	self.mortar:SetParent(self.mortarmodel)
	self.mortar:Spawn()

end
function ENT:Think()
	if !IsValid (self.mortar) then
	self:Remove()
	end
	if !IsValid (self.controlvol) then
	self:Remove()
	end
	if !IsValid (self.mortarmodel) then
	self:Remove()
	end
end
function ENT:OnRemove()
	if IsValid (self.mortar) then
	self.mortar:Remove()
	end
	if IsValid (self.controlvol) then
	self.controlvol:Remove()
	end
	if IsValid (self.mortarmodel) then
	self.mortarmodel:Remove()
	end
end
end