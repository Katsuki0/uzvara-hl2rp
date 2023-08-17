AddCSLuaFile()

//local ENT = {}

ENT.Base = "base_gmodentity"

ENT.PrintName = 'Мука'
ENT.Author = 'vadimhalo'
ENT.Information = 'Для еды'
ENT.Category = 'Cook'
ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SetupDataTables()
    self:NetworkVar( 'Entity', 0, 'owning_ent' )
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
else
	function ENT:Initialize()
		self:SetModel( 'models/props_junk/garbage_bag001a.mdl' )
		self:PhysicsInit( SOLID_VPHYSICS ) 
		self:SetUseType( SIMPLE_USE )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
				
		self.used = false

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	function ENT:Touch( ent )
		if ent:GetClass() == 'cm_stove' and self.used == false then
			for i = 1, 3 do
				local state = ent:GetNWInt( 'CookState' .. i, 0 )
				
				if state == 1 then
					ent:SetNWInt( 'CookState' .. i, 2 )
					ent:SetNWInt( 'CookTime' .. i, CurTime() + ent.CookingTime )
						
					self.used = true
					return self:Remove()
				end
			end
		end
	end

	function ENT:Think()
		
		if IsValid( self:Getowning_ent() ) then

			if self:Getowning_ent():Team() != TEAM_PISHEVOJSNABDITEL then

				return self:Remove()

			end

		end

	end
end


scripted_ents.Register( ENT, 'cm_flour' )
