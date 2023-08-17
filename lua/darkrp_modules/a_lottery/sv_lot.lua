print ("Serverside LOT")

timer.Simple(5, function ()
	local blacklisted_jobs = {
		[TEAM_CMDUNIT] = true,
	}
end)

local mayor_player


hook.Add("lotteryStarted", "lotSystem", function (ply, price)
	if blacklisted_jobs[ply:Team()] then 
		return DarkRP.notify(ply,1,4, "Вы не можете участвовать")
	end

	mayor_player = ply
end)

hook.Add("lotteryEnded", "lotSystemEnded", function (entered_tab, winner, money)
	local money_to_mayor = math.Round(money/10)

	if winner:IsValid() then
		winner:addMoney(money)
	end

	if mayor_player:IsValid() then
		mayor_player:addMoney(money - money_to_mayor)
	end
end)