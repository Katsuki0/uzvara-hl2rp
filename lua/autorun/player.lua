
-----------------------------------------------------
hook.Add("PlayerSpawn","setplayeronspawn",function(ply)
	-- ply:SetNWInt("RationIsUsed",1)
	-- timer.Simple(900, function()
	-- 	ply:SetNWInt("RationIsUsed", 0)
	-- end)

	-- CID
	timer.Simple(120, function()
		ply:SetNWInt("PlayerCID", math.random(10000, 99999))
	end)
end)
