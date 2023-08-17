




hook.Add("OnPlayerChangedTeam", "lifeTimer", function (ply, before, after)
	if ply:getJobTable().lives then
		ply.LifeLeft = ply:getJobTable().lives
		DarkRP.notify(ply,1,5, "У этой профессии есть лимит на жизни. В данный момент у вас "..ply.LifeLeft.." жизни")
	end
end)



hook.Add("OnPlayerChangedTeam", "lifesBanIfAbuse", function (ply, before, after)
	if ply:IsValid() then
		local j_table = RPExtraTeams[before]
		if j_table.lives then
			if ply.LifeLeft < 2 then
				ply:teamBan(before, 1800)
				DarkRP.notify(ply,1,5, "У вас было меньше двух жизней и вы потеряли доступ к прошлой профессии")
			end
		end
	end
end)




hook.Add("PlayerDeath", "StopFuckingMessingMeUP", function (v)
	local lifes = v:getJobTable().lives
	
	if lifes and v.LifeLeft > 0 then
		v.LifeLeft = v.LifeLeft - 1
		DarkRP.notify(v,1,4, "Вы потеряли одну жизнь за эту проффесию. У вас осталось : "..v.LifeLeft)
	else
		v:teamBan(v:Team(), 60) -- На сколько банится профа по времени
		v:changeTeam(1, true) -- На что меняется профа.
		DarkRP.notify(v,1,5, "Вы исчерпали лимит смертей")
	end
end)






-- TEAM_HOBO = DarkRP.createJob("ЛОЛКЕКЧЕБУРЕК", {
--    color = Color(148, 80, 3, 255),
--    model = {"models/player/corpse1.mdl"},
--    description = [[]],
--    weapons = {""},
--    command = "lol",
--    max = 0,
--    salary = 10,
--    lives = 2, -- СКОЛЬКО ЖИЗНЕЙ ДОЛЖНО БЫТЬ
--    admin = 0,
--    vote = false,
--    hasLicense = false,
--    category = "Профессии",
-- })