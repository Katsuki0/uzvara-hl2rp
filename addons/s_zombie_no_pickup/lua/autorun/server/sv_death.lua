--Анти кил в консоль
local function BlockSuicide(ply)
    ply:ChatPrint("А в джаил не хочешь?")
	return false
end
hook.Add( "CanPlayerSuicide", "BlockSuicide", BlockSuicide )
--Отключает голод 
local function init()
    NoHunger = {
    [TEAM_OTAUNION] = true,
	[TEAM_OTASECURITY] = true,
	[TEAM_OTAHEAVY] = true,
	[TEAM_OTAELITE] = true,
	[TEAM_SNIPER] = true
}
end

hook.Add( "Initialize", "Init", init )
hook.Add("hungerUpdate", "removehunger", function(ply, energy) if (NoHunger[ply:Team()]) then
    return true
    end
end)

--local canUse = {
 --   ["superadmin"] = true,
 --   ["admin"] = true,
--}
-- В таблицу выше внести новые группы, где индекс - название самой группы.
--hook.Add("SpawnMenuOpen", "AnyHookName", function()
 --   if not canUse[ LocalPlayer():GetNWString('usergroup') ] then return end
--end)