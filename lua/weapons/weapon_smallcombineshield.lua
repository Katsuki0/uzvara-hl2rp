AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Щит Комбайнов"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
    SWEP.Icon = "vgui/ttt/icon_nades" -- most generic icon I guess
end

SWEP.Category = "Технологии Альянса"
SWEP.Author = "Black Tea"
SWEP.Instructions = "Right Click to Bash Entity"
SWEP.Purpose = "Right Click to Bash Entity"

SWEP.Spawnable = true

SWEP.Base = "shield_base"

SWEP.ViewModel = Model("models/weapons/c_arms_animations.mdl")
SWEP.WorldModel = Model("models/pg_props/pg_weapons/pg_cp_shield_w.mdl")