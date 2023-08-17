 --[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
	Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua#L111

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]

DarkRP.createEntity("Книга", {
	ent = "rp_book",
	model = "models/props_lab/binderblue.mdl",
	price = 5,
	max = 5,
	cmd = "buyadminkniga",
})

DarkRP.createEntity("Коробка", {
	ent = "itemstore_box",
	model = "models/props/cs_office/Cardboard_box02.mdl",
	price = 10,
	max = 1,
	cmd = "buyadminbox",
})

DarkRP.createEntity("Блокнот", {
	ent = "rp_sign",
	model = "models/props_lab/clipboard.mdl", 
	price = 3,
	max = 5,
	cmd = "buyadminbloknot",
})

DarkRP.createEntity("Мука", { 
	ent = "cm_flour",
	model = "models/props_junk/garbage_bag001a.mdl", 
	price = 1,
	max = 15,
	cmd = "buyadminkosssxzxnsbanka",
	allowed = {TEAM_PISHEVOJSNABDITEL},
})

DarkRP.createEntity("Печка", { 
	ent = "cm_stove",
	model = "models/props_wasteland/kitchen_stove002a.mdl", 
	price = 0,
	max = 1,
	cmd = "ssssaf121312asfsazx",
	allowed = {TEAM_PISHEVOJSNABDITEL},
})

DarkRP.createEntity("Мортира", { 
	ent = "hl2_combine_mortar",
	model = "models/props_combine/combine_mortar01a.mdl", 
	price = 0,
	max = 1,
	cmd = "buyadmininfosasaqzablo",
	allowed = {TEAM_UNITENGINER},
})

DarkRP.createEntity("Станковая турель", { 
	ent = "entity_ar3_ent",
	model = "models/props_combine/combine_barricade_short01a.mdl", 
	price = 0,
	max = 1,
	cmd = "buyadmininfozaazazazablo",
	allowed = {TEAM_UNITENGINER},
})

DarkRP.createEntity("Страйдер", { 
	ent = "gw_strider",
	model = "models/Combine_Strider.mdl", 
	price = 0,
	max = 1,
	cmd = "buyadsaazmininfozaazazazablo", 
	allowed = {TEAM_PILIOTA},
})

	--customCheck = function(ply) return CLIENT or table.HasValue({"superadmin", "vip", "operator", "moderator", "administrator", "helper", "administrator_custom	"}, ply:GetUserGroup()) end,
	--CustomCheckFailMsg = "Этот принтер только для VIP игроков!",