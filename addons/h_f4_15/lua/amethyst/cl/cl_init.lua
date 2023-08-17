/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/

--------------------------------------------------------------------------------------------------]]

Amethyst = Amethyst or {}
Amethyst.Settings = Amethyst.Settings or {}

local cvar_th
local cvar_th_s
local ply_theme_table
local ply_manifest_table

local PANEL = {}

function PANEL:Init()

	--[[ -----------------------------------------------------------------------------------------------
	Bokeh effect for main panel background.
	--------------------------------------------------------------------------------------------------]]

	local ffxBokeh = {}
	local doBokehMultiplier = 25

	if ( doBokehMultiplier >= 1 ) then
		local wsize = ScrW()
		local hsize = ScrH()

		for n = 1, doBokehMultiplier do
			local getColorR, getColorG, getColorB = math.random(0, 255), math.random(0, 255), math.random(0, 255)
			ffxBokeh[n] =
			{
				xpos = math.random(0, wsize),
				ypos = math.random(-hsize, hsize),
				size = math.random(50, 200),
				speed = math.random(20, 80),
				area = math.Round(math.random(-50, 150)),
				color = Color(getColorR, getColorG, getColorB)
			}
		end
	end

	--[[ -----------------------------------------------------------------------------------------------
	Screen calculations -- because anything over 900 seems to start making things have way too much room.
	--------------------------------------------------------------------------------------------------]]

	local doScreenH = .8
	local doScreenW = .9
	if ScrH() >= 900 then
		doScreenH = .7
		doScreenW = .8
	end

    --[[ -----------------------------------------------------------------------------------------------
    Fetch player theme
    --------------------------------------------------------------------------------------------------]]

    local function FetchTheme()
        cvar_th     = GetConVar("amethyst_theme")                   -- Fetch current Theme Convar
        cvar_th_s   = string.lower(cvar_th:GetString())             -- Fetch current convar and lower-case it

        if (cvar_th_s == "failsafe" or not Amethyst.Theme[cvar_th_s]) and (Amethyst.Theme["default"]) then
            cvar_th:SetString( "default" )
            cvar_th_s = "default"
        end

        if not Amethyst.Theme[cvar_th_s] and not Amethyst.Theme["default"] then
            cvar_th:SetString( "failsafe" )
            cvar_th_s = "failsafe"
        end

        ply_theme_table             = Amethyst.Theme[cvar_th_s]                 -- Assign theme table
        ply_manifest_table          = Amethyst.Theme.Manifest[cvar_th_s]        -- Assign manifest table
        ply_livewallpapers_table    = Amethyst.Theme.LiveWallpapers[cvar_th_s]  -- Assign live wallpapers table
        ply_backgrounds_table       = Amethyst.Theme.Backgrounds[cvar_th_s]     -- Assign backgrounds table
    end
    FetchTheme()

	--[[ -----------------------------------------------------------------------------------------------
	Initiate Amethyst panels
	--------------------------------------------------------------------------------------------------]]

    Amethyst.PanelMenu = self

    self.w, self.h = ScrW(), ScrH()
    self:SetSize(self.w, self.h)
    self:Center()
    self:MakePopup()
    self.Paint = function(self, w, h)
    	if GetConVar("amethyst_m_dim_enabled"):GetInt() == 1 then
	    	draw.Amethyst_DrawBlur(self)
	        draw.RoundedBox( 0, 0, 0, w, h, Color( GetConVar("amethyst_m_dcolor_red"):GetInt(), GetConVar("amethyst_m_dcolor_green"):GetInt(), GetConVar("amethyst_m_dcolor_blue"):GetInt(), GetConVar("amethyst_m_dcolor_alpha"):GetInt() ) )
    	end
	end

    self.DPanel_Init = vgui.Create("DPanel", self)
    self.DPanel_Init:SetSize(ScrW() * doScreenW, ScrH() * doScreenH)
    self.DPanel_Init:Center()
    self.DPanel_Init.Paint = function(self, w, h) end

    if GetConVar("amethyst_m_background_style"):GetString() == "Live" or "Images" then
        self.dhtmlBackground = vgui.Create( "DHTML", self.DPanel_Init )
        self.dhtmlBackground:SetSize( ScrW(), ScrH() )
        self.dhtmlBackground:SetScrollbars( false )
        self.dhtmlBackground:SetVisible( true )
        if ( GetConVar("amethyst_m_background_style"):GetString() == "Live" or GetConVar("amethyst_m_background_style"):GetString() == "Images" ) and ( ply_backgrounds_table or ply_livewallpapers_table ) then
            local sourceTable = ply_backgrounds_table
            if GetConVar("amethyst_m_background_style"):GetString() == "Live" then
                sourceTable = ply_livewallpapers_table
                self.dhtmlBackground:SetHTML(
                [[
                    <body style="overflow: hidden; height: 100%; width: 100%; margin:0px;">
                        <iframe width="100%" frameborder="0" height="100%" src="]] .. table.Random( sourceTable ) .. [["></iframe>
                    </body>
                ]])
            elseif GetConVar("amethyst_m_background_style"):GetString() == "Images" then
                self.dhtmlBackground:SetHTML(
                [[
                    <body style="overflow: hidden; height: 100%; width: 100%; margin:0px;">
                        <img width="100%" height="100%" src="]] .. table.Random( sourceTable ) .. [[">
                    </body>
                ]])
            end
        end
        self.dhtmlBackground.Paint = function( self, w, h ) end
    end

    self.DHTML_BackgroundFilter = vgui.Create( "DHTML", self.DPanel_Init )
    self.DHTML_BackgroundFilter:SetSize( ScrW(), ScrH() )
    self.DHTML_BackgroundFilter:SetScrollbars( false )
    self.DHTML_BackgroundFilter:SetVisible( true )
    self.DHTML_BackgroundFilter.Paint = function( self, w, h )
		draw.AmethystBox( 0, 0, w, h, Color(GetConVar("amethyst_m_primarycolor_red"):GetInt(), GetConVar("amethyst_m_primarycolor_green"):GetInt(), GetConVar("amethyst_m_primarycolor_blue"):GetInt(), GetConVar("amethyst_m_primarycolor_alpha"):GetInt()) or Color(0, 55, 79, 245) )

		if GetConVar("amethyst_m_bokeh_fx_enabled"):GetInt() == 1 then

			local fetchBokehType = GetConVar("amethyst_m_bokeh_style_enabled"):GetString()

			if fetchBokehType == "circles" then
				doMaterialImage = "amethyst/ffx/amethyst_ffx_circles.png"
			elseif fetchBokehType == "gradients" then
				doMaterialImage = "amethyst/ffx/amethyst_ffx_gradients.png"
			elseif fetchBokehType == "outlines" then
				doMaterialImage = "amethyst/ffx/amethyst_ffx_outlines.png"
			end
			surface.SetMaterial( Material( doMaterialImage or "amethyst/ffx/amethyst_ffx_circles.png", "noclamp smooth" ) )

			if ( table.Count(ffxBokeh) >= 1 ) then

				for n = 1, doBokehMultiplier do
					ffxBokeh[n].xpos = ffxBokeh[n].xpos + ( ffxBokeh[n].area * math.cos(0) / 50 )
					ffxBokeh[n].ypos = ffxBokeh[n].ypos + ( math.sin(0) / 40 + ffxBokeh[n].speed / 30 )

					if ffxBokeh[n].ypos > h then
						ffxBokeh[n].ypos = math.random(-50, 0)
						ffxBokeh[n].xpos = math.random(0, w)
					end
				end

				for n = 1, doBokehMultiplier do

					local doColorSepR = ffxBokeh[n].color.r
					local doColorSepG = ffxBokeh[n].color.g
					local doColorSepB = ffxBokeh[n].color.b
					local doColorSepA = GetConVar("amethyst_m_bokeh_alpha"):GetInt() or 5

					surface.SetDrawColor(Color(doColorSepR, doColorSepG, doColorSepB, doColorSepA) or Color(255,255,255,5))
					surface.DrawTexturedRect(ffxBokeh[n].xpos, ffxBokeh[n].ypos, ffxBokeh[n].size, ffxBokeh[n].size)

				end
			end

		end

    end

    self.DPanel_T_Spacer_001 = vgui.Create("DPanel", self.DPanel_Init)
    self.DPanel_T_Spacer_001:Dock(TOP)
    self.DPanel_T_Spacer_001:SetTall(GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2)
    self.DPanel_T_Spacer_001.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_outsideborder_color_red"):GetInt(), GetConVar("amethyst_m_outsideborder_color_green"):GetInt(), GetConVar("amethyst_m_outsideborder_color_blue"):GetInt(), GetConVar("amethyst_m_outsideborder_color_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

    self.DPanel_L_Spacer_001 = vgui.Create("DPanel", self.DPanel_Init)
    self.DPanel_L_Spacer_001:Dock(LEFT)
    self.DPanel_L_Spacer_001:SetWide(GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2)
    self.DPanel_L_Spacer_001.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_outsideborder_color_red"):GetInt(), GetConVar("amethyst_m_outsideborder_color_green"):GetInt(), GetConVar("amethyst_m_outsideborder_color_blue"):GetInt(), GetConVar("amethyst_m_outsideborder_color_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

    self.DPanel_R_Spacer_001 = vgui.Create("DPanel", self.DPanel_Init)
    self.DPanel_R_Spacer_001:Dock(RIGHT)
    self.DPanel_R_Spacer_001:SetWide(GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2)
    self.DPanel_R_Spacer_001.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_outsideborder_color_red"):GetInt(), GetConVar("amethyst_m_outsideborder_color_green"):GetInt(), GetConVar("amethyst_m_outsideborder_color_blue"):GetInt(), GetConVar("amethyst_m_outsideborder_color_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

    self.DPanel_B_Spacer_001 = vgui.Create("DPanel", self.DPanel_Init)
    self.DPanel_B_Spacer_001:Dock(BOTTOM)
    self.DPanel_B_Spacer_001:SetTall(GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2)
    self.DPanel_B_Spacer_001.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_outsideborder_color_red"):GetInt(), GetConVar("amethyst_m_outsideborder_color_green"):GetInt(), GetConVar("amethyst_m_outsideborder_color_blue"):GetInt(), GetConVar("amethyst_m_outsideborder_color_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

    if (GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 0 and GetConVar("amethyst_m_clock_enabled"):GetInt() == 0) then

        self.DPanel_Navigation = vgui.Create("amethyst.header", self.DPanel_Init )
        self.DPanel_Navigation:Dock(TOP)
        self.DPanel_Navigation:SetTall(60)
        self.DPanel_Navigation.Paint = function(self, w, h) end

        self.DPanel_T_Spacer_001 = vgui.Create("DPanel", self.DPanel_Init)
        self.DPanel_T_Spacer_001:Dock(TOP)
        self.DPanel_T_Spacer_001:SetTall(GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2)
        self.DPanel_T_Spacer_001.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
        end

    end

    if (GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1) then

        if GetConVar("amethyst_m_compactmode_showheader_enabled"):GetInt() == 1 then
            self.DPanel_CompactMenu_Header = vgui.Create("amethyst.header", self.DPanel_Init )
            self.DPanel_CompactMenu_Header:Dock(TOP)
            self.DPanel_CompactMenu_Header:SetTall(60)
            self.DPanel_CompactMenu_Header.Paint = function(self, w, h) end

            self.DPanel_T_Spacer_001 = vgui.Create("DPanel", self.DPanel_Init)
            self.DPanel_T_Spacer_001:Dock(TOP)
            self.DPanel_T_Spacer_001:SetTall(GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2)
            self.DPanel_T_Spacer_001.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
            end
        end

        self.DPanel_CompactMenu_Container = vgui.Create("DPanel", self.DPanel_Init )
        self.DPanel_CompactMenu_Container:Dock(TOP)
        self.DPanel_CompactMenu_Container:SetTall(45)
        self.DPanel_CompactMenu_Container.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_compactmode_menu_bcolor_red"):GetInt(), GetConVar("amethyst_m_compactmode_menu_bcolor_green"):GetInt(), GetConVar("amethyst_m_compactmode_menu_bcolor_blue"):GetInt(), GetConVar("amethyst_m_compactmode_menu_bcolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
        end

        self.DPanel_T_Spacer_001 = vgui.Create("DPanel", self.DPanel_Init)
        self.DPanel_T_Spacer_001:Dock(TOP)
        self.DPanel_T_Spacer_001:SetTall(GetConVar("amethyst_m_outsideborder_thickness"):GetInt() or 2)
        self.DPanel_T_Spacer_001.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
        end

        vgui.Create("Amethyst_STab_Shop_C", self.DPanel_CompactMenu_Container)

    end

    if (GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 0) then

        self.DPanel_L_Container = vgui.Create("DPanel", self.DPanel_Init)
        self.DPanel_L_Container:Dock(LEFT)
        self.DPanel_L_Container:DockMargin(0, 0, 0, 0)
        if ScrH() >= 900 then
        	self.DPanel_L_Container:SetWide(ScreenScale(80))
        else
        	self.DPanel_L_Container:SetWide(ScreenScale(100))
        end
        self.DPanel_L_Container.Paint = function(self, w, h)
            local GetValueData = GetConVar("amethyst_m_grid_background_enabled")
            if GetValueData:GetInt() == 1 then
                surface.SetDrawColor( Color( 5, 5, 5, 30 ) )
                surface.SetMaterial( Material( "amethyst/amethyst_gui_pattern.png", "noclamp smooth" ) )
                surface.DrawTexturedRectRotated( 100, 0, 1275, 333, 90 )
            end
        end

        if (GetConVar("amethyst_m_clock_enabled"):GetInt() == 1) then
            self.DPanel_T_L_Container = vgui.Create("DPanel", self.DPanel_L_Container)
            self.DPanel_T_L_Container:Dock(TOP)
            self.DPanel_T_L_Container:DockMargin(0, 0, 0, 0)
            self.DPanel_T_L_Container:SetTall(60)
            self.DPanel_T_L_Container.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 2))
                draw.SimpleText(GetGlobalString( "Atmos_Time" ) or "ERROR", "Amethyst.Font.Clock", w / 2, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            self.DPanel_T_R_Spacer_001 = vgui.Create("DPanel", self.DPanel_T_L_Container)
            self.DPanel_T_R_Spacer_001:Dock(RIGHT)
            self.DPanel_T_R_Spacer_001:SetWide(2)
            self.DPanel_T_R_Spacer_001.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
            end

            self.DPanel_T_T_Spacer_002 = vgui.Create("DPanel", self.DPanel_L_Container)
            self.DPanel_T_T_Spacer_002:Dock(TOP)
            self.DPanel_T_T_Spacer_002:SetTall(2)
            self.DPanel_T_T_Spacer_002.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
            end
        end

        self.DPanel_T_L_TabContainer = vgui.Create("DPanel", self.DPanel_L_Container)
        self.DPanel_T_L_TabContainer:Dock(TOP)
        self.DPanel_T_L_TabContainer:DockMargin(0,0,0,0)
        self.DPanel_T_L_TabContainer:SetTall(35)
        self.DPanel_T_L_TabContainer.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
        end

        self.DPanel_T_L_Spacer_001 = vgui.Create("DPanel", self.DPanel_T_L_TabContainer)
        self.DPanel_T_L_Spacer_001:Dock(RIGHT)
        self.DPanel_T_L_Spacer_001:SetWide(2)
        self.DPanel_T_L_Spacer_001.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
        end

        self.DPanel_T_L_Spacer_002 = vgui.Create("DPanel", self.DPanel_L_Container)
        self.DPanel_T_L_Spacer_002:Dock(TOP)
        self.DPanel_T_L_Spacer_002:SetTall(2)
        self.DPanel_T_L_Spacer_002.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
        end

    end

    self.DPanel_R_Container = vgui.Create("DPanel", self.DPanel_Init)
    self.DPanel_R_Container:Dock(FILL)
	self.DPanel_R_Container.Paint = function(self, w, h) end

	if (GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 0 and GetConVar("amethyst_m_clock_enabled"):GetInt() == 1) then

		self.DPanel_Navigation = vgui.Create("amethyst.header", self.DPanel_R_Container )
		self.DPanel_Navigation:Dock(TOP)
		self.DPanel_Navigation:SetTall(60)
		self.DPanel_Navigation.Paint = function(self, w, h) end

        self.DPanel_T_R_ContainerDesc = vgui.Create("DPanel", self.DPanel_R_Container)
		self.DPanel_T_R_ContainerDesc:Dock(TOP)
		self.DPanel_T_R_ContainerDesc:SetTall(2)
		self.DPanel_T_R_ContainerDesc.Paint = function(self, w, h)
			draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
		end

	end

	PanelRightFill = vgui.Create("DPanel", self.DPanel_R_Container)
	PanelRightFill:Dock(FILL)
	PanelRightFill.Paint = function(self, w, h) end
    for k, v in pairs(Amethyst.Settings.Tabs) do
        if v.enabled and v.onLoadInit then
            if v.panel == "Amethyst_Tab_Dashboard" then
                Amethyst:UpdateStats()
            end
            if v.panel == "Amethyst_Tab_Logs" then
                Amethyst:UpdateLogs()
            end
            vgui.Create(v.panel, PanelRightFill)
        end
    end

    if (GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 0) then

    	self.DPanelList_Tabs = vgui.Create("DPanelList", self.DPanel_L_Container)
    	self.DPanelList_Tabs:Dock(FILL)
    	self.DPanelList_Tabs.Paint = function(self, w, h) end

    	self.DPanelList_Tabs_Content = vgui.Create("DPanelList", self.DPanelList_Tabs)
    	self.DPanelList_Tabs_Content:Dock(FILL)
    	self.DPanelList_Tabs_Content.Paint = function(self, w, h) end

        self.DPanel_T_R_Spacer_001 = vgui.Create("DPanel", self.DPanelList_Tabs)
        self.DPanel_T_R_Spacer_001:Dock(RIGHT)
        self.DPanel_T_R_Spacer_001:SetWide(2)
        self.DPanel_T_R_Spacer_001.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
        end

        local countTabsTotal = 0
        for k, v in pairs(Amethyst.Settings.SideTabs) do
            if not v.Enabled then continue end
            countTabsTotal = countTabsTotal + 1
        end

    	local AmethystSTabsList = {}
    	for k, v in pairs(Amethyst.Settings.SideTabs) do

            if not v.Enabled then continue end

            local defineWideL, defineWideS = 15, 19
            local defineWCirL, defineWCirS = 10, 11

            if countTabsTotal == 4 then
                defineWideL, defineWideS = 19, 22
                defineWCirL, defineWCirS = 12, 16
            elseif countTabsTotal == 3 then
                defineWideL, defineWideS = 24, 28
                defineWCirL, defineWCirS = 16, 22
            elseif countTabsTotal == 2 then
                defineWideL, defineWideS = 31, 38
                defineWCirL, defineWCirS = 26, 32
            elseif countTabsTotal == 1 then
                defineWideL, defineWideS = 50, 60
                defineWCirL, defineWCirS = 42, 52
            end

    		self.DPanelList_STabs_Item = vgui.Create("DButton", self.DPanel_T_L_TabContainer)
    		self.DPanelList_STabs_Item:Dock(LEFT)
    		self.DPanelList_STabs_Item:DockMargin(0,5,0,5)
    		self.DPanelList_STabs_Item:SetTall(35)
        	if ScrH() >= 900 then
    			self.DPanelList_STabs_Item:SetWide(ScreenScale(defineWideL))
    		else
    			self.DPanelList_STabs_Item:SetWide(ScreenScale(defineWideS))
    		end
    		self.DPanelList_STabs_Item:SetText("")
    		self.DPanelList_STabs_Item:SetTooltip(v.Desc or "")
    		self.DPanelList_STabs_Item.Paint = function(self, w, h)
    			local GetColorInner = Color(GetConVar("amethyst_m_stabs_icolor_red"):GetInt(), GetConVar("amethyst_m_stabs_icolor_green"):GetInt(), GetConVar("amethyst_m_stabs_icolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_icolor_alpha"):GetInt()) or Color( 97, 85, 105, 230 )
    			local GetColorOutline = Color(GetConVar("amethyst_m_stabs_outline_icolor_red"):GetInt(), GetConVar("amethyst_m_stabs_outline_icolor_green"):GetInt(), GetConVar("amethyst_m_stabs_outline_icolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_outline_icolor_alpha"):GetInt()) or Color ( 97, 85, 105, 230 )

    			if self.active then
    				GetColorInner = Color(GetConVar("amethyst_m_stabs_acolor_red"):GetInt(), GetConVar("amethyst_m_stabs_acolor_green"):GetInt(), GetConVar("amethyst_m_stabs_acolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_acolor_alpha"):GetInt()) or Color( 54, 158, 75, 255 )
    				GetColorOutline = Color(GetConVar("amethyst_m_stabs_outline_acolor_red"):GetInt(), GetConVar("amethyst_m_stabs_outline_acolor_green"):GetInt(), GetConVar("amethyst_m_stabs_outline_acolor_blue"):GetInt(), GetConVar("amethyst_m_stabs_outline_acolor_alpha"):GetInt()) or Color ( 29, 87, 40, 255 )
    			end

    			local y = h / 2
    			if ScrH() >= 900 then
    				draw.Amethyst_Circle(ScreenScale(defineWCirL), y, 10, 80, GetColorOutline)
    				draw.Amethyst_Circle(ScreenScale(defineWCirL), y, 9, 80, GetColorInner)
    			else
    				draw.Amethyst_Circle(ScreenScale(defineWCirS), y, 10, 80, GetColorOutline)
    				draw.Amethyst_Circle(ScreenScale(defineWCirS), y, 9, 80, GetColorInner)
    			end
    		end
    		self.DPanelList_STabs_Item.OnCursorEntered = function(self)
    			self.hover = true
    		end
    		self.DPanelList_STabs_Item.OnCursorExited = function(self)
    			self.hover = false
    		end

    		if k == 1 then
    			self.DPanelList_STabs_Item.active = true
    		end
    		self.DPanelList_STabs_Item.DoClick = function(what)

                Amethyst.RemoveTimers()

    			for _, button in pairs( AmethystSTabsList ) do
    				button.active = false
    			end

    			what.active = true

    			self.DPanelList_Tabs_Content:Remove()
    			if not IsValid( self.DPanelList_Tabs_Content ) then
    				self.DPanelList_Tabs_Content = vgui.Create("DPanelList", self.DPanelList_Tabs)
    				self.DPanelList_Tabs_Content:Dock(FILL)
    				self.DPanelList_Tabs_Content.Paint = function(self, w, h) end
    			end

    			vgui.Create(v.DoLoadPanel, self.DPanelList_Tabs_Content)

    		end
    		table.insert( AmethystSTabsList, self.DPanelList_STabs_Item )
    		if v.OnLoadInit then
    			vgui.Create( v.DoLoadPanel, self.DPanelList_Tabs_Content )
    		end

    	end

    end

	--[[ -----------------------------------------------------------------------------------------------
	Open all external links and text panels
	--------------------------------------------------------------------------------------------------]]

	function Amethyst:CommunityAction( resourceTitle, resourceData, resourceExternal, resourceTextOnly )

		if (resourceExternal and not resourceTextOnly) then
			gui.OpenURL( resourceData or "http://scriptfodder.com/" )
			return
		end

		if not resourceExternal then
			PanelRightFill:Clear(true)
		end

		if IsValid(self.PanelExternal) then self.PanelExternal:Remove() end

		self.PanelExternal = vgui.Create( "DPanel", PanelRightFill )
		self.PanelExternal:Dock(FILL)
		self.PanelExternal:DockMargin(0,0,0,0)
		self.PanelExternal.Paint = function( self, w, h ) end

		self.DPanel_SectionTop = vgui.Create("DPanel", self.PanelExternal)
		self.DPanel_SectionTop:Dock(TOP)
		self.DPanel_SectionTop:DockMargin(0, 0, 0, 0)
		self.DPanel_SectionTop:SetTall(35)
		self.DPanel_SectionTop.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
			draw.DrawText( string.upper(resourceTitle or Amethyst.Language["browser"] or "Browser"), "Amethyst.Font.SectionTitle", 23, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		end

		self.DPanel_SectionTop_Spacer = vgui.Create("DPanel", self.PanelExternal)
		self.DPanel_SectionTop_Spacer:Dock(TOP)
		self.DPanel_SectionTop_Spacer:SetTall(2)
		self.DPanel_SectionTop_Spacer.Paint = function(self, w, h)
		    draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
		end

		self.DPanel_P_Container = vgui.Create( "DPanel", self.PanelExternal )
		self.DPanel_P_Container:Dock(FILL)
		self.DPanel_P_Container:DockMargin(0,0,0,0)
		self.DPanel_P_Container.Paint = function( self, w, h )
            local AmethystBox = Color(GetConVar("amethyst_m_secondaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_alpha"):GetInt() )
            draw.AmethystBox( 0, 0, w, h, Color( AmethystBox.r, AmethystBox.g, AmethystBox.b, AmethystBox.a ) )
        end

        self.DPanel_BrowserInternal = vgui.Create( "DPanel", self.DPanel_P_Container )
        self.DPanel_BrowserInternal:Dock(FILL)
        self.DPanel_BrowserInternal:DockMargin(5,5,5,5)
        self.DPanel_BrowserInternal.Paint = function( self, w, h ) end

		if resourceTextOnly then

			self.DTextAnnEntry = vgui.Create( "DTextEntry", self.DPanel_BrowserInternal )
			self.DTextAnnEntry:SetMultiline( true )
			self.DTextAnnEntry:Dock(FILL)
			self.DTextAnnEntry:DockMargin(20, 20, 20, 20)
			self.DTextAnnEntry:SetDrawBackground( false )
			self.DTextAnnEntry:SetEnabled( true )
			self.DTextAnnEntry:SetVerticalScrollbarEnabled( true )
			self.DTextAnnEntry:SetFont( "Amethyst.Font.ExternalText" )
			self.DTextAnnEntry:SetText( resourceData )
			self.DTextAnnEntry:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color(255, 255, 255, 255) )
			self.DTextAnnEntry:SetEditable( true )

		else

			self.DHTMLWindow = vgui.Create( "HTML", self.DPanel_BrowserInternal )
			self.DHTMLWindow:SetSize( ScrW() - 200, 300 )
			self.DHTMLWindow:DockMargin( 10, 10, 10, 10 )
			self.DHTMLWindow:Dock( FILL )

			self.DHTMLControlsBar = vgui.Create( "DHTMLControls", self.DPanel_BrowserInternal )
			self.DHTMLControlsBar:Dock( TOP )
			self.DHTMLControlsBar:SetWide( ScrW() - 200 )
			self.DHTMLControlsBar:SetPos( 0, 0 )
			self.DHTMLControlsBar:SetHTML( self.DHTMLWindow )
			self.DHTMLControlsBar.AddressBar:SetText( resourceData or Amethyst.Script.Website )

			self.DHTMLWindow:MoveBelow( self.DHTMLControlsBar )
			self.DHTMLWindow:OpenURL( resourceData or Amethyst.Script.Website )

		end

	end

	--[[ -----------------------------------------------------------------------------------------------
	UI for Streamers feature (since v1.3.0)
	--------------------------------------------------------------------------------------------------]]

	function Amethyst:StreamersAction( tblStreamers )

		if IsValid(self.PanelExternal) then self.PanelExternal:Remove() end

		self.PanelExternal = vgui.Create( "DPanel", PanelRightFill )
		self.PanelExternal:Dock(FILL)
		self.PanelExternal:DockMargin(0,0,0,0)
		self.PanelExternal.Paint = function( self, w, h ) end

		self.DPanel_SectionTop = vgui.Create("DPanel", self.PanelExternal)
		self.DPanel_SectionTop:Dock(TOP)
		self.DPanel_SectionTop:DockMargin(0, 0, 0, 0)
		self.DPanel_SectionTop:SetTall(35)
		self.DPanel_SectionTop.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
			draw.DrawText( string.upper(resourceTitle or "Community Streamers"), "Amethyst.Font.SectionTitle", 23, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		end

		self.DPanel_SectionTop_Spacer = vgui.Create("DPanel", self.PanelExternal)
		self.DPanel_SectionTop_Spacer:Dock(TOP)
		self.DPanel_SectionTop_Spacer:SetTall(2)
		self.DPanel_SectionTop_Spacer.Paint = function(self, w, h)
		    draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
		end

		self.DPanel_P_Container = vgui.Create( "DPanel", self.PanelExternal )
		self.DPanel_P_Container:Dock(FILL)
		self.DPanel_P_Container:DockMargin(0,0,0,0)
		self.DPanel_P_Container.Paint = function( self, w, h )
            local AmethystBox = Color(GetConVar("amethyst_m_secondaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_alpha"):GetInt() )
            draw.AmethystBox( 0, 0, w, h, Color( AmethystBox.r, AmethystBox.g, AmethystBox.b, AmethystBox.a ) )
        end

        self.DPanel_BrowserInternal = vgui.Create( "DPanel", self.DPanel_P_Container )
        self.DPanel_BrowserInternal:Dock(FILL)
        self.DPanel_BrowserInternal:DockMargin(5,5,5,5)
        self.DPanel_BrowserInternal.Paint = function( self, w, h ) end

		self.IconLayout_Streamers = vgui.Create( "DIconLayout", self.DPanel_BrowserInternal )
	    self.IconLayout_Streamers:Dock(FILL)
		self.IconLayout_Streamers:DockMargin(18,20,0,0)
	    self.IconLayout_Streamers:SetSpaceY( ScreenScale(5) )
	    self.IconLayout_Streamers:SetSpaceX( ScreenScale(5) )
	    self.IconLayout_Streamers:SetVisible( true )
		self.IconLayout_Streamers.Paint = function(self, w, h)

		end

		for k, v in pairs( tblStreamers ) do

			if not v.Enabled then continue end

			self.DPanel_Streamer_Container = vgui.Create("DButton", self.IconLayout_Streamers)
			self.DPanel_Streamer_Container:SetWide( ScreenScale( 204 ) )
			self.DPanel_Streamer_Container:SetTall( 100 )
	    	self.DPanel_Streamer_Container:DockMargin( 20, 5, 5, 5 )
			self.DPanel_Streamer_Container:SetText("")
			self.DPanel_Streamer_Container.Paint = function(self, w, h)

				local colorMain = Color(GetConVar("amethyst_m_primarycolor_red"):GetInt(), GetConVar("amethyst_m_primarycolor_green"):GetInt(), GetConVar("amethyst_m_primarycolor_blue"):GetInt(), GetConVar("amethyst_m_primarycolor_alpha"):GetInt())
				local colorBorder = Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt())

				if self:IsHovered() or self:IsDown() then
					colorMain = Color(GetConVar("amethyst_m_primarycolor_red"):GetInt(), GetConVar("amethyst_m_primarycolor_green"):GetInt(), GetConVar("amethyst_m_primarycolor_blue"):GetInt(), GetConVar("amethyst_m_primarycolor_alpha"):GetInt() - 100)
					colorBorder = Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt() + 255, GetConVar("amethyst_m_primarybordercolor_green"):GetInt() + 255, GetConVar("amethyst_m_primarybordercolor_blue"):GetInt() + 255, GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt() - 0)
				end

				draw.AmethystOutlinedBox( 0, 0, w, h, colorMain, colorBorder )

				draw.RoundedBox( 0, 0, 0, 80, 100, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
				surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), 5) or Color( 255, 255, 255, 255 ) )
				surface.SetMaterial( Material( v.BgImage, "noclamp smooth" ) )
				surface.DrawTexturedRect( w - 100, -10, 120, 120 )

			end
			self.DPanel_Streamer_Container.DoClick = function()
				gui.OpenURL( v.Link or "https://www.twitch.tv/videos/127631387" )
			end

			self.DPanel_Streamer_Photo = vgui.Create( "DPanel", self.DPanel_Streamer_Container )
			self.DPanel_Streamer_Photo:Dock( LEFT )
			self.DPanel_Streamer_Photo:DockMargin(5, 5, 5, 5)
			self.DPanel_Streamer_Photo:SetWide(70)
			self.DPanel_Streamer_Photo.Paint = function( self, w, h )
				surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
				surface.SetMaterial( Material( v.Image, "noclamp smooth" ) )
				surface.DrawTexturedRect( 0, 0, 70, 95 )
			end

            self.DLabel_Streamer_Name = vgui.Create("DLabel", self.DPanel_Streamer_Container)
            self.DLabel_Streamer_Name:Dock(TOP)
            self.DLabel_Streamer_Name:DockMargin(5, 0, 0, 0)
            self.DLabel_Streamer_Name:SetFont("Amethyst.Font.Streamers.Name")
            self.DLabel_Streamer_Name:SetTextColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or  Color( 255, 255, 255, 255 ))
            self.DLabel_Streamer_Name:SetText("")
            self.DLabel_Streamer_Name:SetTall(35)
            self.DLabel_Streamer_Name.Paint = function( self, w, h )
                draw.SimpleText(v.Name or "", "Amethyst.Font.Streamers.Name", 0, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or  Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
            end

			self.DTextEntry_T_HC_Desc = vgui.Create( "DTextEntry", self.DPanel_Streamer_Container )
		    self.DTextEntry_T_HC_Desc:Dock( FILL )
		    self.DTextEntry_T_HC_Desc:DockMargin(3,0,0,0)
			self.DTextEntry_T_HC_Desc:SetWide(ScreenScale(210))
		    self.DTextEntry_T_HC_Desc:SetDrawBackground( false )
		    self.DTextEntry_T_HC_Desc:SetText( v.Desc or "Oh Snap! No Description Available" )
		    self.DTextEntry_T_HC_Desc:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or  Color( 255, 255, 255, 255 ) )
		    self.DTextEntry_T_HC_Desc:SetFont("Amethyst.Font.SettingsHelpDesc")
		    self.DTextEntry_T_HC_Desc:SetMultiline(true)

	    end

	end

