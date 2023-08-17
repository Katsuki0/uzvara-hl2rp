--[[---------------------------------------------------------------------------
DarkRP custom shipments and guns
---------------------------------------------------------------------------

This file contains your custom shipments and guns.
This file should also contain shipments and guns from DarkRP that you edited.

Note: If you want to edit a default DarkRP shipment, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the shipment to this file and edit it.

The default shipments and guns can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
http://wiki.darkrp.com/index.php/DarkRP:CustomShipmentFields


Add shipments and guns under the following line:
---------------------------------------------------------------------------]]

DarkRP.createShipment("Пистолет", {
    model = "models/weapons/w_pistol.mdl",
    entity = "swb_pistol",
    price = 20,
    amount = 1,
    separate = false,
    pricesep = nil,
    noship = false,
	allowed = {TEAM_TORGOVECPOVSTANCEV},
})

DarkRP.createShipment("СМГ", {
    model = "models/weapons/w_smg1.mdl",
    entity = "swb_smg",
    price = 30,
    amount = 1,
    separate = false,
    pricesep = nil,
    noship = false,
	allowed = {TEAM_TORGOVECPOVSTANCEV},
})

DarkRP.createShipment("Дробовик", {
    model = "models/weapons/w_shotgun.mdl",
    entity = "swb_shotgun",
    price = 40,
    amount = 1,
    separate = false,
    pricesep = nil,
    noship = false,
	allowed = {TEAM_TORGOVECPOVSTANCEV},
})
--]]

---AddCustomShipment("Пистолет",   "models/weapons/w_pistol.mdl",  "swb_pistol",   25, 1, true, 15, false, {TEAM_TORGOVECPOVSTANCEV})
---AddCustomShipment("СМГ", 		"models/weapons/w_smg1.mdl", 	"swb_smg", 		35, 1, true, 25, false, {TEAM_TORGOVECPOVSTANCEV})
---AddCustomShipment("Дробовик",   "models/weapons/w_shotgun.mdl", "swb_shotgun",  45, 1, true, 35, false, {TEAM_TORGOVECPOVSTANCEV})

---DarkRP.createShipment("Пистолет ", {
	---model = "models/weapons/w_pistol.mdl",
	---entity = "swb_pistol",
	---price = 50000,
	---amount = 10,
	---seperate = true,
	---pricesep = 5000,
	---noship = false,
	---weight = 1.2,
	---allowed = {TEAM_TORGOVECPOVSTANCEV},
---})