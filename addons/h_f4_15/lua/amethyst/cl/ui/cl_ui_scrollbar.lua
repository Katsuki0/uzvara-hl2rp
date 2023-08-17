/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/


Amethyst = Amethyst or {}
local PANEL = {}
local META = FindMetaTable("Panel")

function META:ConstructScrollbarGUI()
    AmethystVBar = self

    AmethystVBar.Paint = function(self, w, h) end
    AmethystVBar.btnUp.Paint = function(self, w, h) end
    AmethystVBar.btnDown.Paint = function(self, w, h) end
    AmethystVBar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox( 4, 5, 0, 4, h + 22, Color(GetConVar("amethyst_m_sbcolor_red"):GetInt(), GetConVar("amethyst_m_sbcolor_green"):GetInt(), GetConVar("amethyst_m_sbcolor_blue"):GetInt(), GetConVar("amethyst_m_sbcolor_alpha"):GetInt()) or Color(0, 60, 75, 210) )
    end
end

function PANEL:Init()

    local AmethystScrollbar = self

    AmethystScrollbar.Offset = 0
    AmethystScrollbar.Scroll = 0
    AmethystScrollbar.CanvasSize = 1
    AmethystScrollbar.BarSize = 1

    AmethystScrollbar.btnUp = vgui.Create( "DButton", AmethystScrollbar )
    AmethystScrollbar.btnUp:SetText( "" )
    AmethystScrollbar.btnUp.DoClick = function ( AmethystScrollbar ) AmethystScrollbar:GetParent():AddScroll( -1 ) end
    AmethystScrollbar.btnUp.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonUp", panel, w, h ) end

    AmethystScrollbar.btnDown = vgui.Create( "DButton", AmethystScrollbar )
    AmethystScrollbar.btnDown:SetText( "" )
    AmethystScrollbar.btnDown.DoClick = function ( AmethystScrollbar ) AmethystScrollbar:GetParent():AddScroll( 1 ) end
    AmethystScrollbar.btnDown.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ButtonDown", panel, w, h ) end

    AmethystScrollbar.btnGrip = vgui.Create( "DScrollBarGrip", AmethystScrollbar )

    AmethystScrollbar:SetSize( 15, 15 )

end

function PANEL:SetEnabled( b )
    if ( !b ) then
        self.Offset = 0
        self:SetScroll( 0 )
        self.HasChanged = true
    end

    self:SetMouseInputEnabled( b )
    self:SetVisible( b )

    if ( self.Enabled != b ) then
        self.Content:InvalidateLayout()
        if ( self.Content.OnScrollbarAppear ) then
            self.Content:OnScrollbarAppear()
        end
    end
    self.Enabled = b
end


function PANEL:Value()
    return self.Pos
end

function PANEL:BarScale()
    if ( self.BarSize == 0 ) then return 1 end
    return self.BarSize / (self.CanvasSize+self.BarSize)
end

function PANEL:SetUp( _barsize_, _canvassize_ )
    self.BarSize    = _barsize_
    self.CanvasSize = math.max( _canvassize_ - _barsize_, 1 )

    self:SetEnabled( _canvassize_ > _barsize_ )
    self:InvalidateLayout()
end

function PANEL:OnMouseWheeled( dlta )
    if ( !self:IsVisible() ) then return false end
    return self:AddScroll( dlta * -2 )
end

function PANEL:AddScroll( dlta )
    local OldScroll = self:GetScroll()

    dlta = dlta * 25
    self:SetScroll( self:GetScroll() + dlta )

    return OldScroll != self:GetScroll()
end

function PANEL:SetScroll( scrll )
    if ( !self.Enabled ) then self.Scroll = 0 return end

    self.Scroll = math.Clamp( scrll, 0, self.CanvasSize )
    self:InvalidateLayout()

    local func = self.Content.OnVScroll
    if ( func ) then
        func( self.Content, self:GetOffset() )
    else
        self.Content:InvalidateLayout()

    end
end

function PANEL:AnimateTo( scrll, length, delay, ease )
    local anim = self:NewAnimation( length, delay, ease )
    anim.StartPos = self.Scroll
    anim.TargetPos = scrll
    anim.Think = function( anim, pnl, fraction )

        pnl:SetScroll( Lerp( fraction, anim.StartPos, anim.TargetPos ) )

    end
end

function PANEL:GetScroll()
    if ( !self.Enabled ) then self.Scroll = 0 end
    return self.Scroll
end

function PANEL:GetOffset()
    if ( !self.Enabled ) then return 0 end
    return self.Scroll * -1
end

function PANEL:Think() end


function PANEL:Paint( w, h )
    derma.SkinHook( "Paint", "VScrollBar", self, w, h )
    return true
end

function PANEL:OnMousePressed()
    local x, y = self:CursorPos()
    local PageSize = self.BarSize

    if ( y > self.btnGrip.y ) then
        self:SetScroll( self:GetScroll() + PageSize )
    else
        self:SetScroll( self:GetScroll() - PageSize )
    end
end

function PANEL:OnMouseReleased()
    self.Dragging = false
    self.DraggingCanvas = nil
    self:MouseCapture( false )
    self.btnGrip.Depressed = false
end

function PANEL:OnCursorMoved( x, y )
    if ( !self.Enabled ) then return end
    if ( !self.Dragging ) then return end

    local x = 0
    local y = gui.MouseY()
    local x, y = self:ScreenToLocal( x, y )

    y = y - self.btnUp:GetTall()
    y = y - self.HoldPos

    local TrackSize = self:GetTall() - self:GetWide() * 2 - self.btnGrip:GetTall()

    y = y / TrackSize

    self:SetScroll( y * self.CanvasSize )
end

function PANEL:Grip()
    if ( !self.Enabled ) then return end
    if ( self.BarSize == 0 ) then return end

    self:MouseCapture( true )
    self.Dragging = true

    local x, y = 0, gui.MouseY()
    local x, y = self.btnGrip:ScreenToLocal( x, y )
    self.HoldPos = y

    self.btnGrip.Depressed = true
end

function PANEL:PerformLayout()
    local Wide = self:GetWide()
    local Scroll = self:GetScroll() / self.CanvasSize
    local BarSize = math.max( self:BarScale() * (self:GetTall() - (Wide * 2)), 10 )
    local Track = self:GetTall() - ( Wide * 2 ) - BarSize
    Track = Track + 1

    Scroll = Scroll * Track

    self.btnGrip:SetPos( 0, Wide + Scroll )
    self.btnGrip:SetSize( Wide, BarSize )
    self.btnUp:SetPos( 0, 0, Wide, Wide )
    self.btnUp:SetSize( Wide, Wide )
    self.btnDown:SetPos( 0, self:GetTall() - Wide, Wide, Wide )
    self.btnDown:SetSize( Wide, Wide )
end

derma.DefineControl( "AmethystDVScrollBar", "A Scrollbar", PANEL, "Panel" )

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/