print ("SV Atmos Time")

SetGlobalString( "Atmos_Time", "00:00" )

local function calculateTime( time )

	if time == nil then time = 0 end
	
	time = ( time * 3600 )
	
	time = os.date(  "%H:%M", time )
	
	if time[1] == "0" then
	
		time = time:Right( #time - 1 )
	
	end
	
	return time

end

hook.Add( "Think", "Atmos_Clock", function()

	local time = calculateTime( AtmosGlobal.m_Time or 0 )
	
	SetGlobalString( "Atmos_Time", time ) 

end )