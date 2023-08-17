-- DarRp Cook System by vadimhalo

-- ☐   ☐  ☐☐☐☐☐  ☐     ☐     ☐       ☐☐☐☐        ☐
-- ☐   ☐      ☐   ☐     ☐    ☐ ☐      ☐   ☐      ☐ ☐
-- ☐   ☐     ☐     ☐   ☐    ☐   ☐     ☐☐☐☐     ☐    ☐
-- ☐   ☐    ☐       ☐ ☐    ☐☐☐☐☐☐    ☐  ☐     ☐☐☐☐☐☐
--  ☐☐☐   ☐☐☐☐☐     ☐    ☐       ☐  ☐    ☐   ☐       ☐       

--Uzvara discord:https://discord.gg/aTWZxBP

hook.Add("OnEntityCreated", "DarkRP_CameraProp", function(ent)

	if ent:GetClass() == "gmod_cameraprop" then
		function ent:Explode()
			local pos = self:GetPos()

			local effect = EffectData()
			effect:SetStart(pos)
			effect:SetOrigin(pos)
			effect:SetScale(1)

			util.Effect("Explosion", effect)

			self:Remove()
		end

		function ent:OnTakeDamage(dmg)
			self:TakePhysicsDamage(dmg)

			self.damage = (self.damage or 10) - dmg:GetDamage()

			if self.damage <= 0 then
				self:Explode()
			end
		end
	end

end)