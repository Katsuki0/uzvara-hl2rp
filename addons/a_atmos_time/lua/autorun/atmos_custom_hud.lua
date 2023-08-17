/*============================================================================================================*\
¦¦  _ _ _ _   _   _   _ _ _   _ _ _   _ _     _ _ _   _ _ _   __    __    _ _    __    _   _   _ _ _   _ _ _  ¦¦
¦¦ ¦__   __¦ ¦ ¦ ¦ ¦ ¦  _ _¦ ¦  _ _¦ ¦  _ \  ¦  _ _¦ ¦  _ _¦ ¦  \  /  ¦  / _ \  ¦  \  ¦ ¦ ¦ ¦ ¦  _  ¦ ¦_ _  ¦ ¦¦ 
¦¦    ¦ ¦    ¦ ¦_¦ ¦ ¦ ¦_ _  ¦ ¦_    ¦ ¦_¦ ¦ ¦ ¦_ _  ¦ ¦_ _  ¦   \/   ¦ ¦ ¦_¦ ¦ ¦   \ ¦ ¦ ¦ ¦ ¦ ¦_¦ ¦  _ _¦ ¦ ¦¦
¦¦    ¦ ¦    ¦  _  ¦ ¦  _ _¦ ¦  _¦   ¦    /  ¦  _ _¦ ¦  _ _¦ ¦ ¦\__/¦ ¦ ¦  _  ¦ ¦ ¦\ \¦ ¦ ¦ ¦ ¦_ _  ¦ ¦_ _  ¦ ¦¦
¦¦    ¦ ¦    ¦ ¦ ¦ ¦ ¦ ¦_ _  ¦ ¦     ¦ ¦\ \  ¦ ¦_ _  ¦ ¦_ _  ¦ ¦    ¦ ¦ ¦ ¦ ¦ ¦ ¦ ¦ \   ¦ ¦ ¦     ¦ ¦  _ _¦ ¦ ¦¦
¦¦    ¦_¦    ¦_¦ ¦_¦ ¦_ _ _¦ ¦_¦     ¦_¦ \_\ ¦_ _ _¦ ¦_ _ _¦ ¦_¦    ¦_¦ ¦_¦ ¦_¦ ¦_¦  \__¦ ¦_¦     ¦_¦ ¦_ _ _¦ ¦¦
¦¦                                                                                                            ¦¦
\*======= Coded By ============ CC BY-NC-SA 4.0  http://creativecommons.org/licenses/by-nc-sa/4.0/ ===========*/

local function pmsg(...)
	MsgC(Color(0,192,192),"[Atmos HUD] ",color_white,...) MsgN""
end

