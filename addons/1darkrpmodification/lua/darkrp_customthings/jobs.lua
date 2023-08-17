--Граждани/гср
TEAM_GRAZHDANIN = DarkRP.createJob("Гражданин", {
    color = Color(50, 205, 50, 255),
    model = {
        "models/player/zelpa/female_01.mdl",
        "models/player/zelpa/female_01_b.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_03_b.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_04_b.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_06_b.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/female_07_b.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl",
    },
    description = [[
Человек, зарегистрированный
в городе, следует правилам, 
выдает всю информацию.
"Тише едешь – дальше будешь"
	]],
    weapons = {"keys", "itemstore_pickup", "id", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "admingrazhdanicn",
    max = 0,
    salary = 0,
    admin = 0,
    vote = false,
	female = true,
    hasLicense = false,
    category = "Другие",
	candemote = false,
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
		ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetSkin(math.floor(math.random(0,17)))
		ply:SetBodygroup(1, math.floor(math.random(0,2))) 
		ply:SetBodygroup(2, math.floor(math.random(0,1)))
		ply:SetBodygroup(4, math.floor(math.random(0,1)))
		ply:SetBodygroup(5, math.floor(math.random(0,1)))
	end,
})

TEAM_PISHEVOJSNABDITEL = DarkRP.createJob("Пищевой снабдитель ГСР", {
    color = Color(255, 215, 0, 255),
    model = {
        "models/player/zelpa/female_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Пищевой снабдителем из Отдела ГСР. 
Снабжайте питанием город, ставьте цены
в пределах разумного.
„Повар мыслит порциями.“
	]],
    weapons = { "keys", "itemstore_pickup", "id", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminpishevojcsnabditel",
    max = 3,
    salary = 0,
    admin = 0,
    vote = false,
	candemote = false,
    hasLicense = false,
    category = "ГСР",
	type = "GSR",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetBodygroup(1, 12) 
		ply:SetBodygroup(2, 5) 
		ply:SetBodygroup(3, 12) 
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_PISHEVOJSNABDITE then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_GRUZHCHIK = DarkRP.createJob("Грузчик ГСР", {
    color = Color(255, 215, 0, 255),
    model = {
        "models/player/zelpa/female_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Грузчик из Отдела ГСР.  
Работайте на благо города и при этом зарабатывайте!
"И жил он долго и счастливо… Пока не вышел на работу."
	]],
    weapons = {"keys", "itemstore_pickup", "id", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "admingruzhcchik",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
	candemote = false,
    hasLicense = false,
    category = "ГСР",
	type = "GSR",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetBodygroup(1, 12) 
		ply:SetBodygroup(2, 5) 
		ply:SetBodygroup(3, 12) 
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_GRUZHCHIK then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_POSILNIJ = DarkRP.createJob("Посыльный ГСР", {
    color = Color(255, 215, 0, 255),
    model = {
        "models/player/zelpa/female_01.mdl",
        "models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Посыльный из Отдела ГСР. 
Доставляйте посылки и на этом зарабатывайте!
"Вдохновение приходит только во время работы."
	]],
    weapons = {"keys", "itemstore_pickup", "id", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminpocsilnij",
    max = 1,
    salary = 0,
	candemote = false,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ГСР",
	type = "GSR",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetBodygroup(1, 12) 
		ply:SetBodygroup(2, 5) 
		ply:SetBodygroup(3, 12) 
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_POSILNIJ then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_RAZNORABOCHIJ = DarkRP.createJob("Разнорабочий ГСР", {
    color = Color(255, 215, 0, 255),
    model = {
        "models/player/zelpa/female_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Разнорабочий из Отдела ГСР. 
Создавайте бизнес, при этом зарабатывайте.
Организовывайте мероприятия в пределах разумного.
"Когда ваши дела идут плохо — не ходите с ними."

	]],
    weapons = {"keys", "itemstore_pickup", "id", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminrazcnorcabochij",
    max = 4,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ГСР",
	candemote = false,
	type = "GSR",
	unlockCost = 95,
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
		ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetBodygroup(1, 13) 
		ply:SetBodygroup(2, 5) 
		ply:SetBodygroup(3, 12) 
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_RAZNORABOCHIJ then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_DSPMEDIK = DarkRP.createJob("Доктор ГСР", {
    color = Color(255, 215, 0, 255),
    model = {
        "models/player/zelpa/female_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Доктор из Отдела ГСР. 
Работайте на благо города и при этом зарабатывайте!
"В могущество врачей верят только здоровые."
	]],
    weapons = {"keys", "itemstore_pickup", "med_kit", "id", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminfsaqwrtzhcchik",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
	Detective = true,
	candemote = false,
    hasLicense = false,
    category = "ГСР",
	requireUnlock = TEAM_RAZNORABOCHIJ,
	unlockCost = 120,
	type = "GSR",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetBodygroup(1, 9) 
		ply:SetBodygroup(2, 5) 
		ply:SetBodygroup(3, 12) 
	end,
	PlayerDeath = function(ply)
                if ply:Team() == DSPMEDIK then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_GLAVADSP = DarkRP.createJob("Глава ГСР", {
    color = Color(255, 215, 0, 255),
    model = {
        "models/player/zelpa/male_08.mdl",
    },
    description = [[
Глава ГСР, управляет всеми рабочими ГСР.
Получает прямые приказы от Администратора Города. 
Поддерживает город в правопорядке.
"Лидер подобен дельцу, ожидающему прибыли."
	]],
    weapons = {"keys", "itemstore_pickup", "id", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "admgfawqsilnij",
    max = 1,
    salary = 0,
	candemote = false,
    admin = 0,
    vote = false,
    hasLicense = false,
	requireUnlock = TEAM_DSPMEDIK,
	unlockCost = 170,
    category = "ГСР",
	customCheck = function(ply) return ply:GetNWString("usergroup") == "vip" or ply:GetNWString("usergroup") == "operator_vd" or ply:GetNWString("usergroup") == "admin" or ply:GetNWString("usergroup") == "operator_vn" or ply:IsAdmin() end,
	CustomCheckFailMsg = "Эта работа только для VIP!",
	type = "GSR",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы 
		ply:SetBodygroup(1, 14) 
		ply:SetBodygroup(2, 5) 
		ply:SetBodygroup(3, 12) 
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_POSILNIJ then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})
--Гражданская оборона
TEAM_UNIT1 = DarkRP.createJob("UNIT.1", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/DPFilms/Metropolice/Playermodels/pm_HDpolice.mdl"
    },
    description = [[
Сотрудник Граждаской Обороны. 
Человек, начинающий службу в Альянсе. 
"Закон есть закон, сколько бы его ни нарушали."

	]],
    weapons = {"keys", "itemstore_pickup", "door_ram", "weapon_physcannon", "weapon_physgun", "gmod_tool", "weapon_stunstick2", "weaponchecker"},
    command = "adminucnit1",
    max = 3,
    salary = 8,
    admin = 0,
	candemote = false,
	mpf = true,
	unlockCost = 120,
    vote = false,
    hasLicense = false,
    category = "Гражданская Оборона",
		type = "GO",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_UNIT1 then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_UNITMEDIC = DarkRP.createJob("UNIT.MEDIC", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_civil_medic.mdl",
    },
    description = [[
Медик гражданской оборон.
Следит за здоровьем всего состава.
"Медицина заставляет нас умирать
 продолжительнее и мучительнее."
	]],
    weapons = {"keys", "itemstore_pickup", "swb_pistol", "weapon_stunstick2", "med_kit", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool", "weaponchecker"},
    command = "admincunitmedic",
    max = 1,
    salary = 12,
    admin = 0,
    vote = false,
	mpf = true,
	candemote = false,
	unlockCost = 130,
	requireUnlock = TEAM_UNIT1,
    hasLicense = false,
    category = "Гражданская Оборона",
	type = "GO",
	Detective = true,
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_UNITMEDIC then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_UNIT2 = DarkRP.createJob("UNIT.2", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/DPFilms/Metropolice/Playermodels/pm_HDpolice.mdl",
    },
    description = [[
Сотрудник Граждаской Обороны. 
Человек, уже обученный в Альянсе. 
"Мелкие беспорядки порождают крупные силы порядка."
	]],
    weapons = {"keys", "itemstore_pickup", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool", "weapon_stunstick2", "swb_pistol", "weaponchecker"},
    command = "admincunit2",
    max = 3,
    salary = 10,
    admin = 0,
	candemote = false,
	mpf = true,
    vote = false,
	requireUnlock = TEAM_UNITMEDIC,
	unlockCost = 145,
    hasLicense = false,
    category = "Гражданская Оборона",
	type = "GO",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_UNIT2 then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_UNITENGINER = DarkRP.createJob("UNIT.ENGINER", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_biopolice.mdl",
    },
    description = [[
Инженер гражданской обороны,
ваша задача устанавливать оборону. 
"Работа лучшее лекарство от всех бед"
	]],
    weapons = {"keys", "itemstore_pickup", "swb_pistol", "weapon_stunstick2", "med_kit", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool", "weaponchecker"},
    command = "admczawqerfsazcunitmedic",
    max = 1,
    salary = 12,
    admin = 0,
    vote = false,
	requireUnlock = TEAM_UNIT2,
	unlockCost = 160,
	mpf = true,
	candemote = false,
    hasLicense = false,
    category = "Гражданская Оборона",
	type = "GO",
	Detective = true,
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_UNITENGINER then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_UNIT3 = DarkRP.createJob("UNIT.3", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_urban_police.mdl",
    },
    description = [[
Сотрудник Граждаской Обороны. 
Человек, уже опытный в службе на Альянсе. 
"Я не против полиции; я просто боюсь её."
	]],
    weapons = {"keys", "itemstore_pickup", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool", "swb_pistol", "weapon_stunstick2", "swb_smg", "weaponchecker"},
    command = "admincunit3",
    max = 2,
    salary = 12,
    admin = 0,
	mpf = true,
	candemote = false,
    vote = false,
	requireUnlock = TEAM_UNITENGINER,
	unlockCost = 170,
    hasLicense = false,
    category = "Гражданская Оборона",
	type = "GO",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_UNIT3 then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_UNIT4 = DarkRP.createJob("UNIT.4", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_urban_police.mdl",
    },
    description = [[
Сотрудник Граждаской Обороны. 
Специалист в своём деле. 
"Преступление не окупается. 
 Остальные занятия, в общем-то, тоже."


]],
    weapons = {"keys", "itemstore_pickup", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool", "swb_pistol", "weapon_stunstick2", "swb_shotgun", "weapon_smallcombineshield", "weaponchecker"},
    command = "admicnunit4",
    max = 1,
    salary = 12,
    admin = 0,
	mpf = true,
    vote = false,
	requireUnlock = TEAM_UNIT3,
	unlockCost = 195,
	candemote = false,
    hasLicense = false,
    category = "Гражданская Оборона",
	type = "GO",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_UNIT4 then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_UNIT5 = DarkRP.createJob("UNIT.5", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_policetrench.mdl",
    },
    description = [[
Сотрудник Граждаской Обороны. 
Офицер Гражданской обороны,
есть навыки командывание. 
"Недостаток воображения
 предрасполагает к преступлению."

]],
    weapons = {"keys", "itemstore_pickup", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool", "weapon_controllable_manhack",  "swb_smg", "weapon_stunstick2", "weapon_smallcombineshield", "weaponchecker"},
    command = "admicnunit5",
    max = 1,
    salary = 12,
    admin = 0,
	mpf = true,
    vote = false,
	candemote = false,
    hasLicense = false,
	requireUnlock = TEAM_UNIT4,
	unlockCost = 220,
    category = "Гражданская Оборона",
	type = "GO",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_UNIT5 then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_PILIOTA = DarkRP.createJob("UNIT.PILOT", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/DPFilms/Metropolice/Playermodels/pm_hunter_police.mdl",
    },
    description = [[
 Пилот гражданской обороны.
 Управляет грозным оружием альянса, Страйдером.
„Все мы хотели стать пилотами. 
 Большинство из нас стали лузерами.“
	]],
    weapons = {"keys", "itemstore_pickup", "swb_pistol", "weapon_stunstick2", "med_kit", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool", "weaponchecker"},
    command = "admczawqsazzzzxcca11231311aaazafsazcunitmedic",
    max = 1,
    salary = 12,
    admin = 0,
    vote = false,
	mpf = true,
	candemote = false,
    hasLicense = false,
	customCheck = function(ply) return ply:GetNWString("usergroup") == "vip" or ply:GetNWString("usergroup") == "operator_vd" or ply:GetNWString("usergroup") == "admin" or ply:GetNWString("usergroup") == "operator_vn" or ply:IsAdmin() end,
	CustomCheckFailMsg = "Эта работа только для VIP!",
	unlockCost = 245,
    category = "Гражданская Оборона",
	type = "GO",
	Detective = true,
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_PILIOTA then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_CMDUNIT = DarkRP.createJob("CMD.UNIT", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_police_bt.mdl",
    },
    description = [[
Командующий Граждаской Обороной. 
Человек, командующий Гражданской
Обороной. 
"Никто не лидер, если нет последователей."
	]],
    weapons = {"keys", "itemstore_pickup", "swb_shotgun", "swb_357", "weapon_controllable_manhack", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool", "weapon_stunstick2", "weaponchecker"},
    command = "admicnepu",
    max = 1,
    salary = 14,
    admin = 0,
	unlockCost = 220,
    vote = false,
	mpf = true,
	mayor = true,
	candemote = false,
    hasLicense = false,
    category = "Гражданская Оборона",
	type = "GO",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_CMDUNIT then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_ADMGORODA = DarkRP.createJob("Администратор города", {
    color = Color(184, 134, 11, 255),
    model = {
		"models/combineadmin/player/female_01.mdl",
		"models/combineadmin/player/male_01.mdl",
    },
    description = [[
Администратор Города City-11.
Главное общественное лицо, от которого всё зависит.
От рабочей фазы, до красного кода.
"Управляйте вещами. Руководите людьми"
	]],
    weapons = {"keys", "itemstore_pickup", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "admgoroda",
    max = 1,
    salary = 20,
    admin = 0,
    vote = false,
	requireUnlock = TEAM_UNIT5,
	unlockCost = 520,
	candemote = false,
    hasLicense = false,
	mayor = true,
    category = "Гражданская Оборона",
	type = "GO",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
		ply:SetWalkSpeed(100)--скорость ходьбы у профы
		ply:SetRunSpeed(180)--скорость бега у профы
	end,
    PlayerDeath = function(ply)
                    if ply:Team() == TEAM_ADMGORODA then
                            ply:changeTeam( TEAM_GRAZHDANIN, true )
                    end
            end,
})
--Патруль альянса
TEAM_OTAUNION = DarkRP.createJob("OTA.UNION", {
    color = Color(105, 105, 105, 255),
    model = {
        "models/player/combine_soldier.mdl",
    },
    description = [[
Солдат Патруля Альянса - ОТА.
основная пехотная единица армии Альянса на Земле.
"Солдаты попадают прямиком в рай, 
 потому что в аду они уже побывали."
	]],
    weapons = {"keys", "itemstore_pickup", "swb_smg", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminotcaunion1",
    max = 4,
    salary = 8,
    admin = 0,
	requireUnlock = TEAM_UNIT3,
	unlockCost = 245,
	ota = true,
	candemote = false,
    vote = false,
    hasLicense = false,
    category = "ОТА",
	type = "OTA",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(200)--выдача хп
		ply:SetArmor(200)--выдача брони
		ply:SetMaxArmor(200)-- максимальное хп
		ply:SetMaxHealth(200)-- максимальное хп
		ply:SetWalkSpeed(80)--скорость ходьбы у профы
		ply:SetRunSpeed(150)--скорость бега у профы
		ply:SetSkin(0)
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_OTAUNION then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_OTASECURITY = DarkRP.createJob("OTA.SECURITY", {
    color = Color(75, 0, 130, 255),
    model = {
        "models/player/combine_soldier_prisonguard.mdl",
    },
    description = [[
Охраник Патруля Альянса - ОТА.SECURITY.
солдаты, который охраняют тюрьму строгого режима.
Защищающий/Охраняющий Нексус Надзор.
"Тюрьма – недостаток пространства, 
 возмещаемый избытком времени."
	]],
    weapons = {"keys", "itemstore_pickup", "swb_shotgun", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminotcasecurity1",
    max = 4,
    salary = 16,
    admin = 0,
	unlockCost = 270,
	customCheck = function(ply) return ply:GetNWString("usergroup") == "vip" or ply:GetNWString("usergroup") == "operator_vd" or ply:GetNWString("usergroup") == "admin" or ply:GetNWString("usergroup") == "operator_vn" or ply:IsAdmin() end,
	CustomCheckFailMsg = "Эта работа только для VIP!",
	ota = ture,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "ОТА",
	type = "OTA",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(200)--выдача хп
		ply:SetArmor(200)--выдача брони
		ply:SetMaxArmor(200)-- максимальное хп
		ply:SetMaxHealth(200)-- максимальное хп
		ply:SetWalkSpeed(80)--скорость ходьбы у профы
		ply:SetRunSpeed(150)--скорость бега у профы
		ply:SetSkin(math.floor(math.random(0,1)))
		--ply:SetSkin(0, 0)
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_OTASECURITY then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_SNIPER = DarkRP.createJob("OTA.SNIPER", {
    color = Color(0, 0, 255, 255),
    model = {
        "models/player/combine_soldier.mdl",
    },
    description = [[
Снайпер поддержки патруля альянса - OTA.SNIPER.
Солдат вооружённые снайперской винтовкой Альянса.
"Бог не на стороне больших батальонов, 
 а на стороне лучших стрелков."
	]],
    weapons = {"keys", "itemstore_pickup", "swb_pistol", "m9k_combinesniper", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "admincocmbinesniper",
    max = 1,
    salary = 16,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "ОТА",
	requireUnlock = TEAM_OTAUNION,
	unlockCost = 280,
	ota = true,
	candemote = false,
	type = "OTA",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(200)--выдача хп
		ply:SetMaxHealth(200)-- максимальное хп
		ply:SetArmor(200)--выдача брони
		ply:SetMaxArmor(200)-- максимальное хп
		ply:SetWalkSpeed(80)--скорость ходьбы у профы
		ply:SetRunSpeed(150)--скорость бега у профы
		ply:SetSkin(0)
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_SNIPER then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_OTAHEAVY = DarkRP.createJob("OTA.HEAVY", {
    color = Color(139, 69, 19, 255),
    model = {
        "models/player/combine_soldier.mdl",
    },
    description = [[
Тяжёлый солдат альянса - OTA.HEAVY.
Тяжёлая пехотная единица армии Альянса на Земле.
"Солдат не перестает быть солдатом даже, когда ранен."
	]],
    weapons = {"keys", "itemstore_pickup", "swb_shotgun", "weapon_frag", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminotcaheavy1",
    max = 2,
    salary = 14,
    admin = 0,
	ota = true,
	requireUnlock = TEAM_SNIPER,
	unlockCost = 295,
	candemote = false,
    vote = false,
    hasLicense = false,
    category = "ОТА",
	type = "OTA",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(500)--выдача хп
		ply:SetArmor(200)--выдача брони
		ply:SetMaxArmor(200)-- максимальное хп
		ply:SetMaxHealth(500)-- максимальное хп
		ply:SetWalkSpeed(80)--скорость ходьбы у профы
		ply:SetRunSpeed(150)--скорость бега у профы
		--------------- бодигроупы
		ply:SetSkin(1)
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_OTAHEAVY then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_OTAELITE = DarkRP.createJob("OTA.ELITE", {
    color = Color(255, 0, 0, 255),
    model = {
        "models/player/combine_super_soldier.mdl",
    },
    description = [[
Элитный солдат альянса - OTA.ELITE.
Элитная пехотная единица армии Альянса на Земле.
"Бывают ситуации, в которых солдат 
 не имеет права отступать."
	]],
    weapons = {"keys", "itemstore_pickup", "swb_ar2", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminotcaelitee1",
    max = 2,
    salary = 16,
    admin = 0,
	requireUnlock = TEAM_OTAHEAVY,
	unlockCost = 320,
	ota = true,
	candemote = false,
    vote = false,
    hasLicense = false,
    category = "ОТА",
	type = "OTA",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(500)--выдача хп
		ply:SetArmor(200)--выдача брони
		ply:SetMaxArmor(200)-- максимальное хп
		ply:SetMaxHealth(500)-- максимальное хп
		ply:SetWalkSpeed(80)--скорость ходьбы у профы
		ply:SetRunSpeed(150)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_OTAELITE then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_CMDOTA = DarkRP.createJob("CMD.OTA", {
    color = Color(255, 0, 0, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_elite_police.mdl",
    },
    description = [[
Командующий Боевыми Единицами. 
Человек, командующий Солдатам Патруля Альянса. 
Хорошее командывание - залог успеха. 
"Хорошее командывание - залог успеха."
	]],
    weapons = {"weapon_physgun", "gmod_tool", "weapon_physcannon", "keys", "itemstore_pickup", "swb_ar2", "swb_357", "door_ram", "weapon_flash", "weapon_physcannon"},
    command = "adcmindvl",
    max = 1,
    salary = 14,
	ota = true,
    admin = 0,
    vote = false,
	unlockCost = 220,
	candemote = false,
    hasLicense = false,
    category = "Гражданская Оборона",
	type = "OTA",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_CMDOTA then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})
--Зомби
TEAM_ZOMBIE = DarkRP.createJob("Зомби", {
    color = Color(139, 0, 0, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_zombie_police.mdl",
		"models/player/zombie_classic.mdl",
    },
    description = [[
Зомби нужна плоть.
"Конец войны увидят лишь мертвые."
	]],
    weapons = {"w_z_zombie"},
    command = "adminzomcbie1",
    max = 4,
    salary = 0,
    admin = 0,
    vote = false,
	zombie = true,
	unlockCost = 220,
	candemote = false,
    hasLicense = false,
    category = "Зомби",
	type = "zombi",
	lives = 2,
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(500)--выдача хп
		ply:SetMaxHealth(500)-- максимальное хп
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(0)-- максимальное хп
		ply:SetWalkSpeed(100)--скорость ходьбы у профы
		ply:SetRunSpeed(100)--скорость бега у профы
		ply:SetBodygroup(1, math.floor(math.random(1))) 
	end,
})

TEAM_ZOMBIFUTE = DarkRP.createJob("Быстрый Зомби", {
    color = Color(139, 0, 0, 255),
    model = {
        "models/player/zombie_fast.mdl",
    },
    description = [[
Зомби нужна плоть.
"Нельзя убить то, что уже мертво."
	]],
    weapons = {"w_z_fustzombie"},
    command = "admi21zaqsdq11qaznzomcbie1",
    max = 3,
    salary = 0,
    admin = 0,
    vote = false,
	unlockCost = 420,
	customCheck = function(ply) return ply:GetNWString("usergroup") == "vip" or ply:GetNWString("usergroup") == "operator_vd" or ply:GetNWString("usergroup") == "admin" or ply:GetNWString("usergroup") == "operator_vn" or ply:IsAdmin() end,
	CustomCheckFailMsg = "Эта работа только для VIP!",
	candemote = false,
	zombie = true,
    hasLicense = false,
    category = "Зомби",
	type = "zombi",
	lives = 1,
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(250)--выдача хп
		ply:SetMaxHealth(250)-- максимальное хп
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(0)-- максимальное хп
		ply:SetMaxArmor(0)-- максимальное хп
		ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(190)--скорость бега у профы
	end,
})

TEAM_ZOMBINE = DarkRP.createJob("Зомбайн", {
    color = Color(139, 0, 0, 255),
    model = {
        "models/player/zombine/combine_zombie.mdl",
    },
    description = [[
Зомбайн - сильнейший зомби.
"Лучше быть мертвым, чем крутым."
	]],
    weapons = {"w_z_zombine"},
    command = "admicnzombine",
    max = 2,
    salary = 0,
    admin = 0,
	unlockCost = 620,
	requireUnlock = TEAM_ZOMBIE,
    vote = false,
	candemote = false,
    hasLicense = false,
    category = "Зомби",
	type = "zombi",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(800)--выдача хп
		ply:SetMaxHealth(800)-- максимальное хп
		ply:SetArmor(200)--выдача брони
		ply:SetMaxArmor(200)-- максимальное хп
		ply:SetMaxArmor(200)-- максимальное хп
		ply:SetWalkSpeed(100)--скорость ходьбы у профы
		ply:SetRunSpeed(100)--скорость бега у профы
	end,
})
--Сопротивление
TEAM_BEZHENEC = DarkRP.createJob("Беженец", {
    color = Color(105, 105, 105, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Сбежившие гражданин из города.
Нередко воссоединяйщийся с повстанцами для
защиты от Альянса.
"Тех, кто упорно отказывается сдаваться, 
 невозможно победить."
	]],
    weapons = {"keys", "itemstore_pickup", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminbeczhenec",
    max = 0,
    salary = 0,
    admin = 0,
	lives = 1,
	candemote = false,
    vote = false,
    hasLicense = false,
    category = "Повстанцы",
	type = "PISHI",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetSkin(math.floor(math.random(0,17)))
		ply:SetBodygroup(1, math.floor(math.random(0,4))) 
		ply:SetBodygroup(2, math.floor(math.random(0,2)))
		ply:SetBodygroup(4, math.floor(math.random(0,2)))
		ply:SetBodygroup(5, math.floor(math.random(0,1)))
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_BEZHENEC then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_POVSTANEC = DarkRP.createJob("Повстанец", {
    color = Color(128, 128, 128, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Боец сопротивления, воющийся против Альянса.
Не редко они сотрудничают с вортигонтами, беженцами и Бывшими
Военными, для достижение своих целей.
"Сопротивляться, сопротивляться и сопротивляться."
	]],
    weapons = {"keys", "itemstore_pickup", "weapon_hl2axe", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminpcovstanec",
    max = 5,
    salary = 0,
    admin = 0,
    vote = false,
	unlockCost = 120,
    hasLicense = false,
	candemote = false,
    category = "Повстанцы",
	type = "PISHI",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(50)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetSkin(math.floor(math.random(0,17)))
		ply:SetBodygroup(1, math.floor(math.random(5,6))) 
		ply:SetBodygroup(2, math.floor(math.random(3,4)))
		ply:SetBodygroup(3, math.floor(math.random(0,2)))
		ply:SetBodygroup(4, math.floor(math.random(0,2)))
		ply:SetBodygroup(5, math.floor(math.random(0,1)))
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_POVSTANEC then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_TORGOVECPOVSTANCEV = DarkRP.createJob("Торговец Повстанцев", {
    color = Color(128, 128, 128, 255),
    model = {
		"models/player/zelpa/female_01.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Торговец повстанцев исполняющий
роль снабжать сопротивление оружием и патронами
для общей борьбы с Альянсом.
"Кто не умеет улыбатся, не должен заниматся торговлей."
	]],
    weapons = {"keys", "itemstore_pickup", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "admintorcgovec",
    max = 3,
    salary = 0,
    admin = 0,
	unlockCost = 145,
	requireUnlock = TEAM_POVSTANEC,
    vote = false,
	candemote = false,
    hasLicense = false,
    category = "Повстанцы",
	type = "PISHI",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetSkin(math.floor(math.random(0,17)))
		ply:SetBodygroup(1, 3) 
		ply:SetBodygroup(2, 3) 
		ply:SetBodygroup(3, 2)  
		ply:SetBodygroup(5, 1)
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_TORGOVECPOVSTANCEV then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_MEDICPOVSTANEC = DarkRP.createJob("Медик Повстанцев", {
    color = Color(128, 128, 128, 255),
    model = {
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
    },
    description = [[
Медик повстанцев обеспечивает здаровьем
все ряды сопротивления.
"Здоровье - не всё, но всё без здоровье ничто."
	]],
    weapons = {"keys", "itemstore_pickup", "weapon_medkit", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminmecdicpovstancev",
    max = 1,
    salary = 0,
    admin = 0,
	unlockCost = 195,
	requireUnlock = TEAM_TORGOVECPOVSTANCEV,
    vote = false,
    hasLicense = false,
	candemote = false,
    category = "Повстанцы",
	type = "PISHI",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetSkin(math.floor(math.random(0,17)))
		ply:SetBodygroup(1, math.floor(math.random(7,8))) 
		ply:SetBodygroup(2, math.floor(math.random(5,6)))
		ply:SetBodygroup(3, math.floor(math.random(0,2)))
		ply:SetBodygroup(5, math.floor(math.random(0,1)))
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_MEDICPOVSTANEC then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_VORTIGONT = DarkRP.createJob("Вортигонт", {
    color = Color(0, 128, 0, 255),
    model = {
        "models/player/vortigaunt.mdl",
    },
    description = [[
Вортигонт из расы Зен.
Могущественное существо, которое не редко
помогает сопротивлению.
"Измените свои убеждения 
 о себе, вопреки личному сопротивлению."
	]],
    weapons = {"weapon_physcannon", "keys", "itemstore_pickup", "weapon_physcannon", "weapon_physgun", "gmod_tool", "swep_vortigaunt_beam"},
    command = "adminvorctigont",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
	candemote = false,
	unlockCost = 245,
	requireUnlock = TEAM_MEDICPOVSTANEC,
    category = "Повстанцы",
	type = "PISHI",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(200)--выдача хп
		ply:SetMaxHealth(200)-- максимальное хп
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
		ply:SetMaxArmor(150)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_VORTIGONT then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_VIZHIVSHIJVOENNIJ = DarkRP.createJob("Выживший военный", {
    color = Color(128, 128, 128, 255),
    model = {
        "models/player/gasmask.mdl",
    },
    description = [[
Выживший военный, действующий против Альянса.
Действуют военными группами.
Сотрудничают с повстанцами.
"Война — это серия катастроф, ведущих к победе."
	]],
    weapons = {"keys", "itemstore_pickup", "weapon_koreanshield", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminvoecnnij",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
	candemote = false,
    hasLicense = false,
	unlockCost = 320,
    category = "Другие",
	customCheck = function(ply) return ply:GetNWString("usergroup") == "vip" or ply:GetNWString("usergroup") == "operator_vd" or ply:GetNWString("usergroup") == "admin" or ply:GetNWString("usergroup") == "operator_vn" or ply:IsAdmin() end,
	CustomCheckFailMsg = "Эта работа только для VIP!",
	type = "PISHI",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(200)--выдача брони
		ply:SetMaxArmor(200)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_VIZHIVSHIJVOENNIJ then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_DEZERTIR = DarkRP.createJob("Дезертир", {
    color = Color(0, 0, 205, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_urban_police.mdl"
    },
    description = [[
Тайный-шпион UNIT.1, учавствующий против ГО и ОТА.
Помогающий попасть к сопротивлению Гражданам.
"Не объявляйте меня дезертиром,
 я просто отстал от программы."
	]],
    weapons = {"keys", "itemstore_pickup", "weapon_new_stunstick", "door_ram", "weapon_flash", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "admindezcertir",
    max = 2,
    salary = 0,
    admin = 0,
	candemote = false,
    vote = false,
	unlockCost = 345,
	requireUnlock = TEAM_VORTIGONT,
    hasLicense = false,
    category = "Гражданская Оборона",
		type = "PISHI",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_DEZERTIR then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_GLAVAREBELSATW = DarkRP.createJob("Глава Отряда", {
    color = Color(128, 128, 128, 255),
    model = {
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl",
    },
    description = [[
Глава отряда, повстанец который
может повести за собой людей 
в самое пекло, и выбраться от туда победителеми.
Устраивает рейды в город.
Не является "Лидером Сопротивление".
"Люди не любят следовать за пессимистами"
	]],
    weapons = {"keys", "itemstore_pickup", "weapon_vfirethrower", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminvoedafsfawqqrij",
    max = 1,
    salary = 0,
    admin = 0,
	unlockCost = 220,
	requireUnlock = TEAM_POVSTANEC,
    vote = false,
	candemote = false,
    hasLicense = false,
    category = "Повстанцы",
	type = "PISHI",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(100)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
		ply:SetWalkSpeed(100)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetSkin(math.floor(math.random(0,17)))
		ply:SetBodygroup(1, 4) 
		ply:SetBodygroup(2, 4) 
		ply:SetBodygroup(3, 4) 
		ply:SetBodygroup(4, 1) 
		ply:SetBodygroup(5, 1)  
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_GLAVAREBEL then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_PARTISAN = DarkRP.createJob("Партизан", {
    color = Color(128, 128, 128, 255),
    model = {
        "models/player/zelpa/female_01.mdl",
        "models/player/zelpa/female_01_b.mdl",
		"models/player/zelpa/female_02.mdl",
		"models/player/zelpa/female_02_b.mdl",
		"models/player/zelpa/female_03.mdl",
		"models/player/zelpa/female_03_b.mdl",
		"models/player/zelpa/female_04.mdl",
		"models/player/zelpa/female_04_b.mdl",
		"models/player/zelpa/female_06.mdl",
		"models/player/zelpa/female_06_b.mdl",
		"models/player/zelpa/female_07.mdl",
		"models/player/zelpa/female_07_b.mdl",
		"models/player/zelpa/male_01.mdl",
		"models/player/zelpa/male_02.mdl",
		"models/player/zelpa/male_03.mdl",
		"models/player/zelpa/male_04.mdl",
		"models/player/zelpa/male_05.mdl",
		"models/player/zelpa/male_06.mdl",
		"models/player/zelpa/male_07.mdl",
		"models/player/zelpa/male_08.mdl",
		"models/player/zelpa/male_09.mdl",
		"models/player/zelpa/male_10.mdl",
		"models/player/zelpa/male_11.mdl",
    },
    description = [[
Партизан, гражданин не согласный с действием
Альянса, сотрудничает с сопративлением,
устраивает засады, шпионаж, и бунты.
"Партизаны тем горды, что тверды."
	]],
    weapons = {"keys", "itemstore_pickup", "id", "weapon_physcannon", "weapon_physgun", "gmod_tool"},
    command = "adminvoedagaweqwr",
    max = 5,
    salary = 0,
    admin = 0,
	unlockCost = 220,
    vote = false,
	candemote = false,
    hasLicense = false,
    category = "Партизаны",
	type = "PARTISAN",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(100)--выдача хп
		ply:SetMaxHealth(100)
		ply:SetArmor(0)--выдача брони
		ply:SetMaxArmor(100)-- максимальное хп
	    ply:SetWalkSpeed(90)--скорость ходьбы у профы
		ply:SetRunSpeed(170)--скорость бега у профы
		ply:SetBodygroup(1, 2) 
		ply:SetBodygroup(2, 2) 
		ply:SetBodygroup(3, 2) 
		ply:SetBodygroup(4, 2) 
		ply:SetBodygroup(5, 2) 
	end,
	PlayerDeath = function(ply)
                if ply:Team() == TEAM_PARTISAN then
                        ply:changeTeam( TEAM_GRAZHDANIN, true )
                        for k,v in pairs( player.GetAll() ) do
                        end
                end
        end,
})

TEAM_NONRP = DarkRP.createJob("Администратор", {
    color = Color(0, 255, 255, 255),
    model = {
        "models/dpfilms/metropolice/playermodels/pm_badass_police.mdl"
    },
    description = [[
Администратор (Необязательно)
	]],
    weapons = {"weapon_physgun", "gmod_tool", "weapon_physcannon", "keys", "itemstore_pickup"},
    command = "adminomoshnik",
    max = 4,
    salary = 10,
    admin = 0,
	candemote = false,
    vote = false,
    hasLicense = false,
    category = "NONRP",
	PlayerLoadout = function(ply)--если зашёл за эту профу то
		ply:SetHealth(10000)--выдача хп
		ply:SetMaxHealth(10000)
		ply:SetArmor(10000)--выдача брони
		ply:SetWalkSpeed(130)--скорость ходьбы у профы
		ply:SetRunSpeed(250)--скорость бега у профы
		--------------- бодигроупы
		ply:SetBodygroup(1, 1) 
		
	--PlayerSpawn = function(ply) ply:SetHealth(100) ply:SetBodygroup(1, 0) ply:SetBodygroup(2, 0) ply:SetBodygroup(3, 0) ply:SetBodygroup(4, 0) end,
		
	end,
	customCheck = function(ply) return CLIENT or ply:GetNWString("usergroup") == "superadmin" or ply:GetNWString("usergroup") == "operator_n" or ply:GetNWString("usergroup") == "operator_d" or ply:GetNWString("usergroup") == "operator_vn" or ply:GetNWString("usergroup") == "operator_vd" end,
    CustomCheckFailMsg = ""
})

--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = TEAM_GRAZHDANIN


--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_UNIT1] = true,
    [TEAM_UNIT2] = true,
    [TEAM_UNIT3] = true,
    [TEAM_UNIT4] = true,
	[TEAM_UNIT5] = true,
    [TEAM_UNITMEDIC] = true,
	[TEAM_UNITENGINER] = true,
	[TEAM_OTAUNION] = true,
	[TEAM_OTASECURITY] = true,
	[TEAM_OTAHEAVY] = true,
	[TEAM_OTAELITE] = true,
	[TEAM_SNIPER] = true,
	[TEAM_PILIOTA] = true,
    [TEAM_CMDUNIT] = true,
    [TEAM_CMDOTA] = true,
	[TEAM_DEZERTIR] = true,
}

--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)

DarkRP.createCategory{
    name = "Citizens",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 107, 0, 255),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Другие",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 100, 0),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Гражданская Оборона",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 0, 128),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "ОТА",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 128, 128, 128),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "ГСР",
    categorises = "jobs",
    startExpanded = true,
    color = Color(219, 179, 33, 11),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Зомби",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 128, 0, 0),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Повстанцы",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 100, 0),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "Партизаны",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 0, 100, 0),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}

DarkRP.createCategory{
    name = "NONRP",
    categorises = "jobs",
    startExpanded = true,
    color = Color(0, 255, 255, 0),
    canSee = fp{fn.Id, true},
    sortOrder = 100,
}