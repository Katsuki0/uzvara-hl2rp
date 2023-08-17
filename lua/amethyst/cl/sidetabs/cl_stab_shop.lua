/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


local PANEL = {}

function PANEL:Init()

    Amethyst.Init = self
    Amethyst.Init:Dock(FILL)
    Amethyst.Init:DockMargin(0,0,0,0)
    Amethyst.Init.Paint = function(self, w, h) end

    local CVar_ColorText 		= Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt())
    local CVar_ColorButton 		= Color( GetConVar("amethyst_m_stabs_button_scolor_red"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_green"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_alpha"):GetInt() )
    local CVar_ColorImage 		= Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt())
	local CVar_ColorButtonHover = Color(GetConVar("amethyst_m_stabs_button_hcolor_red"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_green"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_alpha"):GetInt())
	local CVar_ObjHeight 		= GetConVar("amethyst_m_stabs_objheight"):GetInt() or 45

	local AmethystTabsList = {}
	for k, v in pairs(Amethyst.Settings.Tabs) do

		if not v.enabled then continue end
		if (v.compactOnly and GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 0) then continue end

		self.DPanelList_Tabs_Item = vgui.Create("DButton", Amethyst.Init )
		self.DPanelList_Tabs_Item:Dock(TOP)
		self.DPanelList_Tabs_Item:DockMargin(0, 0, 0, 5)
		self.DPanelList_Tabs_Item:SetTall(CVar_ObjHeight or 45)
		self.DPanelList_Tabs_Item:SetText("")
		self.DPanelList_Tabs_Item.Paint = function(self, w, h)
			local ColorText = CVar_ColorText or Color( 255, 255, 255, 255 )
			local ColorButton = CVar_ColorButton or Color( 255, 255, 255, 255 )
			local ColorImage = CVar_ColorImage or Color( 255, 255, 255, 255 )

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

			mat = Material(v.icon, "noclamp smooth")
			surface.SetMaterial(mat)
			surface.SetDrawColor(ColorImage)
			surface.DrawTexturedRect(15, self:GetTall() / 2 - 12, 24, 24)
			draw.SimpleText(v.name, "Amethyst.Font.TabName", 55, self:GetTall() / 2 - 7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.desc, "Amethyst.Font.TabDesc", 55, self:GetTall() / 2 + 7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			if self.hover then
				draw.RoundedBox(0, 0, 0, 7, h, ColorButton)
			end
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

			Amethyst.RemoveTimers()

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
vgui.Register("Amethyst_STab_Shop", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/