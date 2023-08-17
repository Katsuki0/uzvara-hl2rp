-- traitor equipment: radio

AddCSLuaFile()

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "Турель"
   SWEP.Slot                = 7

   SWEP.ViewModelFlip       = false
   SWEP.ViewModelFOV        = 10
   SWEP.DrawCrosshair       = false

   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Турель которая атакует врагов"
   };

   SWEP.Icon                = "materials/typical_ttt/turret.png"
end

SWEP.Base                   = "weapon_tttbase"

SWEP.ViewModel              = ""
SWEP.WorldModel             = ""

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 1.0

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 1.0

SWEP.Kind                   = WEAPON_EQUIP2
SWEP.CanBuy                 = {ROLE_DETECTIVE} -- only traitors can buy
SWEP.LimitedStock           = true -- only buyable once
SWEP.WeaponID               = AMMO_TURRET

SWEP.AllowDrop              = false
SWEP.NoSights               = true

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:PrimaryAttack()
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   self:PlaceTurret()
end
function SWEP:SecondaryAttack()
   return
end

-- c4 plant but different
function SWEP:PlaceTurret()
   if SERVER then
      local ply = self.Owner
      if not IsValid( ply ) then return end

      if self.Planted then return end

      local vsrc = ply:GetShootPos()
      local vang = ply:GetAimVector()
      local vvel = ply:GetVelocity()
      local eyetrace = ply:GetEyeTrace()
      local distply = eyetrace.HitPos:Distance( ply:GetPos() )
      
      -- Too far from the owner
      if distply > 100 or !eyetrace.HitWorld then
            ply:ChatPrint( "Выберите другое место." )
         return false
      end
      

      local playerangle = ply:GetAngles()
      local supportangle
      local support = ents.Create( "prop_dynamic" )
      if IsValid( support ) then
         if ply.AddCleanup != nil then
            ply:AddCleanup( "npcs", support )
         end
         support:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
         supportangle = support:GetAngles()
         support:SetPos( eyetrace.HitPos + Vector( 0,0,0 ) )
         support:Spawn()
         support:SetCollisionGroup( COLLISION_GROUP_WORLD ) -- no physgun, etc.

         -- Invisible (propre)
         support:SetRenderMode( 10 )
         support:DrawShadow( false )
         
         support.turret = ents.Create( "npc_turret_floor" )
         if IsValid( support.turret ) then
            self.Planted = true
            support.turret.support = support
            support.turret:SetParent( support ) -- Bug in Garry's Mod
            support.turret:SetLocalPos( Vector( 0,0,0 ) )
            
            support:SetAngles( Angle( supportangle.p, playerangle.y, supportangle.r ) )
            support.turret:SetAngles( support:GetAngles() )
            
            support.turret:Spawn()
            support.turret:SetMoveType(MOVETYPE_NONE) 
            if IsValid(support.turret:GetPhysicsObject()) then
               support.turret:GetPhysicsObject():EnableMotion(false)
            end

            support.turret:EmitSound("npc/turret_floor/deploy.wav")
            for k,v in pairs (player.GetAll()) do
                  support.turret:AddEntityRelationship(v, D_LI, 99)
               end
            end      
            -- Bug fix:
            support.turret:SetParent( NULL )
            support:DeleteOnRemove( support.turret )
            constraint.Weld( support.turret, support, 0, 0, 0, true, false )
            
            support.turret:Activate()
            support.turret:SetMaxHealth( 250 )
            support.turret:SetHealth( 200 )
            support.turret.THealth = 200
            support.turret:SetBloodColor( BLOOD_COLOR_MECH )
            support.turret.FakeDamage = self.FakeDamage
            support.turret.weapon_ttt_turret = true
            support.turret.detective = true
            support.turret:SetNWBool("IsDetectiveTurret", true)
            support.turret.Icon = self.Icon
            
            support.turret:SetPhysicsAttacker( ply ) -- inutile
            support.turret:SetCreator( ply ) -- responsable des dégâts
            
            -- On empêche la tourelle de bloquer son propriétaire tant qu'il est à proximité.
            support.turret:SetOwner( ply )
            self:Remove()
            local turret_pos = support.turret:GetPos()
            local distance_timer = "turret"..tostring( support.turret:GetCreationID() )
            timer.Create( distance_timer, 0.2, 0, function()
               if !IsValid( support.turret ) or !IsValid( ply ) then
                  timer.Destroy( distance_timer )
                  return
               end
               local ply_pos = ply:GetPos()
               if math.abs( turret_pos.x-ply_pos.x )>50 or math.abs( turret_pos.y-ply_pos.y )>50 then
                  support.turret:SetOwner( nil )
                  timer.Destroy( distance_timer )
               end
            end )
         end
      end

   end
-- end


if SERVER then
   hook.Add("EntityTakeDamage", "DetectiveTurrel!", function (target, dmg)
      if target:IsPlayer() and target:IsActiveDetective() and dmg:GetAttacker() and dmg:GetAttacker():IsPlayer() then
         local turrets = ents.FindByClass( "npc_turret_floor" )
         for k,v in pairs (turrets) do
               v:AddEntityRelationship(dmg:GetAttacker(), D_HT, 99)
         end
      end
   end)


   hook.Add("EntityTakeDamage", "ScaleTurrelDamage", function (target, dmg)
      if target:IsValid() and target:IsPlayer() and dmg:GetAttacker():GetClass() == "npc_turret_floor" and dmg:GetDamageType() == 2 then
         dmg:ScaleDamage(3)
      end
   end)



end


function SWEP:Reload()
   return false
end

function SWEP:OnRemove()
   if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
      RunConsoleCommand("lastinv")
   end
end

function SWEP:Deploy()
   if SERVER and IsValid(self:GetOwner()) then
      self:GetOwner():DrawViewModel(false)
   end
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end
