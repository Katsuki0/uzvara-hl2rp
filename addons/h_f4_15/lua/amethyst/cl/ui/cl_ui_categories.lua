/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


Amethyst = Amethyst or {}

local PANEL = {}

function PANEL:Init()

    local PanelCategory = self

    local CVar_Color_CatText = Color(GetConVar("amethyst_g_cat_tcolor_red"):GetInt(), GetConVar("amethyst_g_cat_tcolor_green"):GetInt(), GetConVar("amethyst_g_cat_tcolor_blue"):GetInt(), GetConVar("amethyst_g_cat_tcolor_alpha"):GetInt())
    local CVar_Color_CatBtnCollapse = Color(GetConVar("amethyst_g_cat_collapse_icolor_red"):GetInt(), GetConVar("amethyst_g_cat_collapse_icolor_green"):GetInt(), GetConVar("amethyst_g_cat_collapse_icolor_blue"):GetInt(), GetConVar("amethyst_g_cat_collapse_icolor_alpha"):GetInt())
    local CVar_Color_CatBtnNorm = Color(GetConVar("amethyst_g_cat_norm_icolor_red"):GetInt(), GetConVar("amethyst_g_cat_norm_icolor_green"):GetInt(), GetConVar("amethyst_g_cat_norm_icolor_blue"):GetInt(), GetConVar("amethyst_g_cat_norm_icolor_alpha"):GetInt())

    self.Children = {}
    self:SetTall( 20 )

    self.Button = vgui.Create( "DButton", self )
    self.Button:Dock( TOP )
    self.Button:DockMargin( 5, 5, 5, 0 )
    self.Button:SetHeight( 25 )
    self.Button:SetText( "" )
    self.Button.DoClick = function() self:DoToggle() end
    self.Button.Paint = function(self, w, h)
        draw.SimpleText( string.upper(PanelCategory.Title or ""), "Amethyst.Font.CategoryTitle", 25, 12, CVar_Color_CatText or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

        local ImageExpand = Material("amethyst/amethyst_gui_category_doexpand.png", "smooth noclamp")
        local CategoryIconColor = CVar_Color_CatBtnCollapse or Color(255, 255, 255, 255)
        if PanelCategory.IsToggled  then
            ImageExpand = Material("amethyst/amethyst_gui_category_docollapse.png", "smooth noclamp")
            CategoryIconColor = CVar_Color_CatBtnNorm or Color(255, 255, 255, 255)
        end

        surface.SetDrawColor(CategoryIconColor)
        surface.SetMaterial(ImageExpand)
        surface.DrawTexturedRect(0, h / 2 - 6.5, 13, 13)

        if not PanelCategory.IsToggled then
            PanelCategory:ToggleClosed()
        end

    end

end

function PANEL:AddNewChild(element)
    local PanelCategory = self

    if not IsValid(element) then return end
    table.insert(PanelCategory.Children, element)

    Amethyst.Categories:PerformLayout()
end

function PANEL:SetupChildren()
    local PanelCategory = self
    PanelCategory:SetTall( 25 + PanelCategory.List:GetTall() + 15 )
end

function PANEL:ToggleOpened()
    local PanelCategory = self
    PanelCategory.IsToggled = true
    PanelCategory:SizeTo( PanelCategory:GetWide(), PanelCategory.FetchTall, 0.2, 0.1 )
end

function PANEL:ToggleClosed()
    local PanelCategory = self
    PanelCategory.IsToggled = false
    PanelCategory:SizeTo( PanelCategory:GetWide(), 35, 0.2, 0.1 )
end

function PANEL:DoToggle()
    local PanelCategory = self
    if PanelCategory.IsToggled then
        PanelCategory:ToggleClosed()
    else
        PanelCategory:ToggleOpened()
    end
end

function PANEL:HeaderTitle(catTitle)
    local PanelCategory = self
    PanelCategory.Title = catTitle
end

function PANEL:SetExpanded(bool)
    local PanelCategory = self
    PanelCategory.Expanded = bool
end

function PANEL:FetchTall(height)
    local PanelCategory = self
    PanelCategory.FetchTall = height
end

function PANEL:Paint(w, h) end

vgui.Register("amethyst.category", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/