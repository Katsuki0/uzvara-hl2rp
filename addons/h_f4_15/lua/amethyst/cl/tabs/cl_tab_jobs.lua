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

	--[[ -----------------------------------------------------------------------------------------------
	Define Stuff
	--------------------------------------------------------------------------------------------------]]

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
	local doFetchCategories = DarkRP.getCategories().jobs
	local Material_ButtonPrev 	= "amethyst/amethyst_ui_prev.png"
	local Material_ButtonNext 	= "amethyst/amethyst_ui_next.png"
	local Material_JobCurrent 	= "amethyst/amethyst_gui_check.png"
	local Material_JobIsVote 	= "amethyst/amethyst_gui_jobstatus_vote.png"
	local Material_JobIsDonate 	= "amethyst/amethyst_gui_jobstatus_donate.png"
	local Material_JobMax 		= "amethyst/amethyst_gui_button_max.png"

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
	local DrawIconDonatorColor = Color(GetConVar("amethyst_g_alticon_acolor_red"):GetInt(), GetConVar("amethyst_g_alticon_acolor_green"):GetInt(), GetConVar("amethyst_g_alticon_acolor_blue"):GetInt(), GetConVar("amethyst_g_alticon_acolor_alpha"):GetInt())
	local DrawCircleColor = Color(GetConVar("amethyst_g_desc_ccolor_red"):GetInt(), GetConVar("amethyst_g_desc_ccolor_green"):GetInt(), GetConVar("amethyst_g_desc_ccolor_blue"):GetInt(), GetConVar("amethyst_g_desc_ccolor_alpha"):GetInt())
	local DrawDescColor = Color(GetConVar("amethyst_g_desc_tcolor_red"):GetInt(), GetConVar("amethyst_g_desc_tcolor_green"):GetInt(), GetConVar("amethyst_g_desc_tcolor_blue"):GetInt(), GetConVar("amethyst_g_desc_tcolor_alpha"):GetInt())
	local DrawTitleColor = Color(GetConVar("amethyst_g_desc_tcolor_red"):GetInt(), GetConVar("amethyst_g_desc_tcolor_green"):GetInt(), GetConVar("amethyst_g_desc_tcolor_blue"):GetInt(), GetConVar("amethyst_g_desc_tcolor_alpha"):GetInt())

	--[[ INITIAL PANEL ---------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------]]

    Amethyst.Init = self
    Amethyst.Init:Dock(FILL)
    Amethyst.Init:DockMargin(0,0,0,0)
    Amethyst.Init.Paint = function(self, w, h) end
	Amethyst.Value = RPExtraTeams[1]
    Amethyst.Value.Key = 1

    self.DPanel_SectionTop = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_SectionTop:Dock(TOP)
    self.DPanel_SectionTop:DockMargin(0, 0, 0, 0)
    self.DPanel_SectionTop:SetTall(35)
    self.DPanel_SectionTop.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
		draw.DrawText( string.upper(Amethyst.Language["jobs"] or "JOBS"), "Amethyst.Font.SectionTitle", 23, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
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
		draw.RoundedBox( 0, 7, 0, 4, h + 22, Color(GetConVar("amethyst_m_sbcolor_red"):GetInt(), GetConVar("amethyst_m_sbcolor_green"):GetInt(), GetConVar("amethyst_m_sbcolor_blue"):GetInt(), GetConVar("amethyst_m_sbcolor_alpha"):GetInt()) or Color(0, 0, 0, 100) )
	end

	for _, doCatResult in pairs( doFetchCategories ) do

		local doHasCategory = false

		for k, v in pairs(RPExtraTeams) do
			if v.category == doCatResult.name then
				doHasCategory = true
			end
		end

		if doHasCategory then

			local doCategoryJobsList = {}

			for k, v in pairs(RPExtraTeams) do

				if v.customCheck != nil then
					if not v.customCheck then return end
				end
				if v.category != nil then
					if v.category == doCatResult.name then table.insert(doCategoryJobsList, v) end
				end

			end

			local doCategoriesCalcHeight = 0
			for k, v in pairs( doCategoryJobsList ) do
				doCategoriesCalcHeight = math.ceil( table.Count( doCategoryJobsList ) / 2 ) * doHeightCalc + 40
			end

			self.DPanel_Category = vgui.Create("amethyst.category", Amethyst.Init)
			self.DPanel_Category:Dock(TOP)
			self.DPanel_Category:DockMargin(5, 0, 0, 0)
			self.DPanel_Category:SetText("")
			self.DPanel_Category:HeaderTitle(doCatResult.name)
			if (doCatResult.startExpanded) then
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

			for k, v in ipairs( doCategoryJobsList ) do

				self.DPanel_Item = vgui.Create("DButton")
				self.DPanel_Item:SetText("")
				self.DPanel_Item:SetSize(doWidthCalc, doHeightCalc - 2)
				self.DPanel_Item.Paint = function( self, w, h )
					local doAdjustH = 4
					local doAdjustW = 5
					local fetchItemMax = v.max or 0
	                if fetchItemMax == 0 then
	                    fetchItemMax = Amethyst.Language["unlimited"] or "-"
	                end

					draw.RoundedBox(0, 0, 2, w - doAdjustW, h - doAdjustH, DrawPrimaryColor)
					draw.AmethystOutlinedBox(0, 2, w - doAdjustW, h - doAdjustH, Color( 0, 0, 0, 0), DrawBorderColor)

					draw.SimpleText(v.name, "Amethyst.Font.CardItemTitle", 90, h / 2 - 20, DrawBoxTextColor)

					if v.level then
						draw.SimpleText(GAMEMODE.Config.currency .. v.salary .. "/hr | Requires Year " .. v.level, "Amethyst.Font.JobSalary", 90, h / 2 + 4, DrawBoxTextColor)
					else
						draw.SimpleText(GAMEMODE.Config.currency .. v.salary .. "/hr", "Amethyst.Font.JobSalary", 90, h / 2 + 4, DrawBoxTextColor)
					end

					draw.RoundedBox(0, 0, 2, 75, h - 4, Color(0, 0, 0, 80))
					draw.RoundedBox(4, w - 75, h / 2 - 11, 55, 25, DrawSecondaryColor)

					draw.SimpleText(table.Count(team.GetPlayers(v.team)) .. "/" .. fetchItemMax, "Amethyst.Font.CardItemMax", w - 48, h / 2 + 1, DrawBoxTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					if (LocalPlayer():Team() == v.team) then
				        surface.SetDrawColor( DrawIconActiveColor )
				        surface.SetMaterial( Material( Material_JobCurrent, "noclamp smooth" ) )
				        surface.DrawTexturedRect( w - 100, h/2 - 8, 16, 16 )
				    elseif v.isDonateOnly then
				        surface.SetDrawColor( DrawIconDonatorColor )
				        surface.SetMaterial( Material( Material_JobIsDonate, "noclamp smooth" ) )
				        surface.DrawTexturedRect( w - 100, h/2 - 8, 16, 16 )
				    elseif v.vote then
				        surface.SetDrawColor( DrawIconAltColor )
				        surface.SetMaterial( Material( Material_JobIsVote, "noclamp smooth" ) )
				        surface.DrawTexturedRect( w - 100, h/2 - 8, 16, 16 )
				    end

				end
				self.DPanel_Item.DoClick = function()
	                Amethyst.Value = v
	                Amethyst.Value.Key = 1
	                if istable(Amethyst.Value.model) then
	                    self.DModelPanel_Item_Model:SetModel(Amethyst.Value.model[Amethyst.Value.Key])
	                else
	                    self.DModelPanel_Item_Model:SetModel(Amethyst.Value.model)
	                end
	                self.DModelPanel_Item_Model:InvalidateLayout()
	                self.DButton_Item_Action:InvalidateLayout()

	                self.DPanel_R_Container.Skins = istable(Amethyst.Value.model) and table.Count(Amethyst.Value.model) or 0
				end
				local doDefaultJobModel
				if istable(v.model) then doDefaultJobModel = table.GetFirstValue(v.model) else doDefaultJobModel = v.model end

				--[[ LEFT PANEL ------------------------------------------------------------------------------------
				--------------------------------------------------------------------------------------------------]]

				if GetConVar("amethyst_g_useicons_enabled"):GetInt() != 1 then
		            self.DModelPanel_Player = vgui.Create("DModelPanel", self.DPanel_Item)
					self.DModelPanel_Player:SetModel(doDefaultJobModel)
			        self.DModelPanel_Player:SetPos( v.amethyst_offsetW or 7, v.amethyst_offsetH or 6 )
			        self.DModelPanel_Player:SetSize(60, 60)
			        self.DModelPanel_Player:SetFOV(v.amethyst_offsetfov or 40)
			        self.DModelPanel_Player:SetCamPos(Vector(v.amethyst_camx or 25, v.amethyst_camy or 0, v.amethyst_camz or 65))
			        self.DModelPanel_Player:SetLookAt(Vector(v.amethyst_lookatx or 10, v.amethyst_lookaty or 0, v.amethyst_lookatz or 65))
		            self.DModelPanel_Player.LayoutEntity = function() return end
			    else
					local fetchJob = RPExtraTeams[1]
					local preferredModel = DarkRP.getPreferredJobModel(fetchJob.team)
			        self.ModelAvatar = vgui.Create("amethyst.amodel", self.DPanel_Item)
			        self.ModelAvatar:RehashModel(fetchJob, doDefaultJobModel, self)
			   	end

				local doHeightCalcTotal = math.ceil( table.Count( doCategoryJobsList ) / 2 ) * doHeightCalc or 80
				Amethyst.Categories:AddItem(self.DPanel_Item)
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
    self.DPanel_Information:DockMargin(0, 0, 0, 0)
	self.DPanel_Information.Paint = function( self, w, h )
		local GetValueData = GetConVar("amethyst_m_grid_background_enabled")
		if GetValueData:GetInt() == 1 then
			surface.SetDrawColor( Color( 5, 5, 5, 30 ) )
			surface.SetMaterial( Material( "amethyst/amethyst_gui_pattern.png", "noclamp smooth" ) )
			surface.DrawTexturedRectRotated( 100, 0, 1275, 333, 90 )
		end
	end

    self.DPanel_R_Container = vgui.Create("DPanel", self.DPanel_Information)
    self.DPanel_R_Container:Dock(RIGHT)
	self.DPanel_R_Container:SetWide(230)
	if GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1 then
		self.DPanel_R_Container:SetWide(280)
	end
    self.DPanel_R_Container:DockMargin(0, 0, 0, 0)
    self.DPanel_R_Container.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, 2, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ))
	end
    self.DPanel_R_Container.Skins = 0

    self.DLabel_Item_Title = vgui.Create("DLabel", self.DPanel_R_Container)
    self.DLabel_Item_Title:Dock(TOP)
    self.DLabel_Item_Title:SetText("")
    self.DLabel_Item_Title:DockMargin(0, 0, 0, 0)
    self.DLabel_Item_Title:SetContentAlignment(5)
    self.DLabel_Item_Title:SetSize(self.DPanel_R_Container:GetWide() - 20, 35)
    self.DLabel_Item_Title.Paint = function(self, w, h)
    	draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_tertiaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_alpha"):GetInt() ) )
        draw.SimpleText(Amethyst.Value.name or "", "Amethyst.Font.JobTitle", w / 2, 17, DrawTitleColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.DPanel_Item_Spacer_002 = vgui.Create("DPanel", self.DPanel_R_Container)
    self.DPanel_Item_Spacer_002:Dock(TOP)
    self.DPanel_Item_Spacer_002:SetTall(2)
    self.DPanel_Item_Spacer_002.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) )
    end

    self.DModelPanel_Item_Model = vgui.Create("DModelPanel", self.DPanel_R_Container)
    self.DModelPanel_Item_Model:SetSize( self.DPanel_R_Container:GetWide() / 2, self.DPanel_R_Container:GetTall() + 200 )
    self.DModelPanel_Item_Model:Dock(TOP)
    self.DModelPanel_Item_Model:SetCamPos(Vector(20, 0, 65))
    self.DModelPanel_Item_Model:SetLookAt(Vector(10, 0, 63))
    self.DModelPanel_Item_Model:SetFOV(100)
    if Amethyst.Value.model and istable( Amethyst.Value.model ) then
        self.DModelPanel_Item_Model:SetModel( Amethyst.Value.model[1] )
    else
        self.DModelPanel_Item_Model:SetModel( Amethyst.Value.model )
    end
	self.DModelPanel_Item_Model._Paint = self.DModelPanel_Item_Model.Paint
	self.DModelPanel_Item_Model.Paint = function(self, w, h)
		Amethyst.StencilStart()
		Amethyst.DrawCircle( w / 2, h / 2 + 4, 60, DrawCircleColor )
		Amethyst.StencilReplace()
		self:_Paint(w, h)
		Amethyst.StencilEnd()
	end

    local oldPaint = self.DModelPanel_Item_Model.Paint
    self.DModelPanel_Item_Model.Paint = function(what, w, h)
        oldPaint(what, w, h)
        if self.DPanel_R_Container.Skins < 1 then return end
		local DrawSkinTextColor = Color(GetConVar("amethyst_g_desc_tcolor_red"):GetInt(), GetConVar("amethyst_g_desc_tcolor_green"):GetInt(), GetConVar("amethyst_g_desc_tcolor_blue"):GetInt(), GetConVar("amethyst_g_desc_tcolor_alpha"):GetInt()) or Color(255,255,255,255)
        draw.SimpleText( Amethyst.Value.Key .. "/" .. self.DPanel_R_Container.Skins, "Amethyst.Font.JobTitle", w / 2, 12, DrawSkinTextColor , 1, 1)
    end
    self.DModelPanel_Item_Model.PerformLayout = function()
        if istable(Amethyst.Value.model) then
            if #Amethyst.Value.model != 1 then
				doSwitchColors = Color(255, 255, 255, 255)
            end
        end
        self.DPanel_R_Container.Skins = istable(Amethyst.Value.model) and table.Count(Amethyst.Value.model) or 0
    end
    self.DModelPanel_Item_Model.LayoutEntity = function( ent ) return end

    self.DButton_Item_SkinPrev = vgui.Create("DButton", self.DPanel_R_Container)
    self.DButton_Item_SkinPrev:SetSize(20, 20)
    self.DButton_Item_SkinPrev:SetPos(15, 8)
    self.DButton_Item_SkinPrev:SetText("")
    self.DButton_Item_SkinPrev:SetFont( "Amethyst.Font.JobTitle" )
    self.DButton_Item_SkinPrev.Paint = function( self, w, h )
    	doSwitchColors = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 )
        if Amethyst.Value.Key <= 1 then
			doSwitchColors = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), 50) or Color( 255, 255, 255, 50 )
        end
		surface.SetDrawColor( doSwitchColors )
		surface.SetMaterial( Material( Material_ButtonPrev, "noclamp smooth" ) )
		surface.DrawTexturedRect( 0, 2, 16, 16 )
    end
    self.DButton_Item_SkinPrev.DoClick = function()
    	if Amethyst.Value.Key <= 1 then return end
        Amethyst.Value.Key = Amethyst.Value.Key - 1
        if Amethyst.Value.Key < 1 then Amethyst.Value.Key = 1 end

        self.DModelPanel_Item_Model:SetModel(Amethyst.Value.model[Amethyst.Value.Key])
        self.DModelPanel_Item_Model:InvalidateLayout()
    end

    self.DButton_Item_SkinNext = vgui.Create("DButton", self.DPanel_R_Container)
    self.DButton_Item_SkinNext:SetSize(20, 20)
    self.DButton_Item_SkinNext:SetPos(self.DPanel_R_Container:GetWide() - 30, 8)
    self.DButton_Item_SkinNext:SetText("")
    self.DButton_Item_SkinNext:SetFont( "Amethyst.Font.JobTitle" )
    self.DButton_Item_SkinNext.Paint = function( what, w, h )
    	doSwitchColors = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 )
        if Amethyst.Value.Key >= self.DPanel_R_Container.Skins then
			doSwitchColors = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), 20) or Color( 255, 255, 255, 255 )
        end

		surface.SetDrawColor( doSwitchColors )
		surface.SetMaterial( Material( Material_ButtonNext, "noclamp smooth" ) )
		surface.DrawTexturedRect( 0, 2, 16, 16 )
    end
    self.DButton_Item_SkinNext.DoClick = function()
        if Amethyst.Value.Key == #Amethyst.Value.model then return end
		if Amethyst.Value.Key >= self.DPanel_R_Container.Skins then return end

        self.DPanel_R_Container.Skins = istable(Amethyst.Value.model) and table.Count( Amethyst.Value.model ) or 0

        Amethyst.Value.Key = Amethyst.Value.Key + 1
        self.DModelPanel_Item_Model:SetModel(Amethyst.Value.model[Amethyst.Value.Key])
        self.DModelPanel_Item_Model:InvalidateLayout()
    end

    self.DScrollPanel_Item_Scroll = vgui.Create( "DScrollPanel", self.DPanel_R_Container )
    self.DScrollPanel_Item_Scroll:SetSize( self.DPanel_R_Container:GetWide() - 10, 230)
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
    self.DLabel_Item_Desc.PerformLayout = function()
        self.DLabel_Item_Desc:SetText(Amethyst.Value.description or "")
        if Amethyst.Value.weapons != nil then
            self.DLabel_Item_Desc:SetText(self.DLabel_Item_Desc:GetText() .. "\n\n")
        end
    end
    self.DLabel_Item_Desc.Paint = function( what, w, h)
    	self.DLabel_Item_Desc:SetColor(DrawDescColor)
	end

    self.DButton_Item_Action = vgui.Create("DButton", self.DPanel_R_Container)
    self.DButton_Item_Action:Dock(BOTTOM)
    self.DButton_Item_Action:DockMargin(7, 5, 5, 5)
    self.DButton_Item_Action:SetText("")
    self.DButton_Item_Action.Text = ""
    self.DButton_Item_Action:SetSize(self.DPanel_R_Container:GetWide(), 40)
    self.DButton_Item_Action:SetVisible(true)
    self.DButton_Item_Action.PerformLayout = function()
        if Amethyst.Value.vote then
            self.DButton_Item_Action.Text = string.upper( Amethyst.Language["apply_for_vote"] or "APPLY FOR VOTE" )
            self.DButton_Item_Action.DoClick = function()
                DarkRP.setPreferredJobModel(Amethyst.Value.team, self.DModelPanel_Item_Model:GetModel())
                RunConsoleCommand( "darkrp", "vote" .. Amethyst.Value.command )
                DarkRP.closeF4Menu()
            end
        else
            self.DButton_Item_Action.Text = string.upper( Amethyst.Language["start_new_job"] or "START NEW JOB" )
            self.DButton_Item_Action.DoClick = function()
                DarkRP.setPreferredJobModel( Amethyst.Value.team, self.DModelPanel_Item_Model:GetModel() )
                RunConsoleCommand( "darkrp", Amethyst.Value.command )
                DarkRP.closeF4Menu()
            end
        end
    end
    self.DButton_Item_Action.Paint = function( cooter, w, h )
        local actionStatus = self.DButton_Item_Action.Text or ""
		local doIconStatus = "amethyst/amethyst_gui_jobstatus_become.png"
		local DrawButtonColorize = Color( GetConVar("amethyst_g_button_bcolor_red"):GetInt(), GetConVar("amethyst_g_button_bcolor_green"):GetInt(), GetConVar("amethyst_g_button_bcolor_blue"):GetInt(), GetConVar("amethyst_g_button_bcolor_alpha"):GetInt() ) or Color( 68, 114, 71, 255 )

		if Amethyst.Value.vote then
			DrawButtonColorize = Color( GetConVar("amethyst_g_altbutton_bcolor_red"):GetInt(), GetConVar("amethyst_g_altbutton_bcolor_green"):GetInt(), GetConVar("amethyst_g_altbutton_bcolor_blue"):GetInt(), GetConVar("amethyst_g_altbutton_bcolor_alpha"):GetInt() ) or Color( 0, 90, 140, 255 )
			doIconStatus = "amethyst/amethyst_gui_jobstatus_vote.png"
		end

        local doJobMax = Amethyst.Value.max or 1337
        if ( doJobMax != 0 ) then
            if table.Count( team.GetPlayers(Amethyst.Value.team) ) == jobMax then
                DrawButtonColorize = Color(10,10,10,200)
                actionStatus = Amethyst.Language["full"] or "FULL"
            end
        end

		if (LocalPlayer():Team() == Amethyst.Value.team) then
			doIconStatus = Material_JobMax
			actionStatus = Amethyst.Language["already_hired"] or "ALREADY HIRED"
		end

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

vgui.Register("Amethyst_Tab_Jobs", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/