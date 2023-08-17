include("shared.lua")

surface.CreateFont( "principal", {
	font = "Arial",
	size = 30,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

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
			cam.Start3D2D(pos + oang:Forward()*16 + oang:Up() * 10 + oang:Right() * 10, ang, 0.07 )
				surface.SetDrawColor(161,161,161, 0)
				surface.DrawRect(-150, -30, 300, 45)
			if(LocalPlayer():GetNWInt("MRPJobBoxSystem") == true) then
				surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
				surface.DrawRect( -135, 25, 270, 120)
			else
				surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
				surface.DrawRect( -135, 25, 270, 0)
				draw.SimpleTextOutlined( "Сухпаек", "DermaLarge", 0, 50, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "Цена: 15 KWD", "DermaLarge", 0, 80, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "", "DermaLarge", 0, 110, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end
			cam.End3D2D()
		end
	end
end