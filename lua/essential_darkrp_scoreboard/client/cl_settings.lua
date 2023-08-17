essentialDarkRPScoreboard = essentialDarkRPScoreboard or {}
essentialDarkRPScoreboard.groupColors = essentialDarkRPScoreboard.groupColors or {}
essentialDarkRPScoreboard.settings = essentialDarkRPScoreboard.settings or {}

local function refreshGroupsList()
	if not IsValid(essentialDarkRPScoreboard.groupList) then return end

	essentialDarkRPScoreboard.groupList:Clear()

	for group, settings in pairs(essentialDarkRPScoreboard.groupColors) do
		essentialDarkRPScoreboard.groupList:AddLine(group, settings['display_name'], settings['color']['r'] .. ', ' .. settings['color']['g'] .. ', ' .. settings['color']['b'])
	end
end

net.Receive('scoreboardColorUpdate', function()
	essentialDarkRPScoreboard.groupColors = net.ReadTable()

	refreshGroupsList()
end)

net.Receive('scoreboardSettingsUpdate', function()
	essentialDarkRPScoreboard.settings = net.ReadTable()

	if IsValid(essentialDarkRPScoreboard.showSettingsButtonCheckBox) then
		essentialDarkRPScoreboard.showSettingsButtonCheckBox:SetChecked(essentialDarkRPScoreboard.settings['showSettingsButton'])
	end

	if IsValid(essentialDarkRPScoreboard.enableGroupsCheckBox) then
		essentialDarkRPScoreboard.enableGroupsCheckBox:SetChecked(essentialDarkRPScoreboard.settings['displayUserGroups'])
	end
end)

local defaultBlur = Color(10, 10, 10, 160)
local defaultBlurOutline = Color(20, 20, 20, 210)

local white = Color(255, 255, 255)

local function buttonClickSound()
	surface.PlaySound('ui/buttonclick.wav')
end

local function buttonClickReleaseSound()
	surface.PlaySound('ui/buttonclickrelease.wav')
end

local function uiClickSound()
	surface.PlaySound('garrysmod/ui_click.wav')
end

