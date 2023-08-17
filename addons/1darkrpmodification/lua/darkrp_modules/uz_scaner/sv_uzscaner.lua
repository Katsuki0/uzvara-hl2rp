print ("Uzvara Server Side scanner")


//TEAM_BUIS
// Полезное
// Пизданутый код с хелликса.
// ДЛЯ УСТАНОВКИ СКАНЕРА К ПРОФЕ НУЖНО ПРОПИСАТЬ В САМОЙ ПРОФЕ :
// PlayerLoadout = function (ply) createNPC(ply) end,

// Например :
-- TEAM_BUIS = DarkRP.createJob("Бизнесмен", {
--    color = Color(0, 100, 255, 255),
--    model = {
--    "models/player/Group02/male_02.mdl",
--    "models/player/Group01/male_01.mdl",
--    "models/player/Group01/male_03.mdl",
--    },
--    description = [[
-- ✔ Описание:
-- ● Вы Бизнесмен!
-- ● Придумывайте уникальные способы заработка.
-- ● Воплощайте их в реальность

-- ✔ Правила:
-- ● Вам Запрещенно иметь тяжёлое оружие
-- ● Вам нельзя грабить банк и игрока.
-- ● Вам нельзя объединяться с бандитами]],
--    weapons = {},
--    command = "buis",
--    PlayerLoadout = function (ply) createNPC(ply) end, // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--    max = 0,
--    salary = 60,
--    admin = 0,
--    vote = false,
--    hasLicense = false,
--    category = "Профессии",
-- })

function createNPC(client, class)
	class = class or "npc_cscanner"

	if (IsValid(client.nutScn)) then
		return
	end

	local entity = ents.Create(class)

	if (!IsValid(entity)) then
		return
	end

	client:SetNW2Bool("Scanner", true)
	entity:SetPos(client:GetPos())
	entity:SetAngles(client:GetAngles())
	entity:SetColor(client:GetColor())
	entity:Spawn()
	entity:Activate()
	entity.player = client
	entity.nophys = true
	entity.notool = true
	entity:CPPISetOwner(client)
	entity:SetNW2Bool("pprotect_world", true)
	entity:SetHealth(200)
	entity:CallOnRemove("nutRestore", function()
		if (IsValid(client)) then
			client:UnSpectate()
			client:SetViewEntity(NULL)
			client:SetNW2Bool("Scanner", false)
			client.nutScn = nil
			if (entity.flyLoop) then
				entity.flyLoop:Stop()
			end
			local Effect = EffectData()
			Effect:SetOrigin( entity:GetPos() )
			Effect:SetStart( entity:GetPos() )
			Effect:SetMagnitude( 512 )
			Effect:SetScale( 128 )
			util.Effect("Explosion", Effect)
			timer.Simple(0, function() client:Spawn() end)
		end
	end)

	local name = "nutScn"..os.clock()
	entity.name = name
	timer.Create("scanner_sound_"..entity.name, 1, 1, function()
		if (IsValid(entity)) then
			entity.flyLoop = CreateSound(entity, "npc/scanner/cbot_fly_loop.wav")
			entity.flyLoop:Play()
		end
	end)
	local target = ents.Create("path_track")
	target:SetPos(entity:GetPos())
	target:Spawn()
	target:SetName(name)

	entity:Fire("setfollowtarget", name)
	-- entity:Fire("inputshouldinspect", false)
	entity:Fire("setdistanceoverride", "48")
	entity:SetKeyValue("spawnflags", 8208)

	client.nutScn = entity
	client:StripWeapons()
	client:Spectate(OBS_MODE_CHASE)
	client:SpectateEntity(entity)

	local uniqueID = "nut_Scanner"..client:UniqueID()
	-- DarkRP.log(ply:GetName() .. " (" .. ply:SteamID() .. ") стал сканером.", Color(30, 30, 30))
	timer.Create(uniqueID, 0.33, 0, function()
		if (!IsValid(client) or !IsValid(entity)) then
			if (IsValid(entity)) then
				entity:Remove()
			end
			
			return timer.Remove(uniqueID)
		end

		local factor = 128

		if (client:KeyDown(IN_SPEED)) then
			factor = 64
		end

		if (client:KeyDown(IN_FORWARD)) then
			target:SetPos((entity:GetPos() + client:GetAimVector()*factor) - Vector(0, 0, 64))
			entity:Fire("setfollowtarget", name)
		elseif (client:KeyDown(IN_BACK)) then
			target:SetPos((entity:GetPos() + client:GetAimVector()*-factor) - Vector(0, 0, 64))
			entity:Fire("setfollowtarget", name)
		elseif (client:KeyDown(IN_JUMP)) then
			target:SetPos(entity:GetPos() + Vector(0, 0, factor))
			entity:Fire("setfollowtarget", name)	
		elseif (client:KeyDown(IN_DUCK)) then
			target:SetPos(entity:GetPos() - Vector(0, 0, factor))
			entity:Fire("setfollowtarget", name)				
		end

		client:SetPos(entity:GetPos())
	end)

	return entity
end




local SCANNER_SOUNDS = {
	"npc/scanner/scanner_blip1.wav",
	"npc/scanner/scanner_scan1.wav",
	"npc/scanner/scanner_scan2.wav",
	"npc/scanner/scanner_scan4.wav",
	"npc/scanner/scanner_scan5.wav",
	"npc/scanner/combat_scan1.wav",
	"npc/scanner/combat_scan2.wav",
	"npc/scanner/combat_scan3.wav",
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan5.wav",
	"npc/scanner/cbot_servoscared.wav",
	"npc/scanner/cbot_servochatter.wav"
}

hook.Add("KeyPress", "nutScn_KeyPress", function(client, key)

	if (IsValid(client.nutScn) and (client.nutScnDelay or 0) < CurTime()) then
		
		local source

		if (key == IN_USE) then
			source = table.Random(SCANNER_SOUNDS)
			client.nutScnDelay = CurTime() + 0.75
		elseif (key == IN_RELOAD) then
			source = "npc/scanner/scanner_talk"..math.random(1, 2)..".wav"
			client.nutScnDelay = CurTime() + 5
		elseif (key == IN_SPEED) then
			if (client:GetViewEntity() == client.nutScn) then
				client:SetViewEntity(NULL)
			else
				client:SetViewEntity(client.nutScn)
			end
		end

		if (source) then
			client.nutScn:EmitSound(source)
		end
	end
end)

hook.Add("PlayerNoClip", "nutScn_NoClip", function(client)
	if (IsValid(client.nutScn)) then
		return false
	end
end)
hook.Add("PlayerSwitchFlashlight", "UnionScannerFlash", function(ply, enabled)
	if IsValid(ply.nutScn) then
		ply.nutScn:Remove()
		ply.nutScn = nil
		return false
	end
end)
hook.Add("PlayerUse", "nutScn_PlyUse", function(client, entity)
	if (IsValid(client.nutScn)) then
		return false
	end
end)