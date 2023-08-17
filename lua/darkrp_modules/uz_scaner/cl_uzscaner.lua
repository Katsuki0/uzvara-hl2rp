print ("CLientside uzvara scanner")
local PICTURE_WIDTH, PICTURE_HEIGHT = 480, 320
local PICTURE_WIDTH2, PICTURE_HEIGHT2 = PICTURE_WIDTH * 0.5, PICTURE_HEIGHT * 0.5

local view = {}
local zoom = 0
local deltaZoom = zoom
local nextClick = 0


hook.Add("CalcView", "nutScn_CalcView", function(client, origin, angles, fov)
	local entity = client:GetViewEntity()

	if (IsValid(entity) and entity:GetClass():find("scanner")) then
		view.angles = client:GetAimVector():Angle()
		view.fov = fov - deltaZoom

		if (math.abs(deltaZoom - zoom) > 5 and nextClick < RealTime()) then
			nextClick = RealTime() + 0.05
			client:EmitSound("common/talk.wav", 100, 180)
		end

		return view
	end
end)

hook.Add("InputMouseApply", "nutScn_InputMs", function(command, x, y, angle)
	zoom = math.Clamp(zoom + command:GetMouseWheel()*1.5, 0, 40)
	deltaZoom = Lerp(FrameTime() * 2, deltaZoom, zoom)
end)

local hidden = false

hook.Add("PreDrawOpaqueRenderables", "nutScn_PreDrawOpaq", function()
	local ply = LocalPlayer()
	local viewEntity = LocalPlayer():GetViewEntity()

	if (IsValid(ply.lastViewEntity) and ply.lastViewEntity != viewEntity) then
		ply.lastViewEntity:SetNoDraw(false)
		ply.lastViewEntity = nil
		hidden = false
	elseif (IsValid(viewEntity) and viewEntity:GetClass():find("scanner")) then
		viewEntity:SetNoDraw(true)
		ply.lastViewEntity = viewEntity
		hidden = true
	else
		hidden = false
	end
end)

hook.Add("ShouldDrawCrosshair", "nutScn_Crossh", function()
	if (hidden) then
		return false
	end
end)

hook.Add("AdjustMouseSensitivity", "nutScn_AdjustSens", function()
	if (hidden) then
		return 0.5
	end
end)


local data = {}

hook.Add("HUDPaint", "nutScn_HUD",function()
	local ply = LocalPlayer()
	if (hidden) then
		local scrW, scrH = surface.ScreenWidth() * 0.5, surface.ScreenHeight() * 0.5
		local x, y = scrW - PICTURE_WIDTH2, scrH - PICTURE_HEIGHT2

		if (ply.lastPic and ply.lastPic >= CurTime()) then
			local percent = math.Round(math.TimeFraction(ply.lastPic - PICTURE_DELAY, ply.lastPic, CurTime()), 2) * 100
			local glow = math.sin(RealTime() * 15)*25

			draw.SimpleText("RE-CHARGING: "..percent.."%", "Default", x, y - 24, Color(255 + glow, 100 + glow, 25, 250))
		end

        local cid = LocalPlayer():GetNWString("VIV_Ply_cID")
		local position = LocalPlayer():GetPos()
		local angle = LocalPlayer():GetAimVector():Angle()
		draw.SimpleText("POS ( "..math.floor(position[1])..", "..math.floor(position[2])..", "..math.floor(position[3]).." )", "Default", x + 8, y + 8, color_white)
		draw.SimpleText("ANG ( "..math.floor(angle[1])..", "..math.floor(angle[2])..", "..math.floor(angle[3]).." )", "Default", x + 8, y + 40, color_white)
		draw.SimpleText("ID  ( ".."SCN: "..cid.."  )", "Default", x + 8, y + 56, color_white)
		draw.SimpleText("ZM  ( "..(math.Round(zoom / 40, 2) * 100).."% )", "Default", x + 8, y + 70, color_white)

		if (IsValid(ply.lastViewEntity)) then
			data.start = ply.lastViewEntity:GetPos()
			data.endpos = data.start + LocalPlayer():GetAimVector() * 1000
			data.filter = ply.lastViewEntity

			local entity = util.TraceLine(data).Entity
			local entityname,entityid
			if (IsValid(entity) and entity:IsPlayer()) then
				entityname = entity:Name()
                entityid = entity:GetNWString("VIV_Ply_cID")
			else
				entityname = "NULL"
				entityid = "NULL"
			end

			draw.SimpleText("TRG ( "..entityname.." )", "Default", x + 8, y + 86, color_white)
			draw.SimpleText("CID ( "..entityid.." )", "Default", x + 8, y + 100, color_white)
		end

		surface.SetDrawColor(235, 235, 235, 230)

		surface.DrawLine(0, scrH, x - 128, scrH)
		surface.DrawLine(scrW + PICTURE_WIDTH2 + 128, scrH, ScrW(), scrH)
		surface.DrawLine(scrW, 0, scrW, y - 128)
		surface.DrawLine(scrW, scrH + PICTURE_HEIGHT2 + 128, scrW, ScrH())

		surface.DrawLine(x, y, x + 128, y)
		surface.DrawLine(x, y, x, y + 128)

		x = scrW + PICTURE_WIDTH2

		surface.DrawLine(x, y, x - 128, y)
		surface.DrawLine(x, y, x, y + 128)

		x = scrW - PICTURE_WIDTH2
		y = scrH + PICTURE_HEIGHT2

		surface.DrawLine(x, y, x + 128, y)
		surface.DrawLine(x, y, x, y - 128)

		x = scrW + PICTURE_WIDTH2

		surface.DrawLine(x, y, x - 128, y)
		surface.DrawLine(x, y, x, y - 128)

		surface.DrawLine(scrW - 48, scrH, scrW - 8, scrH)
		surface.DrawLine(scrW + 48, scrH, scrW + 8, scrH)
		surface.DrawLine(scrW, scrH - 48, scrW, scrH - 8)
		surface.DrawLine(scrW, scrH + 48, scrW, scrH + 8)
	end
end)



 local blackAndWhite = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 0.5,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects", "nutScn_ScreenSpaceEff", function()
	if (hidden) then
		blackAndWhite["$pp_colour_brightness"] = 0.05 + math.sin(RealTime() * 10)*0.01
		DrawColorModify(blackAndWhite)
	end
