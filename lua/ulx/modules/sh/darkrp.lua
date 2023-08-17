local CATEGORY_NAME = "DarkRP"

----
//freze
function ulx.propfreeze( calling_ply )


	for _,v in pairs(ents.FindByClass("prop_fix")) do
		if IsValid(v) then
			local PObj = v:GetPhysicsObject()
			if PObj:IsValid() then
				PObj:EnableMotion(false)
			end		
		end
	end

	
	ulx.fancyLogAdmin( calling_ply, false, "#A зафризил все пропы" ) 
end
local propfreeze = ulx.command( CATEGORY_NAME, "ulx propfreeze", ulx.propfreeze, "!propfreeze", true )
propfreeze:defaultAccess( ULib.ACCESS_ADMIN )
propfreeze:help( "Заморозить все пропы." )

//addMoney
function ulx.addMoney( calling_ply, target_ply, amount )
	local total = target_ply:getDarkRPVar("money") + math.floor(amount)
	total = hook.Call("playerWalletChanged", GAMEMODE, target_ply, amount, target_ply:getDarkRPVar("money")) or total
	target_ply:setDarkRPVar("money", total)
	if target_ply.DarkRPUnInitialized then return end
	DarkRP.storeMoney(target_ply, total)
	
	ulx.fancyLogAdmin( calling_ply, true, "#A отвалил бабосов #T $#i", target_ply, amount )
	
end
local addMoney = ulx.command( CATEGORY_NAME, "ulx addmoney", ulx.addMoney, "!addmoney" )
addMoney:addParam{ type=ULib.cmds.PlayerArg }
addMoney:addParam{ type=ULib.cmds.NumArg, hint="money" }
addMoney:defaultAccess( ULib.ACCESS_SUPERADMIN )
addMoney:help( "Adds money to players DarkRP wallet." )
// 

function ulx.model( calling_ply, target_plys, model )
	
	for k,v in pairs( target_plys ) do 
	
		if ( not v:Alive() ) then
		
			ULib.tsayError( calling_ply, v:Nick() .. " is dead", true )
		
		else
		
			v:SetModel( model )

		end
		
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A set the model for #T to #s", target_plys, model )
	
end
local model = ulx.command( "DarkRP", "ulx model", ulx.model, "!model" )
model:addParam{ type=ULib.cmds.PlayersArg }
model:addParam{ type=ULib.cmds.StringArg, hint="model" }
model:defaultAccess( ULib.ACCESS_SUPERADMIN )
model:help( "Установить модель игрока." )

//
function ulx.setrpname( calling_ply, target_ply, name )

	ulx.fancyLogAdmin( calling_ply, "#A установил для #T имя #s", target_ply, name )

	target_ply:setRPName( name )

end

local setrpname = ulx.command( CATEGORY_NAME, "ulx setrpname", ulx.setrpname, "!setrpname" )
setrpname:addParam{ type=ULib.cmds.PlayerArg }
setrpname:addParam{ type=ULib.cmds.StringArg, hint="name" }
setrpname:defaultAccess( ULib.ACCESS_ADMIN )
setrpname:help( "Смена рп имя." )
setrpname:help( "Установить rpname игроку." )

function ulx.arrest( calling_ply, target_ply, time)

	if target_ply:isArrested() then
		ULib.tsayError( calling_ply,"Target is already arrested!", true )
		return
	end

	if time == 0 then
		target_ply:arrest( DarkRP.jailtimer, calling_ply )
		ulx.fancyLogAdmin( calling_ply, "#A арестовал #T", target_ply )
	else
		target_ply:arrest( time, calling_ply )
		ulx.fancyLogAdmin( calling_ply, "#A арестовал #T на #i сек", target_ply, time )
	end

end

function ulx.setjob( calling_ply, target_ply, job)

	local valid = false

	for k, v in pairs( team.GetAllTeams( ) ) do
		if valid == false and string.find( string.lower( tostring(v.Name) ), string.lower( tostring(job) ) ) then
			target_ply:changeTeam( k, true )
			job = v.Name
			valid = true
		end
	end

	if valid then
		ulx.fancyLogAdmin( calling_ply, "#A установил #T профессию  #s", target_ply, job )
	else
		ULib.tsayError( calling_ply, "Job not found!", true )
	end

end

local setjob = ulx.command( CATEGORY_NAME, "ulx setjob", ulx.setjob, "!setjob" )
setjob:addParam{ type=ULib.cmds.PlayerArg }
setjob:addParam{ type=ULib.cmds.StringArg, hint="job" }
setjob:defaultAccess( ULib.ACCESS_ADMIN )
setjob:help( "Установить профессию игроку." )

