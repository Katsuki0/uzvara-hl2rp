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
local cos, sin, rad, render, draw = math.cos, math.sin, math.rad, render, draw

function PANEL:Init()
    self.AvatarAnimated = vgui.Create("DModelPanel", self)
    self.AvatarAnimated:SetModel(LocalPlayer():GetModel())
    self.AvatarAnimated:SetPos(5, 5)
    self.AvatarAnimated:SetSize(128, 128)
    self.AvatarAnimated:SetVisible(false)
    self.AvatarAnimated.Think = function()
        self.AvatarAnimated:SetModel(LocalPlayer():GetModel())
        local PlayerModelBGroup = ""
        local PlayerModelSkin = LocalPlayer():GetSkin() or 0

        for n = 0, LocalPlayer():GetNumBodyGroups() do
            PlayerModelBGroup = PlayerModelBGroup .. LocalPlayer():GetBodygroup(n)
        end
        self.AvatarAnimated.Entity:SetBodyGroups(PlayerModelBGroup)
        self.AvatarAnimated.Entity:SetSkin(PlayerModelSkin)
    end
    self.AvatarAnimated.LayoutEntity = function(ent)
        return
    end
    function self.AvatarAnimated.Entity:GetPlayerColor() return LocalPlayer():GetPlayerColor() end
    function self.AvatarAnimated.Entity:GetSkin() return LocalPlayer():GetSkin() end
    self.AvatarAnimated:SetPaintedManually( true )


    self.Avatar = vgui.Create( "AvatarImage", self )
    self.Avatar:SetPaintedManually( true )
    self.Avatar:SetVisible(false)
    self.Circle = {}
end

function PANEL:Think()

    if GetConVar("amethyst_avatar_pmodel_enabled"):GetInt() == 1 then
        self.AvatarAnimated:SetVisible(true)
        self.AvatarAnimated:SetFOV(GetConVar("amethyst_avatar_fov"):GetInt() or 18)
        self.AvatarAnimated:SetCamPos( Vector( GetConVar("amethyst_avatar_campos_x"):GetInt() or 85, GetConVar("amethyst_avatar_campos_y"):GetInt() or -11, GetConVar("amethyst_avatar_campos_z"):GetInt() or 65 ) )
        self.AvatarAnimated:SetLookAt( Vector( GetConVar("amethyst_avatar_lookat_x"):GetInt() or -2, GetConVar("amethyst_avatar_lookat_y"):GetInt() or 1, GetConVar("amethyst_avatar_lookat_z"):GetInt() or 62 ) )
        self.Avatar:SetVisible(false)
    else
        self.Avatar:SetVisible(true)
        self.AvatarAnimated:SetVisible(false)
    end

end

function PANEL:PerformLayout( w, h )
    local radians = 0
    local sizeMultiplier = 0.4

    self.Avatar:SetSize( w, h )
    self.AvatarSize = w * sizeMultiplier

    for i = 1, 360 do
        radians = rad( i )
        self.Circle[i] = { x = w / 2 + cos( radians ) * self.AvatarSize, y = h / 2 + sin( radians ) * self.AvatarSize }
    end
end

function PANEL:SetPlayer( id )
    self.AvatarAnimated:SetSteamID( id or "", self:GetWide() )
    self.Avatar:SetSteamID( id or "", self:GetWide() )
end

function PANEL:Paint( w, h )

    local DrawColor = Color(GetConVar("amethyst_m_avatar_ccolor_red"):GetInt(), GetConVar("amethyst_m_avatar_ccolor_green"):GetInt(), GetConVar("amethyst_m_avatar_ccolor_blue"):GetInt(), GetConVar("amethyst_m_avatar_ccolor_alpha"):GetInt()) or Color(0, 60, 75, 210)

    draw.Amethyst_Circle( 64, 64, 54, 100, DrawColor )

    render.ClearStencil()
    render.SetStencilEnable( true )

    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )

    render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    render.SetStencilReferenceValue( 1 )

    draw.NoTexture()
    surface.SetDrawColor( color_white )
    surface.DrawPoly( self.Circle )

    render.SetStencilFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilReferenceValue( 1 )

    self.AvatarAnimated:SetPaintedManually( false )
    self.AvatarAnimated:PaintManual()
    self.AvatarAnimated:SetPaintedManually( true )

    self.Avatar:SetPaintedManually( false )
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually( true )

    render.SetStencilEnable(false)

end

vgui.Register( 'Amethyst.Avatar', PANEL )

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/