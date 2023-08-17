AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_wasteland/controlroom_storagecloset001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
		phys:Wake()
	end
end

ENT.Once = false
function ENT:Use( ply, activator )
				if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 1.5
		else
			return
		end
	local coffeprice = cm.coffeprice
	
	if not activator:canAfford( coffeprice ) then
		activator:ChatPrint( "У вас не достаточно средств" )
		return ""
	end
	
	
	self.Once = true
	
	activator:addMoney( -coffeprice )
	activator:ChatPrint( "Вы потратили 15 KWD" )
	activator:EmitSound("items/ammocrate_close.wav", 50, 100)
	timer.Create( self:EntIndex() .. "cm_coffe", 1.5, 1, function()
		if not IsValid(self) then return end
		self:CreateCoffe()
	end )
end

function ENT:CreateCoffe()
	self.Once = false
	local pos, ang = LocalToWorld( Vector(18,-5,-25), Angle( -90, -90, 0 ), self:GetPos(), self:GetAngles() )
	local coffe = ents.Create( "cm_coffe" )
	coffe:SetPos( pos )
	coffe:SetAngles( ang )
	coffe:Spawn()
end

function ENT:OnRemove()
	if not IsValid(self) then return end
	timer.Destroy( self:EntIndex() .. "cm_coffe" )
end

function CoffeMachineSpawn()
	local cmSpawn = cm.mapspawn[ game.GetMap() ]
	if ( cmSpawn ) then
		local coffemachine = ents.Create( "cm_coffemachine" )
		coffemachine:SetPos( cmSpawn.pos )
		coffemachine:SetAngles( cmSpawn.ang )
		coffemachine:SetMoveType( MOVETYPE_NONE )
		coffemachine:Spawn()
	end
end
hook.Add( "InitPostEntity", "SpawnCoffeMachines", CoffeMachineSpawn )