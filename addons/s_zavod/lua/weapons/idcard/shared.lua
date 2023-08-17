AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "CID-карта"
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false

end

SWEP.Author = "Ferzux"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IsDarkRPKeys = true

SWEP.WorldModel = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix  = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "DarkRP (Utility)"
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true
end

function SWEP:Holster()
    return true
end

function SWEP:PreDrawViewModel()
    return true
end



function SWEP:PrimaryAttack()
    if self.Owner:GetNWInt("PlayerCID") > 0 then
        self.Owner:ConCommand("say /me показал CID-карту: "..self.Owner:Nick()..", #"..self.Owner:GetNWInt("PlayerCID"))
    else
        self.Owner:SetNWInt("PlayerCID", math.random(10000, 99999))
        self.Owner:ConCommand("say /me показал CID-карту: "..self.Owner:Nick()..", #"..self.Owner:GetNWInt("PlayerCID"))
    end
end

function SWEP:SecondaryAttack()
    if self.Owner:GetNWInt("PlayerCID") > 0 then
        self.Owner:ConCommand("say /me показал CID-карту: "..self.Owner:Nick()..", #"..self.Owner:GetNWInt("PlayerCID"))
    else
        self.Owner:SetNWInt("PlayerCID", math.random(10000, 99999))
        self.Owner:ConCommand("say /me показал CID-карту: "..self.Owner:Nick()..", #"..self.Owner:GetNWInt("PlayerCID"))
    end
end

