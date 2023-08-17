/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()

    local GetThemeValue = GetConVar("amethyst_theme")

    self.DComboBox_R_TH_Themes = vgui.Create("DComboBox", self)
    self.DComboBox_R_TH_Themes:SetWide(200)
    self.DComboBox_R_TH_Themes:Dock(TOP)
    self.DComboBox_R_TH_Themes:DockMargin(40,5,40,25)
    self.DComboBox_R_TH_Themes:SetTall(30)
    self.DComboBox_R_TH_Themes:SetValue( GetThemeValue:GetString() )
    for k, v in pairs( Amethyst.Settings.Themes ) do
        self.DComboBox_R_TH_Themes:AddChoice( v[1] )
    end
    self.DComboBox_R_TH_Themes.convarname = GetThemeValue
    self.DComboBox_R_TH_Themes.OnSelect = function(self)
        local tblFetchTheme = Amethyst.Theme[self:GetValue()]
        GetThemeValue:SetString( self:GetValue() )

        local newcable = {}
        for name, line in Amethyst:pairsByKeys(tblFetchTheme) do
            table.insert( newcable, line )
        end
        table.sort( newcable, function( a, b ) return a.DataSort < b.DataSort end )

        for k, v in pairs( newcable ) do
            if v.DataType == "category" or v.DataType == "padding" or v.DataType == "spacer" then continue end
            if v.DataType == "rgba" then
                for dn, dv in pairs(v.DataValues) do
                    local Setdata = v.DataID .. "_" .. dn
                    local Dataasdasd = GetConVar(Setdata)
                    Dataasdasd:SetString( dv )

                end
            else
                local GetValueData = GetConVar(v.DataID)
                GetValueData:SetString( v.DataDefault )
            end
        end

    end
    self.DComboBox_R_TH_Themes.Paint = function(self, w, h)
        draw.AmethystOutlinedBox(0, 0, w, h, Color(44, 44, 44, 255), Color(255, 255, 255, 30))
        self:SetTextColor( Color( 255, 255, 255 ) )
        self:SetTextInset( 40, 0 )

        surface.SetDrawColor( doContainerColor or Color(255,255,255,255) )
        surface.SetMaterial( Material( "amethyst/amethyst_gui_theme.png", "noclamp smooth" ) )
        surface.DrawTexturedRect( 10, 6, 18, 18 )
    end
    self.DComboBox_R_TH_Themes.DoClick = function(what)
        if ( what:IsMenuOpen() ) then
            return what:CloseMenu()
        end
        what:OpenMenu()

        for k,v in pairs( self.DComboBox_R_TH_Themes.Menu:GetCanvas():GetChildren() ) do
            function v:Paint(w, h)
                surface.SetDrawColor(77, 77, 77, 255)
                surface.DrawRect(0, 0, w, h)
                surface.SetDrawColor(70, 70, 70, 255)
                surface.DrawLine(0, h - 1, w, h - 1)
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
            p:SetTextColor(Color(255,255,255,255))
        end

        local x, y = what:LocalToScreen( 0, what:GetTall() )

        what.Menu:SetMinimumWidth( what:GetWide() )
        what.Menu:Open( x, y, false, what )
    end

end

vgui.Register( 'Amethyst.ThemeSelect', PANEL )

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/