include('shared.lua')

surface.CreateFont( "SalesName", {
	font = "Roboto Light", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 25,
	weight = 500,
	extended = true
} )

surface.CreateFont( "SalesName2", {
	font = "Roboto Light", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 35,
	weight = 500,
	extended = true
} )

surface.CreateFont( "TovarName", {
	font = "Roboto Light", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 60,
	weight = 500,
	extended = true
} )

surface.CreateFont( "SalesCloseFont", {
	font = "Roboto Light", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 25,
	weight = 500,
	extended = true
} )

function ENT:Draw()
    self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), (CurTime() * 50) % 360)
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) then
		cam.Start3D2D(Pos + Ang:Up() * 1, Ang, 0.11)
		cam.End3D2D()
	end
end


local function MenuProdavca()
	local menu = vgui.Create( "DPanel" )
	menu:SetPos( 0, 0 )
	menu:SetSize(ScrW(), ScrH())
	menu:MakePopup()
	-- для лерпов
	local anim1 = 0
	local anim2 = 0
	local anim3 = 0
	-- фон
	--[[	НАСТРОЙКИ НИЖЕ		]]--
	--[[	НАСТРОЙКИ НИЖЕ		]]--
	--[[	НАСТРОЙКИ НИЖЕ		]]--

	local firstModel = "models/weapons/w_physics.mdl" -- моделька первого товара
	local firstName = "Гравити-пущка" -- название первого товара
	local firstX = -175 -- корректировка по X оси назваания второго товара
	local firstPrice = 10 -- цена на первый товар
	local secondModel = "" -- моделька первого товара
	local secondName = "" -- название первого товара
	local secondX = -0 -- корректировка по X оси назваания второго товара
	local secondPrice = 0 -- цена на второй товар

	--end

	function menu:Paint( w, h )
		anim1 = Lerp( FrameTime() * 1.25, anim1, 25 )
		anim2 = Lerp(FrameTime() * 0.85, anim2, 200)
		anim3 = Lerp(FrameTime() * 0.85, anim2, 150)
		draw.RoundedBox( 0,  0, 0, w, h, Color( 0, 0, 0, anim2 ) )

		draw.RoundedBox( 0, ScrW() / 2 - 425, 125, 800, 0, Color( 0, 0, 0, anim3 ) )
		draw.SimpleText("Купить Взломщик Полей", "SalesName2", ScrW()/2 - 250, 320, Color(255,255,255,anim2))
		draw.RoundedBox( 0, ScrW() / 2 - 395, 185, 740, 0, Color( 0, 0, 0, anim3-50 ) )
		draw.RoundedBox( 0, ScrW() / 2 - 395, 383, 740, 0, Color( 200,200, 200, anim3-50 ) )

	end

	local buyFirstTovar = vgui.Create("DButton", menu) -- кнопка покупки для первого товара
	buyFirstTovar:SetPos(ScrW() / 2 + 100, 300)
	buyFirstTovar:SetSize(325, 85)
	buyFirstTovar:SetText("")
	function buyFirstTovar:DoClick()
		net.Start("BuyFirstTovar")
			net.WriteString(firstPrice)
		net.SendToServer()
	end
	function buyFirstTovar:Paint( w, h)

		if self:IsHovered() then
			draw.RoundedBox(0, 20, 20, 200, 40, Color(45,45,45, 200))
			draw.SimpleText("купить ($"..firstPrice..")", "SalesCloseFont", 50, 0 + 25, Color(230,230,230, 230))
		else
			draw.RoundedBox(0, 20, 20, 200, 40, Color(35,35,35, 200))
			draw.SimpleText("купить", "SalesCloseFont", 80, 0 + 25, Color(255,255,255, 255))
		end
	end


	local buySecTovar = vgui.Create("DButton", menu) -- кнопка покупки для первого товара
	buySecTovar:SetPos(ScrW() / 0 + 0, 0)
	buySecTovar:SetSize(0, 0)
	buySecTovar:SetText("")
	function buySecTovar:DoClick()
		--net.Start("BuySecondTovar")
			net.WriteString(secondPrice)
		net.SendToServer()
		
	end
	function buySecTovar:Paint( w, h)

		if self:IsHovered() then
			draw.RoundedBox(0, 20, 20, 200, 40, Color(45,45,45, 200))
			draw.SimpleText("купить ($"..secondPrice..")", "SalesCloseFont", 50, 0 + 25, Color(230,230,230, 230))
		else
			draw.RoundedBox(0, 20, 20, 200, 40, Color(35,35,35, 200))
			draw.SimpleText("купить", "SalesCloseFont", 80, 0 + 25, Color(255,255,255, 255))
		end
	end



	---------------------------------------




	local leavebutton1 = vgui.Create("DButton", menu) -- кнопка выхода
	leavebutton1:SetPos(ScrW() / 2 - 60, ScrH() / 2 + 250)
	leavebutton1:SetSize(325, 85)
	leavebutton1:SetText("")
	function leavebutton1:DoClick()
		menu:Remove()
	end
	function leavebutton1:Paint( w, h)

		anim2 = Lerp(FrameTime() * 0.85, anim2, 225)
		if self:IsHovered() then
			draw.SimpleText("Закрыть", "SalesCloseFont", 0, 0 + 25, Color(255,55,55, anim2))
		else
			draw.SimpleText("Закрыть", "SalesCloseFont", 0, 0 + 25, Color(255,255,255, anim2))
		end
	end

	timer.Simple(60, function()
		menu:Remove()
	end)
end
usermessage.Hook("OpenSellerMenu", MenuProdavca) -- :)