local canUse = {
    ["superadmin"] = true,
    ["admin"] = true,
}
-- В таблицу выше внести новые группы, где индекс - название самой группы.
hook.Add("SpawnMenuOpen", "AnyHookName", function()
    if not canUse[ LocalPlayer():GetNWString('usergroup') ] then return end
end)