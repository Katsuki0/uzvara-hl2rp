/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/

Amethyst.Theme = Amethyst.Theme or {}
Amethyst.Theme.Manifest = Amethyst.Theme.Manifest or {}

local PANEL = {}
local fetchThemeSettings = {}

--[[ -----------------------------------------------------------------------------------------------
Define
--------------------------------------------------------------------------------------------------]]
local cvar_th
local cvar_th_s
local ply_theme_table
local ply_manifest_table

if not ConVarExists("amethyst_theme") then
	CreateClientConVar("amethyst_theme", "default", true, false) -- Set Default Theme
end

--[[ -----------------------------------------------------------------------------------------------
	@desc: 		Sorting pairs
	@params 	strDataType, strDataID, strDataDefault, tblDataValues
--------------------------------------------------------------------------------------------------]]

function Amethyst.SortPairsKeys(tblSource, funcSorter)
	local a = {}
	for n in pairs(tblSource) do table.insert(a, n) end
		table.sort(a, funcSorter)
		local i = 0
	 	local iter = function ()
		i = i + 1
	    if a[i] == nil then
	    	return nil
	    else
	    	return a[i], tblSource[a[i]]
	    end
  	end
	return iter
end

--[[ -----------------------------------------------------------------------------------------------
	@desc 		Adds an entry to the debug queue.
--------------------------------------------------------------------------------------------------]]

function Amethyst.DebugReportSync( strDataTheme, strDataID, strDataDefault)
	if (strDataTheme and strDataID) then
	    net.Start( "Amethyst_DebugAdd" )
	    net.WriteString( strDataTheme or "" )
	    net.WriteString( strDataID or "" )
	    net.WriteString( strDataDefault or "" )
	    net.SendToServer()
	end
end

--[[ -----------------------------------------------------------------------------------------------
	@desc 		Creates the client convar for each setting in the theme.
--------------------------------------------------------------------------------------------------]]

function Amethyst.SetupConvars( strDataType, strDataID, strDataDefault, tblDataValues)
	if strDataType != "rgba" and strDataType != "dropdown" then
    	CreateClientConVar(strDataID, strDataDefault, true, false)
    elseif strDataType == "dropdown" then
		CreateClientConVar(strDataID, strDataDefault or "", true, false)
    elseif strDataType == "rgba" then
    	for dn, dv in pairs( tblDataValues ) do
    		CreateClientConVar(strDataID .. "_" .. dn, dv, true, false)
    	end
    end
end

--[[ -----------------------------------------------------------------------------------------------
	@desc		Checks to see if the currently applied theme is missing any core theme properties.
--------------------------------------------------------------------------------------------------]]

function table.FailsafeCheck( tblSource, strValue )
	for k, v in pairs( tblSource ) do
		if ( type(v) == "table" ) then
			if ( v.DataID == strValue ) then return true end
		end
	end
	return false
end

function Amethyst.ThemeValidation()
	fetchThemeSettings = {}
	cvar_th 	= GetConVar("amethyst_theme") 					-- Fetch current Theme Convar
	cvar_th_s  	= string.lower(cvar_th:GetString()) 			-- Fetch current convar and lower-case it

	if (cvar_th_s == "failsafe" or not Amethyst.Theme[cvar_th_s]) and (Amethyst.Theme["default"]) then
		cvar_th:SetString( "default" )
		cvar_th_s = "default"
	end

	if not Amethyst.Theme[cvar_th_s] and not Amethyst.Theme["default"] then
		cvar_th:SetString( "failsafe" )
		cvar_th_s = "failsafe"
	end

	ply_theme_table 	= Amethyst.Theme[cvar_th_s] 			-- Assign theme table
	ply_manifest_table 	= Amethyst.Theme.Manifest[cvar_th_s]	-- Assign manifest table

	--[[ -----------------------------------------------------------------------------------------------
	Theme Preparation
	--------------------------------------------------------------------------------------------------]]

	if ply_theme_table then
		for name, line in Amethyst.SortPairsKeys(ply_theme_table) do
			table.insert( fetchThemeSettings, line )
		end
		table.sort( fetchThemeSettings, function( a, b ) return a.DataSort < b.DataSort end )

		for k, v in pairs(fetchThemeSettings) do
			if table.HasValue( Amethyst.Settings.IgnoreBlockTypes, v.DataType ) then continue end
			Amethyst.SetupConvars( v.DataType, v.DataID, v.DataDefault, v.DataValues)
		end
	end

	for k, v in pairs(Amethyst.Theme["failsafe"]) do
		if table.HasValue( Amethyst.Settings.IgnoreBlockTypes, v.DataType ) then continue end
		if not table.FailsafeCheck( ply_theme_table, v.DataID ) then
			Amethyst.DebugReportSync( cvar_th_s, v.DataID, v.DataDefault )
		end
		if v.DataType != "rgba" then
			if not ConVarExists( v.DataID ) then
				Amethyst.SetupConvars( v.DataType, v.DataID, v.DataDefault, v.DataValues )
				Amethyst.DebugReportSync( cvar_th_s, v.DataID, v.DataDefault )
			end
		else
	    	for dn, dv in pairs( v.DataValues ) do
	    		local AssignDataID = v.DataID .. "_" .. dn
				if not ConVarExists( AssignDataID ) then
					CreateClientConVar( v.DataID .. "_" .. dn, dv, true, false )
					Amethyst.DebugReportSync( cvar_th_s, v.DataID .. "_" .. dn, dv )
				end
	    	end
		end
	end
end
Amethyst.ThemeValidation()