if CLIENT then

	surface.CreateFont( "Derma28",
	{
		font		= "Roboto",
		size		= 28,
		antialias	= true,
		weight		= 500
	})

	local lastwide,lasttall = -1,-1
	local function calcpos(wide,tall)
		return (ATMOSHUD.POS_X>-1&&ATMOSHUD.POS_X||ScrW()/15)-(ATMOSHUD.POS_AR&&wide||0), 
		(ATMOSHUD.POS_Y>-1&&ATMOSHUD.POS_Y||ScrH()*.905)-(ATMOSHUD.POS_AB&&tall||30)
	end
	local function regsv(val)
		net.Start"ATMOS_HUD_TOGGLE"
			net.WriteBit(val)
		net.SendToServer()
	end
	
	//Clean up old cvars/ccmds in case we're hotswapping
	cvars.RemoveChangeCallback("atmos_cl_displaytime","ATMOSHUD_enable2")
	concommand.Remove"atmos_cl_rebuildtimedisplay"
	
	if ATMOSHUD && ispanel(ATMOSHUD.AP) && IsValid(ATMOSHUD.AP) then ATMOSHUD.AP:SetVisible(false) ATMOSHUD.AP:Remove() end
	
	ATMOSHUD = {
		CV_EnableHUD = CreateClientConVar("atmoshud_enabled", 1, true),
		TF12 = CreateClientConVar("atmoshud_12hr", 0, true):GetBool(), //Much faster to access table property than call GetBool() on a CVar.
		TF12AM = CreateClientConVar("atmoshud_12hr_am", "am", true):GetString(), 
		TF12PM = CreateClientConVar("atmoshud_12hr_pm", "pm", true):GetString(), 
		POS_AR = CreateClientConVar("atmoshud_anchorright", 1, true):GetBool(),
		POS_AB = CreateClientConVar("atmoshud_anchorbottom", 0, true):GetBool(),
		POS_X = CreateClientConVar("atmoshud_posx", -1, true):GetInt(),
		POS_Y = CreateClientConVar("atmoshud_posy", -1, true):GetInt(),
		LastTime = "00:00",
		UpdateEnabled = function(cvar, oldval, newval)
			local turnon = false
			newval = tonumber(newval)
			if !cvar then //Change in atmos_enabled from server
				if newval > 0 then
					turnon =  ATMOSHUD.CV_EnableHUD:GetBool()
				end
			elseif cvar == "atmoshud_enabled" then //Change in atmoshud_enabled from client
				turnon =  (newval > 0) && (GetConVarNumber"atmos_enabled" > 0)
				regsv(tobool(newval))
			end
			if ispanel(ATMOSHUD.AP) && IsValid(ATMOSHUD.AP) then ATMOSHUD.AP:SetVisible(turnon) else ATMOSHUD:BuildPanel() end
		end,
		UpdateTimeFormat = function(_, _, newval, wide, tall)
			newval = tobool(newval)
			if IsValid(ATMOSHUD.AP) && ispanel(ATMOSHUD.AP) then 
				ATMOSHUD.AP:SetFont("Derma"..(newval && "28" || "Large"))
				ATMOSHUD.AP:SizeToContents()
				if !(tall&&wide) then wide,tall = ATMOSHUD.AP:GetSize() end
				ATMOSHUD.AP:SetPos(calcpos(wide,tall))
			end
			ATMOSHUD.TF12 = newval
		end
	}
	
	function ATMOSHUD:BuildPanel(user)
		if ispanel(self.AP) && IsValid(self.AP) then self.AP:SetVisible(false) self.AP:Remove() end
		self.AP = vgui.Create("DLabel", _, "atmosHUDpanel")
		self.AP:SetZPos(1930)	
		self.AP:SetAllowNonAsciiCharacters(true)
		self.AP:SetAutoStretchVertical(true)
		self.AP:SetTextColor(Color(255, 255, 255, 0))
		self.AP:SetVisible(self.CV_EnableHUD:GetBool())
		self.AP:SetText(self.LastTime)
		lastwide,lasttall = -1,-1
		self.UpdateTimeFormat(_,_,self.TF12)
		if user then pmsg"Rebuilt HUD." end
	end
		
	net.Receive("ATMOStimetransfer", function(/*len,ply*/)
		if !IsValid(ATMOSHUD.AP) then return end
		local atime = net.ReadFloat()
		local hrs = math.floor(atime)
		local min = (atime-hrs) * 60
		local suffix
		if ATMOSHUD.TF12 then
			suffix = (hrs>11&&ATMOSHUD.TF12PM||ATMOSHUD.TF12AM)
			if hrs > 12 then hrs = hrs-12 end
		end
		ATMOSHUD.LastTime = string.format("%02i:%02i"..(ATMOSHUD.TF12&&suffix||""), hrs, min)
		ATMOSHUD.AP:SetText(ATMOSHUD.LastTime)
		ATMOSHUD.AP:SizeToContents()
		local wide,tall = ATMOSHUD.AP:GetSize()
		if wide != lastwide || tall != lasttall then ATMOSHUD.UpdateTimeFormat(_,_,ATMOSHUD.TF12,wide,tall) lastwide,lasttall = wide,tall end
	end)
	net.Receive("ATMOS_TOGGLE", function() ATMOSHUD.UpdateEnabled(_,_,net.ReadBit()) end)
	
	local function ampmcallback(cvar,_,newval)
		if cvar == "atmoshud_12hr_am" then ATMOSHUD.TF12AM = tostring(newval)
		elseif cvar == "atmoshud_12hr_pm" then ATMOSHUD.TF12PM = tostring(newval) 
		elseif cvar == "atmoshud_anchorright" then ATMOSHUD.POS_AR = tobool(newval) 
		elseif cvar == "atmoshud_anchorbottom" then ATMOSHUD.POS_AB = tobool(newval) 
		elseif cvar == "atmoshud_posx" then ATMOSHUD.POS_X = tonumber(newval) 
		elseif cvar == "atmoshud_posy" then ATMOSHUD.POS_Y = tonumber(newval) 
		end
		ATMOSHUD.UpdateTimeFormat(_,_,ATMOSHUD.TF12)
	end
	
	cvars.AddChangeCallback("atmoshud_enabled", ATMOSHUD.UpdateEnabled, "ATMOSHUD_enable2")
	cvars.AddChangeCallback("atmoshud_12hr", ATMOSHUD.UpdateTimeFormat, "ATMOSHUD_timeformat")
	cvars.AddChangeCallback("atmoshud_12hr_am", ampmcallback, "ATMOSHUD_12hr_am")
	cvars.AddChangeCallback("atmoshud_12hr_pm", ampmcallback, "ATMOSHUD_12hr_pm")
	cvars.AddChangeCallback("atmoshud_anchorright", ampmcallback, "ATMOSHUD_pos_ar")
	cvars.AddChangeCallback("atmoshud_anchorbottom", ampmcallback, "ATMOSHUD_pos_ab")
	cvars.AddChangeCallback("atmoshud_posx", ampmcallback, "ATMOSHUD_pos_x")
	cvars.AddChangeCallback("atmoshud_posy", ampmcallback, "ATMOSHUD_pos_y")
	
	hook.Add("InitPostEntity", "buildatmosvguipanel_cl", function()
		ATMOSHUD.UpdateEnabled("atmoshud_enabled",_,ATMOSHUD.CV_EnableHUD:GetInt())
	end)
	
	concommand.Add("atmoshud_rebuild", function(_,_,args) 
		ATMOSHUD:BuildPanel(true) if args[1]&&args[1]=="startup" then regsv(ATMOSHUD.CV_EnableHUD:GetInt()) end 
	end)
	concommand.Add("atmoshud_resetpos", function()
		local d = "\t"
		local x,y,r,b = ATMOSHUD.POS_X, ATMOSHUD.POS_Y, ATMOSHUD.POS_AR, ATMOSHUD.POS_AB
		ATMOSHUD.POS_AR, ATMOSHUD.POS_AB, ATMOSHUD.POS_X, ATMOSHUD.POS_Y = true, false, -1, -1
		RunConsoleCommand("atmoshud_posx","-1")
		RunConsoleCommand("atmoshud_posy","-1")
		RunConsoleCommand("atmoshud_anchorbottom","0")
		RunConsoleCommand("atmoshud_anchorright","1")
		pmsg("Atmos HUD position reset. The settings were:\n",Color(255,230,0)," X\t Y\tAnchor right\tAnchor bottom\n",Color(200,180,255),x,d,y,d,r,d,d,b)
	end)