end

function PANEL:OnKeyCodePressed(keyCode)
    if keyCode == KEY_F4 or keyCode == KEY_F then
        DarkRP.toggleF4Menu()
    end
end
vgui.Register("AmethystPanel", PANEL, "DPanel")

function Amethyst:Activate(keyCode)
    DarkRP.toggleF4Menu()
end
concommand.Add("amethyst", Amethyst.Activate)

hook.Add("InitPostEntity", "AmethystPanel", function()

    Amethyst.Panel = nil

    function DarkRP.openF4Menu()
        if Amethyst.PanelMenu and IsValid(Amethyst.PanelMenu) then
            if Amethyst.Settings.InitRegenPanel then
                Amethyst.PanelMenu = vgui.Create("AmethystPanel")
            else
                Amethyst.PanelMenu:Show()
            end

            Amethyst.PanelMenu:InvalidateLayout()
        else
			Amethyst.PanelMenu = vgui.Create("AmethystPanel")
		end
		if IsValid(PanelRightFill) and (IsValid(Amethyst.TabHome) and Amethyst.TabHome:IsVisible()) then
			Amethyst:UpdateStats()
		end
    end

    function DarkRP.closeF4Menu()
        if Amethyst.PanelMenu then
            Amethyst.RemoveTimers()
            if Amethyst.Settings.InitRegenPanel then
                Amethyst.PanelMenu:Remove()
            else
                Amethyst.PanelMenu:Hide()
            end
        end
    end

    function DarkRP.toggleF4Menu()
        if not IsValid(Amethyst.PanelMenu) or not Amethyst.PanelMenu:IsVisible() then
            DarkRP.openF4Menu()
        else
            DarkRP.closeF4Menu()
        end
    end

    GAMEMODE.ShowSpare2 = DarkRP.toggleF4Menu

end)

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/