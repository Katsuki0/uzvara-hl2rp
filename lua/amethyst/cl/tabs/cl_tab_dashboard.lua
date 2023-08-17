/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


local PANEL = {}

function PANEL:Init()

    Amethyst.Init = self
    Amethyst.Init:Dock(FILL)
    Amethyst.Init:DockMargin(0, 0, 0, 0)
    Amethyst.Init.Paint = function( nymphie, w, h ) end

    self.DPanel_T_Container = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_T_Container:Dock(TOP)
    self.DPanel_T_Container:DockMargin(0, 0, 0, 0)
    self.DPanel_T_Container:SetTall(35)
    self.DPanel_T_Container.Paint = function( nymphie, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
    	draw.DrawText( string.upper(Amethyst.Language["dashboard"] or "DASHBOARD"), "Amethyst.Font.SectionTitle", 15, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    end

    self.DPanel_T_R_Container = vgui.Create("DPanel", self.DPanel_T_Container)
    self.DPanel_T_R_Container:Dock(RIGHT)
    self.DPanel_T_R_Container:DockMargin(0, 0, 0, 0)
    self.DPanel_T_R_Container:SetWide(180)
    self.DPanel_T_R_Container.Paint = function( nymphie, w, h ) end

    local GetThemeValue = GetConVar("amethyst_theme")

    self.DComboBox_R_TH_Themes = vgui.Create("DComboBox", self.DPanel_T_R_Container)
    self.DComboBox_R_TH_Themes:Dock(TOP)
    self.DComboBox_R_TH_Themes:DockMargin(40,6,16,0)
    self.DComboBox_R_TH_Themes:SetTall(22)
    self.DComboBox_R_TH_Themes:SetValue( GetThemeValue:GetString() )
    for k, v in pairs( Amethyst.Settings.Themes ) do
    	if Amethyst.Theme[k] and v.Enabled then
    		if (v.HideNotAllowed and k != "default" and not LocalPlayer():IsSuperAdmin()) then
    			if (v.StaffOnly and not Amethyst.Settings.StaffGroups[string.lower(LocalPlayer():GetUserGroup())]) or (v.DonatorOnly and not Amethyst.Settings.DonatorGroups[string.lower(LocalPlayer():GetUserGroup())]) then continue end
    		end
    		self.DComboBox_R_TH_Themes:AddChoice( k )
    	end
    end
    self.DComboBox_R_TH_Themes.convarname = GetThemeValue
    self.DComboBox_R_TH_Themes.OnSelect = function(what)
    	local tblFetchTheme = Amethyst.Theme[what:GetValue()]

    	GetThemeValue:SetString( what:GetValue() )

    	local newcable = {}
    	for name, line in Amethyst.SortPairsKeys(tblFetchTheme) do
    		table.insert( newcable, line )
    	end
    	table.sort( newcable, function( a, b ) return a.DataSort < b.DataSort end )

    	for k, v in pairs( newcable ) do
    		if table.HasValue( Amethyst.Settings.IgnoreBlockTypes, v.DataType ) then continue end
    		if v.DataType == "rgba" then
    			for dn, dv in pairs(v.DataValues) do
    				local Setdata = v.DataID .. "_" .. dn
    				local fetchConVar = GetConVar(Setdata)
    				fetchConVar:SetString( dv )

    			end
    		else
    			local GetValueData = GetConVar(v.DataID)
    			GetValueData:SetString( v.DataDefault )
    		end
    	end

        DarkRP.closeF4Menu()
        DarkRP.openF4Menu()
        if IsValid(Amethyst.PanelMenu) then
        	Amethyst.ThemeValidation()
            if IsValid( PanelRightFill ) then
            	timer.Create("amethyst.settings.reopen", 0.4, 1, function()
            		if timer.Exists("amethyst.achievements.hoverdesc") then timer.Remove("amethyst.achievements.hoverdesc") end
    				PanelRightFill:Clear()
    				vgui.Create("Amethyst_Tab_Dashboard", PanelRightFill)
    			end)
    		end
    	end

    end
    self.DComboBox_R_TH_Themes.Paint = function(what, w, h)
    	ConVar_DropdownColor = Color(GetConVar("amethyst_m_dropdown_color_red"):GetInt(), GetConVar("amethyst_m_dropdown_color_green"):GetInt(), GetConVar("amethyst_m_dropdown_color_blue"):GetInt(), GetConVar("amethyst_m_dropdown_color_alpha"):GetInt())
    	ConVar_DropdownOutlineColor = Color(GetConVar("amethyst_m_dropdown_ocolor_red"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_green"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_blue"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_alpha"):GetInt())

    	draw.AmethystOutlinedBox(0, 0, w, h, ConVar_DropdownColor, ConVar_DropdownOutlineColor)
    	what:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
    	what:SetTextInset( 35, 0 )

    	surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
    	surface.SetMaterial( Material( "amethyst/amethyst_gui_theme.png", "noclamp smooth" ) )
        surface.DrawTexturedRect( 7, what:GetTall() / 2 - 8, 16, 16 )
    end
    self.DComboBox_R_TH_Themes.DoClick = function(what)
    	if ( what:IsMenuOpen() ) then
    		return what:CloseMenu()
    	end
    	what:OpenMenu()

     	for k,v in pairs( self.DComboBox_R_TH_Themes.Menu:GetCanvas():GetChildren() ) do
    		function v:Paint(w, h)
    			local col1 = Color(GetConVar("amethyst_m_dropdown_icolor_red"):GetInt(), GetConVar("amethyst_m_dropdown_icolor_green"):GetInt(), GetConVar("amethyst_m_dropdown_icolor_blue"):GetInt(), GetConVar("amethyst_m_dropdown_icolor_alpha"):GetInt())
    			surface.SetDrawColor(col1)
    			surface.DrawRect(0, 0, w, h)
    		end
    	end
    end
    self.DComboBox_R_TH_Themes.OpenMenu = function( what, pControlOpener )
    	if ( pControlOpener and pControlOpener == self.TextEntry ) then
    		return
    	end

    	if ( #what.Choices == 0 ) then return end

    	if ( IsValid( what.Menu ) ) then
    		what.Menu:Remove()
    		what.Menu = nil
    	end

    	what.Menu = DermaMenu( false, what )

    	local sorted = {}
    	for k, v in pairs( what.Choices ) do table.insert( sorted, { id = k, data = v } ) end
    	for k, v in SortedPairsByMemberValue( sorted, "data" ) do
    		local p = what.Menu:AddOption( v.data, function() what:ChooseOption( v.data, v.id ) end )
    		p:SetFont( what:GetFont() )
    		p:SetTextColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ))
    	end

    	local x, y = what:LocalToScreen( 0, what:GetTall() )

    	what.Menu:SetMinimumWidth( what:GetWide() )
    	what.Menu:Open( x, y, false, what )
    end

    self.DPanel_T_Container_Spacer = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_T_Container_Spacer:Dock(TOP)
    self.DPanel_T_Container_Spacer:SetTall(2)
    self.DPanel_T_Container_Spacer.Paint = function(nymphie, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

    self.DPanel_P_Container = vgui.Create( "DPanel", Amethyst.Init )
    self.DPanel_P_Container:Dock(FILL)
    self.DPanel_P_Container:DockMargin(0,0,0,0)
    self.DPanel_P_Container.Paint = function( nymphie, w, h )
    	local AmethystBox = Color(GetConVar("amethyst_m_secondaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_alpha"):GetInt() )
    	draw.AmethystBox( 0, 0, w, h, Color( AmethystBox.r, AmethystBox.g, AmethystBox.b, AmethystBox.a ) )
    end

    -- Ability to turn OFF statistics via settings page.
    if GetConVar("amethyst_m_dashboard_display_stats"):GetInt() == 1 then

        self.DPanel_L_Container = vgui.Create( "DPanel", self.DPanel_P_Container )
        self.DPanel_L_Container:Dock(LEFT)
        self.DPanel_L_Container:SetWide(ScreenScale(100))
        self.DPanel_L_Container:DockMargin(15,15,15,15)
        if not Amethyst.Settings.StatsEnabled then
        	self.DPanel_L_Container:SetVisible(false)
        end
        self.DPanel_L_Container.Paint = function( nymphie, w, h )
        	draw.AmethystOutlinedBox(0, 0, w, h, Color(GetConVar("amethyst_m_dashboard_primary_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_alpha"):GetInt()), Color(GetConVar("amethyst_m_dashboard_border_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_alpha"):GetInt()))
        end

        self.DPanel_L_T_Container = vgui.Create( "DPanel", self.DPanel_L_Container )
        self.DPanel_L_T_Container:Dock(TOP)
        self.DPanel_L_T_Container:SetTall(25)
        self.DPanel_L_T_Container:DockMargin(4,4,4,4)
        self.DPanel_L_T_Container.Paint = function( nymphie, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_dashboard_secondary_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
        	draw.DrawText( string.upper(Amethyst.Language["statistics"] or "STATISTICS"), "Amethyst.Font.SectionTitle", 7, 0, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
        end

        self.DBUtton_L_T_Refresh = vgui.Create( "DButton", self.DPanel_L_T_Container )
        self.DBUtton_L_T_Refresh:Dock(RIGHT)
        self.DBUtton_L_T_Refresh:SetText("")
        self.DBUtton_L_T_Refresh:DockMargin(2, 2, 2, 2)
        self.DBUtton_L_T_Refresh:SetTooltip(Amethyst.Language["refresh_statistics"] or "Refresh Statistics")
        self.DBUtton_L_T_Refresh:SetWide(25)
        self.DBUtton_L_T_Refresh.Paint = function( self, w, h )

    		local doContainerColor = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 )
    		if self:IsHovered() or self:IsDown() then
    			doContainerColor = Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt() + 50, GetConVar("amethyst_m_secondarycolor_green"):GetInt() + 50, GetConVar("amethyst_m_secondarycolor_blue"):GetInt() + 50, GetConVar("amethyst_m_secondarycolor_alpha"):GetInt())
    		end

    		surface.SetDrawColor( doContainerColor or Color(255,255,255,255) )
    		surface.SetMaterial( Material( "amethyst/amethyst_gui_action_updatestats.png", "noclamp smooth" ) )
    		surface.DrawTexturedRect( self:GetWide() - 19, self:GetTall() / 2 - 7, 14, 14 )

    	end
    	self.DBUtton_L_T_Refresh.DoClick = function()
    		Amethyst:UpdateStats()
    	end

    	self.DPanel_L_M_Container = vgui.Create( "DPanel", self.DPanel_L_Container )
    	self.DPanel_L_M_Container:Dock(FILL)
        self.DPanel_L_M_Container:DockMargin(4,4,4,4)
    	self.DPanel_L_M_Container.Paint = function( nymphie, w, h ) end

    	self.DScrollPanel_L_M_Statistics = vgui.Create( "DScrollPanel", self.DPanel_L_M_Container )
    	self.DScrollPanel_L_M_Statistics.VBar:ConstructScrollbarGUI()
    	self.DScrollPanel_L_M_Statistics:Dock( FILL )

    	for k, v in pairs( LocalPlayer():PStats_Call() ) do
    		self.DPanel_L_M_Statistics_Container = vgui.Create( "DPanel", self.DScrollPanel_L_M_Statistics )
    		self.DPanel_L_M_Statistics_Container:Dock(TOP)
    	    self.DPanel_L_M_Statistics_Container:DockMargin(0,0,0,0)
    	    self.DPanel_L_M_Statistics_Container:SetTall(30)
    		self.DPanel_L_M_Statistics_Container.Paint = function( nymphie, w, h )
            	local fetchStatsIcon = "amethyst/amethyst_gui_statistics_" .. k .. ".png"
    			surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color(255, 255, 255, 255) )
    			surface.SetMaterial( Material( fetchStatsIcon, "noclamp smooth" ) )
    			surface.DrawTexturedRect( 5, 15 - 7, 14, 14 )
    		end

    		self.DLabel_TickerContent = vgui.Create( "DLabel", self.DPanel_L_M_Statistics_Container )
    		self.DLabel_TickerContent:DockMargin(25, 0, 0, 0)
    		self.DLabel_TickerContent:Dock(LEFT)
    		self.DLabel_TickerContent:SetText("")
    		self.DLabel_TickerContent:SetFont("Amethyst.Font.StatsTitle")
    		self.DLabel_TickerContent:SetWide(120)
    		self.DLabel_TickerContent:SetContentAlignment( 4 )
    		self.DLabel_TickerContent:SetColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ))
    		self.DLabel_TickerContent.Paint = function( nymphie, w, h )
    			draw.DrawText( string.upper(Amethyst.Settings.StatsList[string.lower(k)] or ""), "Amethyst.Font.StatsTitle", 5, 7, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    		end

    		self.DLabel_TickerContent = vgui.Create( "DLabel", self.DPanel_L_M_Statistics_Container )
    		self.DLabel_TickerContent:DockMargin(0, 0, 0, 0)
    		self.DLabel_TickerContent:Dock(RIGHT)
    		self.DLabel_TickerContent:SetText("")
    		self.DLabel_TickerContent:SetFont("Amethyst.Font.StatsResult")
    		self.DLabel_TickerContent:SetWide(60)
    		self.DLabel_TickerContent:SetContentAlignment( 6 )
    		self.DLabel_TickerContent:SetColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ))
    		self.DLabel_TickerContent.Paint = function( nymphie, w, h )
    			draw.DrawText( string.Comma(v or "0"), "Amethyst.Font.StatsResult", nymphie:GetWide() - 5, 7, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
    		end

    	end

    end

    if (DARKRP_LVL_SYSTEM or LevelSystemConfiguration) and GetConVar("amethyst_m_dashboard_display_levelinfo"):GetInt() == 1 then

        self.DPanel_M_T_Container = vgui.Create( "DPanel", self.DPanel_P_Container )
        self.DPanel_M_T_Container:Dock(TOP)
        self.DPanel_M_T_Container:SetTall(30)
        self.DPanel_M_T_Container:DockMargin(0, 15, 0, 0)
        self.DPanel_M_T_Container.Paint = function( nymphie, w, h ) end

        self.DPanel_Level_Progress = vgui.Create( "DPanel", self.DPanel_M_T_Container )
        self.DPanel_Level_Progress:Dock(TOP)
        self.DPanel_Level_Progress.Paint = function( banana, w, h )
            local Progress_MarginLeft = 0
            if GetConVar("amethyst_m_dashboard_display_stats"):GetInt() ~= 1 then
                Progress_MarginLeft = 15
            end
            self.DPanel_Level_Progress:DockMargin(Progress_MarginLeft, 0, 0, 0)
            draw.DrawText( string.upper( "LEVEL PROGRESS"), "Amethyst.Font.SectionTitle", 0, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

        end

        local CalcProgXP = 0
        local PanelBlockProgress = vgui.Create( "DPanel", self.DPanel_Level_Progress )
        PanelBlockProgress:SetTall(ScreenScale(10))
        PanelBlockProgress:DockMargin(150, 10, 15, 0)
        PanelBlockProgress:Dock(TOP)
        PanelBlockProgress.Paint = function(banana, w, h)

            local playerLevel = LocalPlayer():getDarkRPVar("level") or LocalPlayer():getDarkRPVar("lvl") or 0
            local playerXP = LocalPlayer():getDarkRPVar("xp") or 0
            local expFormat = 0
            local calcXP = 0
            local remainingOutput = 0

            if LevelSystemConfiguration then
                local xpPercent = ( ( playerXP or 0 ) / ( ( ( 10 + ( ( ( playerLevel or 1 ) * ( ( playerLevel or 1 ) + 1 ) * 90 ) ) ) ) * LevelSystemConfiguration.XPMult or 1.0 ) ) or 0
                calcXP = xpPercent * 100 or 0
                calcXP = math.Round(calcXP) or 0
                expFormat = math.Clamp(calcXP, 0, 99)
            elseif DARKRP_LVL_SYSTEM then
                local formatPlayerlevel = DARKRP_LVL_SYSTEM["XP"][tonumber(playerLevel)]
                if not formatPlayerlevel then return end
                playerXP = math.floor(playerXP) or 0
                calcXP = ( playerXP * 100 / formatPlayerlevel ) or 0
                expFormat = math.floor(calcXP) or 0
            end

            remainingOutput = ( ( ( 10 + ( ( ( playerLevel or 1) * ( ( playerLevel or 1 ) + 1 ) * 90) ) ) ) * LevelSystemConfiguration.XPMult )

            -- Draw progress bar outline to fill
            surface.SetDrawColor(Color(5, 5, 5, 200))
            surface.DrawRect(0, 0, w, h)

            -- Draw progress bar primary color
            surface.SetDrawColor(Color(124,24,4,255))
            surface.DrawRect( 0, 0, 1 + w * ( math.Clamp( CalcProgXP or 0, 0, 1 ) ), h )

            -- Draw progress bar secondary shadow color
            surface.SetDrawColor(Color(10, 10, 10, 100))
            surface.DrawRect( 0, ScreenScale(3), 1 + w * ( math.Clamp( CalcProgXP or 0, 0, 1 ) ), h )

            draw.DrawText( string.upper(remainingOutput - playerXP .. "XP to level " .. playerLevel + 1), "Amethyst.Font.Levelbar_SecondaryText", w / 2, 1,  Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

        end
        PanelBlockProgress.Think = function()

            local playerLevel = LocalPlayer():getDarkRPVar("level") or LocalPlayer():getDarkRPVar("lvl") or 0
            local playerXP = LocalPlayer():getDarkRPVar("xp") or 0
            local expFormat = 0
            local calcXP = 0

            if (DARKRP_LVL_SYSTEM or LevelSystemConfiguration) then
                if LevelSystemConfiguration then
                    local xpPercent = ( ( playerXP or 0 ) / ( ( ( 10 + ( ( ( playerLevel or 1 ) * ( ( playerLevel or 1 ) + 1 ) * 90 ) ) ) ) * LevelSystemConfiguration.XPMult or 1.0 ) ) or 0
                    calcXP = xpPercent * 100 or 0
                    calcXP = math.Round(calcXP) or 0
                    expFormat = math.Clamp(calcXP, 0, 99)
                elseif DARKRP_LVL_SYSTEM then
                    local formatPlayerlevel = DARKRP_LVL_SYSTEM["XP"][tonumber(playerLevel)]
                    if not formatPlayerlevel then return end
                    playerXP = math.floor(playerXP) or 0
                    calcXP = ( playerXP * 100 / formatPlayerlevel ) or 0
                    expFormat = math.floor(calcXP) or 0
                end
            end

            local currentValues = expFormat or 0
            local maxValues = 100

            local prog = currentValues / maxValues or 0
            CalcProgXP = Lerp( FrameTime() * 2, CalcProgXP or 0, prog or 0 )

        end

    end

    self.DPanel_M_Container = vgui.Create( "DPanel", self.DPanel_P_Container )
    self.DPanel_M_Container:Dock(FILL)
    if not Amethyst.Settings.StatsEnabled then

    	self.DPanel_M_Container:DockMargin(15, 15, 0, 15)

    else

        -- Setup margin default vals
        local doMarginLeft = 15
        local doMarginTop = 15
        local doMarginRight = 0
        local doMarginBottom = 15

        -- Apply a left margin if statistics is enabled
        if GetConVar("amethyst_m_dashboard_display_stats"):GetInt() == 1 then
            doMarginLeft = 0
        end

        -- Apply a right margin when agenda or achievements is enabled
        if GetConVar("amethyst_m_dashboard_display_agenda"):GetInt() == 0 or GetConVar("amethyst_m_dashboard_display_achievements"):GetInt() == 0 then
            doMarginRight = 15
        end

        self.DPanel_M_Container:DockMargin(doMarginLeft, doMarginTop, doMarginRight, doMarginBottom)

    end
    self.DPanel_M_Container.Paint = function( nymphie, w, h )
    	draw.AmethystOutlinedBox(0, 0, w, h, Color(GetConVar("amethyst_m_dashboard_primary_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_alpha"):GetInt()), Color(GetConVar("amethyst_m_dashboard_border_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_alpha"):GetInt()))
    end

    self.DPanel_M_Title = vgui.Create( "DPanel", self.DPanel_M_Container )
    self.DPanel_M_Title:Dock(TOP)
    self.DPanel_M_Title:SetTall(25)
    self.DPanel_M_Title:DockMargin(4, 4, 4, 4)
    self.DPanel_M_Title.Paint = function( nymphie, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_dashboard_secondary_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
    	draw.DrawText( string.upper(Amethyst.Settings.Motd_Title or Amethyst.Language["message_of_the_day"] or "MESSAGE OF THE DAY"), "Amethyst.Font.SectionTitle", 7, 0, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    end

    self.DPanel_M_Content = vgui.Create( "DPanel", self.DPanel_M_Container )
    self.DPanel_M_Content:Dock(FILL)
    self.DPanel_M_Content:DockMargin(0,0,0,0)
    self.DPanel_M_Content.Paint = function( nymphie, w, h ) end

    self.DTextEntry_M_Message = vgui.Create( "DTextEntry", self.DPanel_M_Content )
    self.DTextEntry_M_Message:Dock(FILL)
    self.DTextEntry_M_Message:DockMargin(5, 5, 5, 5)
    self.DTextEntry_M_Message:SetMultiline( true )
    self.DTextEntry_M_Message:SetPaintBackground( false )
    self.DTextEntry_M_Message:SetEnabled( true )
    self.DTextEntry_M_Message:SetEditable( true )
    self.DTextEntry_M_Message:SetVerticalScrollbarEnabled( true )
    self.DTextEntry_M_Message:SetFont( "Amethyst.Font.MOTD.Message" )
    self.DTextEntry_M_Message:SetText( Amethyst.Settings.Motd_Message or Amethyst.Language["no_motd_available"] or "No message of the day available" )
    self.DTextEntry_M_Message:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )

	--[[ PRIMARY CONTAINER > RIGHT ---------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------]]
    if GetConVar("amethyst_m_dashboard_display_achievements"):GetInt() == 1 or GetConVar("amethyst_m_dashboard_display_agenda"):GetInt() == 1 then

        self.DPanel_R_Container = vgui.Create( "DPanel", self.DPanel_P_Container )
        self.DPanel_R_Container:Dock(RIGHT)
        if GetConVar("amethyst_m_dashboard_display_achievements"):GetInt() == 1 or GetConVar("amethyst_m_dashboard_display_agenda"):GetInt() == 1 or GetConVar("amethyst_m_dashboard_display_stats"):GetInt() == 1 then
        self.DPanel_R_Container:SetWide(ScreenScale(120))
        self.DPanel_R_Container:DockMargin(15, 15, 15, 15)
        else
        self.DPanel_R_Container:SetWide(0)
        self.DPanel_R_Container:DockMargin(0, 15, 15, 15)
        end
        self.DPanel_R_Container.Paint = function( nymphie, w, h ) end

    	--[[ PRIMARY CONTAINER > RIGHT > TOP ---------------------------------------------------------------
    	--------------------------------------------------------------------------------------------------]]
        -- Ability to turn OFF statistics via settings page.

        if GetConVar("amethyst_m_dashboard_display_achievements"):GetInt() == 1 then

        	self.DPanel_R_T_Container = vgui.Create( "DPanel", self.DPanel_R_Container )
        	self.DPanel_R_T_Container:Dock(TOP)
            self.DPanel_R_T_Container:DockMargin(0,0,0,0)
            self.DPanel_R_T_Container:SetTall(ScreenScale(110))
        	self.DPanel_R_T_Container.Paint = function( nymphie, w, h )
        		draw.AmethystOutlinedBox(0, 0, w, h, Color(GetConVar("amethyst_m_dashboard_primary_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_alpha"):GetInt()), Color(GetConVar("amethyst_m_dashboard_border_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_alpha"):GetInt()))
        	end

        	--[[ PRIMARY CONTAINER > RIGHT > TOP > TITLE -------------------------------------------------------
        	--------------------------------------------------------------------------------------------------]]

            self.DPanel_R_T_Title = vgui.Create( "DPanel", self.DPanel_R_T_Container )
            self.DPanel_R_T_Title:Dock(TOP)
            self.DPanel_R_T_Title:SetTall(25)
            self.DPanel_R_T_Title:DockMargin(4,4,4,4)
            self.DPanel_R_T_Title.Paint = function( nymphie, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_dashboard_secondary_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
                draw.DrawText( string.upper(Amethyst.Language["achievements"] or "ACHIEVEMENTS"), "Amethyst.Font.SectionTitle", 7, 0, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
            end

        	--[[ PRIMARY CONTAINER > RIGHT > TOP > DESC --------------------------------------------------------
        	--------------------------------------------------------------------------------------------------]]

            self.DPanel_R_T_Desc = vgui.Create( "DPanel", self.DPanel_R_T_Container )
            self.DPanel_R_T_Desc:Dock(TOP)
            self.DPanel_R_T_Desc:SetTall(40)
            self.DPanel_R_T_Desc:DockMargin(0,0,0,0)
            self.DPanel_R_T_Desc.Paint = function( nymphie, w, h ) end

        	--[[ PRIMARY CONTAINER > RIGHT > TOP > DESC CONTENT ------------------------------------------------
        	--------------------------------------------------------------------------------------------------]]

            self.DPanel_R_T_Desc_Content = vgui.Create( "DTextEntry", self.DPanel_R_T_Desc )
            self.DPanel_R_T_Desc_Content:Dock( TOP )
            self.DPanel_R_T_Desc_Content:DockMargin(8,5,5,0)
            self.DPanel_R_T_Desc_Content:SetPaintBackground( false )
            self.DPanel_R_T_Desc_Content:SetTall(40)
            self.DPanel_R_T_Desc_Content:SetText( Amethyst.Language["view_current_achievements"] or "View your current achievements" )
            self.DPanel_R_T_Desc_Content:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
            self.DPanel_R_T_Desc_Content:SetFont("Amethyst.Font.AchievementItem")
            self.DPanel_R_T_Desc_Content:SetMultiline(true)

            self.DPanel_R_T_Content = vgui.Create( "DPanel", self.DPanel_R_T_Container )
            self.DPanel_R_T_Content:Dock(FILL)
            self.DPanel_R_T_Content:DockMargin(0,0,0,0)
            self.DPanel_R_T_Content.Paint = function( nymphie, w, h ) end

            --[[ ACHIEVEMENTS > ICON LIST ----------------------------------------------------------------------
            --------------------------------------------------------------------------------------------------]]

            local DIconLayout_SpacerY = 4
            local DIconLayout_SpacerX = 0
            local DButton_SetTall = 15
            local DButton_SetWide = 17

        	if ScrH() >= 900 then
        		DIconLayout_SpacerY = 3
        		DIconLayout_SpacerX = 1
        		DButton_SetTall = 18
        		DButton_SetWide = 14
        	end

            self.DIconLayout_R_T_ListAchievements = vgui.Create( "DIconLayout", self.DPanel_R_T_Content )
            self.DIconLayout_R_T_ListAchievements:Dock( FILL )
            self.DIconLayout_R_T_ListAchievements:DockMargin(0, 0, 0, 0)
            self.DIconLayout_R_T_ListAchievements:SetPos( 0, 0 )
            self.DIconLayout_R_T_ListAchievements:SetSpaceY( ScreenScale(DIconLayout_SpacerY) )
            self.DIconLayout_R_T_ListAchievements:SetSpaceX( ScreenScale(DIconLayout_SpacerX) )
            self.DIconLayout_R_T_ListAchievements:SetVisible( true )

            for i = 0, achievements.Count() - 1 do

                if i > 0 then

                    self.DButton_R_T_Achievement = self.DIconLayout_R_T_ListAchievements:Add( "DButton" )
                    self.DButton_R_T_Achievement:SetText( "" )
                    surface.SetFont( "Amethyst.Font.AchievementItem" )

                    self.DButton_R_T_Achievement:SetTall( ScreenScale(DButton_SetTall) )
                    self.DButton_R_T_Achievement:SetWide( ScreenScale(DButton_SetWide) )
                    self.DButton_R_T_Achievement.Paint = function( what, w, h )

                        local achievementIconColor = Color( 255, 255, 255, 200)
                        if achievements.IsAchieved( i ) then
                            achievementIconColor = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt())
                        end

                        if what:IsHovered() or what:IsDown() then

                            local achievementStatus = achievements.GetDesc(i)
                            local thumbIcon = "amethyst/amethyst_gui_x.png"
                            local thumbIconColor = Color(255, 0, 0, 255)
                            if achievements.IsAchieved( i ) then
                                thumbIcon = "amethyst/amethyst_gui_check.png"
                                thumbIconColor = Color(0, 255, 0, 255)
                            end

                            surface.SetDrawColor( thumbIconColor )
                            surface.SetMaterial( Material( thumbIcon, "noclamp smooth" ) )
                            surface.DrawTexturedRect( w - 10, 4, 10, 10 )

                            if IsValid(self.DPanel_R_T_Desc_Content) then
                            	self.DPanel_R_T_Desc_Content:SetText( achievementStatus )
                            	self.DPanel_R_T_Desc_Content:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
                        		end
                            if IsValid(self.DPanel_R_T_Desc_Content) and not timer.Exists("amethyst.achievements.hoverdesc") then
                                timer.Create( "amethyst.achievements.hoverdesc", 5, 1, function() self.DPanel_R_T_Desc_Content:SetText( "View your current Garry's Mod Achievements!" ) end )
                            end

                        end

                        local getIconSize = ScreenScale(8)
                        local calcIcon = getIconSize / 2

        				if ScrH() >= 900 then
        					getIconSize = ScreenScale(9)
        					calcIcon = getIconSize / 2
        				end

                        surface.SetDrawColor( achievementIconColor or Color( 255, 255, 255, 50) )
                        surface.SetMaterial( Material( "amethyst/achievements/" .. i .. ".png", "noclamp smooth" ) )
                        surface.DrawTexturedRect( 11, h / 2 - calcIcon, getIconSize, getIconSize )

                    end

                end

            end

           	self.DPanel_R_T_Spacer_001 = vgui.Create( "DPanel", self.DPanel_R_Container )
        	self.DPanel_R_T_Spacer_001:Dock(TOP)
            self.DPanel_R_T_Spacer_001:DockMargin(0,0,0,0)
            self.DPanel_R_T_Spacer_001:SetTall(15)
        	self.DPanel_R_T_Spacer_001.Paint = function( nymphie, w, h ) end

        end

        if GetConVar("amethyst_m_dashboard_display_agenda"):GetInt() == 1 then

        	--[[ PRIMARY CONTAINER > RIGHT > BOTTOM ------------------------------------------------------------
        	--------------------------------------------------------------------------------------------------]]

        	self.DPanel_R_B_Container = vgui.Create( "DPanel", self.DPanel_R_Container )
        	self.DPanel_R_B_Container:Dock(FILL)
            self.DPanel_R_B_Container:DockMargin(0,0,0,0)
            self.DPanel_R_B_Container:SetTall(ScreenScale(80))
        	self.DPanel_R_B_Container.Paint = function( nymphie, w, h )
        		draw.AmethystOutlinedBox(0, 0, w, h, Color(GetConVar("amethyst_m_dashboard_primary_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_primary_color_alpha"):GetInt()), Color(GetConVar("amethyst_m_dashboard_border_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_border_color_alpha"):GetInt()))
        	end

            self.DPanel_R_B_Title = vgui.Create( "DPanel", self.DPanel_R_B_Container )
            self.DPanel_R_B_Title:Dock(TOP)
            self.DPanel_R_B_Title:SetTall(25)
            self.DPanel_R_B_Title:DockMargin(4,4,4,4)
            self.DPanel_R_B_Title.Paint = function( nymphie, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_dashboard_secondary_color_red"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_green"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_blue"):GetInt(), GetConVar("amethyst_m_dashboard_secondary_color_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
                draw.DrawText( string.upper(Amethyst.Language["agenda"] or "AGENDA"), "Amethyst.Font.SectionTitle", 7, 0, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
            end

            self.DPanel_R_B_Content = vgui.Create( "DPanel", self.DPanel_R_B_Container )
            self.DPanel_R_B_Content:Dock(FILL)
            self.DPanel_R_B_Content:DockMargin(4, 4, 4, 4)
            self.DPanel_R_B_Content.Paint = function( nymphie, w, h )
                agendaText = DarkRP.textWrap((LocalPlayer():getDarkRPVar("agenda") or "No Agenda Available"):gsub("//", "\n"):gsub("\\n", "\n"), "Amethyst.Font.AgendaText", self:GetWide() - 50)
                draw.DrawText(agendaText or "", "Amethyst.Font.AgendaText", 7, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

        end

    end

end
vgui.Register("Amethyst_Tab_Dashboard", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/