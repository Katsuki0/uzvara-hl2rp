/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


Amethyst = Amethyst or {}
local PANEL = {}

--[[ -----------------------------------------------------------------------------------------------
Ticker data
--------------------------------------------------------------------------------------------------]]

local TickerResult = math.random( table.Count(Amethyst.Settings.TickerNews ) )
local TickerText = Amethyst.Settings.TickerNews[TickerResult]

function PANEL:Init()

    self.DPanel_T_R_Container = vgui.Create("DPanel", self)
    self.DPanel_T_R_Container:Dock(TOP)
    self.DPanel_T_R_Container:SetTall(60)
    self.DPanel_T_R_Container.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 50))
        draw.SimpleText(Amethyst.Settings.NetworkName or Amethyst.Language["welcome"] or "Welcome!", "Amethyst.Font.NetworkName", 20, h / 2 - 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.DLabel_T_R_Ticker = vgui.Create( "DLabel", self.DPanel_T_R_Container )
    self.DLabel_T_R_Ticker:SetText(string.upper(TickerText) or "")
    self.DLabel_T_R_Ticker:SetFont("Amethyst.Font.Ticker")
    self.DLabel_T_R_Ticker:SizeToContents()
    self.DLabel_T_R_Ticker:SetColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ))
    self.DLabel_T_R_Ticker:DockMargin(20, 25, 0, 0)
    self.DLabel_T_R_Ticker:Dock(LEFT)
    self.DLabel_T_R_Ticker.Think = function()
        if not timer.Exists("amethyst.ticker") then
            timer.Create("amethyst.ticker", Amethyst.Settings.TickerDelayPerMessage or 10, 0, function()
                TickerResult = TickerResult + 1

                if (TickerResult > table.Count(Amethyst.Settings.TickerNews)) then
                    TickerResult = 1
                end

                self.DLabel_T_R_Ticker:AlphaTo(0, Amethyst.Settings.TickerSpeed or 1.0, 0, function()
                    self.DLabel_T_R_Ticker:SetText(string.upper(Amethyst.Settings.TickerNews[TickerResult]))
                    self.DLabel_T_R_Ticker:SizeToContents()
                    self.DLabel_T_R_Ticker:SetColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ))
                    self.DLabel_T_R_Ticker:Dock(FILL)
                    self.DLabel_T_R_Ticker:DockMargin(20, 25, 0, 0)
                    self.DLabel_T_R_Ticker:AlphaTo(255, Amethyst.Settings.TickerSpeed or 1.0, 0, function() end)
                end)
            end)
        end

    end

    self.DPanel_T_R_ContainerNav = vgui.Create("DPanel", self.DPanel_T_R_Container)
    self.DPanel_T_R_ContainerNav:Dock(RIGHT)
    self.DPanel_T_R_ContainerNav:DockMargin(5,24,5,5)
    self.DPanel_T_R_ContainerNav:SetWide(200)
    self.DPanel_T_R_ContainerNav.Paint = function(self, w, h) end

    for k, v in pairs( Amethyst.Settings.InstantActions ) do
        if not v.Enabled then continue end

        local fetchAction       = v.Func or nil
        local fetchIconSize     = v.IconSize or 20
        local fetchIconPadding  = v.IconPadding or 10
        local fetchIcon         = v.Icon or ""

        self.DButton_InstantActions = vgui.Create( "DButton", self.DPanel_T_R_ContainerNav )
        self.DButton_InstantActions:Dock(RIGHT)
        self.DButton_InstantActions:SetToolTip(v.Name or "")
        self.DButton_InstantActions:DockMargin(fetchIconPadding, 0, fetchIconPadding, 0)
        self.DButton_InstantActions:SetSize( fetchIconSize, fetchIconSize )
        self.DButton_InstantActions:SetText("")
        self.DButton_InstantActions.Paint = function( self, w, h )
            local color = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 )
            if self:IsHovered() or self:IsDown() then
                color = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), 20) or Color( 255, 255, 255, 255 )
            end
            surface.SetDrawColor( color )
            surface.SetMaterial( Material( fetchIcon, "noclamp smooth" ) )
            surface.DrawTexturedRect( 0, 0, fetchIconSize, fetchIconSize )
        end
        if fetchAction then
            self.DButton_InstantActions.DoClick = fetchAction
        else
            self.DButton_InstantActions.DoClick = function()
                if timer.Exists("amethyst.ticker") then timer.Remove( "amethyst.ticker" ) end
                if timer.Exists("amethyst.achievements.hoverdesc") then timer.Remove( "amethyst.achievements.hoverdesc" ) end
                if v.Panel == "Amethyst_Tab_Dashboard" then
                    Amethyst:UpdateStats()
                    if XTask then
                        XTask:UpdateAchievements()
                    end
                else
                    if IsValid( PanelRightFill ) then
                        PanelRightFill:Clear(true)
                        vgui.Create("Amethyst_Tab_Settings", PanelRightFill)
                    end
                end
            end
        end
    end

end

derma.DefineControl( "amethyst.header", "DPanelList", PANEL, "DPanel" )

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/