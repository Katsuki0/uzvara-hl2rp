/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/

local PANEL = {}

function PANEL:Init()

    Amethyst.Init = self
    Amethyst.Init:Dock(FILL)
    Amethyst.Init:DockMargin(0,0,0,0)
    Amethyst.Init.Paint = function(self, w, h) end

    local CVar_ColorText = Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt())
    local CVar_ColorButton = Color( GetConVar("amethyst_m_stabs_button_scolor_red"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_green"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_alpha"):GetInt() )
    local CVar_ColorImage = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt())
	local CVar_ColorButtonHover = Color(GetConVar("amethyst_m_stabs_button_hcolor_red"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_green"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_alpha"):GetInt())
	local CVar_ObjHeight = GetConVar("amethyst_m_stabs_objheight"):GetInt() or 45

	local AmethystTabsCommunityList = {}
	for k, v in pairs(Amethyst.Settings.Community) do

		if not v.Enabled then continue end

		self.DPanelList_Tabs_Item = vgui.Create("DButton", Amethyst.Init )
		self.DPanelList_Tabs_Item:Dock(TOP)
		self.DPanelList_Tabs_Item:DockMargin(0,0,0,5)
		self.DPanelList_Tabs_Item:SetTall(CVar_ObjHeight or 45)
		self.DPanelList_Tabs_Item:SetText("")
		self.DPanelList_Tabs_Item.Paint = function(self, w, h)
			local ColorText = CVar_ColorText or Color( 255, 255, 255, 255 )
			local ColorButton = CVar_ColorButton or Color( 255, 255, 255, 255 )
			local ColorImage = CVar_ColorImage or Color( 255, 255, 255, 255 )

			if self.active then
				ColorText = CVar_ColorText or Color( 255, 255, 255, 255 )
			end
			if self.hover then
				draw.RoundedBox(0, 0, 0, 7, h, CVar_ColorButtonHover)
			end

			mat = Material(v.Icon, "noclamp smooth")
			surface.SetMaterial(mat)
			surface.SetDrawColor(ColorImage)
			surface.DrawTexturedRect(15, self:GetTall() / 2 - 12, 24, 24)
			draw.SimpleText(v.Name or "", "Amethyst.Font.TabName", 55, self:GetTall() / 2 - 7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.Desc or "", "Amethyst.Font.TabDesc", 55, self:GetTall() / 2 + 7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			if self.active then
				draw.RoundedBox(0, 0, 0, 7, h, ColorButton)
			end
		end
		self.DPanelList_Tabs_Item.OnCursorEntered = function(self)
			self.hover = true
		end
		self.DPanelList_Tabs_Item.OnCursorExited = function(self)
			self.hover = false
		end

		if k == 1 then
			self.DPanelList_Tabs_Item.active = true
		end
		self.DPanelList_Tabs_Item.DoClick = function(self)

            if timer.Exists("amethyst.ticker") then timer.Remove( "amethyst.ticker" ) end
            if timer.Exists("amethyst.achievements.hoverdesc") then timer.Remove( "amethyst.achievements.hoverdesc" ) end

			for _, button in pairs(AmethystTabsCommunityList) do
				button.active = false
			end

			self.active = true

			v.func()
		end

		table.insert(AmethystTabsCommunityList, self.DPanelList_Tabs_Item)

	end

end
vgui.Register("Amethyst_STab_Community", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/