function essentialDarkRPScoreboard.openSettings()
	if IsValid(essentialDarkRPScoreboard.settingsMenu) then
        uiClickSound()

        essentialDarkRPScoreboard.settingsMenu:Close()

        return
	end

	uiClickSound()

	local localPlayer = LocalPlayer()

	if not localPlayer:IsSuperAdmin() or localPlayer:IsUserGroup('owner') then
		local msg = 'Вы должны быть Суперадмином или Создателем'

		print(msg)
		chat.AddText(msg)

		return
	end

	essentialDarkRPScoreboard.settingsMenu = vgui.Create('DFrame')
	essentialDarkRPScoreboard.settingsMenu:SetSize(448, 320)
	essentialDarkRPScoreboard.settingsMenu:Center()
	essentialDarkRPScoreboard.settingsMenu:MakePopup()
	essentialDarkRPScoreboard.settingsMenu:SetTitle('')
	essentialDarkRPScoreboard.settingsMenu:SetDraggable(false)
	essentialDarkRPScoreboard.settingsMenu.btnMaxim:Hide()
	essentialDarkRPScoreboard.settingsMenu.btnMinim:Hide()

	function essentialDarkRPScoreboard.settingsMenu:OnClose()
        hook.Remove('Think', 'eds_settingsMenu_jobChangeThink')
    end

    local localPlayer = LocalPlayer()
    local originalPlayerGroup = localPlayer:GetUserGroup()

    -- Close menu if player's user group changes
    hook.Add('Think', 'eds_settingsMenu_jobChangeThink', function()
        if IsValid(essentialDarkRPScoreboard.settingsMenu) and localPlayer:GetUserGroup() ~= originalPlayerGroup then
            essentialDarkRPScoreboard.settingsMenu:Close()
        end
    end)

	function essentialDarkRPScoreboard.settingsMenu.btnClose:Paint(w, h)
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

	function essentialDarkRPScoreboard.settingsMenu:Paint()
		essentialDarkRPScoreboard.drawBlurPanelOutlined(self, defaultBlur, 3, 8)
	end

	local windowTitle = essentialDarkRPScoreboard.settingsMenu:Add('DLabel')
    windowTitle:SetPos(5, 2)
    windowTitle:SetText('Settings')
    windowTitle:SetFont('eds_Roboto24')
    windowTitle:SetTextColor(white)
    windowTitle:SizeToContents()

	local settingsScrollPanel = essentialDarkRPScoreboard.settingsMenu:Add('DScrollPanel')
	settingsScrollPanel:Dock(FILL)

	function settingsScrollPanel:Paint() return end

	local scrollBar = settingsScrollPanel:GetVBar()
	scrollBar:DockMargin(-5, 0, 0, 0)

	function scrollBar:Paint() return end

	function scrollBar.btnGrip:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
	end

	function scrollBar.btnUp:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
	end

	function scrollBar.btnDown:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, defaultBlur)
	end

	local groupListMarginTop = 10

	local groupListPanel = settingsScrollPanel:Add('DPanel')
	groupListPanel:SetSize(0, 230)
	groupListPanel:Dock(TOP)
	groupListPanel:DockMargin(0, groupListMarginTop, 0, 5)
	groupListPanel:SizeToContentsY()

	function groupListPanel:Paint() return end

	essentialDarkRPScoreboard.groupList = groupListPanel:Add('DListView')
	essentialDarkRPScoreboard.groupList:SetSize(0, 200)
	essentialDarkRPScoreboard.groupList:Dock(TOP)
	essentialDarkRPScoreboard.groupList:SetMultiSelect(false)
	essentialDarkRPScoreboard.groupList:AddColumn('User Group')
	essentialDarkRPScoreboard.groupList:AddColumn('Display Name')
	essentialDarkRPScoreboard.groupList:AddColumn('Color (RGB)')

	for group, settings in pairs(essentialDarkRPScoreboard.groupColors) do
		essentialDarkRPScoreboard.groupList:AddLine(group, settings['display_name'], settings['color']['r'] .. ', ' .. settings['color']['g'] .. ', ' .. settings['color']['b'])
	end

	-- Resets selected row on creation
	essentialDarkRPScoreboard.selectedGroup = nil

	essentialDarkRPScoreboard.groupList.OnRowSelected = function(lst, index, pnl)
		buttonClickSound()

		essentialDarkRPScoreboard.selectedGroup = pnl:GetColumnText(1)
	end

	local groupListX, groupListY = essentialDarkRPScoreboard.groupList:GetPos()
	local groupListHeight = essentialDarkRPScoreboard.groupList:GetTall()

	local groupEntry = groupListPanel:Add('DTextEntry')
	groupEntry:SetPos(0, groupListY + groupListHeight)
	groupEntry:SetSize(200, 30)
	groupEntry:SetPlaceholderText(' Enter a user group')

	groupEntry.OnEnter = function(self)
		buttonClickSound()

		if self:GetValue() == nil or (self:GetValue() == '' or self:GetValue() == ' ') then
			chat.AddText('You must enter a user group first.')

			return
		end

		if IsValid(essentialDarkRPScoreboard.settingsMenu) then
			essentialDarkRPScoreboard.settingsMenu:SetVisible(false)
		end

		local userGroupNameSettings = vgui.Create('DFrame')
		userGroupNameSettings:SetSize(350, 115)
		userGroupNameSettings:Center()
		userGroupNameSettings:MakePopup()
		userGroupNameSettings:SetTitle('')
		userGroupNameSettings:SetDraggable(false)
		userGroupNameSettings.btnMaxim:Hide()
		userGroupNameSettings.btnMinim:Hide()

		function userGroupNameSettings.btnClose:Paint(w, h)
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

		function userGroupNameSettings:Paint()
			essentialDarkRPScoreboard.drawBlurPanelOutlined(self, defaultBlur, 3, 8)
		end

		local windowTitle = userGroupNameSettings:Add('DLabel')
		windowTitle:SetPos(5, 2)
		windowTitle:SetText('Enter the display name')
		windowTitle:SetFont('eds_Roboto24')
		windowTitle:SetTextColor(white)
		windowTitle:SizeToContents()

		function userGroupNameSettings.OnClose()
			if IsValid(essentialDarkRPScoreboard.settingsMenu) then
				essentialDarkRPScoreboard.settingsMenu:SetVisible(true)
			end
		end

		local nameEntry = userGroupNameSettings:Add('DTextEntry')
		nameEntry:Dock(TOP)
		nameEntry:DockMargin(0, 20, 0, 0)
		nameEntry:SetPos(0, 0)
		nameEntry:SetSize(200, 30)
		nameEntry:SetPlaceholderText(' How the group will be displayed on the scoreboard')

		function nameEntry:OnEnter()
			buttonClickSound()

			if nameEntry:GetValue() == nil or nameEntry:GetValue() == '' or nameEntry:GetValue() == ' ' then
				local msg = 'You must enter a display name first.'

				print(msg)
				chat.AddText(msg)

				return
			end

			if IsValid(essentialDarkRPScoreboard.settingsMenu) then
				essentialDarkRPScoreboard.settingsMenu:SetVisible(false)
			end

			if IsValid(userGroupNameSettings) then
				userGroupNameSettings:SetVisible(false)
			end

			local userGroupColorSettings = vgui.Create('DFrame')
			userGroupColorSettings:SetSize(267, 275)
			userGroupColorSettings:Center()
			userGroupColorSettings:MakePopup()
			userGroupColorSettings:SetTitle('')
			userGroupColorSettings:SetDraggable(false)
			userGroupColorSettings.btnMaxim:Hide()
			userGroupColorSettings.btnMinim:Hide()

			function userGroupColorSettings.btnClose:Paint(w, h)
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

			function userGroupColorSettings:Paint()
				essentialDarkRPScoreboard.drawBlurPanelOutlined(self, defaultBlur, 3, 8)
			end

			local windowTitle = userGroupColorSettings:Add('DLabel')
			windowTitle:SetPos(5, 2)
			windowTitle:SetText(nameEntry:GetValue())
			windowTitle:SetFont('eds_Roboto24')
			windowTitle:SetTextColor(white)
			windowTitle:SizeToContents()

			local colorMixer = userGroupColorSettings:Add('DColorMixer')
			colorMixer:Dock(FILL)
			colorMixer:DockMargin(0, 10, 0, 0)
			colorMixer:SetPalette(true)
			colorMixer:SetAlphaBar(true)
			colorMixer:SetWangs(true)
			colorMixer:SetAlphaBar(false)
			colorMixer:SetColor(Color(255, 255, 255))

			function windowTitle:Paint()
				windowTitle:SetTextColor(colorMixer:GetColor())
			end

			local confirmColorButton = userGroupColorSettings:Add('DButton')
			confirmColorButton:SetText('Confirm')
			confirmColorButton:Dock(BOTTOM)
			confirmColorButton:SetSize(0, 30)
			confirmColorButton:DockMargin(0, 14, 0, 0)

			function confirmColorButton.DoClick()
				buttonClickSound()

				local localPlayer = LocalPlayer()

				if not localPlayer:IsSuperAdmin() or localPlayer:IsUserGroup('owner') then
					local msg = 'You must be a Superadmin or Owner!'

					print(msg)
					chat.AddText(msg)

					return
				end

				local groupName = string.lower(groupEntry:GetValue())

				if essentialDarkRPScoreboard.groupColors[groupName] then
					chat.AddText('Edited group \'' .. groupName .. '\'.')
				else
					chat.AddText('Added new group \'' .. groupName .. '\'.')
				end

				essentialDarkRPScoreboard.groupColors[groupName] = {
					['display_name'] = nameEntry:GetValue(),
					['color'] = colorMixer:GetColor()
				}

				net.Start('addNewGroupSettings')
					net.WriteString(groupName)
					net.WriteTable(essentialDarkRPScoreboard.groupColors[groupName])
				net.SendToServer()

				userGroupColorSettings:Close()

				if IsValid(essentialDarkRPScoreboard.settingsMenu) then
					essentialDarkRPScoreboard.settingsMenu:SetVisible(true)
				end
			end

			function userGroupColorSettings:OnClose()
				if IsValid(userGroupNameSettings) then
					userGroupNameSettings:Close()
				end

				if IsValid(essentialDarkRPScoreboard.settingsMenu) then
					essentialDarkRPScoreboard.settingsMenu:SetVisible(true)
				end
			end
		end

		local confirmNameButton = userGroupNameSettings:Add('DButton')
		confirmNameButton:SetText('Confirm')
		confirmNameButton:Dock(TOP)
		confirmNameButton:SetSize(0, 30)
		confirmNameButton:DockMargin(0, 0, 0, 5)

		function confirmNameButton.DoClick()
			nameEntry:OnEnter()
		end
	end

	local addButton = groupListPanel:Add('DButton')
	addButton:SetText('Add Group')
	addButton:SetPos(groupEntry:GetWide(), groupListY + groupListHeight)
	addButton:SetSize(75, 30)

	addButton.DoClick = function()
		groupEntry:OnEnter()
	end

	local removeButton = groupListPanel:Add('DButton')
	removeButton:SetText('Remove Group')
	removeButton:SetSize(95, 30)
	removeButton:Dock(RIGHT)

	removeButton.DoClick = function()
		buttonClickSound()

		if essentialDarkRPScoreboard.selectedGroup == nil or essentialDarkRPScoreboard.selectedGroup == '' or essentialDarkRPScoreboard.groupColors[essentialDarkRPScoreboard.selectedGroup] == nil or essentialDarkRPScoreboard.groupColors[essentialDarkRPScoreboard.selectedGroup] == '' then
			local msg = 'You must select a group first.'

			print(msg)
			chat.AddText(msg)

			return
		end

		local localPlayer = LocalPlayer()

		if not localPlayer:IsSuperAdmin() or localPlayer:IsUserGroup('owner') then
			local msg = 'You must be a Superadmin or Owner!'

			print(msg)
			chat.AddText(msg)

			return
		end

		net.Start('removeGroupSettings')
			net.WriteString(essentialDarkRPScoreboard.selectedGroup)
		net.SendToServer()

		chat.AddText('Removed group \'' .. essentialDarkRPScoreboard.selectedGroup .. '\'.')
	end

	essentialDarkRPScoreboard.enableGroupsCheckBox = essentialDarkRPScoreboard.settingsMenu:Add('DCheckBoxLabel')
	essentialDarkRPScoreboard.enableGroupsCheckBox:SetPos(25, groupListPanel:GetPos() + groupListPanel:GetTall())
	essentialDarkRPScoreboard.enableGroupsCheckBox:SetText('Display user groups on scoreboard')
	essentialDarkRPScoreboard.enableGroupsCheckBox:SizeToContents()
	essentialDarkRPScoreboard.enableGroupsCheckBox:Dock(BOTTOM)
	essentialDarkRPScoreboard.enableGroupsCheckBox:DockMargin(0, 5, 0, 0)
	essentialDarkRPScoreboard.enableGroupsCheckBox:SetValue(essentialDarkRPScoreboard.settings['displayUserGroups'])

	function essentialDarkRPScoreboard.enableGroupsCheckBox:OnChange(bVal)
		buttonClickReleaseSound()

		local localPlayer = LocalPlayer()

		if not localPlayer:IsSuperAdmin() or localPlayer:IsUserGroup('owner') then
			local msg = 'You must be a Superadmin or Owner!'

			print(msg)
			chat.AddText(msg)

			return
		end

		net.Start('enableUserGroupsChange')
		net.SendToServer()

		chat.AddText('Display user groups on scoreboard set to \'' .. tostring(not essentialDarkRPScoreboard.settings['displayUserGroups']) .. '\'.')
	end

	essentialDarkRPScoreboard.showSettingsButtonCheckBox = essentialDarkRPScoreboard.settingsMenu:Add('DCheckBoxLabel')
	essentialDarkRPScoreboard.showSettingsButtonCheckBox:SetPos(25, groupListPanel:GetPos() + groupListPanel:GetTall())
	essentialDarkRPScoreboard.showSettingsButtonCheckBox:SetText('Show settings button on scoreboard (use !scoreboard)')
	essentialDarkRPScoreboard.showSettingsButtonCheckBox:SizeToContents()
	essentialDarkRPScoreboard.showSettingsButtonCheckBox:Dock(BOTTOM)
	essentialDarkRPScoreboard.showSettingsButtonCheckBox:DockMargin(0, 0, 0, 0)
	essentialDarkRPScoreboard.showSettingsButtonCheckBox:SetValue(essentialDarkRPScoreboard.settings['showSettingsButton'])

	function essentialDarkRPScoreboard.showSettingsButtonCheckBox:OnChange(bVal)
		buttonClickReleaseSound()

		local localPlayer = LocalPlayer()

		if not localPlayer:IsSuperAdmin() or localPlayer:IsUserGroup('owner') then
			local msg = 'You must be a Superadmin or Owner!'

			print(msg)
			chat.AddText(msg)

			return
		end

		net.Start('showSettingsButtonChange')
		net.SendToServer()

		chat.AddText('Show settings button on scoreboard set to \'' .. tostring(not essentialDarkRPScoreboard.settings['showSettingsButton']) .. '\'.')
	end
end

hook.Add('OnPlayerChat', 'eds_ScoreboardCommand', function(ply, text)
	if not (IsValid(ply) and ply == LocalPlayer()) then return end

	if string.lower(text) == '!scoreboard' then
		essentialDarkRPScoreboard.openSettings()
	end

	return
end)
