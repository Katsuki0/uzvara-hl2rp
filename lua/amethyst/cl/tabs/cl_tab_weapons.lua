/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


local PANEL = {}

function PANEL:Init()

	local doHeightCalc = 70
	local doWidthCalc = ScreenScale(169)
	if GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1 then
		doWidthCalc = ScreenScale(207)
	end
	if ScrH() >= 900 then
		doWidthCalc = ScreenScale(160)
		if GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1 then
			doWidthCalc = ScreenScale(187)
		end
	end
	local doSwitchColors = Color(255, 255, 255, 50)
	local doFetchCategories = DarkRP.getCategories().weapons

	--[[ -----------------------------------------------------------------------------------------------
	COLOR ASSOCIATED CONVARS

	Putting these in Panel.Paint will cause fps drops -- so let's define them here, and find a better
	method later.
	--------------------------------------------------------------------------------------------------]]

	local DrawPrimaryColor = Color(GetConVar("amethyst_g_primarycolor_red"):GetInt(), GetConVar("amethyst_g_primarycolor_green"):GetInt(), GetConVar("amethyst_g_primarycolor_blue"):GetInt(), GetConVar("amethyst_g_primarycolor_alpha"):GetInt())
	local DrawSecondaryColor = Color(GetConVar("amethyst_g_secondarycolor_red"):GetInt(), GetConVar("amethyst_g_secondarycolor_green"):GetInt(), GetConVar("amethyst_g_secondarycolor_blue"):GetInt(), GetConVar("amethyst_g_secondarycolor_alpha"):GetInt())
	local DrawBoxTextColor = Color(GetConVar("amethyst_g_box_tcolor_red"):GetInt(), GetConVar("amethyst_g_box_tcolor_green"):GetInt(), GetConVar("amethyst_g_box_tcolor_blue"):GetInt(), GetConVar("amethyst_g_box_tcolor_alpha"):GetInt())
	local DrawBorderColor = Color(GetConVar("amethyst_g_bordercolor_red"):GetInt(), GetConVar("amethyst_g_bordercolor_green"):GetInt(), GetConVar("amethyst_g_bordercolor_blue"):GetInt(), GetConVar("amethyst_g_bordercolor_alpha"):GetInt())
	local DrawIconActiveColor = Color(GetConVar("amethyst_g_icon_acolor_red"):GetInt(), GetConVar("amethyst_g_icon_acolor_green"):GetInt(), GetConVar("amethyst_g_icon_acolor_blue"):GetInt(), GetConVar("amethyst_g_icon_acolor_alpha"):GetInt())
	local DrawIconAltColor = Color(GetConVar("amethyst_g_alticon_acolor_red"):GetInt(), GetConVar("amethyst_g_alticon_acolor_green"):GetInt(), GetConVar("amethyst_g_alticon_acolor_blue"):GetInt(), GetConVar("amethyst_g_alticon_acolor_alpha"):GetInt())
	local DrawCircleColor = Color(GetConVar("amethyst_g_desc_ccolor_red"):GetInt(), GetConVar("amethyst_g_desc_ccolor_green"):GetInt(), GetConVar("amethyst_g_desc_ccolor_blue"):GetInt(), GetConVar("amethyst_g_desc_ccolor_alpha"):GetInt())
	local DrawDescColor = Color(GetConVar("amethyst_g_desc_tcolor_red"):GetInt(), GetConVar("amethyst_g_desc_tcolor_green"):GetInt(), GetConVar("amethyst_g_desc_tcolor_blue"):GetInt(), GetConVar("amethyst_g_desc_tcolor_alpha"):GetInt())
	local DrawTitleColor = Color(GetConVar("amethyst_g_desc_tcolor_red"):GetInt(), GetConVar("amethyst_g_desc_tcolor_green"):GetInt(), GetConVar("amethyst_g_desc_tcolor_blue"):GetInt(), GetConVar("amethyst_g_desc_tcolor_alpha"):GetInt())

    Amethyst.Init = self
    Amethyst.Init:Dock(FILL)
    Amethyst.Init:DockMargin(0,0,0,0)
    Amethyst.Init.Paint = function(self, w, h) end
	Amethyst.Value = CustomShipments[1]
    Amethyst.Value.Key = 1

    self.DPanel_SectionTop = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_SectionTop:Dock(TOP)
    self.DPanel_SectionTop:DockMargin(0, 0, 0, 0)
    self.DPanel_SectionTop:SetTall(35)
    self.DPanel_SectionTop.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 100 ) )
		draw.DrawText( string.upper(Amethyst.Language["weapons"] or "WEAPONS"), "Amethyst.Font.SectionTitle", 23, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color(255, 255, 255, 255), TEXT_ALIGN_LEFT )
    end

    self.DPanel_SectionTop_Spacer = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_SectionTop_Spacer:Dock(TOP)
    self.DPanel_SectionTop_Spacer:SetTall(2)
    self.DPanel_SectionTop_Spacer.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

	self.DPanel_PrimaryContent_Container = vgui.Create( "DPanel", Amethyst.Init )
	self.DPanel_PrimaryContent_Container:Dock(FILL)
    self.DPanel_PrimaryContent_Container:DockMargin(0,0,0,0)
	self.DPanel_PrimaryContent_Container.Paint = function( self, w, h )
		local AmethystBox = Color(GetConVar("amethyst_m_secondaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_alpha"):GetInt() )
		draw.AmethystBox( 0, 0, w, h, Color( AmethystBox.r, AmethystBox.g, AmethystBox.b, AmethystBox.a ) )
	end

	self.DPanelList_Tab = vgui.Create("amethyst.itemlist", self.DPanel_PrimaryContent_Container)
	self.DPanelList_Tab:Dock(FILL)
    self.DPanelList_Tab:DockMargin(15,5,10,5)
	self.DPanelList_Tab:EnableVerticalScrollbar(true)
	self.DPanelList_Tab:SetSpacing(10)
	self.DPanelList_Tab.VBar.Paint = function( s, w, h ) end
	self.DPanelList_Tab.VBar.btnUp.Paint = function( s, w, h ) end
	self.DPanelList_Tab.VBar.btnDown.Paint = function( s, w, h ) end
	self.DPanelList_Tab.VBar.btnGrip.Paint = function( s, w, h )
		draw.RoundedBox( 4, 7, 0, 4, h + 22, Color(GetConVar("amethyst_m_sbcolor_red"):GetInt(), GetConVar("amethyst_m_sbcolor_green"):GetInt(), GetConVar("amethyst_m_sbcolor_blue"):GetInt(), GetConVar("amethyst_m_sbcolor_alpha"):GetInt()) or Color(0, 0, 0, 100) )
	end

	for _, doCatResult in pairs( doFetchCategories ) do

		local doHasCategory = false

		for k, v in pairs(CustomShipments) do
			if (v.seperate and (not GAMEMODE.Config.restrictbuypistol or (GAMEMODE.Config.restrictbuypistol and (not v.allowed[1] or table.HasValue(v.allowed, LocalPlayer():Team()))))) and (not v.customCheck or v.customCheck and v.customCheck(LocalPlayer())) then
				if v.category == doCatResult.name then doHasCategory = true end
			end
		end

		if doHasCategory then

			local doCategoryWeaponsList = {}

			for k, v in pairs(CustomShipments) do
				if v.customCheck != nil then
					if not v.customCheck then return end
				end
				if v.category != nil then
					if v.category == doCatResult.name then table.insert(doCategoryWeaponsList, v) end
				end
			end

			local doCategoriesCalcHeight = 0
			for k, v in pairs( doCategoryWeaponsList ) do
				doCategoriesCalcHeight = math.ceil( table.Count( doCategoryWeaponsList ) / 2 ) * doHeightCalc + 40
			end

			self.DPanel_Category = vgui.Create("amethyst.category", Amethyst.Init)
			self.DPanel_Category:Dock(TOP)
			self.DPanel_Category:DockMargin(5, 0, 0, 0)
			self.DPanel_Category:SetText("")
			self.DPanel_Category:HeaderTitle(doCatResult.name)
			if (doCatResult.startExpanded) or (not doCatResult.startExpanded and doCatResult.name == "Other") then
				self.DPanel_Category.IsToggled = true
				self.DPanel_Category:SetExpanded(true)
			end
			self.DPanel_Category:FetchTall(doCategoriesCalcHeight)
			self.DPanel_Category.Paint = function(self, w, h) end

			Amethyst.Categories = vgui.Create( "DGrid", self.DPanel_Category )
			Amethyst.Categories:Dock(LEFT)
			Amethyst.Categories:DockMargin(6, 3, 0, 5)
			Amethyst.Categories:SetCols( 2 )
			Amethyst.Categories:SetColWide( doWidthCalc )
			Amethyst.Categories:SetRowHeight( doHeightCalc or 70 )

			for k, v in pairs( doCategoryWeaponsList ) do

				if !Amethyst.Value then Amethyst.Value = v end
				Amethyst.Value.Key = 1

				self.DPanel_Job = vgui.Create("DButton")
				self.DPanel_Job:SetText("")
				self.DPanel_Job:SetSize(doWidthCalc, doHeightCalc - 2)
				self.DPanel_Job.Paint = function( self, w, h )
					local doAdjustH = 4
					local doAdjustW = 5
					local fetchItemMax = v.max or 0
	                if fetchItemMax == 0 then
	                    fetchItemMax = Amethyst.Language.JobMaxUnlimited
	                end

					draw.RoundedBox(0, 0, 2, w - doAdjustW, h - doAdjustH, DrawPrimaryColor or Color(70, 75, 97, 230))
					draw.AmethystOutlinedBox(0, 2, w - doAdjustW, h - doAdjustH, Color( 0, 0, 0, 0), DrawBorderColor or Color(90, 95, 117, 255))

					draw.SimpleText(v.name, "Amethyst.Font.CardItemTitle", 90, h / 2 - 13, DrawBoxTextColor or Color(255, 255, 255, 255))
					--draw.SimpleText(GAMEMODE.Config.currency .. ( v.pricesep or v.price ), "Amethyst.Font.JobSalary", 90, h / 2 + 4, DrawBoxTextColor or Color(255, 255, 255, 255))

					draw.RoundedBox(0, 0, 2, 75, h - 4, Color(0, 0, 0, 80))
					draw.RoundedBox(4, w - 75, h / 2 - 11, 55, 25, DrawSecondaryColor)

					draw.SimpleText(GAMEMODE.Config.currency .. ( v.pricesep or v.price ), "Amethyst.Font.CardItemMax", w - 48, h / 2 + 1, DrawBoxTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				end
				self.DPanel_Job.DoClick = function()
	                Amethyst.Value = v
	                Amethyst.Value.Key = 1
	                if istable(Amethyst.Value.model) then
	                    self.DModelPanel_Item_Model:SetModel(Amethyst.Value.model[Amethyst.Value.Key])
	                else
	                    self.DModelPanel_Item_Model:SetModel(Amethyst.Value.model)
	                end
	                self.DModelPanel_Item_Model:InvalidateLayout()
	                self.DButton_Item_Action:InvalidateLayout()

	                Amethyst.Item.Skins = istable(Amethyst.Value.model) and table.Count(Amethyst.Value.model) or 0
				end
				local doDefaultJobModel
				if istable(v.model) then doDefaultJobModel = table.GetFirstValue(v.model) else doDefaultJobModel = v.model end

	            self.DModelPanel_ItemModel = vgui.Create("DModelPanel", self.DPanel_Job)
	            self.DModelPanel_ItemModel.LayoutEntity = function() return end
	            if isstring(doDefaultJobModel) and util.IsValidModel(doDefaultJobModel) then
	                self.DModelPanel_ItemModel:SetModel(doDefaultJobModel)
	            else
	                self.DModelPanel_ItemModel:SetModel("models/error.mdl")
	            end
	            local mn, mx = self.DModelPanel_ItemModel.Entity:GetRenderBounds()
	            local size = 0
	            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
	            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
	            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
	            self.DModelPanel_ItemModel:SetFOV(v.amethyst_offsetfov or 40)
	            self.DModelPanel_ItemModel:SetCamPos(Vector(size, size, size))
	            self.DModelPanel_ItemModel:SetLookAt((mn + mx) * 0.5)
	            self.DModelPanel_ItemModel:SetPos( v.amethyst_offsetW or 7, v.amethyst_offsetH or 5 )
	            self.DModelPanel_ItemModel:SetSize( 60, 60 )
		        self.DModelPanel_ItemModel._Paint = self.DModelPanel_ItemModel.Paint

				local doHeightCalcTotal = math.ceil( table.Count( doCategoryWeaponsList ) / 2 ) * doHeightCalc or 80
				Amethyst.Categories:AddItem(self.DPanel_Job)
				self.DPanel_Category:SetHeight( doHeightCalcTotal + 40 )
			end
			self.DPanelList_Tab:AddItem(self.DPanel_Category)
		end
	end

	self.DPanel_Information = vgui.Create( "DPanel", Amethyst.Init )
	self.DPanel_Information:Dock(RIGHT)
	self.DPanel_Information:SetWide(230)
	if GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1 then
		self.DPanel_Information:SetWide(280)
	end
    self.DPanel_Information:DockMargin(0,0,0,0)
	self.DPanel_Information.Paint = function( self, w, h )
		local GetValueData = GetConVar("amethyst_m_grid_background_enabled")
		if GetValueData:GetInt() == 1 then
			surface.SetDrawColor( Color( 5, 5, 5, 30 ) )
			surface.SetMaterial( Material( "amethyst/amethyst_gui_pattern.png", "noclamp smooth" ) )
			surface.DrawTexturedRectRotated( 100, 0, 1275, 333, 90 )
		end
	end

    Amethyst.Item = vgui.Create("DPanel", self.DPanel_Information)
    Amethyst.Item:Dock(RIGHT)
	Amethyst.Item:SetWide(230)
	if GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1 then
		Amethyst.Item:SetWide(280)
	end
    Amethyst.Item:DockMargin(0, 0, 0, 0)
    Amethyst.Item.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, 2, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ))
	end
    Amethyst.Item.Skins = 0

    self.DLabel_Item_Title = vgui.Create("DLabel", Amethyst.Item)
    self.DLabel_Item_Title:Dock(TOP)
    self.DLabel_Item_Title:SetText("")
    self.DLabel_Item_Title:DockMargin(0, 0, 0, 0)
    self.DLabel_Item_Title:SetContentAlignment(5)
    self.DLabel_Item_Title:SetSize(Amethyst.Item:GetWide() - 20, 35)
    self.DLabel_Item_Title.Paint = function(self, w, h)
    	draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_tertiaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_alpha"):GetInt() ) )
        draw.SimpleText(Amethyst.Value.name or "", "Amethyst.Font.JobTitle", w / 2, 17, DrawTitleColor or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.DPanel_Item_Spacer_002 = vgui.Create("DPanel", Amethyst.Item)
    self.DPanel_Item_Spacer_002:Dock(TOP)
    self.DPanel_Item_Spacer_002:SetTall(2)
    self.DPanel_Item_Spacer_002.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

    self.DModelPanel_Item_Model = vgui.Create("DModelPanel", Amethyst.Item)
    self.DModelPanel_Item_Model:SetSize( Amethyst.Item:GetWide() / 2, Amethyst.Item:GetTall() + 200 )
    self.DModelPanel_Item_Model:Dock(TOP)
    if isstring(Amethyst.Value.model) then
        self.DModelPanel_Item_Model:SetModel(Amethyst.Value.model)
    else
        self.DModelPanel_Item_Model:SetModel("models/error.mdl")
    end
    local mn, mx = self.DModelPanel_Item_Model.Entity:GetRenderBounds()
    local size = 0

    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

    self.DModelPanel_Item_Model:SetCamPos(Vector(size, size, size))
    self.DModelPanel_Item_Model:SetLookAt((mn + mx) * .5)
    self.DModelPanel_Item_Model._Paint = self.DModelPanel_Item_Model.Paint
	self.DModelPanel_Item_Model.Paint = function(self, w, h)
		local DrawCircleColor = Color(GetConVar("amethyst_g_desc_ccolor_red"):GetInt(), GetConVar("amethyst_g_desc_ccolor_green"):GetInt(), GetConVar("amethyst_g_desc_ccolor_blue"):GetInt(), GetConVar("amethyst_g_desc_ccolor_alpha"):GetInt()) or Color( 110, 98, 138, 210 )
		Amethyst.StencilStart()
		Amethyst.DrawCircle( w / 2, h / 2 + 4, 60, DrawCircleColor )
		Amethyst.StencilReplace()
		self:_Paint(w, h)
		Amethyst.StencilEnd()
	end
	self.DModelPanel_Item_Model.Think = function(self)
		self:SetFOV(90)
		if Amethyst.Settings.CustomEntity[Amethyst.Value.entity] then
			self:SetFOV(Amethyst.Settings.CustomEntity[Amethyst.Value.entity].EntSetFOV or 90)
		end
	end

    local oldPaint = self.DModelPanel_Item_Model.Paint
    self.DModelPanel_Item_Model.Paint = function(self, w, h)
        oldPaint(self, w, h)
		local DrawSkinTextColor = Color(GetConVar("amethyst_g_desc_tcolor_red"):GetInt(), GetConVar("amethyst_g_desc_tcolor_green"):GetInt(), GetConVar("amethyst_g_desc_tcolor_blue"):GetInt(), GetConVar("amethyst_g_desc_tcolor_alpha"):GetInt()) or Color(255,255,255,255)
        draw.SimpleText( GAMEMODE.Config.currency .. ( Amethyst.Value.pricesep or Amethyst.Value.price ), "Amethyst.Font.CardDescSubinfo", w / 2, 12, DrawSkinTextColor , 1, 1)
    end

    self.DScrollPanel_Item_Scroll = vgui.Create( "DScrollPanel", Amethyst.Item )
    self.DScrollPanel_Item_Scroll:SetSize( Amethyst.Item:GetWide() - 10, 230)
    self.DScrollPanel_Item_Scroll.VBar:ConstructScrollbarGUI()
    self.DScrollPanel_Item_Scroll:Dock(FILL)
    self.DScrollPanel_Item_Scroll:DockPadding(5, 5, 5, 5)
    self.DScrollPanel_Item_Scroll:DockMargin(5, 0, 0, 0)
    self.DScrollPanel_Item_Scroll.Paint = function(self, w, h) end

    self.DLabel_Item_Desc = vgui.Create( "DLabel", self.DScrollPanel_Item_Scroll )
    self.DLabel_Item_Desc:Dock(FILL)
    self.DLabel_Item_Desc:DockMargin(10, 1, 10, 1)
    self.DLabel_Item_Desc:SetFont( "Amethyst.Font.JobDesc" )
    self.DLabel_Item_Desc:SetAutoStretchVertical(true)
    self.DLabel_Item_Desc:SetWrap(true)
    self.DLabel_Item_Desc:SetSize(40, 200)
    self.DLabel_Item_Desc:SetColor(DrawDescColor or Color(255,255,255,255))
    self.DLabel_Item_Desc.PerformLayout = function()
    	local EntDescText = Amethyst.Language["no_info_available"] or "No additional info"
    	if Amethyst.Settings.CustomEntity[Amethyst.Value.entity] then
			EntDescText = Amethyst.Settings.CustomEntity[Amethyst.Value.entity].EntSetDesc or ""
		end
		self.DLabel_Item_Desc:SetText( EntDescText or "" )
    end

    self.DButton_Item_Action = vgui.Create("DButton", Amethyst.Item)
    self.DButton_Item_Action:Dock(BOTTOM)
    self.DButton_Item_Action:DockMargin(7, 5, 5, 5)
    self.DButton_Item_Action:SetText("")
    self.DButton_Item_Action.Text = ""
    self.DButton_Item_Action:SetSize(Amethyst.Item:GetWide(), 40)
    self.DButton_Item_Action:SetVisible(true)
    self.DButton_Item_Action.PerformLayout = function()
        self.DButton_Item_Action.Text = string.upper( Amethyst.Language["purchase"] or "Purchase" )
        self.DButton_Item_Action.DoClick = function()
            RunConsoleCommand("darkrp", "buy", Amethyst.Value.name)
        end
    end
    self.DButton_Item_Action.Paint = function(cooter, w, h)

        local actionStatus = self.DButton_Item_Action.Text or ""
		local doIconStatus = "amethyst/amethyst_gui_button_cart.png"
		local fetchItemMax = Amethyst.Value.max or 0
		local DrawButtonColorize = Color( GetConVar("amethyst_g_button_bcolor_red"):GetInt(), GetConVar("amethyst_g_button_bcolor_green"):GetInt(), GetConVar("amethyst_g_button_bcolor_blue"):GetInt(), GetConVar("amethyst_g_button_bcolor_alpha"):GetInt() ) or Color( 68, 114, 71, 255 )

        local fetchButtonColor = DrawButtonColorize
		if cooter:IsHovered() or cooter:IsDown() then
			fetchButtonColor = Color(DrawButtonColorize.r - 30, DrawButtonColorize.g - 30, DrawButtonColorize.b - 30, DrawButtonColorize.a)
		end

    	surface.SetFont( "Amethyst.Font.CardButton" )
		local actionStatusW, actionStatusH = surface.GetTextSize( actionStatus )

        draw.RoundedBox( 4, 0, 0, w, h, fetchButtonColor )
        draw.SimpleText( actionStatus, "Amethyst.Font.CardButton", w / 2 + 10, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( Color(255, 255, 255, 255) )
		surface.SetMaterial( Material( doIconStatus, "noclamp smooth" ) )
		surface.DrawTexturedRect( w / 2 - actionStatusW / 2 - 15, h / 2 - 9, 16, 16 )

    end

end

vgui.Register("Amethyst_Tab_Weapons", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/