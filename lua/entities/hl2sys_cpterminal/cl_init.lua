--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
include("shared.lua")

local font1 = "Roboto Condensed"
surface.CreateFont( "LolKekFont", {
	font = font1, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 28,
	weight = 500,
	extended = true
} )

surface.CreateFont( "LolKekFont2", {
	font = font1, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 40,
	weight = 500,
	extended = true
} )

surface.CreateFont( "LolKekButtonFont", {
	font = font1, -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 30,
	weight = 500,
	extended = true
} )


function ENT:Initialize()
end

local function myMenu()
	local menu = vgui.Create("MPanel")
	menu:SetSize(500,100)
	menu:Center()
	menu:SetVisible(true)
	menu:MakePopup()
	
	local menu_close = vgui.Create("MButton", menu)
	menu_close:SetPos(475,0)
	menu_close:SetText("X")
	menu_close:OnClick(function() 
		menu:Remove()
	end)
	
	
	local registrButton = vgui.Create("MButton", menu)
	registrButton:SetPos(115,75)
	registrButton:SetFont("LolKekFont2")
	registrButton:SetText("Нажмите для взаимодействия")
	registrButton:Center()
	registrButton:OnClick(function() 
		registrButton:Remove()
		local text = vgui.Create("MLabel",menu)
		text:SetFont("LolKekFont2")
		text:SetText("21%")
		text:Center()
		
		timer.Simple(1, function ()
			if IsValid(menu) then
				surface.PlaySound("garrysmod/ui_click.wav")
				text:SetPos(15,30)	
				text:SetFont("LolKekFont2")
				text:SetText("43%")
				text:Center()
			end
		end)
		
		timer.Simple(2, function ()
			if IsValid(menu) then
				surface.PlaySound("garrysmod/ui_click.wav")
				text:SetPos(15,30)	
				text:SetFont("LolKekFont2")
				text:SetText("57%")
				text:Center()
			end
		end)
		
		timer.Simple(3, function ()
			if IsValid(menu) then
				surface.PlaySound("garrysmod/ui_click.wav")
				text:SetPos(15,30)	
				text:SetFont("LolKekFont2")
				text:SetText("72%")
				text:Center()
			end
		end)
		
		timer.Simple(4, function ()
			if IsValid(menu) then
				surface.PlaySound("garrysmod/ui_click.wav")
				text:SetPos(15,30)	
				text:SetFont("LolKekFont2")
				text:SetText("84%")
				text:Center()
			end
		end)
		
		timer.Simple(5, function ()
			if IsValid(menu) then
				surface.PlaySound("garrysmod/ui_click.wav")
				text:SetPos(15,30)
				text:SetFont("LolKekFont2")
				text:SetText("100%")
				text:Center()
			end
		end)
		
		timer.Simple(5, function()
			menu:SetSize(500,200)
			menu:Center()
			LocalPlayer():EmitSound("friends/friend_online.wav")
			text:Remove()
			local Panel = vgui.Create( "MPanel", menu )
			Panel:SetPos( 0, 0 )
			Panel:SetSize( 150, 200 )

			local icon = vgui.Create( "DModelPanel", Panel )
			icon:SetSize( 150, 200 )

				local pl = LocalPlayer()




			icon:SetCamPos( Vector( 20, 0, 65 ) )
			icon:SetLookAt( Vector( 0, 0, 60 ) )
			--icon:GetEntity():SetBodygroup(1, 13)
			icon.LayoutEntity = function( ent ) return end
			
			local text1 = vgui.Create("MLabel",menu)
			text1:SetText("Имя: "..LocalPlayer():Nick())
			text1:SetFont("LolKekFont")
			text1:SetPos(165,5)
			
			local text2 = vgui.Create("MLabel",menu)
			text2:SetText("Ранг: "..LocalPlayer():getDarkRPVar("job"))
			text2:SetFont("LolKekFont")
			text2:SetPos(165,35)
			
			local text3 = vgui.Create("MLabel",menu)
			text3:SetText("Кувейты: "..DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")))
			text3:SetFont("LolKekFont")
			text3:SetPos(165,65)
			
			
			local text4 = vgui.Create("MLabel",menu)
			text4:SetText("Зарплата: "..DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary")))
			text4:SetFont("LolKekFont")
			text4:SetPos(165,95)
			
			
			local ammoButton = vgui.Create("MButton",menu)
			ammoButton:SetPos(245,135)
			ammoButton:SetText("")
			ammoButton:SetFont("LolKekButtonFont")
			ammoButton:SetVisible(true)
			ammoButton:OnClick(function()
				net.Start("giveWeapons")
				net.SendToServer()
			end)
			
			local ammoButton = vgui.Create("MButton",menu)
			ammoButton:SetPos(245,135)
			ammoButton:SetText("Пополнить патроны")
			ammoButton:SetFont("LolKekButtonFont")
			ammoButton:SetVisible(true)
			ammoButton:OnClick(function()
				LocalPlayer():EmitSound("items/ammo_pickup.wav")
				net.Start("giveAmmo")
				net.SendToServer()
			end)
			
			local menu_close = vgui.Create("MButton", menu)
			menu_close:SetPos(475,0)
			menu_close:SetText("X")
			menu_close:OnClick(function()
				menu:Remove()
			end)

		
		end)
	end)


end
usermessage.Hook("CPTerminalOpen",myMenu)

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
	cam.Start3D2D(Pos + Ang:Up() * -5, Ang, 0.11)
		
	cam.End3D2D()
	end
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
				draw.SimpleTextOutlined( "Терминал", "DermaLarge", -50, -500, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "", "DermaLarge", 0, 80, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "", "DermaLarge", 0, 110, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			end
			cam.End3D2D()
		end
	end
end