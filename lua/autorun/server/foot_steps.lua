
local painSoundsCP = {
	"npc/metropolice/pain1.wav",
	"npc/metropolice/pain2.wav",
	"npc/metropolice/pain3.wav",
	"npc/metropolice/pain4.wav"
}

local painSoundsZOMBIE = {
	"npc/zombie/pain1.wav",
	"npc/zombie/pain2.wav",
	"npc/zombie/pain3.wav",
	"npc/zombie/pain4.wav",
	"npc/zombie/pain5.wav",
	"npc/zombie/pain6.wav"
}

local painSoundsOTA = {
	"npc/combine_soldier/pain1.wav",
	"npc/combine_soldier/pain2.wav",
	"npc/combine_soldier/pain3.wav"
}

hook.Add("PlayerHurt", "PlayerHurtCP", function(client, attacker, health, damage)
		local painSound = hook.Run("GetPlayerPainSound", client)
		if painSound != nil then
		client:EmitSound(painSound)
		end
end)

hook.Add("GetPlayerPainSound", "GetPlayerPainSoundCP", function(client)
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
		
		local sounds = painSoundsCP
		return table.Random(sounds)
		
	elseif (client:Team() == TEAM_OTAUNION or
	    client:Team() == TEAM_OTASECURITY or 
		client:Team() == TEAM_OTAHEAVY or 
		client:Team() == TEAM_OTAELITE or 
		client:Team() == TEAM_SNIPER) then
		
		local sounds = painSoundsOTA
		return table.Random(sounds)
		
	elseif (client:Team() == TEAM_ZOMBIE or
	    client:Team() == TEAM_ZOMBIFUTE or 
		client:Team() == TEAM_ZOMBINE) then

		local sounds = painSoundsZOMBIE
		return table.Random(sounds)
		
	end
end)