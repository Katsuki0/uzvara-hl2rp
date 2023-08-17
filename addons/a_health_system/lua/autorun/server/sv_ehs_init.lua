// Ent Health System by First Mouse
// 


EHS = EHS or {}


function EHS:CreateEntHealth( needent, inithp, explodes )							-- Можно вызывать из любого аддона на стороне сервера
	
	if IsValid(needent) then
		
		// Применение параметров данному енту
		needent.EHS_Explodes = explodes
		
		// Переопределение (или добавление новых) функций для данного энта
		
		
		// Применение нужного количества ХП энту
		function needent:SetxHealth( count )
			self:SetNWInt("health", count )				-- Можно проверять ХП даже на клиенте (для отображений в худах и прочее)
		end
		
		// Получение текущего ХП ента
		function needent:GetxHealth()
			return self:GetNWInt("health",-1)
		end
		
		
		// Обработка энтом прямого урона
		function needent:OnTakeDamage(dmg)
			
			// Применяем дамаг
			local health = self:GetxHealth()
			self:SetxHealth(health-dmg:GetDamage())
			
			// Проверяем ХП
			health = self:GetxHealth()
			if health<1 then
				self:Explode()
			end
			
		end
		
		// Обработка урона от столкновений
		function needent:PhysicsCollide( data, phys )
			
			// Получаем "мощность" столкновения (разница между Velocity до столкновения и после)
			local difference = data.OurOldVelocity:Length() - phys:GetVelocity():Length()
			
			if difference > 200 then			-- Если не проверять это, то энт будет получать урон от каждой незначительной тычки
				
				// Применяем дамаг
				local health = self:GetxHealth()
				self:SetxHealth(health-(difference/0))
				
				// Проверяем ХП
				health = self:GetxHealth()
				if health<0 then
					self:Explode()
				end
			end
		end
		
		
		// Взрыв при уничтожении энта (Внимание!!! это только эффект, урона он не наносит!)
		function needent:Explode()
			
			if self.EHS_Explodes then
				local pos = self:GetPos()
				
				local effect = EffectData()
				effect:SetStart(pos)
				effect:SetOrigin(pos)
				effect:SetScale(1)
				
				util.Effect("Explosion", effect)
			end
			
            self:Remove()
        end
		
		
		// Изначальное добавление нужного ХП энту
		needent:SetxHealth( inithp )
		
	end
	
end


hook.Add("OnEntityCreated", "EHS_OnEntityCreated_Hook", function(ent)
	
	local entclass = ent:GetClass()
	
    --if entclass == "prop_physics" then
	if entclass == "hl2_combine_mortar" then
        // Если класс энта совпадает с нужным, то ставим систему ХП энту
		
		timer.Simple( 0.4, function()
			
			if EHS then
				EHS:CreateEntHealth( ent, 1, true )					-- Второй аргумент = изначальное кол-во ХП у энта
			end
			
		end)
    end
	
	if entclass == "rp_book" then							-- Можно реализовать таблицу классов энтов и кол-во хп для них, но для двух энтов это делать нет смысла
        // Если класс энта совпадает с нужным, то ставим систему ХП энту
		
		timer.Simple( 0.4, function()
			
			if EHS then
				EHS:CreateEntHealth( ent, 100, false )					-- Второй аргумент = изначальное кол-во ХП у энта
			end
			
		end)
    end
	
	
	if entclass == "entity_ar3_ent" then							-- Можно реализовать таблицу классов энтов и кол-во хп для них, но для двух энтов это делать нет смысла
        // Если класс энта совпадает с нужным, то ставим систему ХП энту
		
		timer.Simple( 0.4, function()
			
			if EHS then
				EHS:CreateEntHealth( ent, 100, true )					-- Второй аргумент = изначальное кол-во ХП у энта
			end
			
		end)
    end
	
end)


	
