--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")

surface.CreateFont( "SDispenserZavod", {
	font = "Roboto Bk", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 42,
	weight = 100,
	extended = true
} )

surface.CreateFont( "SSDispenserZavod", {
	font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 42,
	weight = 400,
	extended = true
} )

surface.CreateFont( "SSSDispenserZavod", {
	font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 60,
	weight = 400,
	extended = true
} )

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Up(), 90)
if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
	cam.Start3D2D(Pos + Ang:Up() * 4.6, Ang, 0.11)
		draw.RoundedBox(6, -95, -40, 222, 180, Color(15,15,15,0))
		draw.WordBox(2, -60, -30, "Коробка", "SDispenserZavod", Color(15, 15, 15,0), Color(255,255,255,0))
		
		
		draw.RoundedBox(2, -45, 25, 120, 60, Color(15,15,15,210))
		draw.SimpleText("", "SSDispenserZavod", -50, 36, Color(255,255,255,255))
		--draw.SimpleText("Еда: ", "SSDispenserZavod", -65, 72, Color(255,255,255,255))
		
		draw.SimpleText(self:GetNWInt("ReadyToSell").."/10", "SSSDispenserZavod", -40, 30, Color(125,125,0))
	--	draw.SimpleText(self:GetNWInt("RFood").."/1", "SSDispenserZavod", 34, 72, Color(45,140,45))
	--	draw.WordBox(2, -TextWidth2*0.5, 18, owner, "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
end
end

function ENT:Think()
end