function PANEL:Init()

    Amethyst.Init = self
    Amethyst.Init:Dock(FILL)
    Amethyst.Init:DockMargin(0,0,0,0)
    Amethyst.Init.Paint = function(self, w, h) end

    self.DTextEntry_T_HC_Desc = vgui.Create( "DTextEntry", Amethyst.Init )
    self.DTextEntry_T_HC_Desc:Dock( TOP )
    self.DTextEntry_T_HC_Desc:DockMargin(0,0,0,0)
    self.DTextEntry_T_HC_Desc:SetTall(35)
    self.DTextEntry_T_HC_Desc:SetDrawBackground( false )
    self.DTextEntry_T_HC_Desc:SetText( "" )
    self.DTextEntry_T_HC_Desc:SetTextColor( Color( 255, 255, 255, 255) )
    self.DTextEntry_T_HC_Desc:SetFont("Amethyst.Font.SettingsHelpDesc")
    self.DTextEntry_T_HC_Desc:SetMultiline(false)
    self.DTextEntry_T_HC_Desc.Paint = function(self, w, h)
		draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
		draw.DrawText( string.upper( Amethyst.Language["settings"] or "SETTINGS" ), "Amethyst.Font.SectionTitle", 15, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end

    self.DPanel_T_Spacer_001 = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_T_Spacer_001:Dock(TOP)
    self.DPanel_T_Spacer_001:SetTall(2)
    self.DPanel_T_Spacer_001.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

	self.DPanel_R_Container = vgui.Create( "DPanel", Amethyst.Init )
	self.DPanel_R_Container:Dock( RIGHT )
	self.DPanel_R_Container:DockMargin(0, 0, 0, 0)
	self.DPanel_R_Container:SetWide(230)
	if GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1 then
		self.DPanel_R_Container:SetWide(280)
	end
	self.DPanel_R_Container.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, 2, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
		local GetValueData = GetConVar("amethyst_m_grid_background_enabled")
		if GetValueData:GetInt() == 1 then
			surface.SetDrawColor( Color( 5, 5, 5, 30 ) )
			surface.SetMaterial( Material( "amethyst/amethyst_gui_pattern.png", "noclamp smooth" ) )
			surface.DrawTexturedRectRotated( 100, 0, 1275, 333, 90 )
		end
	end

    self.DPanel_R_T = vgui.Create("DPanel", self.DPanel_R_Container)
    self.DPanel_R_T:Dock(TOP)
    self.DPanel_R_T:DockMargin(0, 0, 0, 0)
    self.DPanel_R_T:SetTall(35)
    self.DPanel_R_T.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_tertiaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_tertiaryaccent_color_alpha"):GetInt() ) )
		draw.DrawText( string.upper(Amethyst.Language["help_center"] or "HELP CENTER"), "Amethyst.Font.SectionTitle", self:GetWide()/2, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT )
    end

    self.DPanel_T_Spacer_002 = vgui.Create("DPanel", self.DPanel_R_Container)
    self.DPanel_T_Spacer_002:Dock(TOP)
    self.DPanel_T_Spacer_002:DockMargin(0, 0, 0, 11)
    self.DPanel_T_Spacer_002:SetTall(2)
    self.DPanel_T_Spacer_002.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
    end

	self.DPanel_R_TH_Title = vgui.Create( "DPanel", self.DPanel_R_Container )
	self.DPanel_R_TH_Title:Dock(TOP)
	self.DPanel_R_TH_Title:SetTall(25)
    self.DPanel_R_TH_Title:DockMargin(10,5,10,5)
	self.DPanel_R_TH_Title.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
		draw.DrawText( string.upper(Amethyst.Language["themes"] or "THEMES"), "Amethyst.Font.SubSectionTitle", 5, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	end

	self.DPanel_R_TH_Content = vgui.Create( "DPanel", self.DPanel_R_Container )
	self.DPanel_R_TH_Content:Dock(TOP)
	self.DPanel_R_TH_Content:SetTall(140)
    self.DPanel_R_TH_Content:DockMargin(0,0,0,0)
	self.DPanel_R_TH_Content.Paint = function( self, w, h ) end

	self.DPanel_R_TH_Manifest_Container = vgui.Create( "DPanel", self.DPanel_R_TH_Content )
	self.DPanel_R_TH_Manifest_Container:Dock(TOP)
	self.DPanel_R_TH_Manifest_Container:SetTall(80)
    self.DPanel_R_TH_Manifest_Container:DockMargin(5,0,0,0)
	self.DPanel_R_TH_Manifest_Container.Paint = function( self, w, h ) end

	if ply_manifest_table then

		for k, v in pairs(ply_manifest_table) do

			self.DPanel_R_TH_Manifest = vgui.Create( "DPanel", self.DPanel_R_TH_Manifest_Container )
			self.DPanel_R_TH_Manifest:Dock(TOP)
			self.DPanel_R_TH_Manifest:SetTall(25)
		    self.DPanel_R_TH_Manifest:DockMargin(0,0,0,0)
			self.DPanel_R_TH_Manifest.Paint = function( self, w, h ) end

			self.DLabel_Manifest_Title = vgui.Create("DLabel", self.DPanel_R_TH_Manifest)
			self.DLabel_Manifest_Title:SetFont("Amethyst.Font.ThemeManifestInfo")
			self.DLabel_Manifest_Title:SetTextColor( Color(255, 255, 255, 255 ) or Color(255,255,255,255) )
			self.DLabel_Manifest_Title:SetText("")
			self.DLabel_Manifest_Title:Dock(LEFT)
			self.DLabel_Manifest_Title:DockMargin(5,0,0,0)
			self.DLabel_Manifest_Title:SetWide(90)
			self.DLabel_Manifest_Title.Paint = function(self, w, h)
				draw.DrawText( string.upper(k), "Amethyst.Font.ThemeManifestInfo", 5, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			end

			self.DLabel_Manifest_Result = vgui.Create("DLabel", self.DPanel_R_TH_Manifest)
			self.DLabel_Manifest_Result:SetFont("Amethyst.Font.ThemeManifestInfo")
			self.DLabel_Manifest_Result:SetTextColor( Color(255, 255, 255, 255 ) or Color(255,255,255,255) )
			self.DLabel_Manifest_Result:SetText("")
			self.DLabel_Manifest_Result:Dock(RIGHT)
			self.DLabel_Manifest_Result:DockMargin(5,0,5,0)
			self.DLabel_Manifest_Result:SetWide(111)
			self.DLabel_Manifest_Result.Paint = function(self, w, h)
				draw.DrawText( string.upper(v), "Amethyst.Font.ThemeManifestInfo", w - 10, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			end

		end

	elseif (cvar_th_s == "failsafe") then

	    self.DTextEntry_R_TH_FS_Desc = vgui.Create( "DTextEntry", self.DPanel_R_TH_Manifest_Container )
	    self.DTextEntry_R_TH_FS_Desc:Dock( TOP )
	    self.DTextEntry_R_TH_FS_Desc:DockMargin(5,5,5,5)
	    self.DTextEntry_R_TH_FS_Desc:SetDrawBackground( false )
	    self.DTextEntry_R_TH_FS_Desc:SetText( "Failsafe mode activate. Please contact the server owner." )
	    self.DTextEntry_R_TH_FS_Desc:SetTextColor( Color( 255, 255, 255, 255) )
	    self.DTextEntry_R_TH_FS_Desc:SetFont("Amethyst.Font.SettingsHelpDesc")
	    self.DTextEntry_R_TH_FS_Desc:SetTall(ScreenScale(40))
	    self.DTextEntry_R_TH_FS_Desc:SetMultiline(true)

	end

	local GetThemeValue = GetConVar("amethyst_theme")

	self.DComboBox_R_TH_Themes = vgui.Create("DComboBox", self.DPanel_R_TH_Content)
	self.DComboBox_R_TH_Themes:SetWide(200)
	self.DComboBox_R_TH_Themes:Dock(TOP)
	self.DComboBox_R_TH_Themes:DockMargin(40,5,40,25)
	self.DComboBox_R_TH_Themes:SetTall(30)
	self.DComboBox_R_TH_Themes:SetValue( GetThemeValue:GetString() )
	for k, v in pairs( Amethyst.Settings.Themes ) do
		if Amethyst.Theme[k] and v.Enabled then
			if (v.HideNotAllowed and k != "default" and not LocalPlayer():IsSuperAdmin()) then
				if (v.StaffOnly and not Amethyst.Settings.StaffGroups[string.lower(LocalPlayer():GetUserGroup())]) or (v.DonatorOnly and not Amethyst.Settings.DonatorGroups[string.lower(LocalPlayer():GetUserGroup())]) then continue end
			end
			self.DComboBox_R_TH_Themes:AddChoice( k )
		end
	end
	self.DComboBox_R_TH_Themes.convarname = GetThemeValue
	self.DComboBox_R_TH_Themes.OnSelect = function(what)
		local tblFetchTheme = Amethyst.Theme[what:GetValue()]
		local tblFetchManifest = Amethyst.Theme.Manifest[what:GetValue()]

		GetThemeValue:SetString( what:GetValue() )

		local newcable = {}
		for name, line in Amethyst.SortPairsKeys(tblFetchTheme) do
			table.insert( newcable, line )
		end
		table.sort( newcable, function( a, b ) return a.DataSort < b.DataSort end )

		for k, v in pairs( newcable ) do
			if table.HasValue( Amethyst.Settings.IgnoreBlockTypes, v.DataType ) then continue end
			if v.DataType == "rgba" then
				for dn, dv in pairs(v.DataValues) do
					local Setdata = v.DataID .. "_" .. dn
					local fetchConVar = GetConVar(Setdata)
					fetchConVar:SetString( dv )

				end
			else
				local GetValueData = GetConVar(v.DataID)
				GetValueData:SetString( v.DataDefault )
			end
		end
		self.DPanel_R_TH_Manifest_Container:Clear()
		self.DPanel_R_TH_Manifest_Container:InvalidateLayout()

		for k, v in pairs(tblFetchManifest) do
			self.DPanel_R_TH_Manifest = vgui.Create( "DPanel", self.DPanel_R_TH_Manifest_Container )
			self.DPanel_R_TH_Manifest:Dock(TOP)
			self.DPanel_R_TH_Manifest:SetTall(25)
		    self.DPanel_R_TH_Manifest:DockMargin(5,0,5,0)
			self.DPanel_R_TH_Manifest.Paint = function( self, w, h ) end

			self.DLabel_Manifest_Title = vgui.Create("DLabel", self.DPanel_R_TH_Manifest)
			self.DLabel_Manifest_Title:SetFont("Amethyst.Font.ThemeManifestInfo")
			self.DLabel_Manifest_Title:SetTextColor( Color(255, 255, 255, 255 ) or Color(255,255,255,255) )
			self.DLabel_Manifest_Title:SetText("")
			self.DLabel_Manifest_Title:Dock(LEFT)
			self.DLabel_Manifest_Title:DockMargin(5,0,0,0)
			self.DLabel_Manifest_Title:SetWide(90)
			self.DLabel_Manifest_Title.Paint = function(self, w, h)
				draw.DrawText( string.upper(k), "Amethyst.Font.ThemeManifestInfo", 5, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			end

			self.DLabel_Manifest_Result = vgui.Create("DLabel", self.DPanel_R_TH_Manifest)
			self.DLabel_Manifest_Result:SetFont("Amethyst.Font.ThemeManifestInfo")
			self.DLabel_Manifest_Result:SetTextColor( Color(255, 255, 255, 255 ) or Color(255,255,255,255) )
			self.DLabel_Manifest_Result:SetText("")
			self.DLabel_Manifest_Result:Dock(RIGHT)
			self.DLabel_Manifest_Result:DockMargin(5,0,5,0)
			self.DLabel_Manifest_Result:SetWide(90)
			self.DLabel_Manifest_Result.Paint = function(self, w, h)
				draw.DrawText( string.upper(v), "Amethyst.Font.ThemeManifestInfo", w - 10, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			end
		end

        DarkRP.closeF4Menu()
        DarkRP.openF4Menu()
        if IsValid(Amethyst.PanelMenu) then
        	Amethyst.ThemeValidation()
	        if IsValid( PanelRightFill ) then
	        	timer.Create("amethyst.settings.reopen", 0.4, 1, function()
            		Amethyst.RemoveTimers()
					PanelRightFill:Clear()
					vgui.Create("Amethyst_Tab_Settings", PanelRightFill)
				end)
			end
		end

	end
	self.DComboBox_R_TH_Themes.Paint = function(what, w, h)
		ConVar_DropdownColor = Color(GetConVar("amethyst_m_dropdown_color_red"):GetInt(), GetConVar("amethyst_m_dropdown_color_green"):GetInt(), GetConVar("amethyst_m_dropdown_color_blue"):GetInt(), GetConVar("amethyst_m_dropdown_color_alpha"):GetInt())
		ConVar_DropdownOutlineColor = Color(GetConVar("amethyst_m_dropdown_ocolor_red"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_green"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_blue"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_alpha"):GetInt())

		draw.AmethystOutlinedBox(0, 0, w, h, ConVar_DropdownColor, ConVar_DropdownOutlineColor)
		what:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
		what:SetTextInset( 35, 0 )

		surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( Material( "amethyst/amethyst_gui_theme.png", "noclamp smooth" ) )
		surface.DrawTexturedRect( 7, what:GetTall() / 2 - 9, 18, 18 )
	end
	self.DComboBox_R_TH_Themes.OpenMenu = function( what, pControlOpener )
		if ( pControlOpener and pControlOpener == self.TextEntry ) then
			return
		end

		if ( #what.Choices == 0 ) then return end

		if ( IsValid( what.Menu ) ) then
			what.Menu:Remove()
			what.Menu = nil
		end

		what.Menu = DermaMenu( false, what )

		local sorted = {}
		for k, v in pairs( what.Choices ) do table.insert( sorted, { id = k, data = v } ) end
		for k, v in SortedPairsByMemberValue( sorted, "data" ) do
			local p = what.Menu:AddOption( v.data, function() what:ChooseOption( v.data, v.id ) end )
			p:SetFont( what:GetFont() )
			p:SetTextColor(Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ))
		end

		local x, y = what:LocalToScreen( 0, what:GetTall() )

		what.Menu:SetMinimumWidth( what:GetWide() )
		what.Menu:Open( x, y, false, what )
	end

	self.DPanel_R_RD_Title = vgui.Create( "DPanel", self.DPanel_R_Container )
	self.DPanel_R_RD_Title:Dock(TOP)
	self.DPanel_R_RD_Title:SetTall(25)
    self.DPanel_R_RD_Title:DockMargin(10,5,10,5)
	self.DPanel_R_RD_Title.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
		draw.DrawText( string.upper(Amethyst.Language["reset_defaults"] or "RESET DEFAULTS"), "Amethyst.Font.SubSectionTitle", 5, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
	end

	self.DScrollPanel_R_RD_Desc = vgui.Create("DScrollPanel", self.DPanel_R_Container)
	self.DScrollPanel_R_RD_Desc:Dock(TOP)
	self.DScrollPanel_R_RD_Desc:SetTall(ScreenScale(50))
	self.DScrollPanel_R_RD_Desc:DockMargin(10,0,10,0)
	self.DScrollPanel_R_RD_Desc.Paint = function(self, w, h) end

	self.VBar_R_RD_Desc = self.DScrollPanel_R_RD_Desc:GetVBar()
	self.VBar_R_RD_Desc:SetWide(10)
	self.VBar_R_RD_Desc:Dock(RIGHT)
	self.VBar_R_RD_Desc:DockMargin(0,0,0,0)
	self.VBar_R_RD_Desc.Paint = function(self,w,h) end
	self.VBar_R_RD_Desc.btnUp.Paint = function(self, w, h) end
	self.VBar_R_RD_Desc.btnDown.Paint = function(self, w, h) end
	self.VBar_R_RD_Desc.btnGrip.Paint = function(self, w, h)
		draw.RoundedBox( 4, 7, 0, 4, h + 22, Color(GetConVar("amethyst_m_sbcolor_red"):GetInt(), GetConVar("amethyst_m_sbcolor_green"):GetInt(), GetConVar("amethyst_m_sbcolor_blue"):GetInt(), GetConVar("amethyst_m_sbcolor_alpha"):GetInt()) or Color(0, 0, 0, 100) )
	end

    self.DTextEntry_R_RD_Desc = vgui.Create( "DTextEntry", self.DScrollPanel_R_RD_Desc )
    self.DTextEntry_R_RD_Desc:Dock( TOP )
    self.DTextEntry_R_RD_Desc:DockMargin(0,5,0,5)
    self.DTextEntry_R_RD_Desc:SetDrawBackground( false )
    self.DTextEntry_R_RD_Desc:SetText( Amethyst.Language.ResetDefaults_Desc or "" )
    self.DTextEntry_R_RD_Desc:SetTextColor( Color( 255, 255, 255, 255) )
    self.DTextEntry_R_RD_Desc:SetFont("Amethyst.Font.SettingsHelpDesc")
    self.DTextEntry_R_RD_Desc:SetTall(ScreenScale(40))
    self.DTextEntry_R_RD_Desc:SetMultiline(true)

	self.DButton_R_RD = vgui.Create( "DButton", self.DPanel_R_RD_Title )
	self.DButton_R_RD:Dock(RIGHT)
	self.DButton_R_RD:SetText("")
	self.DButton_R_RD:DockMargin(2, 2, 2, 2)
	self.DButton_R_RD:SetToolTip("Reset Defaults")
	self.DButton_R_RD:SetWide(25)
	self.DButton_R_RD.Paint = function( self, w, h )

		local doContainerColor = Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 )
		if self:IsHovered() or self:IsDown() then
			doContainerColor = Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt() + 50, GetConVar("amethyst_m_secondarycolor_green"):GetInt() + 50, GetConVar("amethyst_m_secondarycolor_blue"):GetInt() + 50, GetConVar("amethyst_m_secondarycolor_alpha"):GetInt())
		end

		surface.SetDrawColor( doContainerColor or Color(255,255,255,255) )
		surface.SetMaterial( Material( "amethyst/amethyst_gui_action_resetdefaults.png", "noclamp smooth" ) )
		surface.DrawTexturedRect( self:GetWide() - 19, self:GetTall() / 2 - 7, 14, 14 )

	end
	self.DButton_R_RD.DoClick = function()
		for k, v in pairs( fetchThemeSettings ) do
			if table.HasValue( Amethyst.Settings.IgnoreBlockTypes, v.DataType ) then continue end
			if v.DataType == "rgba" then
				for dn, dv in pairs(v.DataValues) do
					local Setdata = v.DataID .. "_" .. dn
					local Dataasdasd = GetConVar(Setdata)
					Dataasdasd:SetString( Dataasdasd:GetDefault() )
				end
			else
				local GetValueData = GetConVar(v.DataID)
				GetValueData:SetString( v.DataDefault )
			end
		end
		if IsValid( PanelRightFill ) then
			PanelRightFill:Clear()
			vgui.Create("Amethyst_Tab_Settings", PanelRightFill)
		end
	end

	self.DPanel_P_Container = vgui.Create("DPanel", Amethyst.Init)
	self.DPanel_P_Container:Dock(FILL)
	self.DPanel_P_Container:DockMargin(0,0,0,0)
	self.DPanel_P_Container.Paint = function(self, w, h)
		local AmethystBox = Color(GetConVar("amethyst_m_secondaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_secondaryaccent_color_alpha"):GetInt() )
		draw.AmethystBox( 0, 0, w, h, Color( AmethystBox.r, AmethystBox.g, AmethystBox.b, AmethystBox.a ) )
	end

	self.DPanel_P = vgui.Create("DPanel", Amethyst.Init)
	self.DPanel_P:Dock(FILL)
	self.DPanel_P:DockMargin(11,11,11,11)
	self.DPanel_P.Paint = function(self, w, h) end

	self.DScrollPanel_Settings = vgui.Create("DScrollPanel", self.DPanel_P)
	self.DScrollPanel_Settings:Dock(FILL)
	self.DScrollPanel_Settings:DockMargin(5,5,5,5)
	self.DScrollPanel_Settings:SetVisible(true)
	self.DScrollPanel_Settings.Paint = function(what, w, h) end

	if (Amethyst.Settings.Themes[cvar_th_s].DonatorOnly and not Amethyst.Settings.DonatorGroups[string.lower(LocalPlayer():GetUserGroup())]) and not LocalPlayer():IsSuperAdmin() then

		self.DScrollPanel_Settings:SetVisible(false)

		self.DPanel_P_Failsafe_Title = vgui.Create( "DPanel", self.DPanel_P )
		self.DPanel_P_Failsafe_Title:Dock(TOP)
		self.DPanel_P_Failsafe_Title:SetTall(25)
	    self.DPanel_P_Failsafe_Title:DockMargin(0,5,0,5)
		self.DPanel_P_Failsafe_Title.Paint = function( self, w, h )
	        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
			draw.DrawText( string.upper(Amethyst.Language["donator_only"] or "DONATOR ONLY"), "Amethyst.Font.SubSectionTitle", 5, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		end

	    self.DTextEntry_P_Failsafe_Desc = vgui.Create( "DTextEntry", self.DPanel_P )
	    self.DTextEntry_P_Failsafe_Desc:Dock( FILL )
	    self.DTextEntry_P_Failsafe_Desc:DockMargin(0,5,0,5)
	    self.DTextEntry_P_Failsafe_Desc:SetDrawBackground( false )
	    self.DTextEntry_P_Failsafe_Desc:SetText( Amethyst.Language.Themes_DonatorOnly_Desc or "" )
	    self.DTextEntry_P_Failsafe_Desc:SetTextColor( Color( 255, 255, 255, 255) )
	    self.DTextEntry_P_Failsafe_Desc:SetFont("Amethyst.Font.SettingsHelpDesc")
	    self.DTextEntry_P_Failsafe_Desc:SetTall(ScreenScale(40))
	    self.DTextEntry_P_Failsafe_Desc:SetMultiline(true)

	elseif (Amethyst.Settings.Themes[cvar_th_s].StaffOnly and not Amethyst.Settings.StaffGroups[string.lower(LocalPlayer():GetUserGroup())]) then

		self.DScrollPanel_Settings:SetVisible(false)

		self.DPanel_P_Failsafe_Title = vgui.Create( "DPanel", self.DPanel_P )
		self.DPanel_P_Failsafe_Title:Dock(TOP)
		self.DPanel_P_Failsafe_Title:SetTall(25)
	    self.DPanel_P_Failsafe_Title:DockMargin(0,5,0,5)
		self.DPanel_P_Failsafe_Title.Paint = function( self, w, h )
	        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
			draw.DrawText( string.upper(Amethyst.Language["network_staff_only"] or "NETWORK STAFF ONLY"), "Amethyst.Font.SubSectionTitle", 5, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		end

	    self.DTextEntry_P_Failsafe_Desc = vgui.Create( "DTextEntry", self.DPanel_P )
	    self.DTextEntry_P_Failsafe_Desc:Dock( FILL )
	    self.DTextEntry_P_Failsafe_Desc:DockMargin(0,5,0,5)
	    self.DTextEntry_P_Failsafe_Desc:SetDrawBackground( false )
	    self.DTextEntry_P_Failsafe_Desc:SetText( Amethyst.Language.Themes_StaffOnly_Desc or "" )
	    self.DTextEntry_P_Failsafe_Desc:SetTextColor( Color( 255, 255, 255, 255) )
	    self.DTextEntry_P_Failsafe_Desc:SetFont("Amethyst.Font.SettingsHelpDesc")
	    self.DTextEntry_P_Failsafe_Desc:SetTall(ScreenScale(40))
	    self.DTextEntry_P_Failsafe_Desc:SetMultiline(true)

	end

	if cvar_th_s == "failsafe" then

		self.DScrollPanel_Settings:SetVisible(false)

		self.DPanel_P_Failsafe_Title = vgui.Create( "DPanel", self.DPanel_P )
		self.DPanel_P_Failsafe_Title:Dock(TOP)
		self.DPanel_P_Failsafe_Title:SetTall(25)
	    self.DPanel_P_Failsafe_Title:DockMargin(0,5,0,5)
		self.DPanel_P_Failsafe_Title.Paint = function( self, w, h )
	        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
			draw.DrawText( string.upper(Amethyst.Language["failsafe_activated"] or "FAILSAFE ACTIVATED"), "Amethyst.Font.SubSectionTitle", 5, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		end

	    self.DTextEntry_P_Failsafe_Desc = vgui.Create( "DTextEntry", self.DPanel_P )
	    self.DTextEntry_P_Failsafe_Desc:Dock( FILL )
	    self.DTextEntry_P_Failsafe_Desc:DockMargin(0,5,0,5)
	    self.DTextEntry_P_Failsafe_Desc:SetDrawBackground( false )
	    self.DTextEntry_P_Failsafe_Desc:SetText( Amethyst.Language.Themes_Failsafe_Desc or "" )
	    self.DTextEntry_P_Failsafe_Desc:SetTextColor( Color( 255, 255, 255, 255) )
	    self.DTextEntry_P_Failsafe_Desc:SetFont("Amethyst.Font.SettingsHelpDesc")
	    self.DTextEntry_P_Failsafe_Desc:SetTall(ScreenScale(40))
	    self.DTextEntry_P_Failsafe_Desc:SetMultiline(true)

	end

	self.VBar_Settings = self.DScrollPanel_Settings:GetVBar()
	self.VBar_Settings:SetWide(10)
	self.VBar_Settings:Dock(RIGHT)
	self.VBar_Settings:DockMargin(0,0,0,0)
	self.VBar_Settings.Paint = function(self,w,h) end
	self.VBar_Settings.btnUp.Paint = function(self, w, h) end
	self.VBar_Settings.btnDown.Paint = function(self, w, h) end
	self.VBar_Settings.btnGrip.Paint = function(self, w, h)
		draw.RoundedBox( 4, 7, 0, 4, h + 22, Color(GetConVar("amethyst_m_sbcolor_red"):GetInt(), GetConVar("amethyst_m_sbcolor_green"):GetInt(), GetConVar("amethyst_m_sbcolor_blue"):GetInt(), GetConVar("amethyst_m_sbcolor_alpha"):GetInt()) or Color(0, 0, 0, 100) )
	end

	local countRestricted = 0
	for k, v in pairs( fetchThemeSettings ) do

		local ConfigType 	= v.DataType
		local ConfigName 	= tostring(k)

		if v.DataSpecial then
			local hasSpecial = string.Split( v.DataSpecial, "|" )
			if (table.HasValue( hasSpecial, "no_compact") and GetConVar("amethyst_m_compactmode_enabled"):GetInt() == 1 ) then
				continue
			end
		end

		if v.DataGroupsOnly then
			local lenGroups = string.len( v.DataGroupsOnly )
			if lenGroups > 0 then
				local hasGroup = string.Split( v.DataGroupsOnly, "|" )
				if not (table.HasValue( hasGroup, string.lower(LocalPlayer():GetUserGroup()))) then
					countRestricted = countRestricted + 1
					continue
				end
			end
		end

		if not v.DataIsVisible then continue end

		if ConfigType == "category" then

			self.DPanel_Category = vgui.Create("DPanel", self.DScrollPanel_Settings)
			self.DPanel_Category:Dock(TOP)
			self.DPanel_Category:SetTall(25)
		    self.DPanel_Category:DockMargin(0,0,8,10)
			self.DPanel_Category.Paint = function(self, w, h)
        		draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
				draw.DrawText( string.upper(v.DataName or "" ), "Amethyst.Font.SubSectionTitle", 7, 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			end

		elseif ConfigType == "desc" then

			self.DPanel_Description = vgui.Create("DPanel", self.DScrollPanel_Settings)
			self.DPanel_Description:Dock(TOP)
			self.DPanel_Description:SetTall(ScreenScale(25))
		    self.DPanel_Description:DockMargin(0,4,0,0)
			self.DPanel_Description.Paint = function(self, w, h) end

		    self.DTextEntry_Description = vgui.Create( "DTextEntry", self.DPanel_Description )
		    self.DTextEntry_Description:Dock( FILL )
		    self.DTextEntry_Description:DockMargin(3,0,5,5)
		    self.DTextEntry_Description:SetDrawBackground( false )
		    self.DTextEntry_Description:SetText( "" )
		    self.DTextEntry_Description:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
		    self.DTextEntry_Description:SetFont("Amethyst.Font.SubSectionDesc")
		    self.DTextEntry_Description:SetMultiline(true)
    		self.DTextEntry_Description:SetText( v.DataName or "" )

		elseif ConfigType == "padding" then

			self.DPanel_Header = vgui.Create("DPanel", self.DScrollPanel_Settings)
			self.DPanel_Header:Dock(TOP)
			self.DPanel_Header:DockMargin(5,5,10,5)
			self.DPanel_Header.Paint = function(self, w, h) end

		elseif ConfigType == "spacer" then

			self.DPanel_Spacer = vgui.Create("DPanel", self.DScrollPanel_Settings)
			self.DPanel_Spacer:Dock(TOP)
			self.DPanel_Spacer:DockMargin(5,5,20,5)
			self.DPanel_Spacer:SetTall(5)
			self.DPanel_Spacer.Paint = function(self, w, h)
				draw.RoundedBox(0, 5, h - 1, w, 1, Color(0, 55, 79, 255))
			end

		elseif ConfigType == "checkbox" then

			local GetValueData = GetConVar(v.DataID)

			self.DPanel_Checkbox = vgui.Create("DPanel", self.DScrollPanel_Settings)
			self.DPanel_Checkbox:Dock(TOP)
			self.DPanel_Checkbox:DockMargin(0,5,20,0)
			self.DPanel_Checkbox:SetTall(30)
			self.DPanel_Checkbox.Paint = function(self, w, h) end

			self.DLabel_Checkbox = vgui.Create("DButton", self.DPanel_Checkbox)
			self.DLabel_Checkbox:SetFont("Amethyst.Font.ConfigurationSec")
			self.DLabel_Checkbox:DockMargin(5, 0, 0, 8)
			self.DLabel_Checkbox:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
			self.DLabel_Checkbox:SetText("")
			self.DLabel_Checkbox:Dock(LEFT)
			self.DLabel_Checkbox:SetWide(120)
			self.DLabel_Checkbox.Paint = function(what, w, h)
				draw.SimpleText(v.DataName or "", "Amethyst.Font.ConfigurationSec", 0, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				if (what:IsHovered() or what:IsDown()) and (IsValid(self.DTextEntry_T_HC_Desc)) then
				    self.DTextEntry_T_HC_Desc.Paint = function(self, uw, vh)
						draw.RoundedBox( 0, 0, 0, uw, vh, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
				        surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
				        surface.SetMaterial( Material( "amethyst/amethyst_gui_qtip.png", "noclamp smooth" ) )
				        surface.DrawTexturedRect( 15, vh / 2 - 9, 18, 18 )
						draw.DrawText( v.DataDesc or Amethyst.Language["no_info_available"] or "No info available", "Amethyst.Font.SettingsHelpDesc", 35, 9, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				end
			end

			self.DPanel_Checkbox_Right = vgui.Create("DPanel", self.DPanel_Checkbox)
			self.DPanel_Checkbox_Right:Dock(FILL)
			self.DPanel_Checkbox_Right:DockMargin(5,0,0,0)
			self.DPanel_Checkbox_Right.Paint = function(self, w, h) end

			self.DCheckBox_Checkbox = vgui.Create("DCheckBox", self.DPanel_Checkbox_Right)
			self.DCheckBox_Checkbox:SetValue(GetValueData:GetInt() )
			self.DCheckBox_Checkbox:SetText("")
			self.DCheckBox_Checkbox:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
			self.DCheckBox_Checkbox:SetConVar(GetValueData:GetName())
			self.DCheckBox_Checkbox:DockMargin(0, 2, 0, 7)
			self.DCheckBox_Checkbox:Dock(RIGHT)
			self.DCheckBox_Checkbox:SetWide(20)
			self.DCheckBox_Checkbox.Paint = function(self, w, h)
				local col1 = Color(GetConVar("amethyst_m_chkbox_color_red"):GetInt(), GetConVar("amethyst_m_chkbox_color_green"):GetInt(), GetConVar("amethyst_m_chkbox_color_blue"):GetInt(), GetConVar("amethyst_m_chkbox_color_alpha"):GetInt())
				local col2 = Color(GetConVar("amethyst_m_chkbox_color_red"):GetInt(), GetConVar("amethyst_m_chkbox_color_green"):GetInt(), GetConVar("amethyst_m_chkbox_color_blue"):GetInt(), 255)
				local bordercol = Color(GetConVar("amethyst_m_chkbox_ocolor_red"):GetInt(), GetConVar("amethyst_m_chkbox_ocolor_green"):GetInt(), GetConVar("amethyst_m_chkbox_ocolor_blue"):GetInt(), GetConVar("amethyst_m_chkbox_ocolor_alpha"):GetInt())
				local ImageCheckmark = Material("amethyst/amethyst_gui_check.png", "smooth noclamp")
				if (self.Hovered) then
					draw.AmethystOutlinedBox( 0, 0, 18, 20, col2, bordercol)
				else
					draw.AmethystOutlinedBox( 0, 0, 18, 20, col1, bordercol)
				end
				if (self:GetChecked()) then
                    surface.SetDrawColor(Color( 255, 255, 255, 255 ))
                    surface.SetMaterial(ImageCheckmark)
                    surface.DrawTexturedRect(4, 5, 10, 10)
				end
			end
			self.DCheckBox_Checkbox.OnChange = function() end

		elseif ConfigType == "slider" then

			local GetValueData = GetConVar(v.DataID)

			self.DPanel_Boolean = vgui.Create("DPanel", self.DScrollPanel_Settings)
			self.DPanel_Boolean:Dock(TOP)
			self.DPanel_Boolean:SetTall(30)
			self.DPanel_Boolean:DockMargin(0,5,20,0)
			self.DPanel_Boolean.Paint = function(self, w, h) end

			self.DLabel_Number = vgui.Create("DButton", self.DPanel_Boolean)
			self.DLabel_Number:SetFont("Amethyst.Font.ConfigurationSec")
			self.DLabel_Number:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
			self.DLabel_Number:SetText("")
			self.DLabel_Number:Dock(LEFT)
			self.DLabel_Number:DockMargin(5,0,0,8)
			self.DLabel_Number:SetWide(120)
			self.DLabel_Number.Paint = function(what, w, h)
				draw.SimpleText(v.DataName or "", "Amethyst.Font.ConfigurationSec", 0, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				if (what:IsHovered() or what:IsDown()) and (IsValid(self.DTextEntry_T_HC_Desc)) then
				    self.DTextEntry_T_HC_Desc.Paint = function(self, uw, vh)
						draw.RoundedBox( 0, 0, 0, uw, vh, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
				        surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
				        surface.SetMaterial( Material( "amethyst/amethyst_gui_qtip.png", "noclamp smooth" ) )
				        surface.DrawTexturedRect( 15, vh / 2 - 9, 18, 18 )
						draw.DrawText( v.DataDesc or Amethyst.Language["no_info_available"] or "No info available", "Amethyst.Font.SettingsHelpDesc", 35, 9, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				end
			end

			self.DPanel_Number_Right = vgui.Create("DPanel", self.DPanel_Boolean)
			self.DPanel_Number_Right:Dock(FILL)
			self.DPanel_Number_Right:DockMargin(5,0,0,6)
			self.DPanel_Number_Right:SetWide(300)
			self.DPanel_Number_Right.Paint = function(self, w, h) end

			self.Slider_Number = vgui.Create("amethyst.slider", self.DPanel_Number_Right)
			self.Slider_Number:SetMin( v.DataMin )
			self.Slider_Number:SetMax( v.DataMax )
			self.Slider_Number:SetWide(306)
			self.Slider_Number:Dock(RIGHT)
			self.Slider_Number:DockMargin(0, 0, 0, 0)
			self.Slider_Number:SetTall(7)
			self.Slider_Number:SetValue( GetValueData:GetFloat() )
			self.Slider_Number.convarname = GetValueData
			self.Slider_Number.OnValueChanged = function(self)
				GetValueData:SetInt( self:GetValue() )
			end

		elseif ConfigType == "rgba" then

			self.DPanel_RGBA_Container = vgui.Create("DPanel", self.DScrollPanel_Settings)
			self.DPanel_RGBA_Container:Dock(TOP)
			self.DPanel_RGBA_Container:DockMargin(0, 0, 20, 0)
			self.DPanel_RGBA_Container:SetTall(30)
			self.DPanel_RGBA_Container.Paint = function(self, w, h) end

			self.DLabel_RGBA_Title = vgui.Create("DButton", self.DPanel_RGBA_Container)
			self.DLabel_RGBA_Title:SetFont("Amethyst.Font.ConfigurationSec")
			self.DLabel_RGBA_Title:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ))
			self.DLabel_RGBA_Title:SetText("")
			self.DLabel_RGBA_Title:Dock(LEFT)
			self.DLabel_RGBA_Title:DockMargin(5, 0, 0, 8)
			self.DLabel_RGBA_Title:SetWide(ScreenScale(80))
			self.DLabel_RGBA_Title.Paint = function(what, w, h)
				draw.SimpleText(v.DataName or "", "Amethyst.Font.ConfigurationSec", 0, h - 8, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				if (what:IsHovered() or what:IsDown()) and (IsValid(self.DTextEntry_T_HC_Desc)) then
				    self.DTextEntry_T_HC_Desc.Paint = function(self, uw, vh)
						draw.RoundedBox( 0, 0, 0, uw, vh, Color(GetConVar("amethyst_m_primaryaccent_color_red"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_green"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_blue"):GetInt(), GetConVar("amethyst_m_primaryaccent_color_alpha"):GetInt() ) )
				        surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
				        surface.SetMaterial( Material( "amethyst/amethyst_gui_qtip.png", "noclamp smooth" ) )
				        surface.DrawTexturedRect( 15, vh / 2 - 9, 18, 18 )
						draw.DrawText( v.DataDesc or Amethyst.Language["no_info_available"] or "No info available", "Amethyst.Font.SettingsHelpDesc", 35, 9, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				end
			end

			self.DPanel_RGBA_RContainer = vgui.Create("DPanel", self.DPanel_RGBA_Container) -- spacer
			self.DPanel_RGBA_RContainer:Dock(FILL)
			self.DPanel_RGBA_RContainer:DockMargin(5, 7, 0, 0)
			self.DPanel_RGBA_RContainer:SetWide(300)
			self.DPanel_RGBA_RContainer.Paint = function(self, w, h) end

			for dn, dv in pairs(v.DataValues) do

				local Setdata = v.DataID .. "_" .. dn
				local Dataasdasd = GetConVar(Setdata)

				local GetValueData = GetConVar(v.DataID .. "_" .. dn)
				local fetchConVarName = GetValueData:GetName()

				self.Slider_Object = vgui.Create("amethyst.slider", self.DPanel_RGBA_RContainer)
				self.Slider_Object:SetMin( v.DataMin )
				self.Slider_Object:SetMax( v.DataMax )
				self.Slider_Object:SetWide(65)
				self.Slider_Object:Dock(RIGHT)
				self.Slider_Object:DockMargin(15,0,0,0)
				self.Slider_Object:SetTall(7)
				self.Slider_Object:SetValue( Dataasdasd:GetFloat() )
				self.Slider_Object.convarname = Setdata
				self.Slider_Object.OnValueChanged = function(self)
					Dataasdasd:SetInt( self:GetValue() )
				end
				self.Slider_Object.Knob.Paint = function(what, w, h)
					local knobColorResult = Color(GetConVar("amethyst_ui_rgba_a_gcolor_red"):GetInt(), GetConVar("amethyst_ui_rgba_a_gcolor_green"):GetInt(), GetConVar("amethyst_ui_rgba_a_gcolor_blue"):GetInt(), GetConVar("amethyst_ui_rgba_a_gcolor_alpha"):GetInt() ) or Color(255,255,255,255)
					if string.match(fetchConVarName, "_red") then
						knobColorResult = Color(GetConVar("amethyst_ui_rgba_r_gcolor_red"):GetInt(), GetConVar("amethyst_ui_rgba_r_gcolor_green"):GetInt(), GetConVar("amethyst_ui_rgba_r_gcolor_blue"):GetInt(), GetConVar("amethyst_ui_rgba_r_gcolor_alpha"):GetInt() ) or Color(232, 53, 53, 255)
					elseif string.match(fetchConVarName, "_green") then
						knobColorResult = Color(GetConVar("amethyst_ui_rgba_g_gcolor_red"):GetInt(), GetConVar("amethyst_ui_rgba_g_gcolor_green"):GetInt(), GetConVar("amethyst_ui_rgba_g_gcolor_blue"):GetInt(), GetConVar("amethyst_ui_rgba_g_gcolor_alpha"):GetInt() ) or Color(24, 150, 24, 255)
					elseif string.match(fetchConVarName, "_blue") then
						knobColorResult = Color(GetConVar("amethyst_ui_rgba_b_gcolor_red"):GetInt(), GetConVar("amethyst_ui_rgba_b_gcolor_green"):GetInt(), GetConVar("amethyst_ui_rgba_b_gcolor_blue"):GetInt(), GetConVar("amethyst_ui_rgba_b_gcolor_alpha"):GetInt() ) or Color(24, 91, 150, 255)
					end
					draw.RoundedBox(4, 1, 3, w - 2, h - 5, knobColorResult or Color(GetConVar("amethyst_ui_slider_gcolor_red"):GetInt(), GetConVar("amethyst_ui_slider_gcolor_green"):GetInt(), GetConVar("amethyst_ui_slider_gcolor_blue"):GetInt(), GetConVar("amethyst_ui_slider_gcolor_alpha"):GetInt() ))
				end

			end

			self.DPanel_RGBA_Demo = vgui.Create("DPanel", self.DPanel_RGBA_Container)
			self.DPanel_RGBA_Demo:Dock(LEFT)
			self.DPanel_RGBA_Demo:DockMargin(35, 10, 5, 9)
			self.DPanel_RGBA_Demo:SetWide(20)
			self.DPanel_RGBA_Demo:SetTall(20)
			self.DPanel_RGBA_Demo.Paint = function(self, w, h)
				local DemoOptionR = GetConVar(v.DataID .. "_red"):GetInt()
				local DemoOptionG = GetConVar(v.DataID .. "_green"):GetInt()
				local DemoOptionB = GetConVar(v.DataID .. "_blue"):GetInt()
				local DemoOptionA = GetConVar(v.DataID .. "_alpha"):GetInt()
				draw.AmethystOutlinedBox( 0, 0, w, h, Color( DemoOptionR, DemoOptionG, DemoOptionB, DemoOptionA ), Color(GetConVar("amethyst_m_secondarybordercolor_red"):GetInt(), GetConVar("amethyst_m_secondarybordercolor_green"):GetInt(), GetConVar("amethyst_m_secondarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_secondarybordercolor_alpha"):GetInt()) )
			end

		elseif ConfigType == "dropdown" then

			local GetValueData = GetConVar(v.DataID)

			local DPanel_Dropdown_Container = vgui.Create("DPanel", self.DScrollPanel_Settings)
			DPanel_Dropdown_Container:Dock(TOP)
			DPanel_Dropdown_Container:DockMargin(0, 0, 20, 0)
			DPanel_Dropdown_Container:SetTall(30)
			DPanel_Dropdown_Container.Paint = function(self, w, h) end

			local DLabel_Dropdown = vgui.Create("DButton", DPanel_Dropdown_Container)
			DLabel_Dropdown:SetFont("Amethyst.Font.ConfigurationSec")
			DLabel_Dropdown:DockMargin(5, 0, 0, 5)
			DLabel_Dropdown:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
			DLabel_Dropdown:SetText("")
			DLabel_Dropdown:Dock(LEFT)
			DLabel_Dropdown:SetWide(120)
			DLabel_Dropdown.Paint = function(what, w, h)
				draw.SimpleText(v.DataName or "", "Amethyst.Font.ConfigurationSec", 0, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				if (what:IsHovered() or what:IsDown()) and (IsValid(self.DTextEntry_B_HC_Desc)) then
				    self.DTextEntry_B_HC_Desc.Paint = function(self, uw, vh)
				        surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
				        surface.SetMaterial( Material( "amethyst/amethyst_gui_qtip.png", "noclamp smooth" ) )
				        surface.DrawTexturedRect( 5, vh / 2 - 9, 18, 18 )
						draw.DrawText( v.DataDesc or Amethyst.Language["no_info_available"] or "No info available", "Amethyst.Font.SettingsHelpDesc", 30, 4, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
					end
				end
			end

			local DPanel_Dropdown_RContainer = vgui.Create("DPanel", DPanel_Dropdown_Container) -- spacer
			DPanel_Dropdown_RContainer:Dock(FILL)
			DPanel_Dropdown_RContainer:DockMargin(5,0,0,0)
			DPanel_Dropdown_RContainer:SetWide(300)
			DPanel_Dropdown_RContainer.Paint = function(self, w, h) end

			local DComboBox_Dropdown_Object = vgui.Create("DComboBox", DPanel_Dropdown_RContainer)
			DComboBox_Dropdown_Object:SetWide(200)
			DComboBox_Dropdown_Object:Dock(RIGHT)
			DComboBox_Dropdown_Object:SetTall(7)
			DComboBox_Dropdown_Object:SetValue( GetValueData:GetString() )
			for k, v in pairs( v.DataValues ) do
				DComboBox_Dropdown_Object:AddChoice( v )
			end
			DComboBox_Dropdown_Object.convarname = v[2]
			DComboBox_Dropdown_Object.OnSelect = function(self)
				GetValueData:SetString( self:GetValue() )
			end
			DComboBox_Dropdown_Object.Paint = function(what, w, h)
				ConVar_DropdownColor = Color(GetConVar("amethyst_m_dropdown_color_red"):GetInt(), GetConVar("amethyst_m_dropdown_color_green"):GetInt(), GetConVar("amethyst_m_dropdown_color_blue"):GetInt(), GetConVar("amethyst_m_dropdown_color_alpha"):GetInt())
				ConVar_DropdownOutlineColor = Color(GetConVar("amethyst_m_dropdown_ocolor_red"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_green"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_blue"):GetInt(), GetConVar("amethyst_m_dropdown_ocolor_alpha"):GetInt())

				draw.AmethystOutlinedBox(0, 0, w, h, ConVar_DropdownColor, ConVar_DropdownOutlineColor)
				what:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
				what:SetTextInset( 20, 0 )
			end
			function DComboBox_Dropdown_Object:DoClick()
				if ( self:IsMenuOpen() ) then
					return self:CloseMenu()
				end
				self:OpenMenu()

			 	for k,v in pairs( DComboBox_Dropdown_Object.Menu:GetCanvas():GetChildren() ) do
					function v:Paint(w, h)
						local col1 = Color(GetConVar("amethyst_m_dropdown_icolor_red"):GetInt(), GetConVar("amethyst_m_dropdown_icolor_green"):GetInt(), GetConVar("amethyst_m_dropdown_icolor_blue"):GetInt(), GetConVar("amethyst_m_dropdown_icolor_alpha"):GetInt())
						surface.SetDrawColor(col1)
						surface.DrawRect(0, 0, w, h)
					end
				end
			end
			function DComboBox_Dropdown_Object:OpenMenu( pControlOpener )
				if ( pControlOpener && pControlOpener == self.TextEntry ) then
					return
				end

				if ( #self.Choices == 0 ) then return end

				if ( IsValid( self.Menu ) ) then
					self.Menu:Remove()
					self.Menu = nil
				end

				self.Menu = DermaMenu( false, self )

				local sorted = {}
				for k, v in pairs( self.Choices ) do table.insert( sorted, { id = k, data = v } ) end
				for k, v in SortedPairsByMemberValue( sorted, "data" ) do
					local p = self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
					p:SetFont( self:GetFont() )
					p:SetTextColor(Color(255,255,255,255))
				end

				local x, y = self:LocalToScreen( 0, self:GetTall() )

				self.Menu:SetMinimumWidth( self:GetWide() )
				self.Menu:Open( x, y, false, self )
			end

		end

	end

	if countRestricted > 0 then

	    self.DPanel_T_RST = vgui.Create("DPanel", Amethyst.Init)
	    self.DPanel_T_RST:Dock(TOP)
	    self.DPanel_T_RST:DockMargin(0, 0, 0, 0)
	    self.DPanel_T_RST:SetTall(35)
	    self.DPanel_T_RST.Paint = function(self, w, h)
	        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), 100))
	    end

	    self.DPanel_T_Spacer_001 = vgui.Create("DPanel", Amethyst.Init)
	    self.DPanel_T_Spacer_001:Dock(TOP)
	    self.DPanel_T_Spacer_001:SetTall(2)
	    self.DPanel_T_Spacer_001.Paint = function(self, w, h)
	        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_primarybordercolor_red"):GetInt(), GetConVar("amethyst_m_primarybordercolor_green"):GetInt(), GetConVar("amethyst_m_primarybordercolor_blue"):GetInt(), GetConVar("amethyst_m_primarybordercolor_alpha"):GetInt()) or Color( 255, 255, 255, 15 ) )
	    end

	    self.DTextEntry_T_RST_Info = vgui.Create( "DTextEntry", self.DPanel_T_RST )
	    self.DTextEntry_T_RST_Info:Dock( FILL )
	    self.DTextEntry_T_RST_Info:DockMargin(5,5,25,5)
	    self.DTextEntry_T_RST_Info:SetDrawBackground( false )
	    self.DTextEntry_T_RST_Info:SetText( "" )
	    self.DTextEntry_T_RST_Info:SetTextColor( Color( 255, 255, 255, 255) )
	    self.DTextEntry_T_RST_Info:SetFont("Amethyst.Font.SettingsHelpDesc")
	    self.DTextEntry_T_RST_Info:SetMultiline(false)
	    self.DTextEntry_T_RST_Info.Paint = function(self, w, h)
			draw.DrawText( "[" .. countRestricted .. "] " .. Amethyst.Language.ReservedProperties or "", "Amethyst.Font.SettingsHelpDesc", 10, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

	end

	if ( cvar_th_s != "failsafe" and not Amethyst.Settings.Themes[cvar_th_s].DonatorOnly and not Amethyst.Settings.Themes[cvar_th_s].StaffOnly ) or LocalPlayer():IsSuperAdmin() then

	    self.DPanel_B = vgui.Create("DPanel", Amethyst.Init)
	    self.DPanel_B:Dock(BOTTOM)
	    self.DPanel_B:DockMargin(0, 0, 0, 0)
	    self.DPanel_B:SetTall(35)
	    self.DPanel_B.Paint = function(self, w, h)
	        draw.RoundedBox( 0, 0, 0, w, h, Color( 10, 10, 10, 200 ) )
	    end

	    self.DTextEntry_B_AC_Info = vgui.Create( "DTextEntry", self.DPanel_B )
	    self.DTextEntry_B_AC_Info:Dock( FILL )
	    self.DTextEntry_B_AC_Info:DockMargin(11,5,25,5)
	    self.DTextEntry_B_AC_Info:SetDrawBackground( false )
	    self.DTextEntry_B_AC_Info:SetText( "" )
	    self.DTextEntry_B_AC_Info:SetTextColor( Color( 255, 255, 255, 255) )
	    self.DTextEntry_B_AC_Info:SetFont("Amethyst.Font.SettingsHelpDesc")
	    self.DTextEntry_B_AC_Info:SetMultiline(false)
	    self.DTextEntry_B_AC_Info.Paint = function(self, w, h)
			draw.DrawText( Amethyst.Language["save_refresh_notice"] or "Make sure to save your changes -- this will ensure everything is refreshed.", "Amethyst.Font.SettingsHelpDesc", 10, 5, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

        self.DButton_ApplyChanges = vgui.Create( "DButton", self.DPanel_B )
        self.DButton_ApplyChanges:Dock(RIGHT)
        self.DButton_ApplyChanges:SetToolTip("Apply Changes")
        self.DButton_ApplyChanges:DockMargin(0, 0, 10, 0)
        self.DButton_ApplyChanges:SetSize( 100, 22 )
        self.DButton_ApplyChanges:SetText("")
        self.DButton_ApplyChanges.Paint = function( self, w, h )
        	draw.RoundedBox( 4, 0, h/2 - 11, 100, 22, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()))
			draw.SimpleText(Amethyst.Language["apply_changes"] or "Apply Changes", "Amethyst.Font.ConfigurationSec", w / 2, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        self.DButton_ApplyChanges.DoClick = function()
            Amethyst.RemoveTimers()
            Amethyst.PanelMenu:Remove()
            DarkRP.toggleF4Menu()
            if IsValid( PanelRightFill ) then
            	timer.Create("amethyst.settings.reopen", 0.5, 1, function()
					PanelRightFill:Clear()
					vgui.Create("Amethyst_Tab_Settings", PanelRightFill)
				end)
			end
       	end

	end

end
vgui.Register("Amethyst_Tab_Settings", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/