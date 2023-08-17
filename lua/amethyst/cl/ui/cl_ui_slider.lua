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

AccessorFunc(PANEL, "m_iMin", "Min")
AccessorFunc(PANEL, "m_iMax", "Max")
AccessorFunc(PANEL, "m_iRange", "Range")
AccessorFunc(PANEL, "m_iValue", "Value")
AccessorFunc(PANEL, "m_iDecimals", "Decimals")
AccessorFunc(PANEL, "m_fFloatValue", "FloatValue")

function PANEL:Init()
	self:SetMin(2)
	self:SetMax(10)
	self:SetDecimals(0)

	local minVal = self:GetMin()

	self.Dragging = true
	self.Knob.Depressed = true

	self:SetValue(minVal)
	self:SetSlideX(self:GetFraction())

	self.Dragging = false
	self.Knob.Depressed = false
	self.Knob:SetSize(10, 14)

	function self.Knob:Paint(w, h)
		draw.RoundedBox(4, 1, 2, w - 2, h - 5, Color(GetConVar("amethyst_ui_slider_gcolor_red"):GetInt(), GetConVar("amethyst_ui_slider_gcolor_green"):GetInt(), GetConVar("amethyst_ui_slider_gcolor_blue"):GetInt(), GetConVar("amethyst_ui_slider_gcolor_alpha"):GetInt() ))
	end

end

function PANEL:SetMinMax(minVal, maxVal)
	self:SetMin(minVal)
	self:SetMax(maxVal)
end

function PANEL:SetValue(value)
	value = math.Round(math.Clamp(tonumber(value) or 0, self:GetMin(), self:GetMax()), self.m_iDecimals)

	self.m_iValue = value

	self:SetFloatValue(value)
	self:OnValueChanged(value)
	self:SetSlideX(self:GetFraction())
end

function PANEL:GetFraction()
	return (self:GetFloatValue() -self:GetMin()) / self:GetRange()
end

function PANEL:GetRange()
	return (self:GetMax() -self:GetMin())
end

function PANEL:TranslateValues(x, y)
	self:SetValue( self:GetMin() + ( x * self:GetRange() ) )
	return self:GetFraction(), y
end

function PANEL:OnValueChanged(value) end

function PANEL:Paint(w, h)
	draw.AmethystOutlinedBox( 0, 11, w, 2, Color(0, 0, 0, 0), Color(GetConVar("amethyst_ui_slider_lcolor_red"):GetInt(), GetConVar("amethyst_ui_slider_lcolor_green"):GetInt(), GetConVar("amethyst_ui_slider_lcolor_blue"):GetInt(), GetConVar("amethyst_ui_slider_lcolor_alpha"):GetInt() ) )
end

function PANEL:PaintOver(w, h)
	if (self.Hovered or self.Knob.Hovered or self.Knob.Depressed) then
		surface.DisableClipping(true)
		draw.SimpleText(self:GetValue(), "Amethyst.Font.SliderInfo", self.Knob.x + self.Knob:GetWide() / 2, self.Knob.y - 7, Color(GetConVar("amethyst_ui_slider_tcolor_red"):GetInt(), GetConVar("amethyst_ui_slider_tcolor_green"):GetInt(), GetConVar("amethyst_ui_slider_tcolor_blue"):GetInt(), GetConVar("amethyst_ui_slider_tcolor_alpha"):GetInt() ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.DisableClipping(false)
	end
end

vgui.Register("amethyst.slider", PANEL, "DSlider")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/