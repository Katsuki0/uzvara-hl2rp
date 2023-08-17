util.AddNetworkString("R_Broadcast.SendDeath")
util.AddNetworkString("R_Broadcast.SendCoded")

hook.Add( "PlayerDeath", "R_Broadcast.PlayerDeath", function( victim, inflictor, attacker )
	if not IsValid(attacker) then return end
	if not attacker:IsPlayer() then return end
	if attacker:Team() == TEAM_MAYOR then return end

	if not victim:isCP() then return end

	local cps = {}
	for k,v in pairs(player.GetAll()) do
		if v:isCP() then 
			table.insert(cps, v)
		end
	end

	if victim == attacker then
		DarkRP.notify(cps, 1, 4, "Смерть "..victim:GetName()..". Суицид")
	elseif victim:Team() == TEAM_MAYOR then
		DarkRP.notify(cps, 1, 8,  attacker:GetName().. " убил главу города ")
	elseif attacker:isCP() then
		DarkRP.notify(cps, 1, 4, "Смерть "..victim:GetName()..". Убийца "..attacker:GetName())
		DarkRP.notify(cps, 3, 8,  attacker:GetName().. " нуждается в проверке на дефектность")
	else
		DarkRP.notify(cps, 1, 4, "Смерть "..victim:GetName()..". Убийца "..attacker:GetName())
		-- attacker:wanted(nil, "Убийство "..victim:GetName())
	end

	net.Start("R_Broadcast.SendDeath")
	net.WriteString(victim:Name())
	net.WriteVector(victim:GetPos())
	net.Send(cps)
end)

concommand.Add("broadcode", function(ply, command, args)
	if not ply:Alive() then ply:ChatPrint("Вы мертвы") return end
	if not ply:isCP() then ply:ChatPrint("Вы не ГО и не ОТА") return end

	if args == "" then return end

	local cps = {}
	for k,v in pairs(player.GetAll()) do
		if v:isCP() then 
			table.insert(cps, v)
		end
	end

	DarkRP.notify(cps, 0, 8, ply:GetName().." Транслирует "..args[1]) 

	net.Start("R_Broadcast.SendCoded")
	net.WriteEntity(ply)
	net.Send(cps)

	return ""
end)