------------------------------------------------------------------------*/

local function MessageWrap(text, w)
	local i = 0
	text = text:gsub( ".", function(c)
		i = i + surface.GetTextSize(c)
		if i >= w then
			i = 0
			return "\n" .. c
		end
		return c
	end )

	return text, i
end

function Amethyst:FormatMessage(text, w, f)
	local i = 0

	surface.SetFont(f)
	local size = surface.GetTextSize(" ")
	text = text:gsub("(%s?[%S]+)", function(s)
		local c = string.sub( s, 1, 1 )
		if (c == "\n" or c == "\t") then i = 0 end

		local len = surface.GetTextSize(s)
		i = i + len

		if len >= w then
			local spliceS, spliceP = MessageWrap(s, w)
			i = spliceP
			return spliceS
		elseif i < w then
			return s
		end

		if c == " " then
			i = len - size
			return "\n" .. string.sub(s, 2)
		end

		i = len
		return "\n" .. s
	end)

	return text
end

--[[ -----------------------------------------------------------------------------------------------

                    FUNCTION -> PUSH NOTIFICATION

@desc:              Sends a notification to the entire server for all players to see.
@conditions:        Will only send a notification if Amethyst.Settings.Notifications.CooldownTimer
					has expired. This can be modified within sh_main.lua
@params             ent( player ), UInt( ntype ), UInt( plyonly ), str( title ), str( message ), UInt( delay )
@assoc              Client

--------------------------------------------------------------------------------------------------]]

