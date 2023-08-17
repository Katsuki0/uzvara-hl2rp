local PROVIDER = PROVIDER

-- Edit this with your authentication details
local auth = {
	Host = "localhost",
	Port = 3306,
	Username = "itemstore",
	Password = "",
	Database = "itemstore"
}

function PROVIDER:Log( text )
	print( "[ItemStore MySQL] " .. text )
	file.Append( "itemstore/mysql.txt", os.date( "[%c]" ) .. " " .. text .. "\r\n" )
end

function PROVIDER:OnConnected()
	self:Log( "Connection succesful!" )
	self:CreateTables()
end

function PROVIDER:CreateTables()
	local sql  = "CREATE TABLE IF NOT EXISTS `inventories`("
	sql = sql .. "	`steamid` BIGINT NOT NULL,"
	sql = sql .. "  `slot` INT NOT NULL,"
	sql = sql .. "	`class` VARCHAR(255) NULL,"
	sql = sql .. "	`data` BLOB NULL,"
	sql = sql .. "	PRIMARY KEY( `steamid`, `slot` ),"
	sql = sql .. "	INDEX( `steamid` )"
	sql = sql .. ")"

	self:Query( sql )

	local sql  = "CREATE TABLE IF NOT EXISTS `banks`("
	sql = sql .. "	`steamid` BIGINT NOT NULL,"
	sql = sql .. "  `slot` INT NOT NULL,"
	sql = sql .. "	`class` VARCHAR(255) NULL,"
	sql = sql .. "	`data` BLOB NULL,"
	sql = sql .. "	PRIMARY KEY( `steamid`, `slot` ),"
	sql = sql .. "	INDEX( `steamid` )"
	sql = sql .. ")"

	self:Query( sql )
end

function PROVIDER:OnError( err )
	self:Log( "Connection failed: " .. err )

	timer.Simple( 30, function()
		self:Initialize()
	end )
end

function PROVIDER:Initialize()
	require( "tmysql4" )
	assert( tmysql, "[ItemStore] TMySQL4 is not installed" )

	self:Log( "Connecting to database..." )

	local db, err = tmysql.initialize( auth.Host, auth.Username, auth.Password, auth.Database, auth.Port )

	if err then
		PROVIDER:OnError( err )
	else
		PROVIDER.Database = db
		PROVIDER:OnConnected()
	end
end

PROVIDER.Querying = false
PROVIDER.QueryQueue = {}

--[[
	todo: single thread queue system is way too slow. cannot keep up with a busy server.
	solution -- miniqueues. groups of sql statements meant to be run sequentially

	{
		{ "delete from `inventories`", "insert into `inventories` values( whatever" ) },
		{ other query set },
		{ other query set, etc }
	}

	each queryset can run independently of others. should be significantly faster. 
	index using a variable (such as player object or steamid) to ensure two querysets don't conflict?
	hopefully this resolves all the mysql bitching  
]]
function PROVIDER:UpdateQueueCache()
	local cached_queue = {}

	for k, v in ipairs( PROVIDER.QueryQueue ) do
		cached_queue[ k ] = v[ 1 ]
	end

	file.Write( "itemstore/mysql_queue.txt", util.TableToJSON( cached_queue ) )
end

function PROVIDER:QueueQuery( sql, callback )
	table.insert( self.QueryQueue, { sql, callback } )

	self:UpdateQueueCache()
	self:RunQueue()
end

local debug_sql = true

function PROVIDER:RunQueue()
	if not self.Database or self.Querying or #self.QueryQueue <= 0 then return end

	local sql, callback = unpack( table.remove( self.QueryQueue, 1 ) )

	if debug_sql then print( sql ) end

	self.Querying = true
	self.Database:Query( sql, function( results )
		self.Querying = false
		self:UpdateQueueCache()

		callback( results )

		self:RunQueue()
	end)
end

function PROVIDER:Query( sql, params, success, fail )
	if not self.Database then return end
	
	if not success then
		function success( data ) end
	end

	if not fail then
		function fail( err ) self:Log( "Query failed: " .. err ) end
	end

	if params then
		for k, v in pairs( params ) do
			if type( v ) ~= "number" then
				v = self.Database:Escape( v )
				v = "'" .. v .. "'"
			end

			sql = string.gsub( sql, ":" .. k, v )
		end
	end

	local callback = function( results )
		if results[ 1 ].status then
			success( results[ 1 ].data )
		else
			fail( results[ 1 ].error )
		end
	end

	self:QueueQuery( sql, callback )
end

function PROVIDER:LoadInventory( pl )
	local steamid = pl:SteamID64() or "0"

	local sql = "SELECT * FROM `inventories` WHERE `steamid` = :1"
	local params = { steamid }

	self:Query( sql, params, function( data )
		for _, v in ipairs( data ) do
			local slot = v.slot

			if v.data then
				local class = v.class
				local data = util.JSONToTable( v.data )

				pl.Inventory:SetItem( slot, itemstore.Item( class, data ) )
			end
		end

		pl.InventoryLoaded = true
	end )
end

