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

	self:SetJobName("GSR")

	self:SetSequence("idle")
end

function ENT:AcceptInput(name, ply)
	if name == "Use" && ply:IsPlayer() then
		net.Start("Job.OpenMenu")
			net.WriteString(self:GetJobName())
		net.Send(ply)
	end
end