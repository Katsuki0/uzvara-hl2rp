/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


Amethyst = Amethyst or {}

local PANEL = {}

function PANEL:Init()
    self:SetSize(65, 65)
    self:SetText("")
    self.PModel = self.PModel or vgui.Create("ModelImage", self)
    self.PModel:SetSize(69, 69)
    self.PModel:SetPos(7, 3)
end

function PANEL:RehashModel(job, pmodel, src)
    self.hostPanel = src
    self.PModel:SetModel(pmodel, 1, "0")
    self.job = job
    self:SetTooltip(pmodel)
end

function PANEL:Paint(w, h) end

derma.DefineControl("amethyst.amodel", "", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/