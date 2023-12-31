
-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.CrosshairEnabled = false
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Дробовик"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector (-8.9203, -4.7091, 1.7697)
	SWEP.AimAng = Vector (3.0659, 0.0913, 0)
	SWEP.BulletDisplay = 00
	SWEP.SprintPos = Vector (3, 0, 2.5)
	SWEP.SprintAng = Vector (-13, 27, 0)
	
	SWEP.ZoomAmount = 5
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "shotshell"
	SWEP.ShellOnEvent = true
	
	SWEP.IconLetter = "b"
	SWEP.IconFont = "WeaponIcons"
	
	SWEP.MuzzleEffect = "swb_shotgun"
end

SWEP.CanPenetrate = false
SWEP.PlayBackRate = 1
SWEP.PlayBackRateSV = 1
SWEP.SpeedDec = 30
SWEP.BulletDiameter = 5
SWEP.CaseLength = 10

SWEP.BulletDisplay = 0

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_box_buckshot_ttt"

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "shotgun"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"semi"}
SWEP.Base = "swb_base"
SWEP.Category = "Оружие"

SWEP.Author			= "aStonedPenguin"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 50
SWEP.ViewModel			= "models/weapons/c_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Reload		= Sound("Weapon_SHOTGUN.Reload")
SWEP.Primary.Special		= Sound("Weapon_SHOTGUN.Special1")
SWEP.Primary.Double		= Sound("Weapon_SHOTGUN.Double")
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Buckshot"

SWEP.FireDelay = 1.5
SWEP.FireSound = Sound("Weapon_SHOTGUN.Single")	
SWEP.Recoil = 10.0
SWEP.ShotgunReload = true
SWEP.ReloadStartWait = 0.5
SWEP.ReloadFinishWait = 1.0
SWEP.ReloadShellInsertWait = 0.8
SWEP.Chamberable = false

SWEP.HipSpread = 0.036
SWEP.AimSpread = 0.006
SWEP.ClumpSpread = 0.10
SWEP.VelocitySensitivity = 4.4
SWEP.MaxSpreadInc = 0.12
SWEP.SpreadPerShot = 0.04
SWEP.SpreadCooldown = 1.03
SWEP.Shots = 8
SWEP.Damage = 17
SWEP.DeployTime = 1

function SWEP:ReloadSound()
	self.Weapon:EmitSound(self.Primary.Reload)
end

function SWEP:FinishAttack()
	timer.Simple(0.35, function()
		if !(self && self.Owner) then return end
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		if SERVER then
			self.Weapon:EmitSound(self.Primary.Special)
		end
	end)
end