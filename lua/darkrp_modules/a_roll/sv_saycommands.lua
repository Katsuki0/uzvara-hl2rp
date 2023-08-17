local emote = "** " -- Keeps people from faking outcome with /me command.

local function RozaRoll( ply, args )
	local DoSay = function( text )
		local roll = math.random( 0, 100 )
		DarkRP.talkToRange( ply, emote .. ply:Nick() .. " Бросил кубик " .. roll .. ".", "", 350 )
	end
	return args, DoSay
end
DarkRP.defineChatCommand( "roll", RozaRoll )