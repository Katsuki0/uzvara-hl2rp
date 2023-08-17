/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/

--[[   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 
	DScrollBarGrip
--]]

local PANEL = {}

--[[---------------------------------------------------------
   Name: Init
-----------------------------------------------------------]]
function PANEL:Init()
end

--[[---------------------------------------------------------
   Name: OnMousePressed
-----------------------------------------------------------]]
function PANEL:OnMousePressed()

	self:GetParent():Grip( 1 )

end

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Paint( w, h )
	
	if ( self:GetDisabled() ) then
		return draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 75, 75, 75, 255 ) )
	end
	
	if ( self.Depressed ) then
		return draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 140, 255, 255 ) )
	end
	
	if ( self.Hovered ) then
		return draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 160, 255, 255 ) )
	end
	
	return draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 180, 255, 255 ) )
	
end

derma.DefineControl( "ULogs_DScrollBarGrip", "A Scrollbar Grip", PANEL, "DPanel" )

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/