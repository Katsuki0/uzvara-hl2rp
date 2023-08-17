/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


Amethyst = Amethyst or {}

--[[ -----------------------------------------------------------------------------------------------

					ADD DEVEOPER LOG

@desc: 				Saves anything important within Amethyst to a local file on the server and
					prints the output in the console.
@conditions: 		None
@assoc 				Shared

--------------------------------------------------------------------------------------------------]]

function Amethyst:AddDevLog( strText, intType, boolConsole )

	if not intType then intType = 1 end

	local LogType =
	{
		[1] = { "Normal", Color(255, 255, 255) },
		[2] = { "Error", Color(255, 0, 0) },
		[3] = { "Success", Color(0, 255, 0) },
		[4] = { "Notice", Color(255, 255, 0) },
	}

	local fetchLogType 		= LogType[intType]
	local messageType 		= table.KeyFromValue( LogType, intType )
	local fetchSavePath 	= Amethyst.Script.PathLogs or "amethyst/logs"

	local doLogSplice 		= 1
	local dateFormat 		= os.date(Amethyst.Settings.Devmode.FolderFormat or "%m-%d-%Y")
	local logFormat 		= os.date(Amethyst.Settings.Devmode.LogFormat or "%I:%M:%S")
	local FetchLogMaxSize 	= 16 * 16

	if (file.IsDir(fetchSavePath .. "/" .. dateFormat, "DATA")) then
		local files = file.Find(fetchSavePath .. "/" .. dateFormat .. "/*.txt", "DATA")

		if (table.Count(files) > 0) then
			local FetchLogSize = file.Size(fetchSavePath .. "/" .. dateFormat .. "/log_" .. #files .. ".txt", "DATA")

			if (FetchLogSize >= FetchLogMaxSize) then
				doLogSplice = table.Count(files) + 1
			end
		end
	else
		file.CreateDir(fetchSavePath .. "/" .. dateFormat, "DATA")
	end

	local doFormatMessage = fetchLogType[1] .. " -> " .. tostring(strText) .. "\n"

	file.Append(fetchSavePath .. "/" .. dateFormat .. "/log_" .. doLogSplice .. ".txt", doFormatMessage)

	if boolConsole then
		Amethyst.PrintConsole(doFormatMessage or "", fetchLogType[2] or Color(255, 255, 255))
	end

end

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/