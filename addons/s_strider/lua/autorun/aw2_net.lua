if SERVER then
	util.AddNetworkString("aw2Enter")
	util.AddNetworkString("aw2Eject")
end

if CLIENT then
	net.Receive("aw2Enter", function(len)
		local ent = net.ReadEntity()
		local ang = Angle(0, ent:GetAngles().y, 0)

		LocalPlayer().aw2Ent = ent
		LocalPlayer():SetEyeAngles(ang)
	end)

	net.Receive("aw2Eject", function(len)
		LocalPlayer().aw2Ent = nil
	end)
end