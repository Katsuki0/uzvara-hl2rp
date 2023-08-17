
include( "rprint/sh_rprint.lua" )

local function loadConfig()
	include( "rprint/sh_config.lua" )

	rPrint.TriggerEvent( "PostConfigLoaded" )
end

hook.Add( "Initialize", "sh_rprint_ensure_load_config", function()
	ErrorNoHalt( "rPrint: Something went wrong with the loading process; attempting to recover but compatibility is not ensured.\n" )
	
	loadConfig()
end )

hook.Add( "OnGamemodeLoaded", "sh_rprint_load_config", function()
	hook.Remove(  "Initialize", "sh_rprint_ensure_load_config" )
	
	loadConfig()
end )


if SERVER then
	AddCSLuaFile()

	AddCSLuaFile( "rprint/sh_rprint.lua" )
	AddCSLuaFile( "rprint/sh_config.lua" )

	include( "rprint/server/sv_rprint.lua" )

	resource.AddFile( "materials/dan/rprint/fanpart1.png" )
	resource.AddFile( "materials/dan/rprint/fanpart2.png" )	
end
