
rPrint = {}

rPrint.MinorVersion = 3
rPrint.Revision = 3
rPrint.Version = ([[%u.%u]]):format( rPrint.MinorVersion, rPrint.Revision )

rPrint.DefaultPrinterParams = {}
rPrint.SelectionModes = {
	RECHARGE = 1,
	WITHDRAW = 2,
	PURCHASE_COOLER = 3,
	TRANSFER_OWNERSHIP = 4
}

local events = {}


function rPrint.RegisterEventCallback( event, ident, callback )
	events[event] = events[event] or {}

	if !callback then
		callback = ident
		ident = #events[event] + 1
	else
		rPrint.Assert( type( ident ) == "string", "Invalid callback identifier." )
	end

	events[event][ident] = callback
end

function rPrint.UnregisterEventCallback( event, ident )
	rPrint.Assert( type( ident ) == "string", "Invalid callback identifier." )

	events[event] = events[event] or {}
	events[event][ident] = nil
end

function rPrint.TriggerEvent( event, ... )
	if !events[event] then return end

	for _, cb in pairs( events[event] ) do
		cb( ... )
	end
end

function rPrint.TriggerEventForResult( event, ... )
	if !events[event] then return end

	for _, cb in pairs( events[event] ) do
		local results = { cb( ... ) }

		if #results > 0 then 
			return unpack( results )
		end
	end
end


function rPrint.Error( msg, nohalt, noprefix, level )
	local func = nohalt and ErrorNoHalt or error
	msg = (noprefix and '' or "rPrint: ") .. msg .. '\n'
	level = level or 2

	func( msg, level )
end

function rPrint.Assert( cond, msg )
	if !cond then
		rPrint.Error( msg, false, false, 3 )
	end
end

function rPrint.IsMemberOfTeams( ply, teams )  --accepts team ids or names
	teams = (type( teams ) == "table") and teams or { teams }

	local plyt = ply:Team()
	local lookup = {}

	for _, t in pairs( teams ) do
		if type( t ) == "string" then
			t = t:lower()
			
			for tid, tbl in pairs( team.GetAllTeams() ) do
				if tbl.Name and tbl.Name:lower() == t then
					t = tid

					break
				end
			end
		end

		lookup[t] = true
	end

	return lookup[plyt] == true
end


function rPrint.RegisterPrinterType( pname, params, entname )
	local nice_name = ([[%s ]]):format( pname )
	local clean_name = pname:lower():gsub( [=[[^%a%d]+]=], '_' )

	params = params or {}
	entname = entname or ([[rprint_%sprinter]]):format( clean_name )

	local ENT = {}
	ENT.Type = "anim"
	ENT.Base = "rprint_base"
	ENT.PrintName = nice_name
	ENT.Spawnable = true
	ENT.AdminSpawnable = false

	ENT.Params = table.Copy( rPrint.DefaultPrinterParams )
	table.Merge( ENT.Params, params )

	scripted_ents.Register( ENT, entname )

	if ENT.Params.AutoAddToDarkRP then
		local cmd = ENT.Params.SpawnCommand

		if !cmd then
			local cmdfmt = [[buy%sprinter]]

			if !DarkRP or !DarkRP.createEntity then
				cmdfmt = [[/]] .. cmdfmt
			end

			cmd = cmdfmt:format( clean_name )
		end
		
		local entTbl = {
			ent = entname,
			model = "models/props_c17/consolebox01a.mdl",
			price = ENT.Params.Price or 1000,
			cmd = cmd,
			max = ENT.Params.Max or 9999,
			customCheck = function( ply )
				if ENT.Params.CustomCheck then
					local result = ENT.Params.CustomCheck( ply )

					if result != nil then
						return result
					end
				end

				if ENT.Params.AllowedTeams and !rPrint.IsMemberOfTeams( ply, ENT.Params.AllowedTeams ) then
					return false
				end

				if ENT.Params.AllowedUserGroups then
					local ug = ply:GetUserGroup():lower()
					local ingroup = false

					for _, group in pairs( ENT.Params.AllowedUserGroups ) do
						if group:lower() == ug then
							ingroup = true

							break
						end
					end

					if !ingroup then
						return false
					end
				end

				local steamid = ply:SteamID()
				local cnt = 0

				for _, ent in pairs( ents.GetAll() ) do
					if ent.Base == ENT.Base and ent.SpawnerSteamID == steamid then
						cnt = cnt + 1
					end
				end

				return cnt < (rPrint.MaxPrinters or 2)
			end
		}

		table.Merge( entTbl, ENT.Params.Custom or {} )

		AddEntity( nice_name, entTbl )
	end

	return entname
end