elseif SERVER then

	AddCSLuaFile()
	resource.AddWorkshop( "337442751" )
	util.AddNetworkString"ATMOStimetransfer"
	util.AddNetworkString"ATMOS_HUD_TOGGLE"
	util.AddNetworkString"ATMOS_TOGGLE"
	
	local function BuildTimer()
		timer.Create("atmos_dnc_hudUpd", math.Min(math.Max(tonumber(GetConVarNumber"atmos_dnc_length")/1500,0.1),10), 0, ATMOSHUD.TimeTransfer)
	end
	
	local function BroadcastState(state)
		net.Start("ATMOS_TOGGLE", true)
			net.WriteBit(tobool(state))
		net.Broadcast()
	end
	
	ATMOSHUD = {
		TimeTransfer = function()
			if !AtmosGlobal then return end
			net.Start("ATMOStimetransfer")
				net.WriteFloat(AtmosGlobal:GetTime()||0)
			net.Broadcast()
		end,
		Players = {}
	}
	
	net.Receive("ATMOS_HUD_TOGGLE", function(_, ply/*len,ply*/)
		ATMOSHUD.Players[ply:EntIndex()] = tobool(net.ReadBit())
		if table.HasValue(ATMOSHUD.Players, true) && (GetConVarNumber"atmos_enabled" > 0) then 
			if !timer.Exists"atmos_dnc_hudUpd" then BuildTimer() end
		else timer.Destroy"atmos_dnc_hudUpd" end
	end)
	
	//Kicks everything off
	local function ATMOSHUD_START()
		ATMOSHUD_IMMEDIATE = true //For hotswap
		if !AtmosGlobal then ErrorNoHalt"Atmos not found! Stopping. The script can be reloaded once Atmos is running." return end
		cvars.AddChangeCallback("atmos_enabled", function(_,_,newval) 
			if tobool(newval) && table.HasValue(ATMOSHUD.Players, true) then
				if !timer.Exists"atmos_dnc_hudUpd" then BuildTimer() end
			else timer.Destroy"atmos_dnc_hudUpd" end
			BroadcastState(newval)
		end, "ATMOSHUD_enable1")
		
		cvars.AddChangeCallback("atmos_dnc_length", function(_,_,newval)
			if timer.Exists"atmos_dnc_hudUpd" then 
			timer.Adjust("atmos_dnc_hudUpd", math.Min(math.Max(tonumber(newval)/1500,0.1),15), 0, ATMOSHUD.TimeTransfer) end
		end, "ATMOS_DNCLEN_WATCH")
		BuildTimer()
	end
	
	if ATMOSHUD_IMMEDIATE then //If server's already running
		pmsg"Restarting."
		ATMOSHUD_START()
		for _,ply in pairs(player.GetHumans()) do ply:ConCommand"atmoshud_rebuild startup" end
	else hook.Add("InitPostEntity", "buildatmosvguipanel", ATMOSHUD_START) pmsg"Starting."
	end
	
end