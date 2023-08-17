	if (SERVER) then
	
		-- Information about the fact that this mod is activated.
		acdsuccess = "Загрузка автоочистки"
		MsgC(Color(90, 230, 0), acdsuccess.."\n")

		timer.Create("ClearDecalsConsole", 600, 0, function() -- 180 seconds
			acdclearmessages = ""
			MsgC(Color(90, 230, 0), acdclearmessages.."\n")
		end)

	end