function ulx.banjob( calling_ply, target_ply, job)

	local valid = false

	for k, v in pairs( team.GetAllTeams( ) ) do
		if valid == false and string.find( string.lower( tostring(v.Name) ), string.lower( tostring(job) ) ) then
			target_ply:teamBan( k )

			if target_ply:Team() == k then
				target_ply:changeTeam( GAMEMODE.DefaultTeam, true )
			end

			job = v.Name
			valid = true
		end
	end

	if valid then
		ulx.fancyLogAdmin( calling_ply, "#A заблокировал #T профессию #s", target_ply, job )
	else
		ULib.tsayError( calling_ply, "Job not found!", true )
	end

end


--

function ulx.addMoneyid( calling_ply, steamid, money )

	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid steamid." )
		return
	end


	for _, v in pairs( player.GetAll() ) do
	
		if  v:SteamID() == steamid then 
			
			local total = v:getDarkRPVar("money") + math.floor(money)
			total = hook.Call("playerWalletChanged", GAMEMODE, v, money, v:getDarkRPVar("money")) or total
			v:setDarkRPVar("money", total)
			if v.DarkRPUnInitialized then return end
			DarkRP.storeMoney(v, total)
	
			
	
		end

	end

end
local addMoneyid = ulx.command( CATEGORY_NAME, "ulx addmoneyid", ulx.addMoneyid, "!addmoneyid" )
addMoneyid:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
addMoneyid:addParam{ type=ULib.cmds.StringArg, hint="money" }
addMoneyid:defaultAccess( ULib.ACCESS_SUPERADMIN )
addMoneyid:help( "Выдать бабосов игроку." )
--
function ulx.cleardecals(calling_ply)
	for k,v in pairs(player.GetAll()) do
		v:ConCommand("r_cleardecals")
	end
	ulx.fancyLogAdmin( calling_ply, "#A cleared decals.")
end
local cleardecals = ulx.command("Cleanup Kit", "ulx cleardecals", ulx.cleardecals, "!cleardecals")
cleardecals:defaultAccess( ULib.ACCESS_ADMIN )
cleardecals:help( "Убрать все декалии." )

function ulx.clearragdolls(calling_ply)
	for k,v in pairs(player.GetAll()) do
		v:SendLua([[for k,v in pairs(ents.FindByClass('class C_ClientRagdoll')) do v:Remove() end]])
	end
	ulx.fancyLogAdmin( calling_ply, "#A cleared clientside ragdolls.")
end
local clearragdolls = ulx.command("Cleanup Kit", "ulx clearragdolls", ulx.clearragdolls, "!clearragdolls")
clearragdolls:defaultAccess( ULib.ACCESS_ADMIN )
clearragdolls:help( "Убрать регдоллы на стороне клиента." )

function ulx.stopsound(calling_ply)
	for k,v in pairs(player.GetAll()) do
		v:SendLua([[RunConsoleCommand("stopsound")]])
	end
	ulx.fancyLogAdmin( calling_ply, "#A ran stopsound on all players.")
end
local stopsound = ulx.command("Cleanup Kit", "ulx stopsound", ulx.stopsound, "!stopsound")
stopsound:defaultAccess( ULib.ACCESS_ADMIN )
stopsound:help( "Запусть stopsound для всех игроков." )


function ulx.cleanprops(calling_ply,target_ply)
	for k,v in pairs(ents.FindByClass("prop_fix")) do
		if (v.Owner and v.Owner == target_ply) or (v.FPPOwnerID and v.FPPOwnerID == target_ply:SteamID()) then
			v:Remove()
		end
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A Удалил все пропы #T", target_ply )
end
local cleanprops = ulx.command("Cleanup Kit", "ulx cleanprops", ulx.cleanprops, "!cleanprops")
cleanprops:addParam{ type=ULib.cmds.PlayerArg }
cleanprops:defaultAccess( ULib.ACCESS_ADMIN )
cleanprops:help( "Удалить все пропы игроку." )

function ulx.cleanupall( calling_ply )

	for k, v in pairs(player.GetAll()) do
		v:SendLua([[ LocalPlayer():ConCommand("gmod_cleanup") ]])
	end
	ulx.fancyLogAdmin( calling_ply, "#A Удалил пропы всех игроков !" )
	
end
local cleanupall = ulx.command("Cleanup Kit", "ulx cleanupall", ulx.cleanupall, "!cleanupall" )
cleanupall:defaultAccess( ULib.ACCESS_ADMIN )
cleanupall:help( "Удалить все пропы игроков на сервере." )
cleanupall:help( "Удалить все пропы игроков на сервере." )
