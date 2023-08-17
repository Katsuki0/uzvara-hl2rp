
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


util.AddNetworkString( "rprint_selectmode" )

net.Receive( "rprint_selectmode", function( len, ply )
	if !IsValid( ply ) then return end

	local ent = net.ReadEntity()
	local select = net.ReadUInt( 8 )

	if !IsValid( ent ) or ent.Base != "rprint_base" then return end
	
	ent:SetPlayerSelection( ply, select )
end )


AccessorFunc( ENT, "health", "HP", FORCE_NUMBER )

function ENT:Initialize()
	self:SetModel( "models/props_c17/consolebox01a.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	
	self:SetColor( self.Params.Color )
	self:SetUseType( SIMPLE_USE )
	
	local owner = self:Getowning_ent()

	if IsValid( owner ) then
		self.OwnerSteamID = owner:SteamID()
		self.SpawnerSteamID = self.OwnerSteamID

		if self.CPPISetOwner then
			self:CPPISetOwner( owner )
		end
	end

	self.temp = self.Params.TempStart
	self.money = 0
	self.power = 100
	self.hascooler = false

	self:SetHP( self.Params.PrinterHealth )
	self:SetTemp( self.temp )
	self:SetMoney( self.money )
	self:SetPower( self.power )
	self:SetHasCooler( self.hascooler )

	local phys = self:GetPhysicsObject()

	if IsValid( phys ) then 
		phys:Wake()
	end

	self.last_update = 0
	self.last_dtupdate = 0
end

function ENT:Think()
	if CurTime() - self.last_update >= 1 then
		if self.hascooler and self.Params.CoolerBreakEnabled then
			if !self.nextCoolerBreak then
				self.nextCoolerBreak = CurTime() + math.random( 
					(self.Params.CoolerBreakInterval or {})[1] or 0,
					(self.Params.CoolerBreakInterval or {})[2] or 0
				)
			end

			if CurTime() >= self.nextCoolerBreak then
				self.hascooler = false
				self:SetHasCooler( self.hascooler )

				self:EmitSound( "buttons/combine_button2.wav", self.Params.SoundEffectVolume, 100 )

				self.nextCoolerBreak = nil
			end
		end

		if self.power > 0 then
			self.money = self.money + self.Params.PrintRate

			self.power = self.power
				- (self.Params.PowerConsumptionRate * self.Params.PrintRate)
				- (self.hascooler and self.Params.PowerConsumptionRateCooler or 0)

			self.temp = self.temp
				+ (self.Params.HeatRate * self.Params.PrintRate)
				- (self.hascooler and self.Params.CoolerCoolRate or 0)
		end

		self.temp = math.max(
			self.temp - self.Params.CoolRate,
			self.Params.TempMin
		)

		if self.temp >= self.Params.TempMax then
			local owner = self:Getowning_ent()

			if IsValid( owner ) and self.Params.AlertOwnerOnOverheated then
				owner:ChatPrint( "Your printer has overheated." )
			end

			if self.Params.ExplodeOnOverheat then
				self:Explode()
			else
				self.power = 0
				self.temp = self.Params.TempMax - 1
			end
		end

		if self.Params.ExplodeInWater and self:WaterLevel() > 0 then
			timer.Simple( 0.75, function()
				if IsValid( self ) then
					self:Explode()
				end
			end )
		end

		self.last_update = CurTime()
	end

	if CurTime() - self.last_dtupdate >= rPrint.UpdateDelay then
		self:SetTemp( self.temp )
		self:SetMoney( self.money )
		self:SetPower( self.power )

		self.last_dtupdate = CurTime()
	end
end

function ENT:OnTakeDamage( dmg )
	if !self.Params.CanBeDestroyed then return end

	self:SetHP( self:GetHP() - dmg:GetDamage() )

	if self:GetHP() <= 0 then
		local attacker = dmg:GetAttacker()

		if IsValid( attacker ) and attacker:IsPlayer() then
			local onteam = rPrint.IsMemberOfTeams( attacker, self.Params.DestroyPayoutTeams )

			if self.Params.DestroyPayoutTeamsExclusive and !onteam or onteam then
				rPrint.AddMoney( attacker, self.Params.DestroyPayout )
			end
		end

		local owner = self:Getowning_ent()

		if IsValid( owner ) and self.Params.AlertOwnerOnDestroyed then
			owner:ChatPrint( "Ваш принтер был уничтожен." )
		end

		self:Explode()
	end
end

function ENT:Explode()
	local pos, effect = self:GetPos(), EffectData()
		effect:SetStart( pos )
		effect:SetOrigin( pos )
		effect:SetScale( 1 )

	util.Effect( "Explosion", effect )

	self:Remove()
end

function ENT:WithdrawSelected( ply )
	if self.money <= 0 then return end

	rPrint.AddMoney( ply, self.money )

	self.money = 0
	self:SetMoney( self.money )

	self:EmitSound( "ambient/tones/equip3.wav", self.Params.SoundEffectVolume, 50 )
end

function ENT:CoolerSelected( ply )
	if self.hascooler then return end

	local coolercost = self.Params.CoolerCost

	if !rPrint.CanAfford( ply, coolercost ) then 
		self:EmitSound( "buttons/button2.wav", self.Params.SoundEffectVolume, 100 )
		return
	end
	
	rPrint.AddMoney( ply, -coolercost )

	self.hascooler = true
	self:SetHasCooler( self.hascooler )

	self.nextCoolerBreak = nil

	self:EmitSound( "buttons/lever1.wav", self.Params.SoundEffectVolume, 100 )
end

function ENT:Use( ply )
	if !self.selections or !self.selections[ply] then return end
	if self.lastuse and CurTime() - self.lastuse < 0.75 then return	end
	if ply:GetShootPos():Distance( self:GetPos() ) > self.Params.UseDistance then return end

	self.lastuse = CurTime()

	local select = self.selections[ply]

	if select == rPrint.SelectionModes.RECHARGE then
		self:RechargeSelected( ply )
	elseif select == rPrint.SelectionModes.WITHDRAW then
		self:WithdrawSelected( ply )
	elseif select == rPrint.SelectionModes.PURCHASE_COOLER then
		self:CoolerSelected( ply )
	elseif rPrint.OwnershipTransferEnabled and select == rPrint.SelectionModes.TRANSFER_OWNERSHIP and self:Getowning_ent() != ply then
		self:Setowning_ent( ply )
		self.OwnerSteamID = ply:SteamID()
		
		self:EmitSound( "buttons/combine_button1.wav", self.Params.SoundEffectVolume, 100 )
	end

	rPrint.TriggerEvent( "PRINTER_Use", self, ply, select )
end

function ENT:SetPlayerSelection( ply, select )
	self.selections = self.selections or {}

	self.selections[ply] = select
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
