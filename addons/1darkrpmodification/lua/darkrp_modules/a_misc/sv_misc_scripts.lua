print ("This is misc scripts that no needed to creating other lua file.")



// Открытие всех дверей при запуске сервера.

local doors_ents = {
	["func_door"] = true,
	["prop_door_rotating"] = true,
	["prop_dynamic"] = true,
}


hook.Add("OnGamemodeLoaded", "OpenDoorOnGamemodeLoadedFire", function ()
	print ("Start opening doors...")
	for k,v in pairs (ents.GetAll()) do
		if doors_ents[v:GetClass()] then
			print ("[Misc] Found "..k.." ents...")
			v:Fire("unlock", "", 0)
			v:Fire("Open")
			print ("[Misc]"..v:GetClass().." opened!")
		end
	end
end)


// Открытие дверей для ГО и ОТА и еще пару проф.

local misc_jobs = {
	["TEAM_DEZERTIR"] = true,
}

-- TEAM_DEZERTIR

function KeyPressedUse (ply, key)
	if RPExtraTeams[ply:Team()].type == "GO" or RPExtraTeams[ply:Team()].type == "OTA" or misc_jobs[ply:Team()] then
	    if key == IN_USE then 
	        local t = {}   
	        t.start = ply:GetPos()   
	        t.endpos = ply:GetShootPos() + ply:GetAimVector() * 100   
	        t.filter = ply
	        local trace = util.TraceLine(t)          
	        if trace.Entity and trace.Entity:IsValid() and (trace.Entity:GetClass() == "func_door" or trace.Entity:GetClass() == "prop_door_rotating" or trace.Entity:GetClass() == "prop_dynamic") then
	            trace.Entity:Fire("Open")
	        end
	    end
	end
end
hook.Add("KeyPress", "KeyPressedUse", KeyPressedUse)



hook.Add("playerBuyDoor", "stopBuyingDoorsForCP", function (ply, door)
	if RPExtraTeams[ply:Team()].type == "GO" or RPExtraTeams[ply:Team()].type == "OTA" or misc_jobs[ply:Team()] then
		return false, "Вы не можете покупать двери за ГО.", true
	end
end)