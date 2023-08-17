	if (CLIENT) then
	
		timer.Create("ClearDecals", 180, 0, function()
		RunConsoleCommand("r_cleardecals", "")
		notification.AddLegacy( "Декали очищены.", NOTIFY_GENERIC, 3 )
		end)
		
	end