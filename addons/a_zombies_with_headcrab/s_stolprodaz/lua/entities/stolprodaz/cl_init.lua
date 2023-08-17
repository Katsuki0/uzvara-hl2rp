include('shared.lua')

function ENT:Draw()

    self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local color = Color( 0,0,2 )
	local color_two = Color( 0,0,255 )

	Ang:RotateAroundAxis(Ang:Up(), 0)

	Ang:RotateAroundAxis(Ang:Right(), 0)
	

	cam.Start3D2D(Pos + Ang:Up() * 0, Ang, 0)
	
		surface.SetDrawColor( 0, 0, 0, 255)
		
		surface.DrawRect( 0, -0, 0, 255 )
		
		surface.SetDrawColor( color )
		
		surface.DrawOutlinedRect(-0, -0, 0, 255 )


		draw.SimpleTextOutlined( "äçµØ ¨Æ", "DermaLarge", 0, 50, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		draw.SimpleTextOutlined( "¥¨Ô : 15 KWD", "DermaLarge", 0, 80, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		draw.SimpleTextOutlined( "", "DermaLarge", 0, 110, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

		
		surface.SetDrawColor( color )
		
		surface.DrawOutlinedRect( -0, 0, 0, 0 )

	cam.End3D2D()
	
end
