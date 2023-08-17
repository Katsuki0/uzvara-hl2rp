hook.Add("PlayerDeath", "DeathGunDropper", function (ply)
	local default_weap = GAMEMODE.Config.DefaultWeapons
	local job_weap = ply:getJobTable().weapons
	local blocked_weapons = GAMEMODE.Config.DisallowDrop

	local actual_weap = ply:GetWeapons()


	for num, weap in pairs (actual_weap) do
		if not table.HasValue(default_weap, weap:GetClass()) then
			if not table.HasValue(job_weap, weap:GetClass()) then
				if not blocked_weapons[weap:GetClass()] then
					local q = ents.Create("spawned_weapon")
					q:SetModel(weap:GetModel())
					q:SetPos(ply:GetPos() + Vector (0, 20, 0))
					q:SetWeaponClass(weap:GetClass())
					q.clip1 = weap:Clip1()
					q.clip2 = weap:Clip2()
					q.nodupe = true
					q:Spawn()
				end
			end
		end
	end

end)