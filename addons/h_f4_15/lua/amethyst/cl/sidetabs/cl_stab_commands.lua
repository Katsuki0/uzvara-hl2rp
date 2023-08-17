/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/


local PANEL = {}

function PANEL:Init()

    Amethyst.Init = self
    Amethyst.Init:Dock(FILL)
    Amethyst.Init:DockMargin(0, 0, 0, 0)
    Amethyst.Init.Paint = function(self, w, h) end

    self.DIconLayout_Commands = vgui.Create("DIconLayout", Amethyst.Init)
    self.DIconLayout_Commands:Dock(FILL)
    self.DIconLayout_Commands:DockMargin(5, 5, 5, 5)
    self.DIconLayout_Commands:SetPos(0, 0)
    self.DIconLayout_Commands:SetSpaceY(5)
    self.DIconLayout_Commands:SetSpaceX(5)

    for k, v in pairs( Amethyst.Settings.Commands ) do

        if not v.Enabled then continue end

        if ( v.IsMayorOnly and not LocalPlayer():isMayor() ) then continue end
        if ( v.IsCivilProtectionOnly and not LocalPlayer():isCP() ) then continue end

        if v.Type == "separator" then
            self.DIconLayout_Separator = self.DIconLayout_Commands:Add( "DPanel" )

            local hsize = 6
            if v.Name then
                hsize = 22
            end

            self.DIconLayout_Separator:SetSize(2, hsize or 6)
            self.DIconLayout_Separator:Dock(TOP)
            self.DIconLayout_Separator.Paint = function( self, w, h )
                if v.Name then
                    draw.SimpleText(string.upper(v.Name or ""), "Amethyst.Font.Commandlist.Item", 5, 3, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
                end
            end

        elseif v.Type == "button" then
            self.DButton_Command = self.DIconLayout_Commands:Add( "DButton" )
            self.DButton_Command:SetText( "" )
            self.DButton_Command:SetTall(22)
            self.DButton_Command:Dock(TOP)
            self.DButton_Command:DockMargin(5,1,5,1)
            self.DButton_Command.Paint = function(self, w, h)
                local color = Color(GetConVar("amethyst_m_cmdblock_color_red"):GetInt(), GetConVar("amethyst_m_cmdblock_color_green"):GetInt(), GetConVar("amethyst_m_cmdblock_color_blue"):GetInt(), GetConVar("amethyst_m_cmdblock_color_alpha"):GetInt()) or Color(72, 112, 58, 190)
                local txtColor = Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 )
                local colorOutline = Color(GetConVar("amethyst_m_cmdblock_color_red"):GetInt() + 30, GetConVar("amethyst_m_cmdblock_color_green"):GetInt() + 30, GetConVar("amethyst_m_cmdblock_color_blue"):GetInt() + 30, GetConVar("amethyst_m_cmdblock_color_alpha"):GetInt() + 30)

                if self:IsHovered() or self:IsDown() then
                    color = Color(GetConVar("amethyst_m_cmdblock_color_red"):GetInt() - 10, GetConVar("amethyst_m_cmdblock_color_green"):GetInt() - 10, GetConVar("amethyst_m_cmdblock_color_blue"):GetInt() - 10, GetConVar("amethyst_m_cmdblock_color_alpha"):GetInt() - 10) or Color(255, 255, 255, 255)
                    txtColor = Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 )
                end

                draw.AmethystOutlinedBox(0, 0, w, h, color, colorOutline)

                surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), 20) or Color( 255, 255, 255, 20 ) )
                surface.SetMaterial( Material( v.Icon or "amethyst/amethyst_gui_point.png", "noclamp smooth" ) )
                surface.DrawTexturedRect( 4, 2, 18, 18 )

                draw.SimpleText(string.upper(v.Name or ""), "Amethyst.Font.Commandlist.Item", 25, 3, txtColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
            end

            self.DButton_Command.DoClick = function()

                if v.ArgCount == 0 then
                    RunConsoleCommand( "say", v.ExeCommand )
                    Amethyst.PanelMenu:Hide()
                else

                    local sety = 190
                    if (v.ArgCount > 1 and v.Arg2) then
                        if (string.len(v.Arg2) > 1) then
                            sety = 250
                        end
                    end

                    self.DFrame_M = vgui.Create( "DFrame" )
                    self.DFrame_M:SetTitle( "" )
                    self.DFrame_M:SetSize( ScreenScale(250), sety or 225 )
                    self.DFrame_M:SetDraggable( true )
                    self.DFrame_M:ShowCloseButton( false )
                    self.DFrame_M:Center()
                    self.DFrame_M:MakePopup()
                    self.DFrame_M.Paint = function( self, w, h )
                        draw.Amethyst_DrawBlur(self)
                        draw.AmethystBox( 0, 0, w, h, Color(GetConVar("amethyst_m_primarycolor_red"):GetInt(), GetConVar("amethyst_m_primarycolor_green"):GetInt(), GetConVar("amethyst_m_primarycolor_blue"):GetInt(), GetConVar("amethyst_m_primarycolor_alpha"):GetInt()) or Color(0, 55, 79, 245) )
                        draw.AmethystOutlinedBoxThick( 0, 0, w, h, GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2, Color(GetConVar("amethyst_m_outsideborder_color_red"):GetInt(), GetConVar("amethyst_m_outsideborder_color_green"):GetInt(), GetConVar("amethyst_m_outsideborder_color_blue"):GetInt(), GetConVar("amethyst_m_outsideborder_color_alpha"):GetInt()) )
                        local GetValueData = GetConVar("amethyst_m_grid_background_enabled")
                        if GetValueData:GetInt() == 1 then
                            surface.SetDrawColor( Color( 5, 5, 5, 30 ) )
                            surface.SetMaterial( Material( "amethyst/amethyst_gui_pattern.png", "noclamp smooth" ) )
                            surface.DrawTexturedRectRotated( 100, 0, 1275, 333, 0 )
                        end
                    end
                    self.DFrame_M.Think = function()
                        self.DFrame_M:MoveToFront()
                        if not self.DButton_Command:IsVisible() and IsValid(self.DFrame_M) then
                            self.DFrame_M:Close()
                        end
                    end

                    self.DLabel_Title_Text = vgui.Create("DLabel", self.DFrame_M)
                    self.DLabel_Title_Text:Dock(TOP)
                    self.DLabel_Title_Text:DockMargin(15, 0, 5, 5)
                    self.DLabel_Title_Text:SetFont("Amethyst.Font.CommandBlock_Name")
                    self.DLabel_Title_Text:SetTextColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()))
                    self.DLabel_Title_Text:SetText(string.upper(v.Name))

                    self.DPanel_M_Inner = vgui.Create("DPanel", self.DFrame_M)
                    self.DPanel_M_Inner:Dock(FILL)
                    self.DPanel_M_Inner:DockMargin(15, 15, 15, 15)
                    self.DPanel_M_Inner.Paint = function(self, w, h) end

                    self.DLabel_Arg1 = vgui.Create( "DLabel", self.DPanel_M_Inner )
                    self.DLabel_Arg1:SetSize( self.DPanel_M_Inner:GetWide() - 20, 25 )
                    self.DLabel_Arg1:Dock(TOP)
                    self.DLabel_Arg1:DockMargin(0, 0, 0, 0)
                    self.DLabel_Arg1:SetFont("Amethyst.Font.CommandBlock_FieldTitle")
                    self.DLabel_Arg1:SetTextColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()))
                    self.DLabel_Arg1:SetText( v.Arg1 or "" )

                    self.DTextEntry_Arg1 = vgui.Create( "DTextEntry", self.DPanel_M_Inner )
                    self.DTextEntry_Arg1:SetSize( self.DPanel_M_Inner:GetWide() - 20, 25 )
                    self.DTextEntry_Arg1:Dock(TOP)
                    self.DTextEntry_Arg1:DockMargin(0, 0, 0, 0)
                    self.DTextEntry_Arg1:SetText( "" )
                    self.DTextEntry_Arg1.Paint = function(self)
                        draw.AmethystOutlinedBox( 0, 0, self:GetWide(), self:GetTall(), Color(GetConVar("amethyst_m_textbox_icolor_red"):GetInt(), GetConVar("amethyst_m_textbox_icolor_green"):GetInt(), GetConVar("amethyst_m_textbox_icolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_icolor_alpha"):GetInt() ), Color(GetConVar("amethyst_m_textbox_ocolor_red"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_green"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_alpha"):GetInt() ))
                        self:DrawTextEntryText(Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()), Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()), Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()))
                    end

                    self.DLabel_Arg2 = vgui.Create( "DLabel", self.DPanel_M_Inner )
                    self.DLabel_Arg2:SetSize( self.DPanel_M_Inner:GetWide() - 20, 25 )
                    self.DLabel_Arg2:Dock(TOP)
                    self.DLabel_Arg2:DockMargin(0, 10, 0, 0)
                    self.DLabel_Arg2:SetVisible(false)
                    self.DLabel_Arg2:SetFont("Amethyst.Font.CommandBlock_FieldTitle")
                    self.DLabel_Arg2:SetTextColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()))

                    self.DLabel_Arg2:SetText( v.Arg2 or "" )

                    self.DTextEntry_Arg2 = vgui.Create( "DTextEntry", self.DPanel_M_Inner )
                    self.DTextEntry_Arg2:SetSize( self.DPanel_M_Inner:GetWide() - 20, 25 )
                    self.DTextEntry_Arg2:Dock(TOP)
                    self.DTextEntry_Arg2:DockMargin(0, 0, 0, 0)
                    self.DTextEntry_Arg2:SetVisible(false)
                    self.DTextEntry_Arg2:SetText( "" )
                    self.DTextEntry_Arg2.Paint = function(self)
                        draw.AmethystOutlinedBox( 0, 0, self:GetWide(), self:GetTall(), Color(GetConVar("amethyst_m_textbox_icolor_red"):GetInt(), GetConVar("amethyst_m_textbox_icolor_green"):GetInt(), GetConVar("amethyst_m_textbox_icolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_icolor_alpha"):GetInt() ), Color(GetConVar("amethyst_m_textbox_ocolor_red"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_green"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_ocolor_alpha"):GetInt() ))
                        self:DrawTextEntryText(Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()), Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()), Color(GetConVar("amethyst_m_textbox_tcolor_red"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_green"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_blue"):GetInt(), GetConVar("amethyst_m_textbox_tcolor_alpha"):GetInt()))
                    end

                    if v.ArgCount == 2 then
                        self.DPanel_M_Inner:SetSize( 300, 180 )
                        self.DLabel_Arg2:SetVisible(true)
                        self.DTextEntry_Arg2:SetVisible(true)
                    end

                    self.DPanel_B_Inner = vgui.Create("DPanel", self.DPanel_M_Inner)
                    self.DPanel_B_Inner:Dock(BOTTOM)
                    self.DPanel_B_Inner:DockMargin(0, 20, 0, 0)
                    self.DPanel_B_Inner:SetTall( 35 )
                    self.DPanel_B_Inner.Paint = function(self, w, h) end

                    self.DButton_Action_DoConfirm = vgui.Create( "DButton", self.DPanel_B_Inner )
                    self.DButton_Action_DoConfirm:SetSize( self.DPanel_M_Inner:GetWide() - 20, 25 )
                    self.DButton_Action_DoConfirm:Dock(FILL)
                    self.DButton_Action_DoConfirm:SetText( "OK" )
                    self.DButton_Action_DoConfirm:SetFont("Amethyst.Font.Notification_CButton")
                    self.DButton_Action_DoConfirm:SetTextColor( Color( GetConVar("amethyst_m_button_tcolor_red"):GetInt(), GetConVar("amethyst_m_button_tcolor_green"):GetInt(), GetConVar("amethyst_m_button_tcolor_blue"):GetInt(), GetConVar("amethyst_m_button_tcolor_alpha"):GetInt() ) )
                    self.DButton_Action_DoConfirm.Paint = function( self, w, h )
                        local color = Color( GetConVar("amethyst_m_primarybutton_color_red"):GetInt(), GetConVar("amethyst_m_primarybutton_color_green"):GetInt(), GetConVar("amethyst_m_primarybutton_color_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_color_alpha"):GetInt() )
                        if self:IsHovered() or self:IsDown() then
                            color = Color(GetConVar("amethyst_m_primarybutton_hcolor_red"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_green"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_alpha"):GetInt() )
                        end
                        draw.RoundedBox( 4, 0, 0, w, h, color )
                    end
                    self.DButton_Action_DoConfirm.DoClick = function()
                        if IsValid(self.DTextEntry_Arg1) then
                            if (v.ArgCount == 1) then
                                RunConsoleCommand( "say", v.ExeCommand .. " " .. self.DTextEntry_Arg1:GetValue() )
                            else
                                RunConsoleCommand( "say", v.ExeCommand .. " " .. self.DTextEntry_Arg1:GetValue() .. " " .. self.DTextEntry_Arg2:GetValue() )
                            end

                            if IsValid(Amethyst.PanelMenu) then
                                Amethyst.PanelMenu:Hide()
                            end
                            if IsValid(self.DFrame_M) then
                                self.DFrame_M:Close()
                            end
                        end
                    end

                    self.DButton_Action_DoCancel = vgui.Create( "DButton", self.DPanel_B_Inner )
                    self.DButton_Action_DoCancel:Dock(RIGHT)
                    self.DButton_Action_DoCancel:DockMargin(5, 0, 0, 0)
                    self.DButton_Action_DoCancel:SetWide(200)
                    self.DButton_Action_DoCancel:SetTall(15)
                    self.DButton_Action_DoCancel:SetText( "Cancel" )
                    self.DButton_Action_DoCancel:SetFont("Amethyst.Font.Notification_CButton")
                    self.DButton_Action_DoCancel:SetTextColor( Color( GetConVar("amethyst_m_button_tcolor_red"):GetInt(), GetConVar("amethyst_m_button_tcolor_green"):GetInt(), GetConVar("amethyst_m_button_tcolor_blue"):GetInt(), GetConVar("amethyst_m_button_tcolor_alpha"):GetInt() ) )
                    self.DButton_Action_DoCancel.Paint = function( self, w, h )
                        local doContainerColor = Color( GetConVar("amethyst_m_secondarybutton_color_red"):GetInt(), GetConVar("amethyst_m_secondarybutton_color_green"):GetInt(), GetConVar("amethyst_m_secondarybutton_color_blue"):GetInt(), GetConVar("amethyst_m_secondarybutton_color_alpha"):GetInt() )
                        local doContainerOutline = Color( GetConVar("amethyst_m_secondarybutton_ocolor_red"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_green"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_blue"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_alpha"):GetInt() )
                        if self:IsHovered() or self:IsDown() then
                            doContainerColor = Color(GetConVar("amethyst_m_secondarybutton_hcolor_red"):GetInt(), GetConVar("amethyst_m_secondarybutton_hcolor_green"):GetInt(), GetConVar("amethyst_m_secondarybutton_hcolor_blue"):GetInt(), GetConVar("amethyst_m_secondarybutton_hcolor_alpha"):GetInt() )
                            doContainerOutline = Color(GetConVar("amethyst_m_secondarybutton_ocolor_red"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_green"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_blue"):GetInt(), GetConVar("amethyst_m_secondarybutton_ocolor_alpha"):GetInt() )
                        end

                        draw.AmethystOutlinedBox(0, 0, w, h,  doContainerColor, doContainerOutline)
                    end
                    self.DButton_Action_DoCancel.DoClick = function()
                        if IsValid(self.DFrame_M) then
                            self.DFrame_M:Close()
                        end
                    end

                end

            end

        end

    end

    if LocalPlayer():GetUserGroup() and Amethyst.Settings.CanAnnouncementGroups[string.lower(LocalPlayer():GetUserGroup())] then

        self.DPanel_B = vgui.Create("DPanel", Amethyst.Init)
        self.DPanel_B:Dock(BOTTOM)
        self.DPanel_B:DockMargin(5, 5, 5, 5)
        self.DPanel_B:SetTall(40)
        self.DPanel_B.Paint = function(self, w, h) end

        self.DButton_ActionNotification = vgui.Create( "DButton", self.DPanel_B )
        self.DButton_ActionNotification:Dock(FILL)
        self.DButton_ActionNotification:SetToolTip(Amethyst.Language["send_notification"] or "Send Notification")
        self.DButton_ActionNotification:DockMargin(0, 0, 0, 0)
        self.DButton_ActionNotification:SetText("")
        self.DButton_ActionNotification.Paint = function( self, w, h )
            local doContainerColor = Color( GetConVar("amethyst_m_primarybutton_color_red"):GetInt(), GetConVar("amethyst_m_primarybutton_color_green"):GetInt(), GetConVar("amethyst_m_primarybutton_color_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_color_alpha"):GetInt() )
            local doContainerOutline = Color( GetConVar("amethyst_m_primarybutton_ocolor_red"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_green"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_alpha"):GetInt() )
            if self:IsHovered() or self:IsDown() then
                doContainerColor = Color(GetConVar("amethyst_m_primarybutton_hcolor_red"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_green"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_hcolor_alpha"):GetInt() )
                doContainerOutline = Color(GetConVar("amethyst_m_primarybutton_ocolor_red"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_green"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_blue"):GetInt(), GetConVar("amethyst_m_primarybutton_ocolor_alpha"):GetInt() )
            end
            draw.RoundedBox( 4, 0, 0, w, h, doContainerColor )
            draw.SimpleText(Amethyst.Language["send_notification"] or "SEND NOTIFICATION", "Amethyst.Font.Notification_Button_Text", w / 2, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        end
        self.DButton_ActionNotification.DoClick = function()
            RunConsoleCommand("amethyst_notification")
        end

    end

end
vgui.Register("Amethyst_STab_Commands", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/