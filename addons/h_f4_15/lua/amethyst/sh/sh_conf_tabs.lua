Amethyst.Settings = Amethyst.Settings or {}

--[[ -----------------------------------------------------------------------------------------------

SETTINGS -> MAIN TAB BUTTONS

    These are the main tabs that players will use to navigate between the different things they can buy
    or jobs they can become.

        Enabled     =>  If the tab is visible or not.

        OnLoadInit  =>  Forces that particular panel to be the default panel loaded. ONLY ONE panel
                        should have this set to true.

        compactOnly =>  This item will ONLY show if the player is in Compact Mode (in settings panel).

        Name        =>  The name of the button

        Desc        =>  Description displayed below the name of the button

        Icon        =>  The icon to display to the left of each button.

        Panel       =>  The panel to load when the button is pressed.
                        This should NOT be modified for ANY reason unless you know what you're doing.

--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.Tabs = {
    {
        enabled = true,
        onLoadInit = false,
        compactOnly = true,
        name = "Dashboard",
        desc = "Your home",
        icon = "amethyst/amethyst_gui_ia_dashboard.png",
        panel = "Amethyst_Tab_Dashboard",
    },
    {
        enabled = true,
        onLoadInit = false,
        compactOnly = true,
        name = "Settings",
        desc = "Colorize your f4 screen",
        icon = "amethyst/amethyst_gui_ia_settings.png",
        panel = "Amethyst_Tab_Settings",
    },
    {
        enabled = false,
        onLoadInit = true,
        name = "Jobs",
        desc = "Earning your paycheck",
        icon = "amethyst/amethyst_mnu_jobs.png",
        panel = "Amethyst_Tab_Jobs",
    },
    {
        enabled = true,
        onLoadInit = false,
        name = "Предметы",
        desc = "Предметы для использование",
        icon = "amethyst/amethyst_mnu_entities.png",
        panel = "Amethyst_Tab_Entities",
    },
    {
        enabled = true,
        onLoadInit = false,
        name = "Оружие",
        desc = "Покупка Оружие",
        icon = "amethyst/amethyst_mnu_weapons.png",
        panel = "Amethyst_Tab_Weapons",
    },
    {
        enabled = true,
        onLoadInit = false,
        name = "Shipments",
        desc = "Extra things to help out",
        icon = "amethyst/amethyst_mnu_shipments.png",
        panel = "Amethyst_Tab_Shipments",
    },
    {
        enabled = true,
        onLoadInit = false,
        name = "Патроны",
        desc = "Патроны для оружие",
        icon = "amethyst/amethyst_mnu_ammo.png",
        panel = "Amethyst_Tab_Ammo",
    },
    {
        enabled = true,
        onLoadInit = false,
        name = "Food",
        desc = "Fill your face",
        icon = "amethyst/amethyst_mnu_food.png",
        panel = "Amethyst_Tab_Food",
    },
    {
        enabled = false,
        onLoadInit = false,
        name = "Vehicles",
        desc = "Vroom Vroom baby",
        icon = "amethyst/amethyst_mnu_vehicles.png",
        panel = "Amethyst_Tab_Vehicles",
    },
}