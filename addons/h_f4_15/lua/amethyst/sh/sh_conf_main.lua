/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/


Amethyst.Settings = Amethyst.Settings or {}

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> FASTDL / WORKSHOP RESOURCES

Set to false if you do not wish for the server to force players to download the
resources/materials. Ensure that you sync this addon with your FastDL if you wish to use that
feature.

--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.ResourcesEnabled = true
Amethyst.Settings.WorkshopMountGMAEnabled = false
Amethyst.Settings.WorkshopEnabled = true

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> PANEL REGENERATION

If TRUE - this will completely re-create the entire script each time you close it and re-open.
This forces all panels to be freshly made. Only set this to true if you are wanting to test
something. The script itself should function perfectly fine with this turned to false -- which
is the default.

--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.InitRegenPanel = false

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> CUSTOM FONTS

This script makes use of custom fonts (because they look better) However, if you wish to disable
them because for whatever reason, you cannot sync them to your FastDL, then you can simply set the
below setting to 'false'. This will force the script to use the default fonts with modified
properties in order to look as good as they can.
--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.CustomFontsEnabled = true

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> NOTIFICATIONS

Admins can send notifications to the server for other players to see in-game. Below are settings
that are just for this notification system.
--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.Notifications.CooldownTimer = 60

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> GENERAL

General stuff -- nothing too special. Now what Amethyst has theme support, everything from here
has been removed except for a few lonely things.
--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.NetworkName = "Uzvara HL2RP"
Amethyst.Settings.ClockFormat = "%X"

Amethyst.Settings.TickerEnabled = true
Amethyst.Settings.TickerSpeed = 1.0
Amethyst.Settings.TickerDelayPerMessage = 6
Amethyst.Settings.TickerNews =
{
	"В городе разбросан мусор в котором вы можете найти оружие.",
	"Вы можете найти шкаф в котором можете изменить свою внешность.",
	"Многие двери можно взломать, улучшайте ваши замки!",
	"Не рекомендуется выходить на улицу в тёмное время суток..",
	"На многих дверях есть глазок, в который вы можете посмотреть. [E]",
	"Зомби не только убивают свою жертву, но и восстанавливают своё здаровье.",
}

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> SIDE TABS

    The side tabs are the dots to the upper-left. Each dot takes the player to a new panel with options
    to choose from.

        Name        =>  The name of the panel

        Desc        =>  Description displayed when mouse is hovered over tab.

        DoLoadPanel =>  The ID name for the panel.
                        This should NOT be modified for ANY reason unless you know what you're doing.

        OnLoadInit  =>  Forces that particular panel to be the default panel loaded. ONLY ONE panel
                        should have this set to true.

--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.SideTabs =
{
    {
        Name = "Главная",
        Desc = "Информация О Вашем Игроке",
        DoLoadPanel = "Amethyst_STab_Home",
        OnLoadInit = true,
        Enabled = true,
    },
    {
        Name = "Магазин",
        Desc = "Покупайте оружие и устраивайтесь на работу.",
        DoLoadPanel = "Amethyst_STab_Shop",
        OnLoadInit = false,
        Enabled = true,
    },
    {
        Name = "Сообщество",
        Desc = "Навигация, связанная с сообществом.",
        DoLoadPanel = "Amethyst_STab_Community",
        OnLoadInit = false,
        Enabled = true,
    },
    {
        Name = "Плагины",
        Desc = "Плагины для вашего меню F4.",
        DoLoadPanel = "Amethyst_STab_Plugins",
        OnLoadInit = false,
        Enabled = false,
    },
    {
        Name = "Команды",
        Desc = "Часто используемые функции.",
        DoLoadPanel = "Amethyst_STab_Commands",
        OnLoadInit = false,
        Enabled = true,
    }
}

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> PLAYER DATA

    Displays information on the far left side of the "Player Info" tab.

        Enabled         =>  If the command will display at all for the player.
        BlockName       =>  Name of the button.
        BlockType       =>  The type for the block (default is text).
        BlockIcon       =>  Icon to display for the data entry.
        BlockFunc       =>  Function to return data requested.

--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.PlayerData = {
    {
        Enabled = true,
        BlockName = "Money",
        BlockType = "text",
        BlockIcon = "amethyst/amethyst_gui_subinfo_wallet.png",
        BlockFunc = function() return DarkRP.formatMoney( LocalPlayer():getDarkRPVar("money") ) end
    },
    {
        Enabled = true,
        BlockName = "Job",
        BlockType = "text",
        BlockIcon = "amethyst/amethyst_gui_subinfo_job.png",
        BlockFunc = function() return LocalPlayer():getDarkRPVar("job") end
    },
    {
        Enabled = true,
        BlockName = "Salary",
        BlockType = "text",
        BlockIcon = "amethyst/amethyst_gui_subinfo_funds.png",
        BlockFunc = function() return DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary")) .. " / hr" or 0 end
    },
    {
        Enabled = true,
        BlockName = "SteamID",
        BlockType = "text",
        BlockIcon = "amethyst/amethyst_gui_subinfo_steam.png",
        BlockFunc = function() return LocalPlayer():SteamID() end
    },
    {
        Enabled = false,
        BlockName = "Points",
        BlockType = "text",
        BlockIcon = "amethyst/amethyst_gui_subinfo_points.png",
        BlockFunc = function()
            local fetchPly = LocalPlayer()
            if Pointshop2 then
                return fetchPly.PS2_Wallet.points .. " / " .. fetchPly.PS2_Wallet.premiumPoints
            else
                return 0
            end
        end
    },
    {
        Enabled = false,
        BlockName = "Points",
        BlockType = "text",
        BlockIcon = "amethyst/amethyst_gui_subinfo_points.png",
        BlockFunc = function()
            if PS then
                return LocalPlayer():PS_GetPoints()
            else
                return 0
            end
        end
    },
}

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> DATA BLOCKS

    Displays information on the far left side of the "Player Info" tab related to health, etc.

        enabled                     =>  If the command will display at all for the player
        blockType                   =>  Which feature is the block associated with?
        BlockName                   =>  Name of the button
        blockMax                    =>  Max value that the block should calculate for
        blockIcon                   =>  Icon associated with the specified block

--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.Datablocks =
{
    {
        enabled = true,
        blockType = "health",
        blockName = "HEALTH",
        blockMax = 100,
        blockIcon = "amethyst/amethyst_gui_datablocks_health.png",
    },
    {
        enabled = true,
        blockType = "armor",
        blockName = "ARMOR",
        blockMax = 100,
        blockIcon = "amethyst/amethyst_gui_datablocks_armor.png",
    },
    {
        enabled = true,
        blockType = "stamina",
        blockName = "STAMINA",
        blockMax = 100,
        blockIcon = "amethyst/amethyst_gui_datablocks_stamina.png",
    },
    {
        enabled = true,
        blockType = "hunger",
        blockName = "HUNGER",
        blockMax = 100,
        blockIcon = "amethyst/amethyst_gui_datablocks_hunger.png",
    },
    {
        enabled = true,
        blockType = "xp",
        blockName = "XP",
        blockMax = 100,
        blockIcon = "amethyst/amethyst_gui_datablocks_xp.png",
    }
}

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/