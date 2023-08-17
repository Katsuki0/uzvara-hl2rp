include("shared.lua")

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local kd = self:GetDTInt(0) or nil


			

	surface.SetFont("SW.ClockFont1")
	local TxtWidth = surface.GetTextSize("Гражданская")
	local TxtWidth2 = surface.GetTextSize("Оборона")
	
	cam.Start3D2D(pos + Vector(0, 0, 30), ang + Angle(0, 90, 90), .20)
			draw.SimpleTextOutlined( "Гражданская", "DermaLarge", 5, -270, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
			draw.SimpleTextOutlined( "Оборона", "DermaLarge", 5, -240, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
	cam.End3D2D()


end

