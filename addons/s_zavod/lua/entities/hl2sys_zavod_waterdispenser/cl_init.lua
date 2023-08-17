--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")

surface.CreateFont( "DispenserZavod", {
	font = "Roboto Light", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
	weight = 500,
	extended = true
} )

function ENT:Initialize()
end

function ENT:Draw()
	local name = "Раздатчик Воды"
	local textProg1 = "В процессе."
	local textProg2 = "В процессе.."
	local textProg3 = "В процессе..."
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
		cam.Start3D2D(Pos + Ang:Up() * 23.8, Ang, 0.11)
			draw.SimpleTextOutlined( "Раздатчик Воды", "DermaLarge", 0, -100, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
		cam.End3D2D()
	end
end

function ENT:Think()
end
