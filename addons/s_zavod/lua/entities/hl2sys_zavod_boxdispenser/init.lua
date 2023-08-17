AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/metal_tubex2.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMaterial("models/props_pipes/GutterMetal01a")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	
	self:SetUseType( SIMPLE_USE )
	
	--
	self.LastUse = 0
	self.Delay = 200
end

function ENT:Use(activator)
	local timerSound = "buttons/blip1.wav"
	local cSound = "buttons/button6.wav" -- звук закрытия

	local allowedTeam = TEAM_GRAZHDANIN
	if activator:Team() != allowedTeam then DarkRP.notify(activator, 1, 4, "Вы не Работник завода") return end
    if activator.xyu == nil then  activator.xyu = CurTime() - 1 end
    if activator.xyu > CurTime() then DarkRP.notify(activator, 1, 4, "Подождите еще ".. math.floor(activator.xyu -CurTime()) .. " секунд") return end
        activator.xyu = CurTime() + 30
		 
		self:EmitSound("buttons/lever8.wav")
		--aself:EmitSound("buttons/button1.wav")
		timer.Simple(0.4, function()
			self:EmitSound("buttons/button1.wav")
		end)
		
		timer.Simple(0.8, function()
			self:EmitSound(timerSound)
		end)
		timer.Simple(1.4, function()
			self:EmitSound(timerSound)
		end)
		timer.Simple(2, function()
			self:EmitSound(timerSound)
		end)
		
		
		timer.Simple(2, function()
			self:EmitSound("buttons/button9.wav")
		end)
		timer.Simple(2.6, function()
		self:EmitSound("buttons/button4.wav")
		local ent = ents.Create( "hl2sys_zavod_box" )
		ent:SetPos( self:GetPos() + ( self:GetForward() * 3 ) + ( self:GetUp() * 50 ) )
		ent:SetAngles( self:GetAngles() + Angle( 0, 0, 0 ) )
		ent:Spawn()
		ent:Activate()
		ent:GetPhysicsObject():ApplyForceCenter( self:GetForward() * 15 )
		end)
		timer.Simple(200, function()
			self:EmitSound(cSound)
		end)
	end
