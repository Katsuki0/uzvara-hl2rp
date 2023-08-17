
local icon = Material( 'icon16/error.png' )

R_Broadcast = R_Broadcast or {}
R_Broadcast.DeathPlayers = R_Broadcast.DeathPlayers or {}
R_Broadcast.BroadCasted = R_Broadcast.BroadCasted or {}

net.Receive("R_Broadcast.SendDeath", function()
	local name = net.ReadString()
	local pos = net.ReadVector()
	
	R_Broadcast.DeathPlayers[name] = pos

	timer.Simple(15, function()
		R_Broadcast.DeathPlayers[name] = nil
	end)
end)

net.Receive("R_Broadcast.SendCoded", function()
	local ply = net.ReadEntity()
	if not IsValid(ply) then return end
	surface.PlaySound("npc/metropolice/vo/on2.wav")

	local steamid = ply:SteamID()

	R_Broadcast.BroadCasted[steamid] = ply

	local distance = ply:GetPos():Distance(LocalPlayer():GetPos())
	local pos = ply:GetPos():ToScreen()
	pos.x = math.floor(pos.x)
	pos.y = math.floor(pos.y)

	timer.Simple(30, function()
		R_Broadcast.BroadCasted[steamid] = nil
	end)
end)

hook.Add("HUDPaint", "R_Broadcast.HUDPaint", function()
	for name, pos in pairs(R_Broadcast.DeathPlayers) do
		local distance = pos:Distance(LocalPlayer():GetPos())
		if distance > 4000 then continue end
		
		local ppos = pos:ToScreen()
		ppos.x = math.floor(ppos.x)
		ppos.y = math.floor(ppos.y)

		surface.SetMaterial( icon )
		surface.SetDrawColor( 255,255,255 )
		surface.DrawTexturedRect( ppos.x, ppos.y-30, 24, 24  )
		draw.DrawText("*Погиб сотрудник "..name.." - "..math.Round(distance), "Trebuchet24", ppos.x, ppos.y - 70,Color(123,0,28), TEXT_ALIGN_CENTER)
	end

	for steamid, ply in pairs(R_Broadcast.BroadCasted) do
		if not IsValid(ply) then continue end
		
		local distance = ply:GetPos():Distance(LocalPlayer():GetPos())
		local pos = ply:GetPos():ToScreen()
		pos.x = math.floor(pos.x)
		pos.y = math.floor(pos.y)

		draw.DrawText("*Трансляция* "..ply:Name().." - "..math.Round(distance), "Trebuchet24", pos.x, pos.y - 70, Color(65, 105, 225), TEXT_ALIGN_CENTER)
	end
end)