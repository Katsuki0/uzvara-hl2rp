--[[
The MIT License (MIT)

Copyright (c) 2014 Falco Peijnenburg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

essentialDarkRPScoreboard = essentialDarkRPScoreboard or {}

local defaultBlur = Color(10, 10, 10, 160)
local defaultBlurOutline = Color(20, 20, 20, 220)

local white = Color(255, 255, 255)

local blur = Material('pp/blurscreen')

local function uiClickSound()
	surface.PlaySound('garrysmod/ui_click.wav')
end

local function uiReturnSound()
	surface.PlaySound('garrysmod/ui_return.wav')
end

function essentialDarkRPScoreboard.OpenFAdminSettings()
    if not FAdmin then return end

    if IsValid(essentialDarkRPScoreboard.fadminMenu) then
        uiClickSound()

        essentialDarkRPScoreboard.fadminMenu:Close()

        return
    end

    uiClickSound()

    essentialDarkRPScoreboard.fadminMenu = vgui.Create('DFrame')
    essentialDarkRPScoreboard.fadminMenu:SetSize(485, 405)
    essentialDarkRPScoreboard.fadminMenu:SetTitle('')
    essentialDarkRPScoreboard.fadminMenu:SetDraggable(false)
    essentialDarkRPScoreboard.fadminMenu:Center()
    essentialDarkRPScoreboard.fadminMenu:MakePopup()
    essentialDarkRPScoreboard.fadminMenu.btnMaxim:Hide()
    essentialDarkRPScoreboard.fadminMenu.btnMinim:Hide()

    function essentialDarkRPScoreboard.fadminMenu:OnClose()
        hook.Remove('Think', 'eds_fadminMenu_jobChangeThink')
    end

    local localPlayer = LocalPlayer()
    local originalPlayerGroup = localPlayer:GetUserGroup()

    -- Close menu if player's user group changes
    hook.Add('Think', 'eds_fadminMenu_jobChangeThink', function()
        if IsValid(essentialDarkRPScoreboard.fadminMenu) and localPlayer:GetUserGroup() ~= originalPlayerGroup then
            essentialDarkRPScoreboard.fadminMenu:Close()
        end
    end)

    function essentialDarkRPScoreboard.fadminMenu.btnClose:Paint(w, h)
        surface.SetDrawColor(Color(0, 0, 0))
        surface.DrawOutlinedRect(0, 0, w, h)

        if self:IsHovered() then
            surface.SetDrawColor(Color(110, 10, 10, 180))
        else
            surface.SetDrawColor(Color(70, 10, 10, 180))
        end

        surface.DrawRect(0, 0, w, h)

        draw.DrawText('x', 'eds_Roboto24', 15, -2, white, TEXT_ALIGN_CENTER)
    end

    local windowTitle = essentialDarkRPScoreboard.fadminMenu:Add('DLabel')
    windowTitle:SetPos(5, 2)
    windowTitle:SetText('FAdmin')
    windowTitle:SetFont('eds_Roboto24')
    windowTitle:SetTextColor(white)
    windowTitle:SizeToContents()

    function essentialDarkRPScoreboard.fadminMenu:Paint()
        essentialDarkRPScoreboard.drawBlurPanelOutlined(self, defaultBlur, 3, 8)
    end

    local fadminMenuScrollPanel = essentialDarkRPScoreboard.fadminMenu:Add('DScrollPanel')
    fadminMenuScrollPanel:SetSize(essentialDarkRPScoreboard.fadminMenu:GetWide(), 360)
    fadminMenuScrollPanel:SetPos(0, 35)

    local scrollBar = fadminMenuScrollPanel:GetVBar()

    function scrollBar:Paint(w, h) return end

    function scrollBar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
    end

    function scrollBar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
    end

    function scrollBar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
    end

    local _, YPos, Width = 20, FAdmin.ScoreBoard.Y + 120 + FAdmin.ScoreBoard.Height / 5 + 20, (FAdmin.ScoreBoard.Width - 40) / 3

    FAdmin.ScoreBoard.Server.Controls.ServerActionsCat = vgui.Create('FAdminPlayerCatagory', fadminMenuScrollPanel)
    FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetLabel('  Server Actions')
    FAdmin.ScoreBoard.Server.Controls.ServerActionsCat.CatagoryColor = Color(155, 0, 0, 255)
    FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetSize(450, FAdmin.ScoreBoard.Height - 20 - YPos)
    FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetPos(10, 0)
    FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetVisible(true)

    function FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:Toggle() end

    FAdmin.ScoreBoard.Server.Controls.ServerActions = vgui.Create('FAdminPanelList')
    FAdmin.ScoreBoard.Server.Controls.ServerActionsCat:SetContents(FAdmin.ScoreBoard.Server.Controls.ServerActions)
    FAdmin.ScoreBoard.Server.Controls.ServerActions:SetTall(FAdmin.ScoreBoard.Height - 20 - YPos)

    for k, v in pairs(FAdmin.ScoreBoard.Server.Controls.ServerActions:GetChildren()) do
        if k == 1 then continue end

        v:Remove()
    end

    FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat = vgui.Create('FAdminPlayerCatagory', fadminMenuScrollPanel)
    FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetLabel('  Player Actions')
    FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat.CatagoryColor = Color(0, 155, 0, 255)
    FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetSize(450, FAdmin.ScoreBoard.Height - 20 - YPos)
    FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetPos(10, 295)
    FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetVisible(true)

    function FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:Toggle() end

    FAdmin.ScoreBoard.Server.Controls.PlayerActions = vgui.Create('FAdminPanelList')
    FAdmin.ScoreBoard.Server.Controls.PlayerActionsCat:SetContents(FAdmin.ScoreBoard.Server.Controls.PlayerActions)
    FAdmin.ScoreBoard.Server.Controls.PlayerActions:SetTall(FAdmin.ScoreBoard.Height - 20 - YPos)

    for k, v in pairs(FAdmin.ScoreBoard.Server.Controls.PlayerActions:GetChildren()) do
        if k == 1 then continue end

        v:Remove()
    end

    FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat = vgui.Create('FAdminPlayerCatagory', fadminMenuScrollPanel)
    FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetLabel('  Server Settings')
    FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat.CatagoryColor = Color(0, 0, 155, 255)
    FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetSize(450, FAdmin.ScoreBoard.Height - 20 - YPos)
    FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetPos(10, 550)
    FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetVisible(true)

    function FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:Toggle() end

    FAdmin.ScoreBoard.Server.Controls.ServerSettings = vgui.Create('FAdminPanelList')
    FAdmin.ScoreBoard.Server.Controls.ServerSettingsCat:SetContents(FAdmin.ScoreBoard.Server.Controls.ServerSettings)
    FAdmin.ScoreBoard.Server.Controls.ServerSettings:SetTall(FAdmin.ScoreBoard.Height - 20 - YPos)

    for k, v in pairs(FAdmin.ScoreBoard.Server.Controls.ServerSettings:GetChildren()) do
        if k == 1 then continue end

        v:Remove()
    end

    for k, v in ipairs(FAdmin.ScoreBoard.Server.ActionButtons) do
        local visible = v.Visible == true or (type(v.Visible) == 'function' and v.Visible(LocalPlayer()) == true)

        local ActionButton = vgui.Create('FAdminActionButton')

        if type(v.Image) == 'string' then
            ActionButton:SetImage(v.Image or 'icon16/exclamation')
        elseif type(v.Image) == 'table' then
            ActionButton:SetImage(v.Image[1])

            if v.Image[2] then ActionButton:SetImage2(v.Image[2]) end
        elseif type(v.Image) == 'function' then
            local img1, img2 = v.Image()

            ActionButton:SetImage(img1)

            if img2 then ActionButton:SetImage2(img2) end
        else
            ActionButton:SetImage('icon16/exclamation')
        end

        local name = v.Name

        if type(name) == 'function' then name = name() end

        ActionButton:SetText(DarkRP.deLocalise(name))
        ActionButton:SetBorderColor(visible and v.color or Color(120, 120, 120))
        ActionButton:SetDisabled(not visible)
        ActionButton:Dock(TOP)

        function ActionButton:DoClick()
            return v.Action(self)
        end

        FAdmin.ScoreBoard.Server.Controls[v.TYPE]:Add(ActionButton)

        if v.OnButtonCreated then
            v.OnButtonCreated(ActionButton)
        end
    end
end
