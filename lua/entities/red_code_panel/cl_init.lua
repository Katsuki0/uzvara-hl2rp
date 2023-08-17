include("shared.lua")
surface.CreateFont( "DisplayStatusCode", {
	font = "Trebuchet24",
	size = 120,
	weight = 300, 
	blursize = 0, 
	scanlines = 0, 
	antialias = false, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false,
} )

surface.CreateFont( "DisplayStatusCode2", {
	font = "Trebuchet24",
	size = 80,
	weight = 300, 
	blursize = 0, 
	scanlines = 0, 
	antialias = false, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false,
} )

surface.CreateFont( "SW.ClockFont", {

	font = "Trebuchet MS",
	
	extended = false,
	
	size = 30,
	
	weight = 700,
	
	blursize = 1,
	
	scanlines = 0,
	
	antialias = true
	
})

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:Draw()
	local oang = self:GetAngles()
	local opos = self:GetPos()

	local ang = self:GetAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis( oang:Up(), 90 )
	ang:RotateAroundAxis( oang:Right(), - 800 )
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
				draw.SimpleTextOutlined( "Красный код", "DermaLarge", -50, -500, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "", "DermaLarge", 0, 80, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "", "DermaLarge", 0, 110, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end
			cam.End3D2D()
		end
	end
end
