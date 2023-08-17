// hi there
//this is just a shitty swep i made to have fun with friends
//if you own a server, feel free to contract me. 
//I will make you addons for very cheap :)
--
//if you're a developer, feel free to use any code within
//love you

if ( SERVER ) then

	AddCSLuaFile("")

	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	
	CreateConVar( "roulette_secondary_resets", 0, FCVAR_SERVER_CAN_EXECUTE, "Set as 1 to make secondary attack reduce the chance back to 0" )

end

if ( CLIENT ) then

	SWEP.PrintName = "Русская Рулетка"
	SWEP.Author = "rejax"

	SWEP.Slot = 1
	SWEP.SlotPos = 6
	
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	
	SWEP.Category	= "Другое"

end

SWEP.ViewModel		= "models/weapons/v_357.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.ViewModelFlip	= false
SWEP.UseHands		= true

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.AutoSwitchTo	    = true
SWEP.AutoSwitchFrom  	= true
SWEP.ViewModelFOV 		= 50

amt = 0

function SWEP:Deploy()

         self.Weapon:EmitSound( "weapons/357/357_spin1.wav" )
		 
end

function SWEP:PrimaryAttack()   

	self.Weapon:SetNextPrimaryFire(CurTime()+10)
	
	if SERVER then

	
	local ShootSound = Sound( "weapons/357/357_fire3.wav" )
	local EmptySound = Sound( "weapons/pistol/pistol_empty.wav" )
	local ReloadSound = Sound( "weapons/357/357_reload1.wav" )
	local ohno = {
	"vo/npc/male01/gordead_ans02.wav",
	"vo/npc/male01/gordead_ans04.wav",
	"vo/npc/male01/gordead_ans07.wav",
	"vo/npc/male01/gordead_ans08.wav",
	"vo/npc/male01/gordead_ans16.wav",
	"vo/npc/male01/gordead_ans19.wav",
	"vo/npc/male01/question30.wav",
	}
	local happy = {
	"vo/npc/coast/odessa/male01/nlo_cheer01",
	"vo/npc/coast/odessa/male01/nlo_cheer02",
	"vo/npc/coast/odessa/male01/nlo_cheer03",
	"vo/npc/coast/odessa/male01/nlo_cheer04",
	}
	local preshot = {
	"vo/npc/male01/pain01.wav",
	"vo/npc/male01/pain02.wav",
	"vo/npc/male01/pain03.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/male01/pain05.wav",
	"vo/npc/male01/pain06.wav",
	}
	local ShootAlive = {
	"vo/npc/male01/ohno.wav",
	"vo/npc/male01/letsgo02.wav",
	}
	local ShootScream = Sound("vo/npc/male01/no02.wav")
	
	local ply = self.Owner
	local wep = "weapon_roulette"
	local chance = math.random( 1, 6 )
	
	sound.Play( table.Random( preshot ), ply:GetPos() )
	
	timer.Simple( 1, function()
	
	if amt ~= 6 then
	
	if ( chance>4 ) then -- bullet in chamber
	
	amt = 0
	
	ply:EmitSound(ShootSound)
	ply:EmitSound(ShootScream)
	// print("Dead")
	
	ply:DropNamedWeapon(wep)
	ply:Kill()

	for k, v in pairs(ents.FindInSphere( ply:GetPos(), 500 )) do
		if v:IsPlayer() and v:Alive() and v ~= ply then
			if string.StartWith( tostring(v), "Player" ) then
			// print(v:Name())
			sound.Play( table.Random(ohno), v:GetPos() )
			end
		end
	end
	
	else -- no bullet in chamber
	
	for k, v in pairs(ents.FindInSphere( ply:GetPos(), 500 )) do
		if v:IsPlayer() and v:Alive() and v ~= ply then
			if string.StartWith( tostring(v), "Player" ) then
				sound.Play( table.Random(ShootAlive), v:GetPos() )
			end
		end
	end
	
	//PrintTable(ents.FindInSphere( ply:GetPos(), 500 ))
	//print( "Alive" )
	ply:EmitSound(EmptySound)
	ply:EmitSound(ReloadSound)

	ply:DropNamedWeapon( "weapon_roulette" )

	amt = amt+1

	end // do shoot
	
	else // over 6 for some reason
	
	ply:EmitSound(ShootSound)
	ply:EmitSound(ShootScream)
	// print("Dead")
	
	ply:DropNamedWeapon(wep)
	ply:Kill()

	for k, v in pairs(ents.FindInSphere( ply:GetPos(), 500 )) do
		if v:IsPlayer() and v:Alive() and v ~= ply then
			if string.StartWith( tostring(v), "Player" ) then
			// print(v:Name())
			sound.Play( table.Random(ohno), v:GetPos() )
			end
		end
	end
	
		end // amt
	
		end) //timer
	
	end //server
	
end //primary

function SWEP:SecondaryAttack()
self.Weapon:SetNextSecondaryFire(CurTime()+5)
self.Weapon:EmitSound( "weapons/357/357_spin1.wav" )
	if GetConVar( "roulette_secondary_resets" ) ~= 0 then
	amt = 0 --Reset default chance
	end
end