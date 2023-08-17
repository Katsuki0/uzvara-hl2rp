--[[
addons/darkrpmod/lua/weapons/zombieswep2.lua
--]]

AddCSLuaFile()

SWEP.PrintName				= "Быстрый Зомби"
SWEP.Author					= "Uzvara"
SWEP.Purpose				= ""
SWEP.Category				= "Зомби"

SWEP.Slot					= 0
SWEP.SlotPos				= 4

SWEP.Spawnable				= true

SWEP.ViewModel				= Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel				= ""
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.DrawCrosshair      = false
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.DrawAmmo				= false

SWEP.HitDistance			= 48

SWEP.punchMin = 10
SWEP.punchMax = 30
SWEP.critMin = 10
SWEP.critMax = 30

local SwingSound = {Sound( "npc/fast_zombie/claw_miss1.wav" ), Sound( "npc/fast_zombie/claw_miss2.wav" )}
local HitSound = {Sound( "npc/fast_zombie/claw_strike1.wav" ), Sound( "npc/fast_zombie/claw_strike2.wav" ), Sound( "npc/fast_zombie/claw_strike3.wav" )}

local RoarSound = {Sound('npc/fast_zombie/fz_scream1.wav'), Sound('npc/fast_zombie/fz_alert_close1.wav'), Sound('npc/zombie/zombie_voice_idle1.wav')}

local anim_zombie = {
	[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ZOMBIE,
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
	[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01,
	[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_02,
	[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE,
	[ACT_MP_RELOAD_STAND] = ACT_GMOD_GESTURE_TAUNT_ZOMBIE
}

local anim_fast_zombie = {
	[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ZOMBIE,
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
	[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_07,
	[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_01,
	[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE_FAST,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE,
	[ACT_MP_RELOAD_STAND] = ACT_GMOD_GESTURE_TAUNT_ZOMBIE
}

function SWEP:TranslateActivity(act)
	--print(act, anim_zombie[act])
	return anim_fast_zombie[act] || act
end

function SWEP:Initialize()
	self:SetHoldType( "fist" )
	if CLIENT && self.Owner:GetModel():find('zombie_fast') then
		self.fastZombie = true
	end
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )

end

function SWEP:PrimaryAttack( right )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	if ( self:GetCombo() >= 2 ) then
		anim = "fists_uppercut"
	end

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( table.Random(SwingSound), 75 )

	self:UpdateNextIdle()
	self:SetNextMeleeAttack( CurTime() + 0.5 )
	
	self:SetNextPrimaryFire( CurTime() + 0.7 )
	self:SetNextSecondaryFire( CurTime() + 1 )

end

function SWEP:Reload()
	if self:GetNextPrimaryFire() > CurTime() || self:GetNextSecondaryFire() > CurTime() then
		return
	end
	self.Owner:SetAnimation( PLAYER_RELOAD )

	self:SetNextPrimaryFire( CurTime() + 2 )
	self:SetNextSecondaryFire( CurTime() + 2 )

	self:EmitSound("npc/fast_zombie/fz_frenzy1.wav",  75 )
end

function SWEP:SecondaryAttack()
    self.isflying = true
    self.islanding = false
	self:SetVelocity((self:GetUp() * 145) + (self:GetForward() * 555));
		
	if self.isflying then
		local tr = util.QuickTrace(self.Owner:GetShootPos(), (self.Owner:GetForward() * -160), self.Owner);
		if (tr.Hit) then
			self.Owner:ViewPunch(Angle(8, 0, 0));
			self.Owner:SetVelocity((self.Owner:GetForward() * 555) + (self.Owner:GetUp() * 145));
			
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self.Owner:DoAnimationEvent(ACT_ZOMBIE_LEAP_START)

			timer.Create(tostring(self).."_Animations", 0.5, 2, function()
				if !IsValid(self) then return end 
				self.Owner:DoAnimationEvent(ACT_ZOMBIE_LEAPING)
			end)
			
			self.Weapon:EmitSound("npc/fast_zombie/fz_scream1.wav")
		end
	end
	timer.Simple(1.4, function() 
		if !IsValid(self) then return end 
		self:SendWeaponAnim(ACT_VM_IDLE) 
	end)
	self:SetNextPrimaryFire( CurTime() + 2 )
	self:SetNextSecondaryFire( CurTime() + 2 )
end

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then 
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( table.Random(HitSound), 75 )
	end

	local hit = false

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()
		
		local max_health = self.Owner:GetMaxHealth()
		if self.Owner:Health() < max_health then
		self.Owner:SetHealth(self.Owner:Health() + 15)
		end
	
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )

		dmginfo:SetDamage( math.random( self.punchMin, self.punchMax ) )


		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 ) -- Yes we need those specific numbers
		elseif ( anim == "fists_right" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		elseif ( anim == "fists_uppercut" ) then
			dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012 )
			dmginfo:SetDamage( math.random( self.critMin, self.critMax ) )
		end

		--if tr.Entity:IsPlayer() then
			--tr.Entity:AddHigh('Zombie Slow')
		--end

		tr.Entity:TakeDamageInfo( dmginfo )
		hit = true

	end

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end
	

	self.Owner:LagCompensation( false )

end

function SWEP:OnDrop()

	self:Remove() -- You can't drop fists

end

function SWEP:Deploy()

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	
	self:UpdateNextIdle()
	
	if ( SERVER ) then
		self:SetCombo( 0 )
	end

	local t = RPExtraTeams[self.Owner:Team()]
	self.punchMin = t.punchMin or self.punchMin
	self.punchMax = t.punchMax or self.punchMax
	self.critMin = t.critMin or self.critMin
	self.critMax = t.critMax or self.critMax

	return true

end

function SWEP:Think()

	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()

	if ( idletime > 0 && CurTime() > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )

		self:UpdateNextIdle()

	end

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end

	if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then

		self:SetCombo( 0 )

	end

end

if SERVER then
	hook.Add("GetFallDamage", "FastZombie", function(ply, speed)
		if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "zombieswep2" then
			return 0
		end
	end)
else
	hook.Add("RenderScreenspaceEffects", "ZombieEffect", function()
		local ply = LocalPlayer()
		local alpha = 0
		local tab = {
			["$pp_colour_addr"] = -1,
			["$pp_colour_addg"] = -0.6,
			["$pp_colour_addb"] = -1,
			["$pp_colour_brightness"] = 0.8,
			["$pp_colour_contrast"]  = 2,
			["$pp_colour_colour"] = 0,
			["$pp_colour_mulr"] = 0 ,
			["$pp_colour_mulg"] = 0.1,
			["$pp_colour_mulb"] = 0
		}
		if not (ply:Team() == TEAM_ZOMBIEB) then return end
		DrawColorModify(tab)
	end)
end