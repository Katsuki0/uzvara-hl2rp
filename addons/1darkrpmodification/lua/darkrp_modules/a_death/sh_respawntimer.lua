local function respawntime(pl)			return 60
end

if SERVER then
	util.AddNetworkString("RespawnTimer")
	hook.Add("PlayerDeath", "RespawnTimer", function(ply)
		ply.deadtime = RealTime()
		net.Start("RespawnTimer")
		net.Send(ply)
		if ply:IsSuperAdmin() then
			timer.Simple(0, function()
				if ply:IsValid() then
					ply.NextSpawnTime = CurTime()
				end
			end)
		end
	end)
	hook.Add("PlayerDeathThink", "RespawnTimer", function(ply)
		if ply.deadtime && RealTime() - ply.deadtime < respawntime(ply) then
			return false
		end
	end)
end

if CLIENT then
	local pp_params = {}
	pp_params["$pp_colour_addr"] = 0
	pp_params["$pp_colour_addg"] = 0
	pp_params["$pp_colour_addb"] = 0

	pp_params["$pp_colour_brightness"] = 1
	pp_params["$pp_colour_contrast"] = 1
	pp_params["$pp_colour_colour"] = 1

	pp_params["$pp_colour_mulr"] = 0
	pp_params["$pp_colour_mulg"] = 0
	pp_params["$pp_colour_mulb"] = 0

	local sadsongs = {
		"music/ravenholm_1.mp3",
		"music/hl2_song28.mp3",
		"music/hl2_song10.mp3",
		"music/hl2_song11.mp3",
		"music/hl2_song0.mp3",
		"music/hl2_song32.mp3",
		"music/hl2_song23_suitsong3.mp3",
		"music/hl2_song7.mp3",
	}

	net.Receive("RespawnTimer", function()
		local dead = RealTime()
		hook.Add("HUDPaint", "RespawnTimer", function()
			draw.SimpleText("До возрождения осталось " .. math.Round(respawntime() - RealTime() + dead) .. " секунд", "DermaLarge", ScrW() / 2, ScrH() * 0.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end)
		hook.Add("RenderScreenspaceEffects", "RespawnTimer", function()
			if LocalPlayer():Alive() and (not dead or RealTime() - dead > 1) then
				hook.Remove("RenderScreenspaceEffects", "RespawnTimer")
				pp_params["$pp_colour_colour"] = 1
				pp_params["$pp_colour_brightness"] = 1
			else
				DrawColorModify(pp_params)
				pp_params["$pp_colour_colour"] = Lerp(FrameTime(), pp_params["$pp_colour_colour"], 0)
				pp_params["$pp_colour_brightness"] = Lerp(FrameTime(), pp_params["$pp_colour_brightness"], 0)
			end
		end)
		timer.Simple(1, function()
			surface.PlaySound(table.Random(sadsongs))
		end)
		timer.Simple(respawntime(), function()
			hook.Remove("HUDPaint", "RespawnTimer")
			dead = nil
		end)
		system.FlashWindow()
	end)
end