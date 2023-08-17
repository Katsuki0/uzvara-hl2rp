---- Shared corpsey stuff

CORPSE = CORPSE or {}

-- Manual datatable indexing
CORPSE.dti = {
   BOOL_FOUND = 0,
   
   ENT_PLAYER = 0,

   INT_CREDITS = 0
};

local dti = CORPSE.dti
--- networked data abstraction
function CORPSE.GetFound(rag, default)
   return rag and rag:GetDTBool(dti.BOOL_FOUND) or default
end

function CORPSE.GetPlayerNick(rag, default)
   if not IsValid(rag) then return default end

   local ply = rag:GetDTEntity(dti.ENT_PLAYER)
   if IsValid(ply) then
      return ply:Nick()
   else
      return rag:GetNWString("nick", default)
   end
end

function CORPSE.GetCredits(rag, default)
   if not IsValid(rag) then return default end
   return rag:GetDTInt(dti.INT_CREDITS)
end

function CORPSE.GetPlayer(rag)
   if not IsValid(rag) then return NULL end
   return rag:GetDTEntity(dti.ENT_PLAYER)
end


hook.Add("OnEntityCreated", "MG_RagdollCollide", function(ent)
   -- if ragdoll_collide:GetBool() then return end
   if ent:IsRagdoll() then
      timer.Simple(0, function()
         if IsValid(ent) then
            ent:SetCustomCollisionCheck(true)
         end
      end)
   end
end)

hook.Add("ShouldCollide", "MG_RagdollCollide", function(ent1, ent2)
   -- if ragdoll_collide:GetBool() then return end
   if IsValid(ent1) and IsValid(ent2) and ent1:IsRagdoll() and ent2:IsRagdoll() then
      if ent1.GetCollisionGroup and ent1:GetCollisionGroup() == COLLISION_GROUP_WEAPON and ent2:GetCollisionGroup() == COLLISION_GROUP_WEAPON then
         return false
      end
   end
end)