/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/
--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 
	DComboBox
--]]

local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "ComboBox" )

Derma_Install_Convar_Functions( PANEL )

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()

	self.DropButton = vgui.Create( "DPanel", self )
	self.DropButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ComboDownArrow", panel, w, h ) end
	self.DropButton:SetMouseInputEnabled( false )
	self.DropButton.ComboBox = self

	self:SetTall( 22 )
	self:Clear()

	self:SetContentAlignment( 4 )
	self:SetTextInset( 8, 0 )
	self:SetIsMenu( true )

end

--[[---------------------------------------------------------
   Name: Clear
-----------------------------------------------------------]]
function PANEL:Clear()

	self:SetText( "" )
	self.Choices = {}
	self.Data = {}

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end
	
end

function PANEL:Paint()
		if self.Depressed or self.m_bSelected then
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 120, 255 ) )
		elseif self.Hovered then
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 140, 255 ) )
		else
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 160, 255 ) )
		end
end

--[[---------------------------------------------------------
   Name: GetOptionText
-----------------------------------------------------------]]
function PANEL:GetOptionText( id )

	return self.Choices[ id ]

end

--[[---------------------------------------------------------
   Name: GetOptionData
-----------------------------------------------------------]]
function PANEL:GetOptionData( id )

	return self.Data[ id ]

end

--[[---------------------------------------------------------
   Name: PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()

	self.DropButton:SetSize( 15, 15 )
	self.DropButton:AlignRight( 4 )
	self.DropButton:CenterVertical()

end

--[[---------------------------------------------------------
   Name: ChooseOption
-----------------------------------------------------------]]
function PANEL:ChooseOption( value, index )

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self:SetText( value )
	
	self.selected = index
	self:OnSelect( index, value, self.Data[index] )
	
end

--[[---------------------------------------------------------
   Name: ChooseOptionID
-----------------------------------------------------------]]
function PANEL:ChooseOptionID( index )

	local value = self:GetOptionText( index )
	self:ChooseOption( value, index )

end

--[[---------------------------------------------------------
   Name: GetSelected
-----------------------------------------------------------]]
function PANEL:GetSelectedID()

	return self.selected

end



--[[---------------------------------------------------------
   Name: GetSelected
-----------------------------------------------------------]]
function PANEL:GetSelected()
	
	if ( !self.selected ) then return end
	
	return self:GetOptionText(self.selected), self:GetOptionData(self.selected)
	
end


--[[---------------------------------------------------------
   Name: OnSelect
-----------------------------------------------------------]]
function PANEL:OnSelect( index, value, data )

	-- For override

end

--[[---------------------------------------------------------
   Name: AddChoice
-----------------------------------------------------------]]
function PANEL:AddChoice( value, data, select )

	local i = table.insert( self.Choices, value )

	if ( data ) then
		self.Data[ i ] = data
	end

	if ( select ) then

		self:ChooseOption( value, i )

	end
	
	return i

end

function PANEL:IsMenuOpen()

	return IsValid( self.Menu ) && self.Menu:IsVisible()

end

--[[---------------------------------------------------------
   Name: OpenMenu
-----------------------------------------------------------]]
function PANEL:OpenMenu( pControlOpener )

	if ( pControlOpener ) then
		if ( pControlOpener == self.TextEntry ) then
			return
		end
	end

	-- Don't do anything if there aren't any options..
	if ( #self.Choices == 0 ) then return end
	
	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self.Menu = ULogs_DermaMenu()
	
	local sorted = {}
	for k, v in pairs( self.Choices ) do table.insert( sorted, { id = k, data = v } ) end
	for k, v in SortedPairsByMemberValue( sorted, "data" ) do
		self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
	end
	
	local x, y = self:LocalToScreen( 0, self:GetTall() )
	
	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, false, self )

end

function PANEL:CloseMenu()

	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
	end
	
end

function PANEL:Think()

	self:ConVarNumberThink()

end

function PANEL:SetValue( strValue )

	self:SetText( strValue )

end

function PANEL:DoClick()

	if ( self:IsMenuOpen() ) then
		return self:CloseMenu()
	end
	
	self:OpenMenu()

end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:AddChoice( "Some Choice" )
	ctrl:AddChoice( "Another Choice" )
	ctrl:SetWide( 150 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "ULogs_DComboBox", "", PANEL, "DButton" )
/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/