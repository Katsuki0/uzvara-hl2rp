AddCSLuaFile()
if SERVER then
	util.AddNetworkString("PainAndCrying")
end

if (CLIENT) then
	SWEP.PrintName = "Дубинка"
	SWEP.Slot = 0
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Uzvara"
SWEP.Instructions = ""
SWEP.Purpose = ""
SWEP.Drop = false
SWEP.Category = "Холодное оружие"
SWEP.AdminOnly 				= true

SWEP.HoldType = "normal"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModelFOV = 47
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "melee"

SWEP.ViewTranslation = 4
SWEP.Activated = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 13
SWEP.Primary.Delay = 0.7

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = Model("models/weapons/c_stunstick.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.UseHands = true
SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.FireWhenLowered = true

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")
end

function SWEP:Precache()
	util.PrecacheSound("weapons/stunstick/stunstick_swing1.wav")
	util.PrecacheSound("weapons/stunstick/stunstick_swing2.wav")
	util.PrecacheSound("weapons/stunstick/stunstick_impact1.wav")	
	util.PrecacheSound("weapons/stunstick/stunstick_impact2.wav")
	util.PrecacheSound("weapons/stunstick/spark1.wav")
	util.PrecacheSound("weapons/stunstick/spark2.wav")
	util.PrecacheSound("weapons/stunstick/spark3.wav")
end

function SWEP:Initialize()
	self:SetHoldType("normal")
end


-- if replaceModels[self.Owner:GetModel()] then
-- 	self.Owner.PrevModel = self.Owner:GetModel()
-- 	self.Owner:SetModel(replaceModels[self.Owner:GetModel()])
-- end




function SWEP:PrimaryAttack()	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if (self.Owner:KeyDown(IN_USE)) then
		if (SERVER) then
			self:SetActivated(!self:GetActivated())
			self.Activated = !self:GetActivated()

			local sequence = "deactivatebaton"

			if (self:GetActivated()) then
				self.Owner:EmitSound("weapons/stunstick/spark3.wav", 100, math.random(90, 110))
				sequence = "activatebaton"
				self:SetHoldType("grenade")
				self:SetNW2Bool("Angry",true)
			else
				self:SetHoldType("normal")
				self.Owner:EmitSound("weapons/stunstick/spark"..math.random(1, 2)..".wav", 100, math.random(90, 110))
				self:SetNW2Bool("Angry",false)
			end

			local model = string.lower(self.Owner:GetModel())
		end

		return
	end

	if self:GetActivated() then

		self:EmitSound("weapons/stunstick/stunstick_swing"..math.random(1, 2)..".wav", 70)
		self:SendWeaponAnim(ACT_VM_HITCENTER)

		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Owner:ViewPunch(Angle(1, 0, 0.125))

		self.Owner:LagCompensation(true)
			local data = {}
				data.start = self.Owner:GetShootPos()
				data.endpos = data.start + self.Owner:GetAimVector()*72
				data.filter = self.Owner
			local trace = util.TraceLine(data)
		self.Owner:LagCompensation(false)

		if (SERVER and trace.Hit) then
			if (self:GetActivated()) then
				local effect = EffectData()
					effect:SetStart(trace.HitPos)
					effect:SetNormal(trace.HitNormal)
					effect:SetOrigin(trace.HitPos)
				util.Effect("StunstickImpact", effect, true, true)
			end
				self.Owner:EmitSound("weapons/stunstick/stunstick_impact"..math.random(1, 2)..".wav")
				local entity = trace.Entity
			--	if !IsValid(entity) or !entity:IsPlayer() or entity:isCP() or entity:isZombie() or entity:Team() == TEAM_ADMIN then return end
			--	DarkRP.notify(entity,2,4, self.Owner:getDarkRPVar("job").." перевоспитывает вас")
				net.Start("PainAndCrying")
				net.Send(entity)
				local damageInfo = DamageInfo()
				damageInfo:SetAttacker(self.Owner)
				damageInfo:SetInflictor(self)
				damageInfo:SetDamage(15)
				damageInfo:SetDamageType(DMG_CLUB)
				damageInfo:SetDamagePosition(trace.HitPos)
				entity:TakeDamageInfo(damageInfo)
		--		entity:Freeze(true)
			--	timer.Create("mp_freeze"..entity:SteamID64(), 4,1,function()
			--		if !IsValid(entity) then return end
			--		entity:Freeze(false)
			--	end)

				entity.UntilFall = (entity.UntilFall or 0) + 1 or 0
				

		end
	end
end

function SWEP:OnLowered()
	if SERVER then self:SetActivated(false) self.Activated = false end
	self:SetNW2Bool("angry", false)
	self:SetHoldType("normal")
end

function SWEP:Holster(nextWep)
	self:OnLowered()
	return true
end

function SWEP:SecondaryAttack()
	self.Owner:LagCompensation(true)
		local data = {}
			data.start = self.Owner:GetShootPos()
			data.endpos = data.start + self.Owner:GetAimVector()*72
			data.filter = self.Owner
			data.mins = Vector(-8, -8, -30)
			data.maxs = Vector(8, 8, 10)
		local trace = util.TraceHull(data)
		local entity = trace.Entity
	self.Owner:LagCompensation(false)

	if (SERVER and IsValid(entity)) then
		local pushed

		if (entity:isDoor()) then
			if (hook.Run("PlayerCanKnock", self.Owner, entity) == false) then
				return
			end

			self.Owner:ViewPunch(Angle(-1.3, 1.8, 0))
			self.Owner:EmitSound("physics/plastic/plastic_box_impact_hard"..math.random(1, 4)..".wav")	
			self.Owner:SetAnimation(PLAYER_ATTACK1)

			self:SetNextSecondaryFire(CurTime() + 0.4)
			self:SetNextPrimaryFire(CurTime() + 1)
		elseif (entity:IsPlayer()) then
			local direction = self.Owner:GetAimVector() * (300 + 1 * 3)
			direction.z = 0

			entity:SetVelocity(direction)
			local emitsounds = {"npc/metropolice/vo/move.wav", "npc/metropolice/vo/movealong.wav", "npc/metropolice/vo/movealong3.wav", "npc/metropolice/vo/movebackrightnow.wav", "npc/metropolice/vo/moveit.wav", "npc/metropolice/vo/moveit2.wav"}
			if self.Owner:isCP() then
			self.Owner:EmitSound(emitsounds[ math.random( #emitsounds ) ])
			end

			pushed = true
		else
			local physObj = entity:GetPhysicsObject()

			if (IsValid(physObj)) then
				physObj:SetVelocity(self.Owner:GetAimVector() * 180)
			end

			pushed = true
		end

		if (pushed) then
			self:SetNextSecondaryFire(CurTime() + 1.5)
			self:SetNextPrimaryFire(CurTime() + 1.5)
			self.Owner:EmitSound("weapons/crossbow/hitbod"..math.random(1, 2)..".wav")

			local model = string.lower(self.Owner:GetModel())
			local owner = self.Owner

			-- if (nut.anim.getModelClass(model) == "metrocop") then
				local anim = self:LookupSequence( "pushplayer" )
				self.Owner:SetSequence(anim)
			-- end
		end
	end
end

local STUNSTICK_GLOW_MATERIAL = Material("effects/stunstick")
local STUNSTICK_GLOW_MATERIAL2 = Material("effects/blueflare1")
local STUNSTICK_GLOW_MATERIAL_NOZ = Material("sprites/light_glow02_add_noz")

local color_glow = Color(128, 128, 128)

function SWEP:DrawWorldModel()
	self:DrawModel()

	if (self:GetActivated()) or self.Activated then
		local size = math.Rand(4.0, 6.0)
		local glow = math.Rand(0.6, 0.8) * 255
		local color = Color(glow, glow, glow)
		local attachment = self:GetAttachment(1)

		if (attachment) then
			local position = attachment.Pos

			render.SetMaterial(STUNSTICK_GLOW_MATERIAL2)
			render.DrawSprite(position, size * 2, size * 2, color)

			render.SetMaterial(STUNSTICK_GLOW_MATERIAL)
			render.DrawSprite(position, size, size + 3, color_glow)
		end
	end
end

local NUM_BEAM_ATTACHEMENTS = 9
local BEAM_ATTACH_CORE_NAME	= "sparkrear"

function SWEP:PostDrawViewModel()
	if (!self:GetActivated()) then
		return
	end

	local viewModel = LocalPlayer():GetViewModel()

	if (!IsValid(viewModel)) then
		return
	end

	cam.Start3D(EyePos(), EyeAngles())
		local size = math.Rand(3.0, 4.0)
		local color = Color(255, 255, 255, 50 + math.sin(RealTime() * 2)*20)

		STUNSTICK_GLOW_MATERIAL_NOZ:SetFloat("$alpha", color.a / 255)

		render.SetMaterial(STUNSTICK_GLOW_MATERIAL_NOZ)

		local attachment = viewModel:GetAttachment(viewModel:LookupAttachment(BEAM_ATTACH_CORE_NAME))

		if (attachment) then
			render.DrawSprite(attachment.Pos, size * 10, size * 15, color)
		end

		for i = 1, NUM_BEAM_ATTACHEMENTS do
			local attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark"..i.."a"))

			size = math.Rand(2.5, 5.0)

			if (attachment and attachment.Pos) then
				render.DrawSprite(attachment.Pos, size, size, color)
			end

			local attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark"..i.."b"))

			size = math.Rand(2.5, 5.0)

			if (attachment and attachment.Pos) then
				render.DrawSprite(attachment.Pos, size, size, color)
			end
		end
	cam.End3D()
end




// Client shit
if CLIENT then
	net.Receive("PainAndCrying",function ()
		LocalPlayer().DamagedByCP = true
		LocalPlayer().Color = 255
	end)

	function HUDDamage()
		if LocalPlayer().DamagedByCP == true then
			LocalPlayer().Color = LocalPlayer().Color - 1
			draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(255,255,255,LocalPlayer().Color))
		end
	end
	hook.Add("HUDPaint","Damage Shit",HUDDamage)
end

function SWEP:Reload()
	if (self.nextup or 0) > CurTime() then return end
	self.nextup = CurTime() + 1
	if (SERVER) then
			self:SetActivated(!self:GetActivated())
			self.Activated = !self:GetActivated()

			local sequence = "deactivatebaton"

			if (self:GetActivated()) then
				self.Owner:EmitSound("weapons/stunstick/spark3.wav", 100, math.random(90, 110))
				sequence = "activatebaton"
				self:SetHoldType("grenade")
				self:SetNW2Bool("Angry",true)
			else
				self:SetHoldType("normal")
				self.Owner:EmitSound("weapons/stunstick/spark"..math.random(1, 2)..".wav", 100, math.random(90, 110))
				self:SetNW2Bool("Angry",false)
			end

			local model = string.lower(self.Owner:GetModel())
		end
	return
end


