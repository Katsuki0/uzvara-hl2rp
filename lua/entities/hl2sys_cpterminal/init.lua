AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()	
	self:SetNWInt("FactoryIsWorking", 0)
	self:SetUseType( SIMPLE_USE )
	-- предотвращение абуза
	self.LastUse = 0
	self.Delay = 2
	util.AddNetworkString( "giveWeapons" )
	util.AddNetworkString( "giveAmmo" )
	
	
end
util.AddNetworkString( "giveWeapons" )

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
			if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 1.5
		else
			return
		end
		if !Caller:isCP() then Caller:ChatPrint( "Доступно только для Альянса" ) return end
		umsg.Start("CPTerminalOpen", Caller)
		umsg.End()
	end
end

function ENT:Use(ply)
end

net.Receive( "giveWeapons", function( len, ply ) -- выдача оружия тут!
	-- ply:Give("ID оружия")
	-- elseif ply:Team() == TEAM_ID then ply:Give("weapon_ment")

	if ply:Team() == TEAM_RCT then				    ply:Give("stunstick2")	ply:Give("weaponchecker")	ply:Give("weapon_cuff_rope")
	--
	
	elseif ply:Team() == TEAM_SEC then		        ply:Give("stunstick2") 	ply:Give("weaponchecker")	ply:Give("fas2_cweaponry_pph")	ply:Give("weapon_cuff_rope") ply:Give("door_ram") ply:Give("keypad_cracker") ply:Give("fas2_cweaponry_pcshotgun")
	
	end
end )

net.Receive( "giveAmmo", function( len, ply )

	ply:addMoney(0) -- снятие денег


	ply:GiveAmmo( 30, "ar2", true )

	ply:GiveAmmo( 30, "smg1", true )

	ply:GiveAmmo( 30, "smg", true )

	ply:GiveAmmo( 30, "357", true )

	ply:GiveAmmo( 30, "pistol", true )

	ply:GiveAmmo( 30, "buckshot", true )
	
	ply:GiveAmmo( 30, "rpg_round", true )
end )

