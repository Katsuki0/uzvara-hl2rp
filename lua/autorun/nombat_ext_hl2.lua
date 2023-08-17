if SERVER then

	resource.AddWorkshop("506536295") --place you workshop addon number here ( I told you to copy it remember ;) )
	
end

if CLIENT then

	function Nombat_Cl_Init(  )
		
		local pl = LocalPlayer() -- (DONT EDIT)
		
		if IsValid(pl) then
			
			if pl then
				
				pl.NOMBAT_Level = 1 -- (DONT EDIT)
				pl.NOMBAT_PostLevel = 1 -- (DONT EDIT)
								
				local Ambient_Time = {131,96,99,34,90,115,84,37,84,39,98,50,59,29,61,115,43,69,72} --song time (in seconds)
				pl.NOMBAT_Amb_Delay = CurTime() -- (DONT EDIT)
				
				local Combat_Time = {104,120,123,61,90,65,45,73,159,69,170,103,139,46,13,135,98,42,31} --song time (in seconds)
				pl.NOMBAT_Com_Delay = CurTime() -- (DONT EDIT)
				pl.NOMBAT_Com_Cool = CurTime() -- (DONT EDIT)
				
				local packName = "hl2" --MAKE SURE THIS IS THE SAME AS THE FOLDER NAME HOLDING THE SOUNDS
				
				packName = packName.."/" -- (DONT EDIT)

				local subTable = { packName, Ambient_Time, Combat_Time } -- (DONT EDIT)
				
				if !pl.NOMBAT_PackTable then -- (DONT EDIT)
					pl.NOMBAT_PackTable = {subTable} -- (DONT EDIT)
						
				else
					table.insert( pl.NOMBAT_PackTable, subTable ) -- (DONT EDIT)
				end
				
				pl.NOMBAT_SVol = 0 -- (DONT EDIT)
				
			end
		end
	end
	hook.Add( "InitPostEntity", "Nombat_Cl_Init_hl2", Nombat_Cl_Init ) -- change the "Nombat_Cl_Init_GAMENAME" to "Nombat_Cl_Init_" and your game name.
	
end







