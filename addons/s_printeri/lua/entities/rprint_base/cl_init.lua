
include( "shared.lua" )


surface.CreateFont( "rprint_normal", {
	font = "ChatFont",
	size = 28,
	antialias = true
} )

surface.CreateFont( "rprint_small", {
	font = "ChatFont",
	size = 18,
	antialias = true
} )

surface.CreateFont( "rprint_tiny", {
	font = "ChatFont",
	size = 12,
	antialias = false,
} )


local mat_fan = Material( "dan/rprint/fanpart1.png" )
local mat_fanbase = Material( "dan/rprint/fanpart2.png" )

function ENT:DrawMoneyBox( x, y, w, h, alpha, cx, cy, cactive )
	local balpha = 240 * alpha

	surface.SetDrawColor( Color( 30, 30, 30, balpha ) )
	surface.DrawRect( x, y, w, h )

	surface.SetDrawColor( Color( 80, 80, 80, balpha ) )
	surface.DrawOutlinedRect( x, y, w, h )

	draw.SimpleTextOutlined(
		"Деньги",
		"ChatFont",
		x + 8, y + 4,
		Color( 255, 255, 255, 255 * alpha ),
		TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM,
		0, Color( 0, 0, 0, 255 * alpha )
	)

	draw.SimpleTextOutlined(
		"KWD " .. string.Comma( self.Params.PrintRate * 60 ) .. "/m",
		"rprint_small",
		x + 8, y + 22,
		Color( 255, 255, 255, 255 * alpha ),
		TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM,
		0, Color( 0, 0, 0, 255 * alpha )
	)

	draw.SimpleTextOutlined(
		"",
		"rprint_small",
		x + 8, y + 40,
		Color( 255, 255, 255, 255 * alpha ),
		TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM,
		0, Color( 0, 0, 0, 255 * alpha )
	)

	draw.SimpleTextOutlined(
		"KWD: " .. string.Comma( self:GetMoney() ),
		"rprint_small",
		x + h / 2, y + 58,
		Color( 255, 255, 255, 255 * alpha ),
		TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,
		0, Color( 0, 0, 0, 255 * alpha )
	)

	local wb_x = x + 4
	local wb_y = y + h - 20
	local wb_w = w - 8
	local wb_h = 16

	local inrad = LocalPlayer():GetShootPos():Distance( self:GetPos() ) < self.Params.UseDistance
	local wb_selected = cactive and inrad and 
		cx >= wb_x and cx <= wb_x + wb_w and 
		cy >= wb_y and cy <= wb_y + wb_h

	self.selected = wb_selected and rPrint.SelectionModes.WITHDRAW or self.selected

	surface.SetDrawColor( 
		wb_selected and Color( 75, 75, 75, balpha ) or Color( 20, 20, 20, balpha )
	)
	surface.DrawRect( wb_x, wb_y, wb_w, wb_h )

	surface.SetDrawColor( 
		wb_selected and Color( 125, 125, 125, balpha ) or Color( 40, 40, 40, balpha )
	)
	surface.DrawOutlinedRect( wb_x, wb_y, wb_w, wb_h )

	draw.SimpleTextOutlined(
		"Взять",
		"rprint_tiny",
		wb_x + (wb_w / 2), wb_y + (wb_h / 2),
		Color( 255, 255, 255, 255 * alpha ),
		TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
		0, Color( 0, 0, 0, 255 * alpha )
	)
end

