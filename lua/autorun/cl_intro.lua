net.Receive( "SpawnFOV", function( len )	 
	plyPos = net.ReadVector()
	plyAng = net.ReadAngle()
end ) 

stopval = false

function CalcViewSpawn(ply, pos, angles, fov)
	if stopval==true then return end
	local view = {}
	if ply:GetNWBool("Fresh") then
		view.origin = Vector(-170.075027, -2339.624756, 389.139984)
		view.angles = Angle(30.044487, 88.488121, 0)
		view.fov = fov
		return view
	end 
end
hook.Add( "CalcView", "CalcViewSpawn", CalcViewSpawn )


function SpawnMenu()
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
	
	--local dc = vgui.Create( "DButton",dP )
	--dc:SetPos( 0,150 )
	--dc:SetSize( 400, 75 )
	--dc:SetText( "Выход" )
	--dc:SetVisible( true )
	--dc:SetFont("LargeText")
	--dc.Fill = false
--	dc:SetTextColor( Color(0,0,0) )
--	dc.OnCursorEntered = function () dc.Fill = true dc:SetTextColor( Color(255,255,255) ) surface.PlaySound("UI/buttonrollover.wav") end 
--	dc.OnCursorExited = function () dc.Fill = false dc:SetTextColor( Color(0,0,0) ) end 
	--dc.Paint = function()
	--	if !dc.Fill then 
	--		surface.SetDrawColor(255,255,255,220)
	--	else
	--		surface.SetDrawColor(163, 80, 0,220)
	--	end
	--	dc:DrawFilledRect()
	--	surface.SetDrawColor(149, 165, 166,0)
	--	dc:DrawOutlinedRect()
	--end
	--dc:NoClipping(true)
	--dc.DoClick = function() RunConsoleCommand("disconnect") end
end
usermessage.Hook( "SpawnMenu", SpawnMenu )

hook.Add("HUDShouldDraw", "HideHUD", function( n )
	if stopval == false then 
		return false
	else
		return end
end)