end) 




concommand.Add("test_vgui", function ()

surface.CreateFont("DermaLarge", {
	font = "Dotum", 
	size = 40, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false, 
})

	local dP = vgui.Create( "DFrame" )
	dP:SetSize(ScrW(), ScrH())
	dP:Center()
	-- dP:SetPos( 50,ScrH()/100 )
	-- dP:SetSize( 1000, 1000 )
	dP:SetTitle( " " )
	dP:SetVisible( true )
	dP:SetDraggable( false )
	dP:ShowCloseButton( false )
	dP.Paint = function()
		surface.SetDrawColor(255,255,255,0)
		dP:DrawFilledRect()
		surface.SetDrawColor(189, 195, 199,0)
		dP:DrawOutlinedRect()
	end
	dP:NoClipping(true)
	dP:MakePopup()

	
	local introlabel = vgui.Create( "DLabel" )
	introlabel:SetSize( 600,100 )
	introlabel:SetPos( ScrW()/2-270,ScrH()/2 )
	local Timestamp = os.time()
	local day = os.date( "%d" , Timestamp )
	local month = os.date( "%B" , Timestamp )
	introlabel:SetText( "Добро пожаловать на Uzvara HL2RP" )
	introlabel:SetFont( "DermaLarge" )
	introlabel.Alpha = 0
	introlabel:SetTextColor(Color(152,250,77,introlabel.Alpha))
	
	local intro = vgui.Create( "DFrame" )
	intro:SetSize( ScrW(),ScrH() )
	intro:SetPos( 0,0 )
	intro:SetTitle( " " )
	intro:SetVisible( true )
	intro:SetDraggable( false )
	intro:SetBackgroundBlur( true )
	intro:ShowCloseButton( false )
	intro.Alpha = 0
	intro.Paint = function()
		surface.SetDrawColor(0,0,0,intro.Alpha)
		intro:DrawFilledRect()
	end
	timer.Create("unintro",0.1,255,function() intro.Alpha=intro.Alpha-5 
		introlabel.Alpha=introlabel.Alpha-6 
		introlabel:SetTextColor(Color(255,255,255,introlabel.Alpha))
		if introlabel.Alpha<4 then introlabel:SetTextColor(Color(255,255,255,0)) end
	end)
	timer.Toggle("unintro")
	
	local spawn = vgui.Create( "DButton",dP )
	spawn:Dock(FILL)
	-- spawn:SetPos( 400,350 )
	-- spawn:SetSize( 500, 100 )
	spawn:SetText( "Нажмите чтобы продолжить" )
	spawn:SetFont("DermaLarge")
	spawn:SetVisible( true )
	spawn.Fill = false
	spawn:SetTextColor( Color(255,255,255) )
	spawn.OnCursorEntered = function () spawn.Fill = true spawn:SetTextColor( Color(255,255,255) ) surface.PlaySound("UI/buttonrollover.wav") end 
	spawn.OnCursorExited = function () spawn.Fill = false spawn:SetTextColor( Color(255,255,255) ) end 
	spawn.Paint = function()
		if !spawn.Fill then 
			surface.SetDrawColor(255,255,255,0)
		else
			surface.SetDrawColor(163, 80, 0,0)
		end
		spawn:DrawFilledRect()
		surface.SetDrawColor(149, 165, 166,0)
		spawn:DrawOutlinedRect()
	end
	spawn.DoClick = function()
		surface.PlaySound("UI/buttonclick.wav")
		intro:SetKeyboardInputEnabled(false)
		intro:SetMouseInputEnabled(true)
		intro:SetVisible(true)
		intro.Alpha = 255
		introlabel.Alpha = 255
		stopval = true
		timer.Toggle("unintro")
		dP:Close()
	end
	spawn:NoClipping(true)


end)