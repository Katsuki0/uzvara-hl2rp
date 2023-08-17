AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/cardboard_box003a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()	
	self:SetNWInt("ReadyToSell", 0)
	-- предотвращение абуза
	self:SetUseType( SIMPLE_USE )
	self.LastUse = 0
	self.Delay = 2

	timer.Simple(360, function()
		if IsValid(self ) then
			self:Remove()
		end
	end)
	
end

function ENT:Use(activator)
-- таймер для предотвращения абуза
	if self.LastUse <= CurTime() then
		self.LastUse = CurTime() + self.Delay
		
		DarkRP.notify(activator, 3, 3, "Наполните коробку двумя готовыми рационами.")
		timer.Simple(1.2, function()
		
			DarkRP.notify(activator, 3, 3, "Далее - заполненную коробку засуньте в обработку рациона.")
		
		end)
		
	end
end


function ENT:StartTouch( hitEnt )
 if hitEnt:GetClass() == "hl2sys_zavod_ration" && self:GetNWInt("ReadyToSell") < 10 && hitEnt:GetNWInt("RWater") == 1 && hitEnt:GetNWInt("RFood") == 1 then
 if self.Delay > CurTime() then return end
 if !IsValid(hitEnt) then return end
  hitEnt:Remove()
  self:EmitSound("physics/metal/metal_barrel_impact_soft4.wav");
  self:SetNWInt("ReadyToSell", self:GetNWInt("ReadyToSell") + 1)
  self.Delay = CurTime()+1
 end
end