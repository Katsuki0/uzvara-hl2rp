SWEP.Base 				    = "scoped_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Author				        = ""
SWEP.Contact				    = ""
SWEP.Purpose				    = "Combine Sniper Rifle on M9K base. No laser this time."
SWEP.Instructions				= ""

if CLIENT then

    SWEP.PrintName				= "Снайперская Винтовка"		-- Weapon name (Shown on HUD)
    SWEP.ViewModelFOV			= 64
    SWEP.ViewModelFlip			= false	
    SWEP.Slot				    = 4	-- Slot in the weapon selection menu
    SWEP.SlotPos				= 1		-- Position in the slot
    SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
    SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
    SWEP.BounceWeaponIcon   	= false	    -- Should the weapon icon bounce?
    SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
    SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
    SWEP.Weight				    = 50		-- Rank relative ot other weapons. bigger is better
    SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
    SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
    SWEP.BoltAction				= false		-- Is this a bolt action rifle?
    SWEP.HoldType 				= "ar2"	    -- how others view you carrying the weapon
	
	killicon.Add("m9k_combinesniper", "csniper/sniperkill", color_white ) --Custom Killicon
	
	surface.CreateFont( "csd",
		{
		font = "csd",
		size = ScreenScale(90),
		weight = 400
		})
	
	SWEP.IconLetter			= "a"
	
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText("o", "csd", x + 0.48*wide, y + tall*0.35, Color(0,200,255,255), TEXT_ALIGN_CENTER)
		-- Draw weapon info box
		self:PrintWeaponInfo(x + wide + 0.90, y + tall*0.90, alpha)
	end
	
end

SWEP.Category               = "Оружие"

SWEP.ViewModel				= "models/weapons/v_combinesniper_e2.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_combinesniper_e2.mdl"	-- Weapon world model

SWEP.Primary.Sound			    = Sound("weapons/combinesniper_e2/ep2sniper_fire.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 50		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip		= 0	    -- Bullets you start with
SWEP.Primary.KickUp				= 6	    -- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 3			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 2		    -- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			    = "357"	    -- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets
SWEP.Primary.Force              = 10

SWEP.Secondary.ScopeZoom			= 11	
SWEP.Secondary.UseACOG			= false -- Choose one scope type
SWEP.Secondary.UseMilDot		= false	-- I mean it, only one	
SWEP.Secondary.UseSVD			= false	-- If you choose more than one, your scope will not show up at all
SWEP.Secondary.UseParabolic		= true	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false	
SWEP.Secondary.UseAimpoint		= false
SWEP.Secondary.UseMatador		= false

SWEP.data 				= {}
SWEP.data.ironsights		= 1
SWEP.ScopeScale 			= 0.63
SWEP.ReticleScale 			= 0.5

SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 50	--base damage per bullet
SWEP.Primary.Spread		= .065	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .00001 -- ironsight accuracy, should be the same for shotguns

-- enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-6.031, -8.443, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(-4.961, -13.78, 1.968)
SWEP.SightsAng = Vector (0, 0, 0)
SWEP.RunSightsPos = Vector(4.802, -4.803, 0.865)
SWEP.RunSightsAng = Vector(-4.134, 31.142, 12.402)