function PROVIDER:SaveInventory( pl )
	if not pl.InventoryLoaded then return end

	local steamid = tostring( pl:SteamID64() or "0" ) -- in sp SteamID64 returns a number??

	local sql = "DELETE FROM `inventories` WHERE `steamid` = :1"
	local params = { steamid }

	self:Query( sql, params )

	if table.Count( pl.Inventory:GetItems() ) > 0 then
		local sql = "INSERT INTO `inventories`( `steamid`, `slot`, `class`, `data` ) VALUES"

		for k, v in pairs( pl.Inventory:GetItems() ) do
			local slot = k
			local steamid = "'" .. self.Database:Escape( steamid ) .. "'"
			local class = "'" .. self.Database:Escape( v:GetClass() ) .. "'"
			local data = "'" .. self.Database:Escape( util.TableToJSON( v.Data ) ) .. "'"

			sql = sql .. string.format( "( %s, %d, %s, %s ),", steamid, slot, class, data )
		end

		sql = string.Trim( sql, "," )

		self:Query( sql )
	end
end

function PROVIDER:LoadBank( pl )	
	local steamid = pl:SteamID64() or "0"

	self:Query( "SELECT * FROM `banks` WHERE `steamid` = :1", { steamid }, function( data )
		for _, v in ipairs( data ) do
			local slot = v.Slot

			if v.class then
				local class = v.Class
				local data = util.JSONToTable( v.Data )

				pl.Bank:SetItem( slot, itemstore.Item( class, data ) )
			end
		end

		pl.BankLoaded = true
	end )
end

function PROVIDER:SaveBank( pl )
	if not pl.BankLoaded then return end

	local steamid = pl:SteamID64() or "0"

	self:Query( "DELETE FROM `banks` WHERE `steamid` = :1", { steamid } )
	
	if table.Count( pl.Bank:GetItems() ) > 0 then
		local sql = "INSERT INTO `banks`( `steamid`, `slot`, `class`, `data` ) VALUES"

		for k, v in pairs( pl.Bank:GetItems() ) do
			local slot = k
			local steamid = "'" .. self.Database:Escape( steamid ) .. "'"
			local class = "'" .. self.Database:Escape( v:GetClass() ) .. "'"
			local data = "'" .. self.Database:Escape( util.TableToJSON( v.Data ) ) .. "'"

			sql = sql .. string.format( "( %s, %d, %s, %s ),", steamid, slot, class, data )
		end

		sql = string.Trim( sql, "," )

		self:Query( sql )
	end
end

function PROVIDER:Import( data )
	for k, v in pairs( data ) do
		self:Query( "DELETE FROM `inventories` WHERE `steamid` = :1", { k } )
		self:Query( "DELETE FROM `banks` WHERE `steamid` = :1", { k } )

		if v.Inventory then
			for slot, item in pairs( v.Inventory ) do
				if item then
					self:Query( "REPLACE INTO `inventories`( `steamid`, `slot`, `class`, `data` ) VALUES( :1, :2, :3, :4 )", { k, slot, item.Class, util.TableToJSON( item.Data ) } )
				else
					self:Query( "REPLACE INTO `inventories`( `steamid`, `slot`, `class`, `data` ) VALUES( :1, :2, :3, :4 )", { k, slot, item.Class, util.TableToJSON( item.Data ) } )
				end
			end
		end

		if v.Bank then
			for slot, item in pairs( v.Bank ) do
				if item then
					self:Query( "REPLACE INTO `banks`( `steamid`, `slot`, `class`, `data` ) VALUES( :1, :2, :3, :4 )", { k, slot, item.Class, util.TableToJSON( item.Data ) } )
				else
					self:Query( "REPLACE INTO `banks`( `steamid`, `slot`, `class`, `data` ) VALUES( :1, :2, :3, :4 )", { k, slot, item.Class, util.TableToJSON( item.Data ) } )
				end
			end
		end
	end

	return true
end

function PROVIDER:Export( filename )
	local export = {}

	local inventory_loaded = false
	local bank_loaded = false

	local function FinishExport( export )
		file.Write( filename, util.TableToJSON( export ) )
	end

	self:Query( "SELECT * FROM `inventories`", nil, function( data )
		for _, row in ipairs( data ) do
			if not ( export[ row.SteamID ] ) then
				export[ row.SteamID ] = {}
			end

			if not ( export[ row.SteamID ].Inventory ) then
				export[ row.SteamID ].Inventory = {}
			end

			if row.Class then
				export[ row.SteamID ].Inventory[ row.Slot ] = { Class = row.Class, Data = util.JSONToTable( row.Data ) }
			end
		end

		inventory_loaded = true

		if inventory_loaded and bank_loaded then
			FinishExport( export )
		end
	end )

	self:Query( "SELECT * FROM `banks`", nil, function( data )
		for _, row in ipairs( data ) do
			if not ( export[ row.SteamID ] ) then
				export[ row.SteamID ] = {}
			end

			if not ( export[ row.SteamID ].Bank ) then
				export[ row.SteamID ].Bank = {}
			end

			if row.Class then
				export[ row.SteamID ].Bank[ row.Slot ] = { Class = row.Class, Data = util.JSONToTable( row.Data ) }
			end
		end

		bank_loaded = true

		if inventory_loaded and bank_loaded then
			FinishExport( export )
		end
	end )
end

if file.Exists( "itemstore/mysql_queue.txt", "DATA" ) then
	queue = util.JSONToTable( file.Read( "itemstore/mysql_queue.txt", "DATA" ) )

	if queue and #queue > 0 then
		PROVIDER:Log( "Restoring " .. #queue .. " un-executed queries" )

		for k, v in ipairs( queue ) do
			PROVIDER.QueryQueue[ k ] = { v[ 1 ], function() end }
		end
	end
end