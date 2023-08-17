AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.damage = redcode.config.panelhp
end


local red_code_cooldown = CurTime()

util.AddNetworkString("RedCodeStarted")
util.AddNetworkString("RedCodeEnd")

function DieOrChange(ply, before)
	if isnumber(before) and redcode.config.die_jobs[team.GetName(before)]  then
		if GetGlobalInt("Slime_Red_Code") == 1 then
			SetGlobalInt("Slime_Red_Code", 0)
			net.Start("RedCodeEnd")
			net.Broadcast()
			DarkRP.notifyAll(1,5, redcode.config.text_to_missing or "ERROR")
			red_code_cooldown = CurTime() + 1800
		end
	end
	if ply:IsValid() and redcode.config.die_jobs[team.GetName(ply:Team())] then 
		if GetGlobalInt("Slime_Red_Code") == 1 then
			SetGlobalInt("Slime_Red_Code", 0)
			net.Start("RedCodeEnd")
			net.Broadcast()
			DarkRP.notifyAll(1,5, redcode.config.text_to_death or "ERROR")
			red_code_cooldown = CurTime() + 1800
		end
	end

end


hook.Add("PlayerDeath", "RedCodeDeath", DieOrChange)
hook.Add("OnPlayerChangedTeam", "RedCodeChangeJob", DieOrChange)



function ENT:Use(ply)
	if ply:IsPlayer() and ply:Alive() then
		if redcode.config.r_jobsallow[team.GetName(ply:Team())] or ply:Team() == TEAM_MAYOR then
			if self.damage <= 0 then 
				DarkRP.notify(ply, 1, 5, "Панель управления КК сломана.")
				return
			end
			if GetGlobalInt("JobPhaseStatus") == 1 then return DarkRP.notify(ply,1,4,"В данный момент обьявлена рабочая фаза. Действие невозможно.") end
			if GetGlobalInt("Slime_Red_Code") == 0 then
				if not timer.Exists("y_customcheck") and not timer.Exists("y_break_check") then
					if red_code_cooldown > CurTime() then return DarkRP.notify(ply,1,4,"В данный момент невозможно включить красный код.") end
					SetGlobalInt("Slime_Red_Code", 1)
					net.Start("RedCodeStarted")
					net.Broadcast()


					timer.Simple(redcode.config.redcode, function ()
						if GetGlobalInt("Slime_Red_Code") == 1 then
							SetGlobalInt("Slime_Red_Code", 0)
							net.Start("RedCodeEnd")
							net.Broadcast()
						end
					end)
				end				
			end
		else
			ply:ChatPrint( "Доступно только для CMD.OTA" )
		end
	end
end

function ENT:Break()
	if redcode.config.dbug == true then 
		MsgC(Color(0,255,0), "Панель КК сломали!\n") 
	end
	if ( GetGlobalInt( "Slime_Red_Code", 0 ) != 0 ) then
		for k,v in pairs(player.GetAll()) do
			net.Start( "RedCodeEnd" )
			net.Send(v)
		end
		SetGlobalInt("Slime_Red_Code", 0)
	end
	timer.Create( "y_break_check", redcode.config.crashtime, 1, function() 
		self.damage = redcode.config.panelhp
		if redcode.config.dbug == true then 
			MsgC(Color(0,255,0), "CustomCheck закончен, панель ЖК работает.\n") 
		end 
	end )
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()
	if redcode.config.dbug == true then 
		MsgC(Color(0,255,0), self.damage.."/"..redcode.config.panelhp.."\n") 
	end 
	if self.damage <= 0 then
		if timer.Exists("y_break_check") == false then
			self:Break()
		end
	end
end