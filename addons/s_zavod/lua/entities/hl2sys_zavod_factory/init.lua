AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/reciever_cart.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()	
	self:SetNWInt("FactoryIsWorking", 0)
	self:SetUseType( SIMPLE_USE )
	-- предотвращение абуза
	self.LastUse = 0
	self.Delay = 2
	
	
end

function ENT:Use(activator)
-- таймер для предотвращения абуза
	local allowedTeam = TEAM_GRAZHDANIN
	if self.LastUse <= CurTime() and activator:Team() == allowedTeam then
		self.LastUse = CurTime() + self.Delay
		
		DarkRP.notify(activator, 3, 3, "Сюда необходимо принести заполненную двумя рационами коробку.")
		timer.Simple(1.2, function()
		
			DarkRP.notify(activator, 3, 3, "Далее - получите награждение.")
		
		end)
		
	end
end

function ENT:StartTouch( hitEnt )
	-- Settings / Настройки
	local moneyForWork = math.floor(math.random(10,10)) -- деньги за приготовленный рацион / money for work
	local WorkTime = 1 -- время работы (в секундах) / working time (in sec) 
	--
	
	if hitEnt:GetClass() == "hl2sys_zavod_box" && hitEnt:GetNWInt("ReadyToSell") == 10 && self:GetNWInt("FactoryIsWorking") == 0 then
			local TimerSoundC = "buttons/blip2.wav"
			
			hitEnt:Remove()
			
			self:SetNWInt("FactoryIsWorking", 1)
			
			self:EmitSound("items/medshot4.wav")
			self:EmitSound("plats/tram_hit1.wav")
			self:SetNWInt('timer', CurTime() + WorkTime)
			
			
			
			
		timer.Simple(0.2, function()
			self:EmitSound("plats/tram_motor_start.wav")
		
		end)
		timer.Simple(0.4, function()
			self:EmitSound(TimerSoundC)
					self.sound = CreateSound(self, Sound("plats/heavymove1.wav"))
					self.sound:SetSoundLevel(50)
					self.sound:PlayEx(1, 200)
		end)
		
		
		
		
		timer.Simple(0.8, function()
			self:EmitSound(TimerSoundC)
		
		end)
		timer.Simple(1.2, function()
			self:EmitSound(TimerSoundC)
		
		end)
		timer.Simple(1.6, function()
			self:EmitSound(TimerSoundC)
		
		end)
		timer.Simple(2, function()
			self:EmitSound(TimerSoundC)
		
		end)
		
		
		timer.Simple(8, function()
			self:EmitSound("physics/flesh/flesh_squishy_impact_hard2.wav")
		
		end)
		timer.Simple(9.5, function()
			self:EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav")
		
		end)
		timer.Simple(11, function()
			self:EmitSound("physics/cardboard/cardboard_box_impact_hard5.wav")
		
		end)
		timer.Simple(13, function()
			self:EmitSound("physics/cardboard/cardboard_box_impact_hard5.wav")
		
		end)
		timer.Simple(15, function()
			self:EmitSound("physics/cardboard/cardboard_box_impact_hard5.wav")
		
		end)
		timer.Simple(16, function()
			self:EmitSound("physics/cardboard/cardboard_cup_impact_hard1.wav")
		end)
		
		timer.Simple(20, function()
			self:EmitSound("ambient/machines/slicer1.wav")
		end)
		timer.Simple(20.7, function()
			self:EmitSound("ambient/machines/slicer2.wav")
		end)
		timer.Simple(21.2, function()
			self:EmitSound("ambient/machines/slicer3.wav")
		end)
		timer.Simple(22, function()
			self:EmitSound("ambient/machines/steam_release_2.wav")
		end)
		
		timer.Simple(25, function()
			self:EmitSound("ambient/machines/squeak_2.wav")
		end)
		
		timer.Simple(WorkTime - 2, function()
				if self.sound then
					self.sound:Stop()
				end
			self:EmitSound("plats/elevator_large_stop1.wav")
		end)
		timer.Simple(WorkTime, function()
			self:SetNWInt("FactoryIsWorking", 0)
			DarkRP.createMoneyBag(Vector(self:GetPos().x + 0.5, self:GetPos().y + 1, self:GetPos().z - 10), moneyForWork)
		end)
		
	end
end