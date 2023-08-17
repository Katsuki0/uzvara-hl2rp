AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	local mModels = {
		"models/props_junk/cardboard_box003a.mdl",
		"models/props_junk/cardboard_box004a.mdl",
		"models/props_lab/powerbox02c.mdl"
	}
	
	self:SetModel(table.Random(mModels))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	
	self:SetUseType( SIMPLE_USE )
	
	--
	self.LastUse = 0
	self.Delay = 5
	
	timer.Simple(300, function()
		if IsValid(self ) then
			self:Remove()
		end
	end)
	
end

function ENT:Use(activator)
	if self.LastUse <= CurTime() then
		self.LastUse = CurTime() + self.Delay

	end
end