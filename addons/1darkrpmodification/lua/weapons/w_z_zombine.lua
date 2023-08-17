AddCSLuaFile()

SWEP.PrintName				= "Руки зомбайна"
SWEP.Author					= ""
SWEP.Purpose				= ""
SWEP.Category = "Зомби"

SWEP.Slot					= 0
SWEP.SlotPos				= 4

SWEP.Spawnable				= true

SWEP.ViewModel				= Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_eq_fraggrenade.mdl" )
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= true
SWEP.AdminOnly 				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair      = false
SWEP.HitDistance			= 48

SWEP.punchMin = 50
SWEP.punchMax = 80
SWEP.critMin = 50
SWEP.critMax = 80

local SwingSound = {Sound( "npc/zombie/claw_miss1.wav" ), Sound( "npc/zombie/claw_miss2.wav" )}
local HitSound = {Sound( "npc/zombie/claw_strike1.wav" ), Sound( "npc/zombie/claw_strike2.wav" ), Sound( "npc/zombie/claw_strike3.wav" )}

local RoarSound = {Sound('npc/zombie/zombie_alert1.wav'),Sound('npc/zombie/zombie_alert2.wav'),Sound('npc/zombie/zombie_alert3.wav'),Sound('npc/zombie_poison/pz_alert1.wav'),Sound('npc/zombie_poison/pz_alert2.wav')}

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
	[ACT_MP_STAND_IDLE] = ACT_HL2MP_WALK_ZOMBIE,
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
	[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_05,
	[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_06,
	[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE_FAST,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE,
	[ACT_MP_RELOAD_STAND] = ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
}

function SWEP:TranslateActivity(act)
	return anim_zombie[act] || act
end

function SWEP:Initialize()
	self:SetHoldType( "fist" )
	-- self.Owner.NextGrenadeAttack = CurTime() + 0.1
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
	
	self:SetNextPrimaryFire( CurTime() + 1.5 )
	self:SetNextSecondaryFire( CurTime() + 1.5 )

end

function SWEP:Reload()
	if self:GetNextPrimaryFire() > CurTime() || self:GetNextSecondaryFire() > CurTime() then
		return
	end
	self.Owner:SetAnimation( PLAYER_RELOAD )

	self:SetNextPrimaryFire( CurTime() + 2 )
	self:SetNextSecondaryFire( CurTime() + 2 )

	self:EmitSound( table.Random(RoarSound),  75 )
end

function SWEP:Grenade()
    if SERVER then
    	local grenade = ents.Create("env_explosion")
        grenade:SetPos(self:GetPos())
        grenade:Spawn()
        grenade:SetKeyValue( "iMagnitude", "200" )
        grenade:SetOwner( self.Owner )
        grenade:Fire( "Explode", 0, 0 )
        grenade:EmitSound("ambient/fire/gascan_ignite1.wav")	
        end
end
local exploding = {"npc/combine_soldier/vo/zero.wav", "npc/combine_soldier/vo/one.wav", "npc/combine_soldier/vo/two.wav", "npc/combine_soldier/vo/three.wav", "npc/combine_soldier/vo/four.wav", "npc/combine_soldier/vo/alert1.wav", "npc/combine_soldier/vo/blade.wav", "npc/combine_soldier/vo/apex.wav", "npc/combine_soldier/vo/cleaned.wav", "npc/combine_soldier/vo/contact.wav"}
function SWEP:SecondaryAttack()
	if self.Owner.NextGrenadeAttack != nil and self.Owner.NextGrenadeAttack >= CurTime() then return end
	self:SetNextPrimaryFire( CurTime() + 5 )
	self:SetNextSecondaryFire( CurTime() + 5 )
    self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
    self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
    self:EmitSound(table.Random(exploding))
    timer.Create(tostring(self).."_sounds", 1, 2, function()
	if !IsValid(self) then return end
    	self:EmitSound(exploding[math.random(#exploding)])
    end)
    timer.Simple(0.9, function(wep)
    	if !IsValid(self) then return end
    	self:SendWeaponAnim(ACT_VM_THROW) 
    end)
    timer.Simple(2.5, function(wep)
    	if !IsValid(self) then return end
    	self:EmitSound("npc/combine_soldier/die"..math.random(3)..".wav")
	end)
    timer.Simple(3, function(wep)
    	if !IsValid(self) then return end
    	self:Grenade() 
    end)
    self.NextGrenade = CurTime() + 200
    self.Owner.NextGrenadeAttack = CurTime() + 200
	self.Owner:SetRunSpeed(100)
	self.Owner:SetWalkSpeed(100)
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
		self.Owner:SetHealth(self.Owner:Health() + 50)
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
	
	
	local attacker = self.Owner
	local trc = tr.Entity
	

	self.Owner:LagCompensation( false )

end

function SWEP:OnDrop()

	self:Remove() -- You can't drop fists

end

function initFonts()
    surface.CreateFont( "Money", {

    font = "Trebuchet MS",
    
    extended = true,
    
    size = 40,
    
    weight = 700,
    
    blursize = 0,
    
    scanlines = 0,
    
    antialias = true,
    
    })
end


function SWEP:DrawHUD()
	if self.Owner.NextGrenadeAttack and self.Owner.NextGrenadeAttack >= CurTime() then

		draw.SimpleTextOutlined("Перезарядка: "..math.Round(self.Owner.NextGrenadeAttack - CurTime()).." секунд ", "Money", 113, ScrH() - 150,  Color(255,70,70,100), 1, 0, 1,Color(0,0,0,255), TEXT_ALIGN_LEFT )
	else
		draw.SimpleTextOutlined("Взорваться(Способность) ", "Money", 113, ScrH() - 150, Color(255,70,70,100), 1, 0, 1,Color(0,0,0,255), TEXT_ALIGN_LEFT )
	end

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
	--hook.Add("GetFallDamage", "FastZombie", function(ply, speed)
	--	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "zombieswep3" then
			return 
	--	end
	--end)
else
	--hook.Add("RenderScreenspaceEffects", "ZombieEffect", function()
		--local ply = LocalPlayer()
		--local alpha = 0
		--local tab = {
		--	["$pp_colour_addr"] = -0.3,
		--	["$pp_colour_addg"] = -1,
		--	["$pp_colour_addb"] = -1,
		--    ["$pp_colour_brightness"] = 0.6,
		--	["$pp_colour_contrast"]  = 2,
		--	["$pp_colour_colour"] = 0.4,
		--	["$pp_colour_mulr"] = 0 ,
		--	["$pp_colour_mulg"] = 0.1,
		--	["$pp_colour_mulb"] = 0
		--}
		--if not ply:isZOMBIE() then return end
	--	DrawColorModify(tab)
	--end)
end

--[[
if SERVER then 
	hook.Add("EntityTakeDamage", "ZombieInfect", function(ply, dmginfo)
		if not IsValid(ply) or not ply:IsPlayer() then return end
		if not IsValid(dmginfo:GetAttacker()) or not dmginfo:GetAttacker():IsPlayer() then return end
		local zombie = dmginfo:GetAttacker()
		if zombie == ply or not zombie:isZombie() or not ply:Alive() then return end
		if ply:GetDisease() then return end
		if IsValid(zombie:GetActiveWeapon()) and zombie:GetActiveWeapon():GetClass() == "zombieswep3" then
			local chance = math.random(0,100)
			if chance < 10 then
				ply:SetDisease("Кашель")
			end
		end
	end)
end
]]