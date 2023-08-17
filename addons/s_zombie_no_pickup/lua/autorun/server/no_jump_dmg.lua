hook.Add( "GetFallDamage", "Disable Damage", function( ply, speed )
local disablefdjobs = {"Быстрый Зомби"} -- название профессии
if table.HasValue(disablefdjobs, ply:getDarkRPVar("job")) then
    return 0
end
end )