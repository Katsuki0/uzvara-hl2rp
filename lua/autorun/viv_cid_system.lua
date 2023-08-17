if SERVER then
	util.AddNetworkString("VIV_Ply_Check_cID")
	
	net.Receive( "VIV_Ply_Check_cID", function()
		local ply = net.ReadEntity()
		local cID = net.ReadFloat()
		
		local ent = nil
		
		for k, v in pairs(player.GetAll()) do
			if v:GetNWInt("VIV_Ply_cID") == cID then
				ent = v
			end
		end
		
		if ent == nil then
			ply:PrintMessage( HUD_PRINTTALK, "[Диспетчер] Данные не найдены, перепроверьте запрос." )
		end
		
		local entName = ent:Name()
		local entCiD = ent:GetNWInt("VIV_Ply_cID")
		local entCcity = ent:GetNWInt("VIV_Ply_cCity")		
		local entTeam = ent:getDarkRPVar("job")
		
		----------------------------------[Admin job]-------------------------------------
		
		if ent:Team() == TEAM_GMAN or ent:Team() == TEAM_UKLI then
			entCcity = "ERROR"
		end
		
		if ent:Team() == TEAM_GMAN or ent:Team() == TEAM_UKLI then
			entName = "ERROR"
		end
		
		if ent:Team() == TEAM_GMAN or ent:Team() == TEAM_UKLI then
			entTeam = "ERROR"
		end
		
		----------------------------------[Citizen]-------------------------------------
		
		if ent:Team() == TEAM_VOR or ent:Team() == TEAM_DOMVOR or ent:Team() == TEAM_PRODAV or ent:Team() == TEAM_UBICA or ent:Team() == TEAM_INKOGNITO or ent:Team() == TEAM_VARZIK or ent:Team() == TEAM_EDA then
			entTeam = "Гражданин"
		end
		
		----------------------------------[Povst]-------------------------------------
		
		if ent:Team() == TEAM_BEZEN or ent:Team() == TEAM_SBR or ent:Team() == TEAM_POVST or ent:Team() == TEAM_MEDPOVST or ent:Team() == TEAM_POVSTWEP or ent:Team() == TEAM_SP or ent:Team() == TEAM_SHOTGUNERPV or ent:Team() == TEAM_PIRO or ent:Team() == TEAM_GRANAGER or ent:Team() == TEAM_STURM or ent:Team() == TEAM_VORTPV or ent:Team() == TEAM_LMD or ent:Team() == TEAM_SPECLMD or ent:Team() == TEAM_CMDLMD then
			entTeam = "Находится в чёрном списке"
		end	
		
		----------------------------------[Vokzal]-------------------------------------
		
		if ent:Team() == TEAM_FREEMAN or ent:Team() == TEAM_CITIZEN then
			entTeam = "Неопознанное лицо"
		end	

		----------------------------------[Liders]-------------------------------------
		
		if ent:Team() == TEAM_PL then
			entTeam = "Цель №2"
		end
		
		if ent:Team() == TEAM_FREEMANHEV then
			entTeam = "Цель №1"
		end
		
		----------------------------------[Civil Protection]-------------------------------------		
		
		if ent:isCP() or ent:Team() == TEAM_RCTTRAIT or ent:Team() == TEAM_GOO or ent:Team() == TEAM_BARNI then
			entTeam = "Сотрудник Альянса"
		end
		
		ply:ConCommand( "say /me Запросил данные о CID у диспетчера" )
		timer.Simple(0.1, function()
		ply:PrintMessage( HUD_PRINTTALK, "[Диспетчер] Получение информации..." )
		end)
		timer.Simple(2, function()
			ply:PrintMessage( HUD_PRINTTALK, "------[ CID : "..entCiD.." ]------" )
			ply:PrintMessage( HUD_PRINTTALK, "Имя: "..entName.."" )
			--ply:PrintMessage( HUD_PRINTTALK, "CID: "..entCiD.."" )
			ply:PrintMessage( HUD_PRINTTALK, "Прописка: "..entCcity.."" )
			ply:PrintMessage( HUD_PRINTTALK, "Должность: "..entTeam.."" )
			ply:PrintMessage( HUD_PRINTTALK, "---------------------------" )
		end)
	end)

	
	hook.Add( "PlayerInitialSpawn", "some_unique_name", function(ply)
		ply:SetNWString("VIV_Ply_cCity", "City - 11")
		ply:SetNWInt("VIV_Ply_cID", math.random(1000,8000)+ply:UserID())
	end)
end

if CLIENT then
	
end