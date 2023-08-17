AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	local mModels = {
		"models/props_lab/box01a.mdl"
	}

	self:SetModel(table.Random(mModels))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()	
	self:SetNWInt("RWater", 0)
	self:SetNWInt("RFood", 0)
	
	-- предотвращение абуза
	self:SetUseType( SIMPLE_USE )
	self.LastUse = 0
	self.Delay = 2

	timer.Simple(100, function()
		if IsValid( self ) then
			self:Remove()
		end
	end)

	
end

function ENT:Use(activator)
-- таймер для предотвращения абуза
	if self.LastUse <= CurTime() then
		self.LastUse = CurTime() + self.Delay
		
		DarkRP.notify(activator, 3, 3, "Заполните рацион едой и водой.")
		timer.Simple(1.2, function()
		
			DarkRP.notify(activator, 3, 3, "Далее - положите заполненный рацион в коробку.")
		
		end)
		
	end
end

function ENT:StartTouch( hitEnt )
	if hitEnt:GetClass() == "hl2sys_zavod_water" && self:GetNWInt("RWater") == 0 then
		hitEnt:Remove()
		self:EmitSound("items/medshot4.wav");
		self:SetNWInt("RWater", 1)
	end
	if hitEnt:GetClass() == "hl2sys_zavod_food" && self:GetNWInt("RFood") == 0 then
		hitEnt:Remove()
		self:EmitSound("items/medshot4.wav");
		self:SetNWInt("RFood", 1)
	end
end