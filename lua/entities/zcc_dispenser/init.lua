AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/metal_tube.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	
	self:SetUseType( SIMPLE_USE )
	
	--
	self.LastUse = 0
	self.Delay = 60
end

function ENT:Use(activator, caller)
				if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 1.5
		else
			return
		end

	local allowedTeam = TEAM_POSILNIJ
	if activator:Team() != allowedTeam then activator:ChatPrint( "Вы не умеете этим управлять" ) return end
	if self.LastUse > CurTime() then return end
		self.LastUse = CurTime() + self.Delay
		
		timer.Simple(0, function()
			self:EmitSound("buttons/button4.wav")
			caller:ConCommand( "say /me получил посылку")
			local ent = ents.Create( "zcc_ent" )
			ent:SetPos( self:GetPos() + ( self:GetForward() * 3 ) + ( self:GetUp() * 50 ) )
			ent:SetAngles( self:GetAngles() + Angle( 0, 0, 0 ) )
			ent:Spawn()
			ent:Activate()
			ent:GetPhysicsObject():ApplyForceCenter( self:GetForward() * 10 )
		end)
    end
	
function ENT:Draw()
	local oang = self:GetAngles()
	local opos = self:GetPos()

	local ang = self:GetAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis( oang:Up(), 90 )
	ang:RotateAroundAxis( oang:Right(), - 90 )
	ang:RotateAroundAxis( oang:Up(), - 0)

    self:DrawModel()
	if(LocalPlayer():GetEyeTrace().Entity == self) then
		if self:GetPos():Distance( LocalPlayer():GetPos() ) < 150 then
			cam.Start3D2D(pos + oang:Forward()*7 + oang:Up() * 53 + oang:Right() * 0, ang, 0.07 )
				surface.SetDrawColor(161,161,161, 0)
				surface.DrawRect(-150, -30, 300, 45)
				--draw.SimpleTextOutlined( "Кладовщик", "DermaLarge", 0, -10, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			if(LocalPlayer():GetNWInt("MRPJobBoxSystem") == true) then
				surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
				surface.DrawRect( -135, 25, 270, 0)
				draw.SimpleTextOutlined( "Нажмите ["..input.LookupBinding("+use").."]", "DermaLarge", 30, 50, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "Что бы", "DermaLarge", 0, 80, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "взаимодействовать", "DermaLarge", 0, 110, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end
			cam.End3D2D()
		end
	end
end