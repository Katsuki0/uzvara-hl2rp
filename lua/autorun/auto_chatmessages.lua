
-----------------------------------------------------
if SERVER then
	util.AddNetworkString( "switch_weapon" )
	net.Receive( "switch_weapon", function(l,ply)
		ply:SelectWeapon(net.ReadString())
	end)
end

AddCSLuaFile()

local PREFIX = {Color(255, 137, 1), "Uzvara HL2RP | "}

local text = Color(255, 255, 255)
local lime = Color(0, 255, 100)
local yellow = Color(255, 255, 255)
local orange = Color(255, 180, 10)

local MESSAGES = {
	{text, "Следите за новостями в нашем Дискорде", Color(50, 255, 255), " <url>https://discord.gg/aTWZxBP</url>", text, "", lime, "", text, ""},
}

if (SERVER) then
	local CYCLE_TIME = 600

	util.AddNetworkString("AutoChatMessage")
	local curmsg = 1
	
	timer.Create("AutoChatMessages", CYCLE_TIME, 0, function()
		net.Start("AutoChatMessage")
			net.WriteUInt(curmsg, 16)
		net.Broadcast()

		curmsg = curmsg + 1
		if (curmsg > #MESSAGES) then
			curmsg = 1
		end
	end)
else
	net.Receive("AutoChatMessage", function()
		local t = {}
		table.Add(t, PREFIX)
		table.Add(t, MESSAGES[net.ReadUInt(16)])
		
		chat.AddText(unpack(t))
	end)
end