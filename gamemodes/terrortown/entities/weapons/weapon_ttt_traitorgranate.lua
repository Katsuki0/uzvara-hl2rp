AddCSLuaFile()

SWEP.HoldType           = "grenade"

if CLIENT then
   SWEP.PrintName       = "Граната предателя"
   SWEP.Slot            = 8

   SWEP.ViewModelFlip   = false
   SWEP.ViewModelFOV    = 54

   SWEP.Icon            = "vgui/ttt/icon_nades"
   SWEP.IconLetter      = "P"

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Граната которая намного мощьнее обычной"
   };
end

SWEP.Base               = "weapon_tttbasegrenade"

SWEP.Kind                   = WEAPON_EQUIP2
SWEP.CanBuy                 = {ROLE_TRAITOR} -- only traitors can buy
SWEP.LimitedStock           = true -- only buyable once
SWEP.WeaponID               = AMMO_FAGGRANATA

SWEP.UseHands           = true
SWEP.ViewModel          = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel         = "models/weapons/w_eq_flashbang.mdl"

SWEP.Weight             = 5
SWEP.AutoSpawnable      = true
SWEP.Spawnable          = true
-- really the only difference between grenade weapons: the model and the thrown
-- ent.

function SWEP:GetGrenadeName()
   return "ttt_firegrenade_traitor"
end
