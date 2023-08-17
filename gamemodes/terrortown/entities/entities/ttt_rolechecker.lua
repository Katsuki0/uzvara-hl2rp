
AddCSLuaFile()

if CLIENT then
   local GetPTranslation = LANG.GetParamTranslation
   local hint_params = {usekey = Key("+use", "USE")}

   ENT.TargetIDHint = {
      name = "Проверка детектива",
      hint = "Это проверяет людей",
      fmt  = function(ent, txt) return "Заставьте людей нажать на это" end
   };

end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/hunter/blocks/cube025x025x025.mdl")

ENT.RenderGroup = RENDERGROUP_BOTH


ENT.UseTry = 2

ENT.CanUseKey = true

function ENT:Initialize()
   self.BaseClass.Initialize(self)
   if SERVER then
    self:SetUseType( SIMPLE_USE )
   end
   self:SetSolid(SOLID_VPHYSICS)

   if SERVER then
      self:SetMaxHealth(50)
      self:SetExplodeTime(CurTime() + 1)
   end

   self:SetHealth(50)
end

local role_colors = {
   ["traitor"] = Color(255,0,0),
   ["innocent"] = Color(0,255,0),
   ["detective"] = Color(0,0,255)
}


local role_colors = {
   ["traitor"] = Color(255,0,0),
   ["innocent"] = Color(0,255,0),
   ["detective"] = Color(0,0,255)
}



local role_str = {
   ["traitor"] = "Предатель",
   ["innocent"] = "Невиновный",
   ["detective"] = "Детектив"
}

function ENT:Use(ent)
   if self.UserTry == nil or self.UserTry >= 0 then
	   if ent:IsValid() and ent:IsPlayer() then
	      if ent.Checked == true then ent:ChatPrint("Вы уже проверялись! Вы "..role_str[ent:GetRoleString()]) return end
	         if role_colors[ent:GetRoleString()] then
	            self:SetColor(role_colors[ent:GetRoleString()])
	            self:EmitSound(Sound("npc/assassin/ball_zap1.wav"))
	            ent.Checked = true
	            net.Start("ttt.PrettyPrintString")
	            net.WriteString(ent:Nick().." только что проверился на проверке. Его роль : "..role_str[ent:GetRoleString()])
	            net.Broadcast()

	            self.UseTry = self.UseTry - 1


               ent:SetPlayerColor(Vector(role_colors[ent:GetRoleString()].r/255,role_colors[ent:GetRoleString()].g/255,role_colors[ent:GetRoleString()].b/255))
	         end
	   end
	end
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")

function ENT:Think()
   if self.UseTry <= 0 and not self.Destroy then
      self.Destroy = true
      self:Ignite(3)
      timer.Simple(3, function ()
         local effect = EffectData()
         effect:SetOrigin(self:GetPos())
         util.Effect("cball_explode", effect)
         sound.Play(zapsound, self:GetPos())
         
         self:Remove()
      end)

   end

   self:NextThink(CurTime() + 2)
end

-- local zapsound = Sound("npc/assassin/ball_zap1.wav")
function ENT:OnTakeDamage(dmginfo)
   self:TakePhysicsDamage(dmginfo)

   if dmginfo:GetDamageType() == 2 then
      self:SetHealth(self:Health() - dmginfo:GetDamage())
      if self:Health() < 0 then
         self:Remove()

         local effect = EffectData()
         effect:SetOrigin(self:GetPos())
         util.Effect("cball_explode", effect)
         sound.Play(zapsound, self:GetPos())
      end
   end
end



-- function ENT:OnRemove()
--    self:StopScanSound(true)
-- end

function ENT:Explode(tr)
   if SERVER then

      -- prevent starting effects when round is about to restart
      if GetRoundState() == ROUND_POST then return end

      self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

      local corpses = self:GetNearbyCorpses()
      if #corpses > self.MaxScenesPerPulse then
         table.SortByMember(corpses, "dist", function(a, b) return a > b end)
      end

      local e = EffectData()
      e:SetOrigin(self:GetPos())
      e:SetRadius(128)
      e:SetMagnitude(0.5)
      e:SetScale(4)
      util.Effect("pulse_sphere", e)

      -- "schedule" next show pulse
      self:SetDetonateTimer(self.PulseDelay)

   end
end


hook.Add("TTTEndRound", "clearRoleCheker", function ()
   for k,v in pairs (player.GetAll()) do
      v.Checked = false
   end
end)