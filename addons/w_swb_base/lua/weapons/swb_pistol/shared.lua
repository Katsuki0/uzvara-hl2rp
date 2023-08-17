
-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.CrosshairEnabled = false
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Пистолет"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector (-6.0266, -1.0035, 2.9003)
	SWEP.AimAng = Vector (0.5281, -1.3165, 0.8108)
	
	SWEP.SprintPos = Vector (5.041, 0, 3.6778)
	SWEP.SprintAng = Vector (-17.6901, 10.321, 0)
	SWEP.BulletDisplay = 0
	SWEP.ZoomAmount = 5
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "smallshell"
	
	SWEP.IconLetter = "d"
	SWEP.IconFont = "WeaponIcons"
	
	--SWEP.MuzzleEffect = "swb_pistol_large"
	--SWEP.MuzzlePosMod = {x = 6.5, y =	30, z = -2}
	--SWEP.PosBasedMuz = true
end

SWEP.SpeedDec = 12
SWEP.BulletDiameter = 9.1
SWEP.CaseLength = 33

SWEP.PlayBackRate = 20
SWEP.PlayBackRateSV = 20

SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "pistol"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "swb_base"
SWEP.Category = "Оружие"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"

SWEP.FireDelay = 0.3
SWEP.FireSound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Reload 		= Sound("Weapon_Pistol.Reload")
SWEP.Recoil = 1.9
SWEP.Chamberable = false

SWEP.HipSpread = 0.40
SWEP.AimSpread = 0.020
SWEP.VelocitySensitivity = 33.3
SWEP.MaxSpreadInc = 0.020 -- расбросс 
SWEP.SpreadPerShot = 10.002
SWEP.SpreadCooldown = 10.13
SWEP.Shots = 1
SWEP.Damage = 15
SWEP.DeployTime = 0

function SWEP:ReloadSound()
	self.Weapon:EmitSound(self.Primary.Reload)
end