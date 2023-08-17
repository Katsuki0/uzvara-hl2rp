/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


--[[ -----------------------------------------------------------------------------------------------

	XTASK => LOGGING

		Provides debugging and logging features for the script based on whatever
		parameters are passed through the 'register' function.

	LOGGING ARGUMENT FORMAT:

		d or i		[Signed] decimal integer					100
		u			[Unsigned] decimal integer					7500
		f or F		Decimal floating point						500.50
		c			Character									a
		s			String										"Example"
		%%			Displays a single % within output 			%

--------------------------------------------------------------------------------------------------]]

rLib = rLib or {}
rLib.logs = rLib.logs or {}
rLib.tools = rLib.tools or {}
rLib.debug = rLib.debug or {}

local logProperties =
{
	[1] =
	{
		iName = "Normal",
		iColor = Color(255, 255, 255),
		ConsoleEnabled = true,
	},
	[2] =
	{
		iName = "Success",
		iColor = Color(0, 255, 0),
		ConsoleEnabled = true,
	},
	[3] =
	{
		iName = "Warning",
		iColor = Color(255, 255, 0),
		ConsoleEnabled = true,
	},
	[4] =
	{
		iName = "Error",
		iColor = Color(255, 0, 0),
		ConsoleEnabled = true,
	},
	[5] =
	{
		iName = "Notice",
		iColor = Color(255, 255, 0),
		ConsoleEnabled = true,
	},
	[6] =
	{
		iName = "Debug",
		iColor = Color(255, 255, 255),
		ConsoleEnabled = false,
	},
}

--[[ -----------------------------------------------------------------------------------------------

					FUNCTION -> xtask.logs.register

@desc: 				Adds a new item to the developer logs

@conditions:		None

@params 			intLogLevel 	=> 	Integer => Type of log
					boolWriteable 	=> 	Boolean => Writes log to file
					strMessage 		=> 	String  => Log to pass through
					{...} 			=> 	Arguments

@assoc 				Server

--------------------------------------------------------------------------------------------------]]

function rLib.logs.writetofile( loglevel, message )

	local doLogSplice 		= 1
	local dateFormat 		= os.date("%m-%d-%Y")
	local logFormat 		= os.date("%I:%M:%S")
	local fetchSavePath 	= Amethyst.Script.PathLogs or "amethyst/logs"
	local FetchLogMaxSize 	= 1024 * 1024

	local logFile = "log"
	if ( loglevel == 6 ) then
		logFile = "debug"
	end

	if ( file.IsDir( fetchSavePath .. "/" .. dateFormat, "DATA" ) ) then
		local files = file.Find( fetchSavePath .. "/" .. dateFormat .. "/*.txt", "DATA" )

		if ( table.Count( files ) > 0 ) then
			local FetchLogSize = file.Size( fetchSavePath .. "/" .. dateFormat .. "/" .. logFile .. "_" .. #files .. ".txt", "DATA" )

			if ( FetchLogSize >= FetchLogMaxSize ) then
				doLogSplice = table.Count( files ) + 1
			end
		end
	else
		file.CreateDir( fetchSavePath .. "/" .. dateFormat, "DATA" )
	end

	file.Append( fetchSavePath .. "/" .. dateFormat .. "/" .. logFile .. "_" .. doLogSplice .. ".txt", message )

end

--[[ -----------------------------------------------------------------------------------------------

			XTASK.LOGS.FORMAT

@desc 		Takes registered log entries and properly formats them.

--------------------------------------------------------------------------------------------------]]

function rLib.logs.format( loglevel, message, ... )

	if not loglevel then loglevel = 1 end

	--[[ -------------------------------------------------------------
	loglevel properties table
	----------------------------------------------------------------]]

	local logOutput = logProperties[loglevel]

	if not logOutput.ConsoleEnabled then return end

	if SERVER then
		if loglevel == 6 then
			MsgC( logOutput.iColor, "[" .. Amethyst.Script.Name .. "]" .. "-> [" .. logOutput.iName .. "]-> ", message .. "\n" )
		else
			MsgC( logOutput.iColor, "[" .. Amethyst.Script.Name .. "]" .. "-> ", message .. "\n" )
		end
	else
		MsgC( logOutput.iColor, message .. "\n" )
	end

end

function rLib.logs.register( loglevel, isWritable, message, ... )
	local args = { ... }
	local result, msg = pcall( string.format, message, unpack( args ) )

	if isWritable then
		rLib.logs.writetofile( loglevel, msg )
	end

	if result then
		rLib.logs.format( loglevel, msg )
	else
		-- Level 0 => does not report positioning ( no line numbers )
    	-- Level 1 => shows line number of error (default behavior)
    	-- Level 2 => shows line number of function call that caused error.
		error( msg, 1 )
	end
end

function rLib.logs.nline( lines )
	local linecount = tonumber( lines ) or 0
	if isnumber( linecount ) then
		for i = 1, lines or 1 do
			MsgC( "\n" )
		end
	end
end

function rLib.logs.print( loglevel, message, nl )
	if not loglevel then loglevel = 1 end
	local logOutput
	if ( type( loglevel ) == "table" and IsColor(loglevel) ) then
		if IsColor(loglevel) then
			logOutput = loglevel
		end
	else
		logOutput = logProperties[loglevel].iColor
	end
	MsgC( logOutput, message .. "\n" )

	if nl then
		rLib.logs.nline(nl)
	end
end

function rLib.isfunction( func )
    if ( type( func ) == "function" ) then
        return true
    end
    return false
end

function rLib.istable( tbl )
    if ( type( tbl ) == "table" ) then
        return true
    end
    return false
end

function rLib.debug.line()
    local line = 1
    local ifnot = "unspecified"
    for count = 1, math.huge do
        local setinfo = debug.getinfo( line + count, "l" )
        if not setinfo then
        	rLib.logs.register( 5, false, "Could not fetch reported line.")
        	return ifnot
        else
        	return setinfo.currentline or ifnot
        end
	end
end

function rLib.debug.os()
	if system.IsWindows() then
		return "Windows"
	elseif system.IsLinux() then
		return "Linux"
	else
		return "Unknown"
	end
end

function rLib.format_benchtime( seconds )
	if seconds < 1 then
		return math.Truncate( seconds, 3 ) .. " ms"
	else
		return math.Truncate( seconds, 2 ) .. " seconds"
	end
end

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/