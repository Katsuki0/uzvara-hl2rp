hook.Add("PlayerFootstep", "PlayerFootstepCP", function(client, position, foot, soundName, volume)
	if (client:Team() == TEAM_UNIT1 or 
		client:Team() == TEAM_UNIT2 or
	    client:Team() == TEAM_UNIT3 or 
		client:Team() == TEAM_UNIT4 or 
		client:Team() == TEAM_UNIT5 or
		client:Team() == TEAM_PILIOTA or
		client:Team() == TEAM_UNITENGINER  or
		client:Team() == TEAM_UNITMEDIC or
		client:Team() == TEAM_CMDUNIT or
		client:Team() == TEAM_DEZERTIR or
	    client:Team() == TEAM_CMDOTA) then
		client:EmitSound("npc/metropolice/gear"..math.random(1, 6)..".wav", volume * 130)

		return true
	elseif (client:Team() == TEAM_OTAUNION or
	    client:Team() == TEAM_OTASECURITY or 
		client:Team() == TEAM_OTAHEAVY or 
		client:Team() == TEAM_OTAELITE or 
		client:Team() == TEAM_SNIPER) then
		client:EmitSound("npc/combine_soldier/gear"..math.random(1, 6)..".wav", volume * 130)

		return true
	elseif (client:Team() == TEAM_OTAUNION or
	    client:Team() == TEAM_OTASECURITY or 
		client:Team() == TEAM_OTAHEAVY or 
		client:Team() == TEAM_OTAELITE or 
		client:Team() == TEAM_SNIPER) then
		client:EmitSound("npc/zombie/foot"..math.random(1, 3)..".wav", volume * 130)

		return true
	end
end)
