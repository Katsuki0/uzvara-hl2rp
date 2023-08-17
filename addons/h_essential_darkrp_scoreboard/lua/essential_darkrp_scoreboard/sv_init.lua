if not file.IsDir('essential_darkrp_scoreboard', 'DATA') then
    file.CreateDir('essential_darkrp_scoreboard')
end

AddCSLuaFile('essential_darkrp_scoreboard/cl_init.lua')
AddCSLuaFile('essential_darkrp_scoreboard/client/cl_scoreboard.lua')
AddCSLuaFile('essential_darkrp_scoreboard/client/cl_fadmin.lua')
AddCSLuaFile('essential_darkrp_scoreboard/client/cl_settings.lua')

include('essential_darkrp_scoreboard/server/sv_settings.lua')