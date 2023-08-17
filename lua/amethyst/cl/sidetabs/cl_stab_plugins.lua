/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

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

    self.DScroll_Plugins = vgui.Create( "DScrollPanel", Amethyst.Init )
    self.DScroll_Plugins.VBar:ConstructScrollbarGUI()
    self.DScroll_Plugins:Dock(FILL)
    self.DScroll_Plugins:DockPadding(6, 0, 0, 0)
    self.DScroll_Plugins:DockMargin(0, 0, 0, 0)
    self.DScroll_Plugins.Paint = function(self, w, h) end

    local CVar_ColorText           = Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt())
    local CVar_ColorButton         = Color( GetConVar("amethyst_m_stabs_button_scolor_red"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_green"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_button_scolor_alpha"):GetInt() )
    local CVar_ColorImage          = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt())
	local CVar_ColorButtonHover    = Color(GetConVar("amethyst_m_stabs_button_hcolor_red"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_green"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_button_hcolor_alpha"):GetInt())
	local CVar_ObjHeight           = GetConVar("amethyst_m_stabs_objheight"):GetInt() or 45

    local PluginsInstalled = {}
    for k, v in pairs( Amethyst.Plugins ) do
        if v.Parameters and ( type(v.Parameters) == "table" ) then
            PluginsInstalled[v.Parameters.id] =
            {
                panel = v.Panel,
                onClick = v.ActionDoClick,
                isExternal = v.Parameters.isExternal
            }
        end
    end

    local official_GetTotal = table.Count(Amethyst.PluginsList)
    local count_OfficialPlugins = 0
    for k, v in pairs( Amethyst.PluginsList ) do
        if not PluginsInstalled[v.Parameters.id] then continue end
        count_OfficialPlugins = count_OfficialPlugins + 1
    end

    self.DPanel_T_L_Container = vgui.Create("DPanel", self.DScroll_Plugins)
    self.DPanel_T_L_Container:Dock(TOP)
    self.DPanel_T_L_Container:DockMargin(0, 0, 0, 0)
    self.DPanel_T_L_Container:SetTall(30)
    self.DPanel_T_L_Container.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 2))
        draw.RoundedBox(4, w - 40, h / 2 - 8, 30, 16, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), 200))
        draw.SimpleText("Official Plugins", "Amethyst.Font.Plugins_Title", 13, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(count_OfficialPlugins .. "/" .. official_GetTotal or "0", "Amethyst.Font.Plugins_Count", w - 25, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

	local PluginsList = {}
	for k, v in pairs( Amethyst.PluginsList ) do

        local assocTable = PluginsInstalled[v.Parameters.id]

		self.DPanelList_Tabs_Item = vgui.Create("DButton", self.DScroll_Plugins )
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

            if not PluginsInstalled[v.Parameters.id] then
                ColorText = Color(CVar_ColorText.r, CVar_ColorText.g, CVar_ColorText.b, 20)
                ColorImage = Color(CVar_ColorImage.r, CVar_ColorImage.g, CVar_ColorImage.b, 20)
                ColorButton = Color(ColorButton.r, ColorButton.g, ColorButton.b, 20)
            end

			mat = Material(v.Icon or "", "noclamp smooth")
			surface.SetMaterial(mat)
			surface.SetDrawColor(ColorImage)
			surface.DrawTexturedRect(15, self:GetTall() / 2 - 12, 24, 24)
			draw.SimpleText(v.Name, "Amethyst.Font.TabName", 55, self:GetTall() / 2 - 7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(v.Desc, "Amethyst.Font.TabDesc", 55, self:GetTall() / 2 + 7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

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

			if assocTable and assocTable.onClick then
				assocTable.onClick()
			end

			for _, button in pairs( PluginsList ) do
				button.active = false
			end

			self.active = true

            if not PluginsInstalled[v.Parameters.id] then
                gui.OpenURL( v.PurchaseURL )
				return
            end

	        if IsValid( PanelRightFill ) and assocTable.panel then
	        	timer.Create("amethyst.achievements.reopen", 0.3, 1, function()
	        		if timer.Exists("amethyst.achievements.hoverdesc") then timer.Remove("amethyst.achievements.hoverdesc") end
					PanelRightFill:Clear()
					vgui.Create(assocTable.panel, PanelRightFill)
				end)
			end

		end
		table.insert(PluginsList, self.DPanelList_Tabs_Item)

	end

    local count_OtherPlugins = 0
    for k, v in pairs( Amethyst.Plugins ) do
        if Amethyst.PluginsList[v.Parameters.id] then continue end
        count_OtherPlugins = count_OtherPlugins + 1
    end

    self.DPanel_T_L_Container = vgui.Create("DPanel", self.DScroll_Plugins)
    self.DPanel_T_L_Container:Dock(TOP)
    self.DPanel_T_L_Container:DockMargin(0, 0, 0, 0)
    self.DPanel_T_L_Container:SetTall(30)
    self.DPanel_T_L_Container.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 2))
        draw.RoundedBox(4, w - 40, h / 2 - 8, 30, 16, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), 200))
        draw.SimpleText("3rd Party Plugins", "Amethyst.Font.Plugins_Title", 13, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(count_OtherPlugins or "0", "Amethyst.Font.Plugins_Count", w - 25, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if count_OtherPlugins > 0 then
        local ThirdParty_PluginsList = {}
    	for k, v in pairs( Amethyst.Plugins ) do

            local assocTable = PluginsInstalled[v.Parameters.id]

            -- Do not load plugins that are marked as official
            if Amethyst.PluginsList[v.Parameters.id] then continue end

    		self.DPanelList_Tabs_Item = vgui.Create("DButton", self.DScroll_Plugins )
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

                if not PluginsInstalled[v.Parameters.id] then
                    ColorText = Color(CVar_ColorText.r, CVar_ColorText.g, CVar_ColorText.b, 20)
                    ColorImage = Color(CVar_ColorImage.r, CVar_ColorImage.g, CVar_ColorImage.b, 20)
                    ColorButton = Color(ColorButton.r, ColorButton.g, ColorButton.b, 20)
                end

    			mat = Material(v.Icon or "", "noclamp smooth")
    			surface.SetMaterial(mat)
    			surface.SetDrawColor(ColorImage)
    			surface.DrawTexturedRect(15, self:GetTall() / 2 - 12, 24, 24)
    			draw.SimpleText(v.Name, "Amethyst.Font.TabName", 55, self:GetTall() / 2 - 7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    			draw.SimpleText(v.Desc, "Amethyst.Font.TabDesc", 55, self:GetTall() / 2 + 7, ColorText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

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

    			if assocTable and assocTable.onClick then
    				assocTable.onClick()
    			end

    			for _, button in pairs( ThirdParty_PluginsList ) do
    				button.active = false
    			end

    			self.active = true

                if not PluginsInstalled[v.Parameters.id] then
                    gui.OpenURL( v.PurchaseURL )
    				return
                end

    	        if IsValid( PanelRightFill ) and assocTable.panel then
    	        	timer.Create("amethyst.achievements.reopen", 0.3, 1, function()
    	        		if timer.Exists("amethyst.achievements.hoverdesc") then timer.Remove("amethyst.achievements.hoverdesc") end
    					PanelRightFill:Clear()
    					vgui.Create(assocTable.panel, PanelRightFill)
    				end)
    			end

    		end
    		table.insert(ThirdParty_PluginsList, self.DPanelList_Tabs_Item)

    	end
    else
        self.DPanel_ThirdPP_Container = vgui.Create("DPanel", self.DScroll_Plugins)
        self.DPanel_ThirdPP_Container:Dock(TOP)
        self.DPanel_ThirdPP_Container:DockMargin(0, 0, 0, 0)
        self.DPanel_ThirdPP_Container:SetTall(30)
        self.DPanel_ThirdPP_Container.Paint = function(self, w, h)
            draw.SimpleText("No Plugins Found", "Amethyst.Font.No_Plugins_Found", w / 2, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

end
vgui.Register("Amethyst_STab_Plugins", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/