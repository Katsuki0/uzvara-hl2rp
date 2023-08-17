if (SERVER) then
   AddCSLuaFile ("shared.lua")
end

if SERVER then
   resource.AddFile("materials/vgui/ttt/icon_flashbang.png")
   resource.AddWorkshop( "711811322" )
end

if (CLIENT) then


	SWEP.PrintName = "Флешка"
	SWEP.SlotPos = 2
	SWEP.IconLetter			= "g"
	SWEP.NameOfSWEP			= "weapon_ttt_flashbang" 
	
	SWEP.EquipMenuData = {
	   type = "Grenade",
	   desc = [[
	   Левая кнопка мыши:
	   Бросить флешку]]
	   
   };

end

SWEP.Primary.NumNades = 3 
SWEP.Grenade = "ttt_thrownflashbang"

local here = true
SWEP.Author = "Converted by Porter reworked by BocciardoLight"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Base = "weapon_tttbasegrenade"

SWEP.ViewModel			= "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel			= "models/weapons/w_eq_flashbang.mdl"
SWEP.ViewModelFlip		= true
SWEP.AutoSwitchFrom		= true

SWEP.DrawCrosshair		= false

SWEP.IsGrenade = true
SWEP.NoSights = true

SWEP.was_thrown = false

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = {ROLE_TRAITOR} 
SWEP.LimitedStock = false
SWEP.Icon = "vgui/ttt/icon_flashbang.png"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:GetGrenadeName()
   return "ttt_thrownflashbang"
end