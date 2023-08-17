print ("Client side bar")

local hide_table = {
    ["#spawnmenu.category.dupes"] = true,
    ["#spawnmenu.category.entities"] = true,
    ["#spawnmenu.category.npcs"] = true,
    ["#spawnmenu.category.postprocess"] = true,
    ["#spawnmenu.category.saves"] = true,
    ["#spawnmenu.category.vehicles"] = true,
    ["#spawnmenu.category.weapons"] = true,
}

// Попробуем проще.
local not_hide = {
    ["#spawnmenu.content_tab"] = true,
}


local adm_groups = {
    ["superadmin"] = true,
    ["moderator"] = false,
    ["admin"] = false,
	["operator_vn"] = false,
	["operator_n"] = false,
	["VIP"] = false,
	["operator_vd"] = false,
	["operator_d"] = false,
	["user"] = false,
}


local save_table = {}

// Могут быть баги
hook.Add("InitPostEntity", "hideNonNeededTable", function ()
    local q_tbl = spawnmenu.GetCreationTabs()
    save_table = q_tbl
    for k, _ in pairs (q_tbl) do
        if not not_hide[k] and not adm_groups[LocalPlayer():GetUserGroup()] then
            q_tbl[k] = nil
        end
    end
    RunConsoleCommand("spawnmenu_reload")
end)