function Amethyst:PushNotification( player, ntype, plyonly, title, message, delay)

	Message = Amethyst:FormatMessage(message, 350, "Amethyst.Font.Notification_Title")
	local TextW, TextH = surface.GetTextSize(Message)

	if not ( timer.Exists( "amethyst.notification.timer" ) ) then

		local countdownTimer = delay or 10

		Amethyst.InitNotification = vgui.Create("DPanel")
		Amethyst.InitNotification:SetSize(300, 25 + TextH + 55)
		Amethyst.InitNotification:SetPos(ScrW(), 200)
		Amethyst.InitNotification.Paint = function(self, w, h)
	        draw.Amethyst_DrawBlur(self)
			draw.AmethystBox( 0, 0, w, h, Color(GetConVar("amethyst_n_primary_color_red"):GetInt(), GetConVar("amethyst_n_primary_color_green"):GetInt(), GetConVar("amethyst_n_primary_color_blue"):GetInt(), GetConVar("amethyst_n_primary_color_alpha"):GetInt()) or Color(0, 55, 79, 245) )
			draw.AmethystOutlinedBoxThick( 0, 0, w, h, GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2, Color(GetConVar("amethyst_n_outline_color_red"):GetInt(), GetConVar("amethyst_n_outline_color_green"):GetInt(), GetConVar("amethyst_n_outline_color_blue"):GetInt(), GetConVar("amethyst_n_outline_color_alpha"):GetInt()) )
	        local GetValueData = GetConVar("amethyst_m_grid_background_enabled")
	        if GetValueData:GetInt() == 1 then
	            surface.SetDrawColor( Color( 5, 5, 5, 30 ) )
	            surface.SetMaterial( Material( "amethyst/amethyst_gui_pattern.png", "noclamp smooth" ) )
	            surface.DrawTexturedRectRotated( 100, 0, 1275, 333, 0 )
	        end
		end

	    self.DPanel_M_Inner = vgui.Create("DPanel", Amethyst.InitNotification)
	    self.DPanel_M_Inner:Dock(TOP)
	    self.DPanel_M_Inner:SetTall(30)
	    self.DPanel_M_Inner:DockMargin(0, 0, 0, 0)
	    self.DPanel_M_Inner.Paint = function(self, w, h)
			draw.AmethystBox( 0, 0, w, h, Color(10, 10, 10, 100) )
		end

	    self.DPanel_B_Inner = vgui.Create("DPanel", Amethyst.InitNotification)
	    self.DPanel_B_Inner:Dock(BOTTOM)
	    self.DPanel_B_Inner:SetTall(20)
	    self.DPanel_B_Inner:DockMargin(0, 0, 0, 0)
	    self.DPanel_B_Inner.Paint = function(self, w, h)
			draw.AmethystBox( 0, 0, w, h, Color(10, 10, 10, 100) )
		end

		self.DLabel_Title = vgui.Create("DLabel", self.DPanel_M_Inner)
		self.DLabel_Title:SetText(string.upper(title or Amethyst.Language["notification"]) .. " (" .. delay .. ")")
		self.DLabel_Title:SetTextColor( Color(GetConVar("amethyst_n_text_color_red"):GetInt(), GetConVar("amethyst_n_text_color_green"):GetInt(), GetConVar("amethyst_n_text_color_blue"):GetInt(), GetConVar("amethyst_n_text_color_alpha"):GetInt()) )
		self.DLabel_Title:SetFont("Amethyst.Font.Notification_Title")
		self.DLabel_Title:SetContentAlignment( 5 )
		self.DLabel_Title:DockMargin(0, 5, 0, 0)
		self.DLabel_Title:Dock(TOP)

		self.DLabel_PName = vgui.Create("DLabel", self.DPanel_B_Inner)
		self.DLabel_PName:SetText(player:Name() or "sent by Server")
		self.DLabel_PName:SetTextColor( Color(GetConVar("amethyst_n_text_color_red"):GetInt(), GetConVar("amethyst_n_text_color_green"):GetInt(), GetConVar("amethyst_n_text_color_blue"):GetInt(), GetConVar("amethyst_n_text_color_alpha"):GetInt()) )
		self.DLabel_PName:SetFont("Amethyst.Font.Notification_PName")
		self.DLabel_PName:SetContentAlignment( 5 )
		self.DLabel_PName:DockMargin(5, 0, 0, 0)
		self.DLabel_PName:Dock(TOP)

		self.DLabel_Message_Text = vgui.Create("DLabel", Amethyst.InitNotification)
		self.DLabel_Message_Text:SetText("")
		self.DLabel_Message_Text.Paint = function(self)
			draw.DrawText(Message or "", "Amethyst.Font.Notification_Msg", self:GetWide() / 2, 10, Color(GetConVar("amethyst_n_text_color_red"):GetInt(), GetConVar("amethyst_n_text_color_green"):GetInt(), GetConVar("amethyst_n_text_color_blue"):GetInt(), GetConVar("amethyst_n_text_color_alpha"):GetInt()) , TEXT_ALIGN_CENTER)
		end
		self.DLabel_Message_Text:SetContentAlignment( 5 )
		self.DLabel_Message_Text:DockMargin(0, 0, 0, 0)
		self.DLabel_Message_Text:Dock(FILL)

		Amethyst.InitNotification:MoveTo(ScrW() - Amethyst.InitNotification:GetWide(), 200, 1.01, 0.1, -1)

		timer.Create( "amethyst.notification.countdown", 1, delay or 5, function()
			countdownTimer = countdownTimer - 1
			if IsValid(self.DLabel_Title) then
	    		self.DLabel_Title:SetText(string.upper(title or Amethyst.Language["notification"]) .. " (" .. countdownTimer .. ")")
	    	end
		end)

		timer.Create( "amethyst.notification.timer", delay or 5, 1, function()
			if !IsValid(Amethyst.InitNotification) then return end
			Amethyst.InitNotification:MoveTo(ScrW() + Amethyst.InitNotification:GetWide(), 200, 1, 0.1, -1, function(anim, pnl)
				Amethyst.InitNotification:Remove()
				timer.Destroy("amethyst.notification.timer")
			end)
		end )

	end

end

