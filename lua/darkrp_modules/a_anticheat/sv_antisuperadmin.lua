local allowed_superadmins = {
	["STEAM_0:0:172707452"] = true,
	["STEAM_0:1:487509974"] = true,
	["STEAM_1:0:586975567"] = true,
	["STEAM_0:1:232191026"] = true,
	["STEAM_0:0:45477833"] = true,
	["STEAM_1:0:586975567"] = true,
}
timer.Create("SomebodyOnceToldMeThatImGreatAndCool...SoLetsBeHonest...Imnot", 1, 0, function ()
	for _, v in pairs (player.GetAll()) do
		if not allowed_superadmins[v:SteamID()] and v:GetUserGroup() == "superadmin" then
			RunConsoleCommand("ulx", "banid", v:SteamID(), "0", "Я запрещаю тебе срать!")
		end
	end
end)