function ENT:DrawPrinterInfo( alpha )
	local lpos = Vector( -16.25, -15, 10.75 )
	local pos = self:LocalToWorld( lpos )
	local ang = self:GetAngles()
	local balpha = 240 * alpha
	local scale = 0.12

	ang:RotateAroundAxis( ang:Up(), 90 )
	
	local whitpos = util.IntersectRayWithPlane( 
		LocalPlayer():GetShootPos(), LocalPlayer():GetAimVector(),
		pos, ang:Up()
	)
	local cx, cy = 0, 0
	local cactive = false

	if whitpos then
		local hitpos = self:WorldToLocal( whitpos ) - lpos

		cx = hitpos.y * (1 / scale)
		cy = hitpos.x * (1 / scale)
		cactive = true
	end

	--size: 256x256
	cam.Start3D2D( pos, ang, scale )

		--Background

		surface.SetDrawColor( Color( 10, 10, 10, 200 * alpha ) )
		surface.DrawRect( 8, 8, 256 - 16, 256 - 16 )

		local box_w, box_h = (256 - 32), 48

		--Name Box

		local nb_x, nb_y = 16, 16

		local inrad = LocalPlayer():GetShootPos():Distance( self:GetPos() ) < self.Params.UseDistance
		local nb_selected = rPrint.OwnershipTransferEnabled and cactive and inrad and self:Getowning_ent() != LocalPlayer() and
			cx >= nb_x and cx <= nb_x + box_w and 
			cy >= nb_y and cy <= nb_y + box_h

		self.selected = nb_selected and rPrint.SelectionModes.TRANSFER_OWNERSHIP or self.selected

		surface.SetDrawColor( 
			nb_selected and Color( 75, 75, 75, balpha ) or Color( 30, 30, 30, balpha )
		)
		surface.DrawRect( nb_x, nb_y, box_w, box_h )

		surface.SetDrawColor( 
			nb_selected and Color( 125, 125, 125, balpha ) or Color( 80, 80, 80, balpha )
		)
		surface.DrawOutlinedRect( nb_x, nb_y, box_w, box_h )

		local name = ""
		local owner = self:Getowning_ent()

		if IsValid( owner ) then
			name = owner:Name()
		end

		draw.SimpleText(
			name,
			"rprint_normal",
			nb_x + (box_w / 2), nb_y + (box_h / 2),
			Color( 255, 255, 255, 255 * alpha ),
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
		)

		--Printer Type Box

		local tb_x = 16
		local tb_y = nb_y + box_h + 10

		surface.SetDrawColor( Color( 30, 30, 30, balpha ) )
		surface.DrawRect( tb_x, tb_y, box_w, box_h )

		surface.SetDrawColor( Color( 80, 80, 80, balpha ) )
		surface.DrawOutlinedRect( tb_x, tb_y, box_w, box_h )

		local pcol = self.Params.Color

		draw.SimpleText(
			self.PrintName,
			"rprint_normal",
			tb_x + (box_w / 2), tb_y + (box_h / 2),
			Color( pcol.r, pcol.g, pcol.b, 255 * alpha ),
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
		)

		--Battery and Money Boxes

		local smallbox_w = (500 - (16 * 3)) / 2
		local smallbox_h = (256 - (tb_y + box_h)) - (16 * 2)

		local bb_x = 16 
		local bb_y = 16 + (tb_y + box_h)

		local mb_x = (-105 * 2) + smallbox_w
		local mb_y = bb_y

		self:DrawMoneyBox( 
			mb_x, mb_y, 
			smallbox_w, smallbox_h, 
			alpha, 
			cx, cy, cactive
		)
	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	local dist = math.Clamp( LocalPlayer():GetShootPos():Distance( self:GetPos() ) - 40, 0, 5000 )

	if dist > self.Params.FadeDistance then return end

	local alpha = math.Clamp( math.cos( (dist / self.Params.FadeDistance) * (math.pi / 2) ), 0, 1 )

	self.selected = 0

	rPrint.TriggerEvent( "PRINTER_PreDraw", self, alpha )

	self:DrawPrinterInfo( alpha )

	rPrint.TriggerEvent( "PRINTER_PostDraw", self, alpha )
end

function ENT:Think()
	self:NextThink( CurTime() + 0.4 )

	if self.selected == self.last_selected then return end

	self.last_selected = self.selected

	net.Start( "rprint_selectmode" )
		net.WriteEntity( self )
		net.WriteUInt( self.selected, 8 )
	net.SendToServer()
end
