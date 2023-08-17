/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/


Amethyst.Settings = Amethyst.Settings or {}

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> COMMANDS

    These are the buttons that will display when the 'Commands' tab is pressed.

        Enabled         =>  If the command will display at all for the player.

        Name            =>  Name of the button

        Icon            =>  Icon to display to the left of each button.

        Type            =>  Defines the type of control the item is. Either button or separator.

        ExeCommand      =>  Command to be executed when button is pressed.

        ArgCount        =>  Number of arguments this button has.

        Arg1            =>  Argument 1

        Arg2            =>  Argument 2

        [---- SPECIAL PARAMETERS ----]

        IsMayorOnly               =>  If true -- item will only display if a player is a mayor specified job.

        IsCivilProtectionOnly     =>  If true -- item will only display if a player is a civil protector specified job.

        [------ SPECIAL NOTES ------]

        NOTE    =>  If type = "separator" -- you can NOT have to specify a NAME for the item. If you
                    do provide a name for a separator type, then it will automatically add it as a
                    category name above the space for the separator.

--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.Commands = {
    {
        Enabled = true,
        Name = "Общее",
        Type = "separator",
    },
    {
        Enabled = true,
        Name = "Выбросить деньги",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = false,
        Type = "button",
        ExeCommand = "/dropmoney",
        ArgCount = 1,
        Arg1 = "Amount",
        Arg2 = "",
    },
    {
        Enabled = true,
        Name = "Дать деньги",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = false,
        Type = "button",
        ExeCommand = "/give",
        ArgCount = 1,
        Arg1 = "Amount",
        Arg2 = ""
    },
    {
        Enabled = true,
        Type = "separator",
    },
    {
        Enabled = true,
        Name = "Выбросить оружие",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = false,
        Type = "button",
        ExeCommand = "/drop",
        ArgCount = 0,
        Arg1 = "",
        Arg2 = ""
    },
    {
        Enabled = true,
        Name = "Сделать ящик",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = false,
        Type = "button",
        ExeCommand = "/makeshipment",
        ArgCount = 0,
        Arg1 = "",
        Arg2 = ""
    },
    {
        Enabled = true,
        Name = "Продать все двери",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = false,
        ExeCommand = "/unownalldoors",
        Type = "button",
        ArgCount = 0,
        Arg1 = "",
        Arg2 = ""
    },
    {
        Enabled = true,
        Name = "Получить лицензию мэра",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = false,
        ExeCommand = "/requestlicense",
        Type = "button",
        ArgCount = 0,
        Arg1 = "",
        Arg2 = ""
    },
    {
        Enabled = true,
        Name = "Mayor",
        Type = "separator",
        IsMayorOnly = true
    },
    {
        Enabled = true,
        Name = "Начать ком. час",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = true,
        ExeCommand = "/lockdown",
        Type = "button",
        ArgCount = 0,
        Arg1 = "",
        Arg2 = "",
    },
    {
        Enabled = true,
        Name = "Закончить ком. час",
        Icon = "amethyst/amethyst_gui_point.png",
        IconColor = Color(255, 255, 255, 25),
        IsCivilProtectionOnly = false,
        IsMayorOnly = true,
        ExeCommand = "/unlockdown",
        Type = "button",
        ArgCount = 0,
        Arg1 = "",
        Arg2 = "",
    },
    {
        Enabled = true,
        Name = "Добавить правило",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = true,
        ExeCommand = "/addlaw",
        Type = "button",
        ArgCount = 1,
        Arg1 = "New Law",
        Arg2 = "",
    },
    {
        Enabled = true,
        Name = "Удалить правило",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = true,
        ExeCommand = "/removelaw",
        Type = "button",
        ArgCount = 1,
        Arg1 = "Law Number",
        Arg2 = "",
    },
    {
        Enabled = true,
        Name = "Поставить табло с правилами",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = true,
        ExeCommand = "/placelaws",
        Type = "button",
        ArgCount = 0,
        Arg1 = "",
        Arg2 = "",
    },
    {
        Enabled = true,
        Name = "Сообщение",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = false,
        IsMayorOnly = true,
        ExeCommand = "/broadcast",
        Type = "button",
        ArgCount = 1,
        Arg1 = "Message to Broadcast",
        Arg2 = "",
    },
    {
        Enabled = true,
        Name = "Civil Protection",
        Type = "separator",
        IsCivilProtectionOnly = true
    },
    {
        Enabled = true,
        Name = "Поиск ордера",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = true,
        IsMayorOnly = false,
        ExeCommand = "/warrant",
        Type = "button",
        ArgCount = 2,
        Arg1 = "Player",
        Arg2 = "Reason",
    },
    {
        Enabled = true,
        Name = "Розыск игрока",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = true,
        IsMayorOnly = false,
        ExeCommand = "/wanted",
        Type = "button",
        ArgCount = 2,
        Arg1 = "Player",
        Arg2 = "Reason",
    },
    {
        Enabled = true,
        Name = "Удалить розыск статуса",
        Icon = "amethyst/amethyst_gui_point.png",
        IsCivilProtectionOnly = true,
        IsMayorOnly = false,
        ExeCommand = "/unwanted",
        Type = "button",
        ArgCount = 1,
        Arg1 = "Player",
        Arg2 = "",
    }

}

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/