--[[ -----------------------------------------------------------------------------------------------

                    FUNCTION -> NOTIFICATION UI

@desc:              UI that allows admins to submit entries to post a notification.
@conditions:        Only accessible if player has proper access (admin/superadmin)
@assoc              Client
@usage 				[Console] -> amethyst_notification

--------------------------------------------------------------------------------------------------]]

function Amethyst:Notification()

	local message, adminonly = "Notification sent!", "1" and true or false
	local ply = LocalPlayer()
	local labelWidth = 90

	Intro = Amethyst:CropMessage(message, 500, "Amethyst.Font.Notification_Msg")
	local TextW, TextH = surface.GetTextSize(Intro)

    self.DFrame_N_Container = vgui.Create( "DFrame" )
    self.DFrame_N_Container:SetTitle( "" )
    self.DFrame_N_Container:SetSize( ScreenScale(250), 300 )
    self.DFrame_N_Container:SetDraggable( true )
    self.DFrame_N_Container:ShowCloseButton( false )
    self.DFrame_N_Container:Center()
    self.DFrame_N_Container:MakePopup()
    self.DFrame_N_Container.Paint = function( self, w, h )
        draw.Amethyst_DrawBlur(self)
		draw.AmethystBox( 0, 0, w, h, Color(GetConVar("amethyst_n_primary_color_red"):GetInt(), GetConVar("amethyst_n_primary_color_green"):GetInt(), GetConVar("amethyst_n_primary_color_blue"):GetInt(), GetConVar("amethyst_n_primary_color_alpha"):GetInt()) or Color(0, 55, 79, 245) )
		draw.AmethystOutlinedBoxThick( 0, 0, w, h, GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2, Color(GetConVar("amethyst_n_outline_color_red"):GetInt(), GetConVar("amethyst_n_outline_color_green"):GetInt(), GetConVar("amethyst_n_outline_color_blue"):GetInt(), GetConVar("amethyst_n_outline_color_alpha"):GetInt()) )
    end
    self.DFrame_N_Container.Think = function()
		self.DFrame_N_Container:MoveToFront()
	end

    self.DLabel_Title_Text = vgui.Create("DLabel", self.DFrame_N_Container)
    self.DLabel_Title_Text:Dock(TOP)
    self.DLabel_Title_Text:DockMargin(15, 0, 5, 5)
    self.DLabel_Title_Text:SetFont("Amethyst.Font.CommandBlock_Name")
    self.DLabel_Title_Text:SetTextColor(Color(GetConVar("amethyst_n_text_color_red"):GetInt(), GetConVar("amethyst_n_text_color_green"):GetInt(), GetConVar("amethyst_n_text_color_blue"):GetInt(), GetConVar("amethyst_n_text_color_alpha"):GetInt()))
    self.DLabel_Title_Text:SetText(string.upper(Amethyst.Language["send_notification"] or "Notification"))

    self.DPanel_M_Inner = vgui.Create("DPanel", self.DFrame_N_Container)
    self.DPanel_M_Inner:Dock(FILL)
    self.DPanel_M_Inner:DockMargin(15, 0, 15, 15)
    self.DPanel_M_Inner.Paint = function(self, w, h) end

	self.DPanel_Title_Container = vgui.Create("DPanel", self.DPanel_M_Inner)
	self.DPanel_Title_Container:Dock(TOP)
	self.DPanel_Title_Container:SetTall(35)
	self.DPanel_Title_Container:DockMargin(0,15,0,0)
	self.DPanel_Title_Container.Paint = function(self, w, h) end

    self.DLabel_Title_Text = vgui.Create("DLabel", self.DPanel_Title_Container)
    self.DLabel_Title_Text:Dock(LEFT)
    self.DLabel_Title_Text:DockMargin(0, 0, 5, 5)
    self.DLabel_Title_Text:SetFont("Amethyst.Font.Notification_CText")
    self.DLabel_Title_Text:SetTextColor(Color(GetConVar("amethyst_n_text_color_red"):GetInt(), GetConVar("amethyst_n_text_color_green"):GetInt(), GetConVar("amethyst_n_text_color_blue"):GetInt(), GetConVar("amethyst_n_text_color_alpha"):GetInt()))
    self.DLabel_Title_Text:SetText(string.upper(Amethyst.Language["title"] or "Title"))
	self.DLabel_Title_Text:SetWide(labelWidth or 90)

    self.DTextEntry_Title = vgui.Create("DTextEntry", self.DPanel_Title_Container)
    self.DTextEntry_Title:Dock(FILL)
    self.DTextEntry_Title:DockMargin(0, 0, 0, 10)
    self.DTextEntry_Title:SetMultiline( false )
	self.DTextEntry_Title:SetEnabled( true )
	self.DTextEntry_Title:SetFont( "Amethyst.Font.Notification_CText" )
	self.DTextEntry_Title:SetText( Amethyst.Language["notification"] or "Notification")
	self.DTextEntry_Title:SetEditable( true )
	self.DTextEntry_Title.MaxChars = 15
	self.DTextEntry_Title.Paint = function(self)
        draw.AmethystOutlinedBox( 0, 0, self:GetWide(), self:GetTall(), Color(GetConVar("amethyst_m_textbox_icolor_red"):GetInt(), GetConVar("amethyst_m_textbox_icolor_green"):GetInt(), GetConVar("amethyst_m_textbox_icolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_icolor_alpha"):GetInt() ), Color(GetConVar("amethyst_m_textbox_ocolor_red"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_green"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_alpha"):GetInt() ))
		self:DrawTextEntryText(Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()), Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()), Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()))
	end
	self.DTextEntry_Title.OnTextChanged = function(self)
		local txt = self:GetValue()
		local amt = string.len(txt)
		if amt > self.MaxChars then
			self:SetText(self.OldText)
			self:SetValue(self.OldText)
		else
			self.OldText = txt
		end
	end

	self.DPanel_Message_Container = vgui.Create("DPanel", self.DPanel_M_Inner)
	self.DPanel_Message_Container:Dock(TOP)
	self.DPanel_Message_Container:SetTall(80)
	self.DPanel_Message_Container:DockMargin(0, 5, 0, 0)
	self.DPanel_Message_Container.Paint = function(self, w, h) end

    self.DLabel_Instructions_Text = vgui.Create("DLabel", self.DPanel_Message_Container)
    self.DLabel_Instructions_Text:Dock(LEFT)
    self.DLabel_Instructions_Text:DockMargin(0, 0, 5, 5)
    self.DLabel_Instructions_Text:SetFont("Amethyst.Font.Notification_CText")
    self.DLabel_Instructions_Text:SetTextColor(Color(GetConVar("amethyst_n_text_color_red"):GetInt(), GetConVar("amethyst_n_text_color_green"):GetInt(), GetConVar("amethyst_n_text_color_blue"):GetInt(), GetConVar("amethyst_n_text_color_alpha"):GetInt()))
    self.DLabel_Instructions_Text:SetText(string.upper(Amethyst.Language["message"] or "Message"))
	self.DLabel_Instructions_Text:SetWide(labelWidth or 90)

    self.DTextEntry_Message = vgui.Create("DTextEntry", self.DPanel_Message_Container)
    self.DTextEntry_Message:Dock(FILL)
    self.DTextEntry_Message:DockMargin(0, 0, 0, 5)
    self.DTextEntry_Message:SetMultiline( true )
	self.DTextEntry_Message:SetEnabled( true )
	self.DTextEntry_Message:SetVerticalScrollbarEnabled( true )
	self.DTextEntry_Message:SetFont( "Amethyst.Font.Notification_CText" )
	self.DTextEntry_Message:SetText( "" )
	self.DTextEntry_Message:SetEditable( true )
	self.DTextEntry_Message.Paint = function(self)
		draw.AmethystOutlinedBox( 0, 0, self:GetWide(), self:GetTall(), Color(GetConVar("amethyst_m_textbox_icolor_red"):GetInt(), GetConVar("amethyst_m_textbox_icolor_green"):GetInt(), GetConVar("amethyst_m_textbox_icolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_icolor_alpha"):GetInt() ), Color(GetConVar("amethyst_m_textbox_ocolor_red"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_green"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_alpha"):GetInt() ))
		self:DrawTextEntryText(Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()), Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()), Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()))
	end

    self.DPanel_B_Inner = vgui.Create("DPanel", self.DPanel_M_Inner)
    self.DPanel_B_Inner:Dock(BOTTOM)
    self.DPanel_B_Inner:DockMargin(0, 20, 0, 0)
    self.DPanel_B_Inner:SetTall( 30 )
    self.DPanel_B_Inner.Paint = function(self, w, h) end

	self.DPanel_Slider = vgui.Create("DPanel", self.DPanel_M_Inner)
	self.DPanel_Slider:Dock(BOTTOM)
	self.DPanel_Slider:SetTall(30)
	self.DPanel_Slider:DockMargin(0, 15, 0, 0)
	self.DPanel_Slider.Paint = function(self, w, h) end

    self.DLabel_Slider_Text = vgui.Create("DLabel", self.DPanel_Slider)
    self.DLabel_Slider_Text:Dock(LEFT)
    self.DLabel_Slider_Text:DockMargin(0, 0, 5, 15)
    self.DLabel_Slider_Text:SetFont("Amethyst.Font.ConfigurationSec")
    self.DLabel_Slider_Text:SetTextColor(Color(GetConVar("amethyst_n_text_color_red"):GetInt(), GetConVar("amethyst_n_text_color_green"):GetInt(), GetConVar("amethyst_n_text_color_blue"):GetInt(), GetConVar("amethyst_n_text_color_alpha"):GetInt()))
    self.DLabel_Slider_Text:SetText(string.upper(Amethyst.Language["display_time"] or "Display Time"))
	self.DLabel_Slider_Text:SetWide(labelWidth or 90)

	self.DPanel_Number_Right = vgui.Create("DPanel", self.DPanel_Slider)
	self.DPanel_Number_Right:Dock(FILL)
	self.DPanel_Number_Right:DockMargin(5, 0, 0, 4)
	self.DPanel_Number_Right:SetWide(300)
	self.DPanel_Number_Right.Paint = function(self, w, h) end

	self.DNumSlider_TimeDelay = vgui.Create( "amethyst.slider", self.DPanel_Number_Right )
	self.DNumSlider_TimeDelay:Dock(BOTTOM)
	self.DNumSlider_TimeDelay:DockMargin(0, 5, 0, 5)
	self.DNumSlider_TimeDelay:SetSize( 300, 25 )
	self.DNumSlider_TimeDelay:SetText( Amethyst.Language["notification_display_time"] or "Notification Display Time" )
	self.DNumSlider_TimeDelay:SetMin( 5 )
	self.DNumSlider_TimeDelay:SetMax( 20 )
	self.DNumSlider_TimeDelay:SetValue( 5 )
	self.DNumSlider_TimeDelay:SetDecimals( 0 )

    self.DButton_Action_DoSend = vgui.Create( "DButton", self.DPanel_B_Inner )
    self.DButton_Action_DoSend:Dock(FILL)
    self.DButton_Action_DoSend:SetTall(25)
    self.DButton_Action_DoSend:DockMargin(0, 0, 0, 0)
    self.DButton_Action_DoSend:SetText( Amethyst.Language["send_notification"] or "Send Notification" )
    self.DButton_Action_DoSend:SetFont("Amethyst.Font.Notification_CButton")
    self.DButton_Action_DoSend:SetTextColor( Color( GetConVar("amethyst_m_button_tcolor_red"):GetInt(), GetConVar("amethyst_m_button_tcolor_green"):GetInt(), GetConVar("amethyst_m_button_tcolor_blue"):GetInt(), GetConVar("amethyst_m_button_tcolor_alpha"):GetInt() ) )
    self.DButton_Action_DoSend.Paint = function( self, w, h )
        local doContainerColor = Color( GetConVar("amethyst_m_primarybutton_color_red"):GetInt(), GetConVar("amethyst_m_primarybutton_color_green"):GetInt(), GetConVar("amethyst_m_primarybutton_color_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_color_alpha"):GetInt() )
        local doContainerOutline = Color( GetConVar("amethyst_m_primarybutton_ocolor_red"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_green"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_alpha"):GetInt() )
        if self:IsHovered() or self:IsDown() then
            doContainerColor = Color(GetConVar("amethyst_m_primarybutton_hcolor_red"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_green"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_alpha"):GetInt() )
            doContainerOutline = Color(GetConVar("amethyst_m_primarybutton_ocolor_red"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_green"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_alpha"):GetInt() )
        end

        draw.AmethystOutlinedBox(0, 0, w, h,  doContainerColor, doContainerOutline)
    end
    self.DButton_Action_DoSend.DoClick = function()
		Amethyst:SendNotification(self.DTextEntry_Title:GetValue(), self.DTextEntry_Message:GetValue(), self.DNumSlider_TimeDelay:GetValue())
        if IsValid(self.DFrame_N_Container) then self.DFrame_N_Container:Remove() end
    end

    self.DButton_Action_DoClose = vgui.Create( "DButton", self.DPanel_B_Inner )
    self.DButton_Action_DoClose:Dock(RIGHT)
    self.DButton_Action_DoClose:DockMargin(5, 0, 0, 0)
    self.DButton_Action_DoClose:SetWide(200)
    self.DButton_Action_DoClose:SetTall(25)
    self.DButton_Action_DoClose:SetText( Amethyst.Language["close"] or "Close" )
    self.DButton_Action_DoClose:SetFont("Amethyst.Font.Notification_CButton")
    self.DButton_Action_DoClose:SetTextColor( Color( GetConVar("amethyst_m_button_tcolor_red"):GetInt(), GetConVar("amethyst_m_button_tcolor_green"):GetInt(), GetConVar("amethyst_m_button_tcolor_blue"):GetInt(), GetConVar("amethyst_m_button_tcolor_alpha"):GetInt() ) )
    self.DButton_Action_DoClose.Paint = function( self, w, h )
        local doContainerColor = Color( GetConVar("amethyst_m_secondarybutton_color_red"):GetInt(), GetConVar("amethyst_m_secondarybutton_color_green"):GetInt(), GetConVar("amethyst_m_secondarybutton_color_blue"):GetInt(), GetConVar("amethyst_m_secondarybutton_color_alpha"):GetInt() )
        local doContainerOutline = Color( GetConVar("amethyst_m_secondarybutton_ocolor_red"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_green"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_blue"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_alpha"):GetInt() )
        if self:IsHovered() or self:IsDown() then
            doContainerColor = Color(GetConVar("amethyst_m_secondarybutton_hcolor_red"):GetInt(), GetConVar("amethyst_m_secondarybutton_hcolor_green"):GetInt(), GetConVar("amethyst_m_secondarybutton_hcolor_blue"):GetInt(), GetConVar("amethyst_m_secondarybutton_hcolor_alpha"):GetInt() )
            doContainerOutline = Color(GetConVar("amethyst_m_secondarybutton_ocolor_red"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_green"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_blue"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_alpha"):GetInt() )
        end

        draw.AmethystOutlinedBox(0, 0, w, h,  doContainerColor, doContainerOutline)
    end
    self.DButton_Action_DoClose.DoClick = function()
        if IsValid(self.DFrame_N_Container) then self.DFrame_N_Container:Remove() end
    end

end
concommand.Add("amethyst_notification", Amethyst.Notification)