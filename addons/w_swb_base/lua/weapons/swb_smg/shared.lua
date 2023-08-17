
-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.CrosshairEnabled = false
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "СМГ"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector (-6.4318, -2.0031, 1)
	SWEP.AimAng = Vector (0, 0, 0)
	
	SWEP.SprintPos = Vector(9.071, 0, 1.6418)
	SWEP.SprintAng = Vector(-12.9765, 26.8708, 0)
	
	SWEP.IconLetter = "a"
	SWEP.IconFont = "WeaponIcons"
	
	SWEP.MuzzleEffect = "swb_rifle_med"
end

SWEP.Base = 'swb_base'
SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.SpeedDec = 15
SWEP.BulletDiameter = 9
SWEP.CaseLength = 19

SWEP.BulletDisplay = 0

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "smg"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Category = "Оружие"

SWEP.Author			= "aStonedPenguin"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 50
SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 45
SWEP.Primary.Reload 		= Sound("Weapon_SMG1.Reload")
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.FireDelay = 0.115
SWEP.FireSound = Sound("Weapon_SMG1.Single")
SWEP.Recoil = 1.3

SWEP.HipSpread = 0.40
SWEP.AimSpread = 0.020
SWEP.VelocitySensitivity = 3.3
SWEP.MaxSpreadInc = 0.020
SWEP.SpreadPerShot = 10.02
SWEP.SpreadCooldown = 10.13
SWEP.Shots = 1
SWEP.Damage = 14
SWEP.DeployTime = 1


function SWEP:ReloadSound()
	self.Weapon:EmitSound(self.Primary.Reload)
end