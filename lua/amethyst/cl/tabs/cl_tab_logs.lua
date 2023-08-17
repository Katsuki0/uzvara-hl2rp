/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

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

    self.DPanel_T_Container = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_T_Container:Dock(TOP)
    self.DPanel_T_Container:DockMargin(0, 0, 0, 0)
    self.DPanel_T_Container:SetTall(35)
    self.DPanel_T_Container.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
		draw.DrawText( string.upper("LOGS"), "Amethyst.Font.SectionTitle", 15, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
    end

    self.DPanel_T_R_Container = vgui.Create("DPanel", self.DPanel_T_Container)
    self.DPanel_T_R_Container:Dock(RIGHT)
    self.DPanel_T_R_Container:DockMargin(0, 0, 0, 0)
    self.DPanel_T_R_Container:SetWide(180)
    self.DPanel_T_R_Container.Paint = function(self, w, h) end

    self.DPanel_T_Container_Spacer = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_T_Container_Spacer:Dock(TOP)
    self.DPanel_T_Container_Spacer:SetTall(2)
    self.DPanel_T_Container_Spacer.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

	self.DPanel_P_Container = vgui.Create( "DPanel", Amethyst.Init )
	self.DPanel_P_Container:Dock(FILL)
    self.DPanel_P_Container:DockMargin(0,0,0,0)
	self.DPanel_P_Container.Paint = function( self, w, h )
		local AmethystBox = Color(GetConVar("amethyst_m_secondaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_alpha"):GetInt() )
		draw.AmethystBox( 0, 0, w, h, Color( AmethystBox.r, AmethystBox.g, AmethystBox.b, AmethystBox.a ) )
	end

	self.DPanel_L_Container = vgui.Create( "DPanel", self.DPanel_P_Container )
	self.DPanel_L_Container:Dock(FILL)
    self.DPanel_L_Container:DockMargin(15,15,15,15)
    if not Amethyst.Settings.StatsEnabled then
		self.DPanel_L_Container:SetVisible(false)
    end
	self.DPanel_L_Container.Paint = function( self, w, h )
	end

	self.DPanel_L_M_Container = vgui.Create( "DPanel", self.DPanel_L_Container )
	self.DPanel_L_M_Container:Dock(FILL)
    self.DPanel_L_M_Container:DockMargin(4,4,4,4)
	self.DPanel_L_M_Container.Paint = function( self, w, h ) end

	self.DScrollPanel_L_M_Statistics = vgui.Create( "DScrollPanel", self.DPanel_L_M_Container )
	self.DScrollPanel_L_M_Statistics.VBar:ConstructScrollbarGUI()
	self.DScrollPanel_L_M_Statistics:Dock( FILL )

	if Amethyst.Logs then
		for k, v in pairs( Amethyst.Logs ) do
			self.DPanel_L_M_Statistics_Container = vgui.Create( "DButton", self.DScrollPanel_L_M_Statistics )
			self.DPanel_L_M_Statistics_Container:Dock(TOP)
		    self.DPanel_L_M_Statistics_Container:DockMargin(0,0,0,0)
		    self.DPanel_L_M_Statistics_Container:SetText("")
		    self.DPanel_L_M_Statistics_Container:SetTall(30)
			self.DPanel_L_M_Statistics_Container.Paint = function( self, w, h )
	            local color = Color(GetConVar("amethyst_m_primarycolor_red"):GetInt() + 50, GetConVar("amethyst_m_primarycolor_green"):GetInt() + 50, GetConVar("amethyst_m_primarycolor_blue"):GetInt() + 50, GetConVar("amethyst_m_primarycolor_alpha"):GetInt())
	            local txtColor = Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt())

	            if ( k % 2 == 0 ) then
	                color = Color(color.r, color.g, color.b, 40)
	            else
	                color = Color(color.r, color.g, color.b, 60)
	            end

	            if self:IsHovered() or self:IsDown() then
	                color =  Color(color.r, color.g, color.b, 100)
	            end

	            surface.SetDrawColor( color )
	            surface.DrawRect( 0, 0, w, h )
			end

			self.DLabel_TickerContent = vgui.Create( "DLabel", self.DPanel_L_M_Statistics_Container )
			self.DLabel_TickerContent:DockMargin(25, 0, 0, 0)
			self.DLabel_TickerContent:Dock(FILL)
			self.DLabel_TickerContent:SetText("")
			self.DLabel_TickerContent:SetFont("Amethyst.Font.StatsTitle")
			self.DLabel_TickerContent:SetContentAlignment( 4 )
			self.DLabel_TickerContent:SetColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ))
			self.DLabel_TickerContent.Paint = function(self, w, h)
				draw.DrawText( v or "", "Amethyst.Font.StatsTitle", 5, 7, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			end
		end
	end

    self.DPanel_B = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_B:Dock(BOTTOM)
    self.DPanel_B:DockMargin(0, 0, 0, 0)
    self.DPanel_B:SetTall(35)
    self.DPanel_B.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 200 ) )
    end

    self.DTextEntry_B_AC_Info = vgui.Create( "DTextEntry", self.DPanel_B )
    self.DTextEntry_B_AC_Info:Dock( FILL )
    self.DTextEntry_B_AC_Info:DockMargin(5,5,25,5)
    self.DTextEntry_B_AC_Info:SetDrawBackground( false )
    self.DTextEntry_B_AC_Info:SetText( "" )
    self.DTextEntry_B_AC_Info:SetTextColor( Color( 255, 255, 255, 255) )
    self.DTextEntry_B_AC_Info:SetFont("Amethyst.Font.SettingsHelpDesc")
    self.DTextEntry_B_AC_Info:SetMultiline(false)
    self.DTextEntry_B_AC_Info.Paint = function(self, w, h)
		draw.DrawText( "Make sure to save your changes -- this will ensure everything is refreshed.", "Amethyst.Font.SettingsHelpDesc", 10, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

    self.DButton_ApplyChanges = vgui.Create( "DButton", self.DPanel_B )
    self.DButton_ApplyChanges:Dock(RIGHT)
    self.DButton_ApplyChanges:SetToolTip("Refresh Logs")
    self.DButton_ApplyChanges:DockMargin(0, 0, 10, 0)
    self.DButton_ApplyChanges:SetSize( 100, 22 )
    self.DButton_ApplyChanges:SetText("")
    self.DButton_ApplyChanges.Paint = function( self, w, h )
    	draw.RoundedBox( 4, 0, h/2 - 11, 100, 22, Color( 68,114,71,255 ) )
		draw.SimpleText("Refresh Logs", "Amethyst.Font.ConfigurationSec", w / 2, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.DButton_ApplyChanges.DoClick = function()
        if IsValid( PanelRightFill ) then
			Amethyst:UpdateLogs()
        	timer.Create("amethyst.settings.reopen", 0.5, 1, function()
				PanelRightFill:Clear()
				vgui.Create("Amethyst_Tab_Logs", PanelRightFill)
			end)
		end
   	end

end
vgui.Register("Amethyst_Tab_Logs", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/