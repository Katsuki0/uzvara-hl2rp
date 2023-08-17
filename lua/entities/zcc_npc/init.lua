AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.JobNPC = true

function ENT:Initialize()
	self:SetModel("models/Humans/Group02/male_02.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetHullSizeNormal()

	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()

	self:SetMaxYawSpeed(90)

	self:SetSequence("idle")
end

function ENT:AcceptInput( Name, activator, Caller )	
				if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 1.5
		else
			return
		end
	if Name == "Use" and Caller:IsPlayer() then
		local tbl = {}
		local entities = ents.FindInSphere(self:GetPos(),50)
		for k, v in pairs(entities) do 
			tbl[#tbl+1] = v:GetClass()
		end

		if table.HasValue(tbl, "zcc_ent") then
			for k, v in pairs(entities) do 
				if v:GetClass() == "zcc_ent" then
					local price = math.random(7)
					v:Remove()
					Caller:addMoney(price)
					DarkRP.notify(Caller, 0, 4, "Вы получили "..DarkRP.formatMoney(price))
				end
			end
		else
							if activator:Team() != allowedTeam then activator:ChatPrint( "Ты принёс мне посылку?" ) return end
		end
	end
end