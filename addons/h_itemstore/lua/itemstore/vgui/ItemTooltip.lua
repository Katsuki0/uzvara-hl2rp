DEFINE_BASECLASS( "DListLayout" )

local PANEL = {}

AccessorFunc( PANEL, "ContainerID", "ContainerID", FORCE_NUMBER )
AccessorFunc( PANEL, "Slot", "Slot", FORCE_NUMBER )
AccessorFunc( PANEL, "Item", "Item" )

function PANEL:Init()
	self:SetWide( 200 )
	self:SetDrawOnTop( true )
	self:DockPadding( 5, 5, 5, 5 )

	self.Name = self:Add( "DLabel" )
	self.Name:SetFont( "DermaDefaultBold" )
	self.Name:SetWrap( true )

	self.Model = self:Add( "DModelPanel" )
	self.Model:SetSize( 125, 125 )

	self.Description = self:Add( "DLabel" )
	self.Description:SetWrap( true )
end

PANEL.Blur = Material( "pp/blurscreen" )
function PANEL:Paint( w, h )
	self.Blur:SetFloat( "$blur", 8 )
	self.Blur:Recompute()
	render.UpdateScreenEffectTexture()

	local x, y = self:LocalToScreen( 0, 0 )

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( self.Blur )
	surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )

	surface.SetDrawColor( Color( 30, 30, 30, 200 ) )
	surface.DrawRect( 0, 0, w, h )
end

function PANEL:PerformLayout()
	self.Name:SizeToContents()
	self.Description:SizeToContents()

	BaseClass.PerformLayout( self )
end

function PANEL:Refresh()
	local item = self:GetItem()

	if not item then
		self.Model.Entity:Remove()
		self.Name:SetText( "" )
		self.Description:SetText( "" )

		return
	end

	local name = item:GetName()
	local desc = item:GetDescription() or ""

	if item:GetAmount() > 1 then
		name = name .. " x" .. item:GetAmount()
	end

	if self:GetSlot() then
		desc = desc .. "\n\n" .. itemstore.Translate( "dragtomove" )
		desc = desc .. "\n" .. itemstore.Translate( "mclicktodrop" )
		desc = desc .. "\n" .. itemstore.Translate( "rclickforoptions" )

		if item.Use then
			desc = desc .. "\n" .. itemstore.Translate( "dclicktouse" )
		end
	end

	self.Name:SetText( name )
	self.Name:SizeToContents()

	self.Description:SetText( desc )
	self.Description:SizeToContents()

	self.Model:SetModel( item:GetModel() )

	self.Model.Entity:SetMaterial( item:GetMaterial() )
	self.Model:SetColor( item:GetColor() or color_white )

	min, max = self.Model.Entity:GetRenderBounds()

	self.Model:SetCamPos( Vector( 0.55, 0.55, 0.55 ) * min:Distance( max ) )
	self.Model:SetLookAt( ( min + max ) / 2 )

	self:InvalidateLayout( true )
end

vgui.Register( "ItemStoreTooltip", PANEL, "DListLayout" )
