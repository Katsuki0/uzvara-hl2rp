AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


local Drugs = {""} -- Список наркотиков
 
local Weapons = {"swb_smg", "swb_shotgun", "swb_pistol"} -- Список оружий
 
local Printers = {"vzlom_polya", "weapon_hl2axe"} -- Список предметов
 

function ENT:Initialize()

	self:SetModel("models/props_combine/combine_interface003.mdl")
	
	self:PhysicsInit(SOLID_VPHYSICS)
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	self:SetSolid(SOLID_VPHYSICS)
	
	self:SetUseType(SIMPLE_USE)
	
end

function ENT:AcceptInput( Name, ply)	

    	if( Name == "Use" ) then
					if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 1.5
		else
			return
		end
    		ply:ChatPrint( "Положите сюда нелегальное оружие!" );
			
    	end
		
end

function ENT:StartTouch(ent)

	if table.HasValue(Drugs,ent:GetClass()) then

			ent:Remove()
			
			ent:EmitSound( "buttons/button5.wav" )
			
			DarkRP.createMoneyBag(self:GetPos()- Vector(1,1,-30), math.random(0,0)) -- Спавн денег
			
	elseif ent:GetClass() == "spawned_weapon" and table.HasValue(Weapons,ent:GetWeaponClass()) then
	
			ent:Remove()
			
			ent:EmitSound( "buttons/button5.wav" )
			
			DarkRP.createMoneyBag(self:GetPos()- Vector(1,1,-30), math.random(0,0)) -- Спавн денег
			
	elseif table.HasValue(Printers,ent:GetClass()) then	

			ent:Remove()
			
			ent:EmitSound( "buttons/button5.wav" )
			
			DarkRP.createMoneyBag(self:GetPos()- Vector(1,1,-30), math.random(0,0))	-- Спавн денег
			
	end
	
end