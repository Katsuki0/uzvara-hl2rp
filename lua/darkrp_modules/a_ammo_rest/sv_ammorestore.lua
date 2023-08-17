// Grenades and other stuff resuit
local ammo_table = {
	// https://wiki.facepunch.com/gmod/Default_Ammo_Types
	// ["ОРУЖИЕ ИЗ Q МЕНЮ"] = "ТИП ПАТРОНОВ ИЗ ^"
	["weapon_frag"] = "Grenade",
	["swb_pistol"] = "Pistol",
	["weapon_slam"] = "slam",
	["swb_shotgun"] = "Buckshot",
	["swb_357"] = "357",
}

timer.Simple(2, function ()
	local resets_jobs = {
		[TEAM_CMDUNIT] = { -- Проффесия
			time = 60, -- Время через которое восстанавливается патроны и оружие
			weapons = {["swb_shotgun"] = 50, ["swb_357"] = 10}, -- Список оружия которое будет восстанавливатся (Гранаты например)
		},
		[TEAM_HOBO] = { -- Проффесия
			time = 360, -- Время через которое восстанавливается патроны и оружие
			weapons = {["weapon_slam"] = 5, ["swb_shotgun"] = 10}, -- Список оружия которое будет восстанавливатся (Гранаты например)
		},
	}

	// Наброски
	// Да, я знаю что три цикла это не есть хорошо но я целую ночь думал как это можно сделать проще и ничего так и не придумал.
	// Даже в чате кодеров спросил но они тоже не смогли дать дельного совета. Потому делаем так, как делаем.
	for job_number, tbl in pairs (resets_jobs) do
		timer.Create("restoreWeaponAndAmmoIntime.TeamNumber : "..job_number, tbl.time, 0, function ()
			for _, ply in pairs (team.GetPlayers(job_number)) do
				for weap, count in pairs (tbl.weapons) do
					ply:Give(weap)
					ply:GiveAmmo(count, ammo_table[weap])
				end
			end
		end)
	end
end)