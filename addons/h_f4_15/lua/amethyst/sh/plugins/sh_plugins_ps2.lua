/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


local PLUGIN = {}

PLUGIN.Enabled = true
PLUGIN.Name = "Pointshop"
PLUGIN.Author = "Kamshak"
PLUGIN.Desc = "Spend your points."
PLUGIN.Icon = "amethyst/plugins/amethyst_plugin_pointshop.png"
PLUGIN.Parameters =
{
    id = "amethyst_ps2int",
}

PLUGIN.ActionDoClick = function() RunConsoleCommand("pointshop2_toggle") end

Amethyst:RegisterPlugin( PLUGIN )

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/