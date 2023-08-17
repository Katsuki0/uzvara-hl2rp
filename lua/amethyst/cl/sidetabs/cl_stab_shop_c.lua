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
    Amethyst.Init:DockMargin(0,0,0,0)
    Amethyst.Init.Paint = function(self, w, h) end

    local CVar_ColorText 		= Color( GetConVar("amethyst_m_compactmode_menu_tcolor_red"):GetInt(), GetConVar("amethyst_m_compactmode_menu_tcolor_green"):GetInt(), GetConVar("amethyst_m_compactmode_menu_tcolor_blue"):GetInt(), GetConVar("amethyst_m_compactmode_menu_tcolor_alpha"):GetInt() )
    local CVar_ColorImage       = Color( GetConVar("amethyst_m_compactmode_menu_icolor_red"):GetInt(), GetConVar("amethyst_m_compactmode_menu_icolor_green"):GetInt(), GetConVar("amethyst_m_compactmode_menu_icolor_blue"):GetInt(), 1 )
    local CVar_ColorButton 		= Color( GetConVar("amethyst_m_compactmode_menu_icolor_red"):GetInt(), GetConVar("amethyst_m_compactmode_menu_icolor_green"):GetInt(), GetConVar("amethyst_m_compactmode_menu_icolor_blue"):GetInt(), GetConVar("amethyst_m_compactmode_menu_icolor_alpha"):GetInt() )
	local CVar_ColorButtonHover = Color( GetConVar("amethyst_m_compactmode_menu_ucolor_red"):GetInt(), GetConVar("amethyst_m_compactmode_menu_ucolor_green"):GetInt(), GetConVar("amethyst_m_compactmode_menu_ucolor_blue"):GetInt(), GetConVar("amethyst_m_compactmode_menu_ucolor_alpha"):GetInt() )
	local CVar_ObjSpacing 		= GetConVar("amethyst_m_compactmode_menu_bspacing"):GetInt() or 5

	local AmethystTabsList = {}
	for k, v in pairs(Amethyst.Settings.Tabs) do

		if not v.enabled then continue end
		if (v.compactOnly and GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 0) then continue end

		local doItemName = v.name or ""
		local doItemDesc = v.desc or ""

		self.DPanelList_Tabs_Item = vgui.Create( "DButton", Amethyst.Init )
		self.DPanelList_Tabs_Item:SetText( "" )

		surface.SetFont( "Amethyst.Font.TabName" )
		local sizex, sizey = surface.GetTextSize( string.upper( v.name ) )

		self.DPanelList_Tabs_Item:SetSize( sizex + 15, 25 )
		self.DPanelList_Tabs_Item:Dock( LEFT )
		self.DPanelList_Tabs_Item:SetToolTip(doItemName .. " | " .. doItemDesc)
		self.DPanelList_Tabs_Item:DockMargin(15, 0, CVar_ObjSpacing or 5, 0)

		local mat = false
		if v.icon and GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1 then
			mat = Material( v.icon, "noclamp smooth" )
			self.DPanelList_Tabs_Item:SetSize( self.DPanelList_Tabs_Item:GetWide() + 32, self.DPanelList_Tabs_Item:GetTall() )
		elseif v.icon and GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 0 then
			mat = Material( v.icon, "noclamp smooth" )
			self.DPanelList_Tabs_Item:SetSize( 64, self.DPanelList_Tabs_Item:GetTall() )
		end

		self.DPanelList_Tabs_Item.Paint = function( self, w, h )

			local ColorText = CVar_ColorText or Color( 255, 255, 255, 255 )
            local ColorImage = CVar_ColorImage or Color( 255, 255, 255, 255 )
			local ColorButton = CVar_ColorButton or Color( 255, 255, 255, 255 )
			local ColorHover = CVar_ColorButtonHover or Color( 255, 255, 255, 255 )

			if v.panel == "Amethyst_Tab_Jobs" then
				if not Amethyst.HasJobs() then
					ColorText = Color(CVar_ColorText.r, CVar_ColorText.g, CVar_ColorText.b, 20)
					ColorImage = Color(CVar_ColorImage.r, CVar_ColorImage.g, CVar_ColorImage.b, 20)
					ColorButton = Color(ColorButton.r, ColorButton.g, ColorButton.b, 20)
				end
			end

			if v.panel == "Amethyst_Tab_Ammo" then
				if not Amethyst.HasAmmo() then
					ColorText = Color(CVar_ColorText.r, CVar_ColorText.g, CVar_ColorText.b, 20)
					ColorImage = Color(CVar_ColorImage.r, CVar_ColorImage.g, CVar_ColorImage.b, 20)
					ColorButton = Color(ColorButton.r, ColorButton.g, ColorButton.b, 20)
				end
			end

			if v.panel == "Amethyst_Tab_Entities" then
				if not Amethyst.HasEntities() then
					ColorText = Color(CVar_ColorText.r, CVar_ColorText.g, CVar_ColorText.b, 20)
					ColorImage = Color(CVar_ColorImage.r, CVar_ColorImage.g, CVar_ColorImage.b, 20)
					ColorButton = Color(ColorButton.r, ColorButton.g, ColorButton.b, 20)
				end
			end

			if v.panel == "Amethyst_Tab_Weapons" then
				if not Amethyst.HasWeapons() then
					ColorText = Color(CVar_ColorText.r, CVar_ColorText.g, CVar_ColorText.b, 20)
					ColorImage = Color(CVar_ColorImage.r, CVar_ColorImage.g, CVar_ColorImage.b, 20)
					ColorButton = Color(ColorButton.r, ColorButton.g, ColorButton.b, 20)
				end
			end

			if v.panel == "Amethyst_Tab_Shipments" then
				if not Amethyst.HasShipments() then
					ColorText = Color(CVar_ColorText.r, CVar_ColorText.g, CVar_ColorText.b, 20)
					ColorImage = Color(CVar_ColorImage.r, CVar_ColorImage.g, CVar_ColorImage.b, 20)
					ColorButton = Color(ColorButton.r, ColorButton.g, ColorButton.b, 20)
				end
			end

			if v.panel == "Amethyst_Tab_Food" then
                if not Amethyst.HasFood() then
					return
				end
			end

			if v.panel == "Amethyst_Tab_Vehicles" then
				local doVehicleCount = table.Count( CustomVehicles )
				if doVehicleCount > 0 then
					if doVehicleCount and not Amethyst.HasVehicles() then
						ColorText = Color(CVar_ColorText.r, CVar_ColorText.g, CVar_ColorText.b, 20)
						ColorImage = Color(CVar_ColorImage.r, CVar_ColorImage.g, CVar_ColorImage.b, 20)
						ColorButton = Color(ColorButton.r, ColorButton.g, ColorButton.b, 20)
					elseif not CustomVehicles then
						return
					end
				else
					return
				end
			end

			if GetConVar("amethyst_m_compactmode_textwbuttons_enabled"):GetInt() == 1 and mat then

				surface.SetDrawColor( ColorButton )
				surface.SetMaterial( mat )
				surface.DrawTexturedRect( 5, self:GetTall() / 2 - 12, 24, 24 )

				draw.SimpleText( string.upper( v.name ), "Amethyst.Font.TabName", 40, self:GetTall() / 2, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

				local fetchOrgSize = sizex + 15
				if self:GetWide() != fetchOrgSize then
					self:SetSize( sizex + 45, 25 )
				end

			elseif GetConVar("amethyst_m_compactmode_textwbuttons_enabled"):GetInt() == 0 and mat then

				surface.SetDrawColor( ColorButton )
				surface.SetMaterial( mat )
				surface.DrawTexturedRect( 5, self:GetTall() / 2 - 12, 24, 24 )

				if self:GetWide() != "30" then
					self:SetSize( 30, 25 )
				end

			else

				draw.SimpleText( string.upper( v.name ), "Amethyst.Font.TabName", 40, self:GetTall() / 2, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

			end

			if self.hover then
				draw.RoundedBox(0, 0, h-2, w, 4, ColorHover)
			end

			if self.active then
				draw.RoundedBox(0, 0, h-2, w, 4, ColorHover)
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

			if v.panel == "Amethyst_Tab_Jobs" then
				if not Amethyst.HasJobs() then return end
			end

			if v.panel == "Amethyst_Tab_Ammo" then
				if not Amethyst.HasAmmo() then return end
			end

			if v.panel == "Amethyst_Tab_Entities" then
				if not Amethyst.HasEntities() then return end
			end

			if v.panel == "Amethyst_Tab_Weapons" then
				if not Amethyst.HasWeapons() then return end
			end

			if v.panel == "Amethyst_Tab_Shipments" then
				if not Amethyst.HasShipments() then return end
			end

			if v.panel == "Amethyst_Tab_Food" then
				if not Amethyst.HasFood() then
					return
				end
			end

			if v.panel == "Amethyst_Tab_Vehicles" then
				if not Amethyst.HasVehicles() then
					return
				end
			end

			for _, button in pairs(AmethystTabsList) do
				button.active = false
			end

			self.active = true

			PanelRightFill:Clear(true)
			vgui.Create(v.panel, PanelRightFill)
		end
		table.insert(AmethystTabsList, self.DPanelList_Tabs_Item)
	end

end
vgui.Register("Amethyst_STab_Shop_C", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/