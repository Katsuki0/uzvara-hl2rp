--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")

surface.CreateFont( "BCDispenserZavod", {
	font = "DermaLarge", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 500,
	extended = true
} )


function ENT:Initialize()
end

function ENT:Draw()

	local TIMER;
	if (self:GetNWInt('timer') < CurTime()) then
		TIMER = 0
	else 
		TIMER = (self:GetNWInt('timer')-CurTime())
	end
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
		cam.Start3D2D(Pos + Ang:Up() * 13, Ang, 0.11)
			if (self:GetNWInt('timer') > CurTime()) then
				draw.RoundedBox(6, -70, -150, 220, 78, Color(15,15,15,0))
				draw.WordBox(2, -40, -110, "Процесс: "..string.ToMinutesSeconds(TIMER), "BCDispenserZavod", Color(35, 80, 35, 0), Color(255,255,255,0))
			else
				draw.RoundedBox(6, -10, -150, 220, 44, Color(15,15,15,0))
			end
			draw.SimpleTextOutlined( "Обработка рациона", "DermaLarge", 40, -340, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			
		cam.End3D2D()
	end
end

function ENT:Think()
end
