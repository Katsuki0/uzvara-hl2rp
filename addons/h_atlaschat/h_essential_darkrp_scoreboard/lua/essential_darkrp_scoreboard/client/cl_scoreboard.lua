essentialDarkRPScoreboard = essentialDarkRPScoreboard or {}
essentialDarkRPScoreboard.groupColors = essentialDarkRPScoreboard.groupColors or {}
essentialDarkRPScoreboard.settings = essentialDarkRPScoreboard.settings or {}

local defaultBlur = Color(10, 10, 10, 160)
local defaultBlurOutline = Color(20, 20, 20, 210)
local buttonColor = Color(10, 10, 10, 160)
local buttonHoveredText = Color(255, 128, 0)

local white = Color(255, 255, 255)

local blur = Material('pp/blurscreen')
local scriptEdit = 'icon16/script_edit.png'

surface.CreateFont('eds_Roboto24', {
	font = 'Roboto Regular',
	size = 24
})

surface.CreateFont('eds_Roboto20', {
	font = 'Roboto Regular',
	size = 20
})

local function buttonClickSound()
	surface.PlaySound('ui/buttonclick.wav')
end

local function buttonClickReleaseSound()
	surface.PlaySound('ui/buttonclickrelease.wav')
end

local function uiClickSound()
	surface.PlaySound('garrysmod/ui_click.wav')
end

-- Draw blur rectangle in paint hook
local function drawBlurRect(xpos, ypos, width, height, color, layers, density)
	local x, y = 0, 0
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(white)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat('$blur', (i / layers) * density)
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(xpos, ypos, xpos + width, ypos + height, true)
			surface.DrawTexturedRect(xpos, ypos, scrW, scrH)
		render.SetScissorRect(0, 0, 0, 0, false)
	end

	surface.SetDrawColor(color)
	surface.DrawRect(xpos, ypos, width, height)
end

-- Draw blur rectangle in paint hook
local function drawBlurRectOutlined(xpos, ypos, width, height, color, layers, density)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(white)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat('$blur', (i / layers) * density)
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(xpos + 1, ypos + 1, width - 2, height - 2, true)
			surface.DrawTexturedRect(xpos, ypos, scrW, scrH)
		render.SetScissorRect(0, 0, 0, 0, false)
	end

	surface.SetDrawColor(color)
	surface.DrawRect(xpos + 1, ypos + 1, width - 2, height - 2)

	surface.SetDrawColor(defaultBlurOutline)
	surface.DrawOutlinedRect(xpos, ypos, width, height)
end

-- Draw blur panel
function essentialDarkRPScoreboard.drawBlurPanelOutlined(panel, color, layers, density)
	local x, y = panel:LocalToScreen(0, 0)
	local width, height = panel:GetWide(), panel:GetTall()
	local xpos, ypos = panel:GetPos()

	surface.SetDrawColor(white)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat('$blur', (i / layers) * density)
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end

	surface.SetDrawColor(color)
	surface.DrawRect(xpos - (x - 1), ypos - (y - 1), width - 2, height - 2)

	surface.SetDrawColor(defaultBlurOutline)
	surface.DrawOutlinedRect(xpos - x, ypos - y, width, height)
end

-- Draw outlined rectangle in paint hook
local function drawRectOutlined(xpos, ypos, width, height, color)
	surface.SetDrawColor(color)
	surface.DrawRect(xpos + 1, ypos + 1, width - 2, height - 2)

	surface.SetDrawColor(defaultBlurOutline)
	surface.DrawOutlinedRect(xpos, ypos, width, height)
end

local playerLine = {
	Init = function(self)
		self.playerPanel = self:Add('DButton')
		self.playerPanel:Dock(FILL)
		self.playerPanel:SetSize(self:GetWide(), self:GetTall())
		self.playerPanel:SetText('')

		function self.playerPanel.DoClick()
			if IsValid(self.playerMenu) then
				uiClickSound()

				self.playerMenu:Close()

				return
			end

			if not IsValid(self.player) then return end

			uiClickSound()

			local pl = self.player
			local localPlayer = LocalPlayer()

			self.playerMenu = vgui.Create('DFrame')
			self.playerMenu:SetSize(477, 200)
			self.playerMenu:SetTitle('')
			self.playerMenu:SetDraggable(false)
			self.playerMenu:Center()
			self.playerMenu:MakePopup()
			self.playerMenu.btnMaxim:Hide()
			self.playerMenu.btnMinim:Hide()

			function self.playerMenu:OnClose()
				hook.Remove('Think', 'eds_playerMenu_infoThink')
			end

			local function returnPlayerMenu()
				return self.playerMenu
			end

			function self.playerMenu.btnClose:Paint(w, h)
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

			self.playerInfo = self.playerMenu:Add('DPanel')
			self.playerInfo:SetPos(105, 8)
			self.playerInfo:SetSize(330, 95)

			function self.playerInfo:Paint() return end

			self.playerName = self.playerInfo:Add('DLabel')
			self.playerName:SetPos(0, 0)
			self.playerName:SetText(pl:Nick())
			self.playerName:SetFont('eds_Roboto20')
			self.playerName:SetTextColor(white)
			self.playerName:SizeToContents()

			if DarkRP then
				local teamName = pl:getDarkRPVar('job') or team.GetName(pl:Team())

				self.playerJob = self.playerInfo:Add('DLabel')
				self.playerJob:SetPos(0, 21)
				self.playerJob:SetText(teamName)
				self.playerJob:SetTextColor(team.GetColor(pl:Team())) -- team.GetColor(pl:Team())
				self.playerJob:SetFont('eds_Roboto20')
				self.playerJob:SizeToContents()

			end

			self.playerUserGroup = self.playerInfo:Add('DLabel')

			if DarkRP then
				self.playerUserGroup:SetPos(0, 63)
			else
				self.playerUserGroup:SetPos(0, 21)
			end

			self.playerUserGroup:SetText(string.gsub(pl:GetUserGroup(), '^.', string.upper))
			self.playerUserGroup:SetTextColor(white)
			self.playerUserGroup:SetFont('eds_Roboto20')
			self.playerUserGroup:SizeToContents()

			-- Close menu if player's user group changes
			hook.Add('Think', 'eds_playerMenu_infoThink', function()
				if IsValid(self.playerMenu) then
					self.playerName:SetText(pl:Nick())
					self.playerName:SizeToContents()

					self.playerUserGroup:SetText(string.gsub(pl:GetUserGroup(), '^.', string.upper))
					self.playerUserGroup:SizeToContents()

					if DarkRP then
						local teamName = pl:getDarkRPVar('job') or team.GetName(pl:Team())

						self.playerJob:SetText(teamName)
						self.playerJob:SetTextColor(team.GetColor(pl:Team()))
						self.playerJob:SizeToContents()

					end
				end
			end)

			self.playerMenuAvatar = self.playerMenu:Add('AvatarImage')
			self.playerMenuAvatar:SetPos(9, 9)
			self.playerMenuAvatar:SetSize(84, 84)
			self.playerMenuAvatar:SetPlayer(pl, 128)

			local function returnPlayerMenuAvatar()
				return self.playerMenuAvatar
			end

			self.playerMenuButtons = self.playerMenu:Add('DPanel')
			self.playerMenuButtons:SetPos(8, 108)
			self.playerMenuButtons:SetSize(450, 250)

			function self.playerMenuButtons:Paint() return end

			self.playerSteamIDButton = self.playerMenuButtons:Add('DButton')
			self.playerSteamIDButton:SetFont('eds_Roboto20')
			self.playerSteamIDButton:SetTall(30)
			self.playerSteamIDButton:SetPos(0, 0)
			self.playerSteamIDButton:SetTextColor(white)
			self.playerSteamIDButton:SetText('Скопировать SteamID')
			self.playerSteamIDButton:SizeToContents()

			function self.playerSteamIDButton:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerSteamIDButton:DoClick()
				SetClipboardText(pl:SteamID())

				chat.AddText('SteamID скопирован (CTRL + V)')

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			self.playerSteamID64Button = self.playerMenuButtons:Add('DButton')
			self.playerSteamID64Button:SetFont('eds_Roboto20')
			self.playerSteamID64Button:SetPos(0, 30)
			self.playerSteamID64Button:SetTextColor(white)
			self.playerSteamID64Button:SetText('Скопировать SteamID64')
			self.playerSteamID64Button:SizeToContents()

			function self.playerSteamID64Button:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerSteamID64Button:DoClick()
				if pl:SteamID64() then
					SetClipboardText(pl:SteamID64())

					chat.AddText('SteamID64 скопирован (CTRL + V)')
				end

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			-- Steam profile button
			self.playerSteamProfileButton = self.playerMenuButtons:Add('DButton')
			self.playerSteamProfileButton:SetFont('eds_Roboto20')
			self.playerSteamProfileButton:SetPos(0, 60)
			self.playerSteamProfileButton:SetTextColor(white)
			self.playerSteamProfileButton:SetText('Открыть Steam Профиль')
			self.playerSteamProfileButton:SizeToContents()

			function self.playerSteamProfileButton:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerSteamProfileButton:DoClick()
				pl:ShowProfile()

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			-- Kick button
			self.playerKickButton = self.playerMenuButtons:Add('DButton')
			self.playerKickButton:SetFont('eds_Roboto20')
			self.playerKickButton:SetPos(210, 0)
			self.playerKickButton:SetTextColor(white)
			self.playerKickButton:SetText('Kick')
			self.playerKickButton:SizeToContents()

			function self.playerKickButton:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerKickButton:DoClick()
				if ulx then
					localPlayer:ConCommand('ulx kick ' .. pl:Nick())
				else
					localPlayer:ConCommand('say /kick ' .. pl:SteamID())
				end

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			-- Freeze button
			self.playerFreezeButton = self.playerMenuButtons:Add('DButton')
			self.playerFreezeButton:SetFont('eds_Roboto20')
			self.playerFreezeButton:SetPos(210, 30)
			self.playerFreezeButton:SetTextColor(white)
			self.playerFreezeButton:SetText('Freeze')
			self.playerFreezeButton:SizeToContents()

			function self.playerFreezeButton:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerFreezeButton:DoClick()
				if ulx then
					localPlayer:ConCommand('ulx freeze ' .. pl:Nick())
				else
					localPlayer:ConCommand('say /freeze ' .. pl:SteamID())
				end

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			-- Unfreeze button
			self.playerUnfreezeButton = self.playerMenuButtons:Add('DButton')
			self.playerUnfreezeButton:SetFont('eds_Roboto20')
			self.playerUnfreezeButton:SetPos(210, 60)
			self.playerUnfreezeButton:SetTextColor(white)
			self.playerUnfreezeButton:SetText('Unfreeze')
			self.playerUnfreezeButton:SizeToContents()

			function self.playerUnfreezeButton:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerUnfreezeButton:DoClick()
				if ulx then
					localPlayer:ConCommand('ulx unfreeze ' .. pl:Nick())
				else
					localPlayer:ConCommand('say /unfreeze ' .. pl:SteamID())
				end

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			-- Goto button
			self.playerGotoButton = self.playerMenuButtons:Add('DButton')
			self.playerGotoButton:SetFont('eds_Roboto20')
			self.playerGotoButton:SetPos(340, 0)
			self.playerGotoButton:SetTextColor(white)
			self.playerGotoButton:SetText('Goto')
			self.playerGotoButton:SizeToContents()

			function self.playerGotoButton:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerGotoButton:DoClick()
				if ulx then
					localPlayer:ConCommand('ulx goto ' .. pl:Nick())
				else
					localPlayer:ConCommand('say /goto ' .. pl:SteamID())
				end

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			-- Bring button
			self.playerBringButton = self.playerMenuButtons:Add('DButton')
			self.playerBringButton:SetFont('eds_Roboto20')
			self.playerBringButton:SetPos(340, 30)
			self.playerBringButton:SetTextColor(white)
			self.playerBringButton:SetText('Bring')
			self.playerBringButton:SizeToContents()

			function self.playerBringButton:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerBringButton:DoClick()
				if ulx then
					localPlayer:ConCommand('ulx bring ' .. pl:Nick())
				else
					localPlayer:ConCommand('say /bring ' .. pl:SteamID())
				end

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			-- Return button
			self.playerReturnButton = self.playerMenuButtons:Add('DButton')
			self.playerReturnButton:SetFont('eds_Roboto20')
			self.playerReturnButton:SetPos(340, 60)
			self.playerReturnButton:SetTextColor(white)
			self.playerReturnButton:SetText('Return')
			self.playerReturnButton:SizeToContents()

			function self.playerReturnButton:Paint(w, h)
				if self:IsHovered() then
					self:SetTextColor(buttonHoveredText)
				else
					self:SetTextColor(Color(255, 255, 255))
				end

				drawRectOutlined(0, 0, w, h, buttonColor)
			end

			function self.playerReturnButton:DoClick()
				if ulx then
					localPlayer:ConCommand('ulx return ' .. pl:Nick())
				else
					localPlayer:ConCommand('say /return ' .. pl:SteamID())
				end

				buttonClickSound()

				returnPlayerMenu():Close()
			end

			function self.playerMenu:Paint()
				local x, y = returnPlayerMenuAvatar():GetPos()

				essentialDarkRPScoreboard.drawBlurPanelOutlined(self, defaultBlur, 3, 8)

				surface.SetDrawColor(defaultBlurOutline)
				surface.DrawOutlinedRect(x - 1, y - 1, 86, 86)
			end
		end

		function self.playerPanel:Paint() return end

		self.avatarButton = self.playerPanel:Add('DButton')
		self.avatarButton:Dock(LEFT)
		self.avatarButton:DockMargin(3, 3, 0, 3)
		self.avatarButton:SetSize(32, 32)
		self.avatarButton:SetContentAlignment(5)

		function self.avatarButton.DoClick()
			self.player:ShowProfile()

			buttonClickSound()
		end

		self.avatar = vgui.Create('AvatarImage', self.avatarButton)
		self.avatar:SetSize(32, 32)
		self.avatar:SetMouseInputEnabled(false)

		self.name = self.playerPanel:Add('DLabel')
		self.name:Dock(FILL)
		self.name:SetFont('eds_Roboto20')
		self.name:SetTextColor(white)
		self.name:DockMargin(8, 0, 0, 0)
		self.name:SetContentAlignment(4)

		self.mutePanel = self.playerPanel:Add('DPanel')
		self.mutePanel:SetSize(41, self:GetTall())
		self.mutePanel:Dock(RIGHT)
		self.mutePanel:DockMargin(0, 0, 0, 0)

		function self.mutePanel:Paint() return end

		self.mute = self.mutePanel:Add('DImageButton')
		self.mute:SetSize(32, 32)
		self.mute:SetPos(5, 3)

		self.ping = self.playerPanel:Add('DLabel')
		self.ping:Dock(RIGHT)
		self.ping:DockMargin(0, 0, 6, 0)
		self.ping:SetFont('eds_Roboto20')
		self.ping:SetTextColor(white)
		self.ping:SetContentAlignment(5)

		self.score = self.playerPanel:Add('DLabel')
		self.score:Dock(RIGHT)
		self.score:DockMargin(0, 0, 17, 0)
		self.score:SetWidth(70)
		self.score:SetFont('eds_Roboto20')
		self.score:SetContentAlignment(5)

		if DarkRP then
			self.job = self.playerPanel:Add('DLabel')
			self.job:Dock(RIGHT)
			self.job:SetWidth(200)
			self.job:SetFont('eds_Roboto20')
			self.job:SetTextColor(white)
			self.job:DockMargin(0, 0, 17, 0)
			self.job:SetContentAlignment(5)
		end

		self.userGroup = self.playerPanel:Add('DLabel')
		self.userGroup:Dock(RIGHT)
		self.userGroup:SetFont('eds_Roboto20')
		self.userGroup:SetTextColor(white)
		self.userGroup:DockMargin(5, 0, 17, 0)
		self.userGroup:SetContentAlignment(5)

		self:Dock(TOP)
		self:SetHeight(38)
		self:DockMargin(10, 0, 10, 2)
	end,

	Setup = function(self, pl)
		self.player = pl
		self.avatar:SetPlayer(pl, 64)
		self:Think(self)
	end,

	Think = function(self)
		if not IsValid(self.player) then
			self:SetZPos(9999)
			self:Remove()

			return
		end

		self.name:SetTextColor(white)
		self.score:SetTextColor(white)
		self.ping:SetTextColor(white)

		if self.numKills == nil or self.numKills ~= self.player:Frags() or self.numDeaths ~= self.player:Deaths() then
			self.numKills = self.player:Frags()
			self.numDeaths = self.player:Deaths()

			self.plyKd = string.format('%i:%i', self.player:Frags() < 0 and 0 or self.player:Frags(), self.player:Deaths())
			self.score:SetText(self.plyKd)

			self.score:SizeToContentsX()
		end

		if self.plyName == nil or self.plyName ~= self.player:Nick() then
			self.plyName = self.player:Nick()

			self.name:SetText(self.plyName)
		end

		if DarkRP then
			if self.plyJob == nil or self.plyJob ~= self.player:getDarkRPVar('job') then
				self.plyJob = self.player:getDarkRPVar('job') or ''

				self.job:SetText(self.plyJob)
				self.job:SizeToContentsX()
			end

			if self.plyJobColor == nil or self.plyJobColor ~= team.GetColor(self.player:Team()) then
				self.plyJobColor = team.GetColor(self.player:Team()) or white

				self.job:SetTextColor(self.plyJobColor)
			end
		end

		if essentialDarkRPScoreboard.settings['displayUserGroups'] then
			self.userGroup:SetVisible(true)

			self.plyUserGroup = string.lower(self.player:GetUserGroup())

			if essentialDarkRPScoreboard.groupColors[self.plyUserGroup] then
				self.userGroup:SetText(essentialDarkRPScoreboard.groupColors[self.plyUserGroup]['display_name'])
				self.userGroup:SetTextColor(essentialDarkRPScoreboard.groupColors[self.plyUserGroup]['color'])
			else
				self.userGroup:SetText('')
			end

			self.userGroup:SizeToContentsX()
		else
			self.userGroup:SetVisible(false)
		end

		if self.numPing == nil or self.numPing ~= self.player:Ping() then
			self.numPing = self.player:Ping()

			self.ping:SetText(self.numPing .. ' пинг')
			self.ping:SizeToContentsX()
		end

		if self.muted == nil or self.muted ~= self.player:IsMuted() then
			self.muted = self.player:IsMuted()

			if self.muted then
				self.mute:SetImage('icon32/muted.png')
			else
				self.mute:SetImage('icon32/unmuted.png')
			end

			self.mute.DoClick = function()
				self.player:SetMuted(not self.muted)

				if self.player:IsMuted() then
					chat.AddText('Player ' .. self.player:Nick() .. ' is now being muted.')
				else
					chat.AddText('Player ' .. self.player:Nick() .. ' is no longer being muted.')
				end

				buttonClickReleaseSound()
			end
		end

		if self.player:Team() == 0 then
			self:SetZPos((self.player:EntIndex() + 2000) + (self.numKills * -50))
		end

		self:SetZPos(self.player:EntIndex() + (self.numKills * -50))
	end,

	Paint = function(self, w, h)
		if not IsValid(self.player) then
			return
		end

		if not self.player:Alive() then
			drawBlurRectOutlined(0, 0, w, h, Color(50, 10, 10, 180), 3, 8)

			return
		end

		if self.player:Team() == 0 then
			drawRectOutlined(0, 0, w, h, buttonColor)

			return
		end

		if self.player:Team() == 1 then
			drawRectOutlined(0, 0, w, h, buttonColor)

			return
		end

		if self.player:Team() == TEAM_CONNECTING then
			drawRectOutlined(0, 0, w, h, buttonColor)

			return
		end

		drawRectOutlined(0, 0, w, h, buttonColor)
	end
}

local playerLine = vgui.RegisterTable(playerLine, 'EditablePanel')

local scoreboard = {
	Init = function(self)
		self.header = self:Add('Panel')
		self.header:Dock(TOP)
		self.header:SetHeight(70)

		self.hostName = self.header:Add('DLabel')
		self.hostName:SetFont('eds_Roboto24')
		self.hostName:SetTextColor(white)
		self.hostName:Dock(TOP)
		self.hostName:SetHeight(70)
		self.hostName:SetContentAlignment(5)
		self.hostName:DockMargin(0, 0, 0, 0)

		self.scores = self:Add('DScrollPanel')
		self.scores:Dock(FILL)
		self.scores:DockMargin(0, 0, 0, 10)

		local scrollBar = self.scores:GetVBar()
		scrollBar:DockMargin(-5, 0, 0, 0)

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

		self.footer = self:Add('Panel')
		self.footer:Dock(BOTTOM)
		self.footer:SetHeight(40)

		self.settingsButton = self:Add('DButton')
		self.settingsButton:SetPos(25, 50)
		self.settingsButton:SetSize(24, 24)
		self.settingsButton:SetText('')
		self.settingsButton:SetImage(scriptEdit)

		function self.settingsButton:Paint(w, h)
			drawRectOutlined(0, 0, w, h, defaultBlur)
		end

		self.settingsButton.DoClick = function()
			essentialDarkRPScoreboard.openSettings()
		end

		self.playersOnline = self.footer:Add('DLabel')
		self.playersOnline:SetFont('eds_Roboto24')
		self.playersOnline:SetTextColor(white)
		self.playersOnline:Dock(FILL)
		self.playersOnline:SetHeight(40)
		self.playersOnline:SetContentAlignment(5)
		self.playersOnline:DockMargin(0, 0, 0, 0)

		self.fadminSettingsButton = self:Add('DButton')
		self.fadminSettingsButton:SetSize(84, 35)
		self.fadminSettingsButton:SetText('Панель')
		self.fadminSettingsButton:SetTextColor(white)
		self.fadminSettingsButton:SetFont('eds_Roboto20')
		self.fadminSettingsButton:SetVisible(true)

		function self.fadminSettingsButton:Paint(w, h)
			if self:IsHovered() then
				self:SetTextColor(buttonHoveredText)
			else
				self:SetTextColor(white)
			end

			drawRectOutlined(0, 0, w, h, buttonColor)
		end

		function self.fadminSettingsButton:DoClick()
			essentialDarkRPScoreboard.OpenFAdminSettings()
		end
	end,

	PerformLayout = function(self)
		scrH = ScrH()
		scoreboardGap = ScrH() * 0.13

		self:SetSize(800, scrH - scoreboardGap)

		self:SetPos((ScrW() * 0.5) - 400, scoreboardGap * 0.5)
		self.fadminSettingsButton:SetPos(800 - 90, scrH - (scoreboardGap + 41))
		self.settingsButton:SetPos(6, scrH - (scoreboardGap + 30))
	end,

	Paint = function(self, w, h)
		essentialDarkRPScoreboard.drawBlurPanelOutlined(self, defaultBlur, 3, 8)
	end,

	Think = function(self, w, h)
		self.hostName:SetText(GetHostName())

		for id, pl in pairs(player.GetAll()) do
			if IsValid(pl.ScoreEntry) then continue end

			pl.ScoreEntry = vgui.CreateFromTable(playerLine, pl.ScoreEntry)
			pl.ScoreEntry:Setup(pl)
			self.scores:AddItem(pl.ScoreEntry)
		end

		local localPlayer = LocalPlayer()

		if (localPlayer:IsSuperAdmin() or localPlayer:IsUserGroup('owner')) and essentialDarkRPScoreboard.settings['showSettingsButton'] then
			self.settingsButton:SetVisible(true)
		else
			self.settingsButton:SetVisible(false)
		end

		self.playersOnline:SetText(string.format('%i/%i', player.GetCount(), game.MaxPlayers()))

		if FAdmin and ulx and (localPlayer:IsSuperAdmin() or localPlayer:IsUserGroup('owner')) then
			self.fadminSettingsButton:SetVisible(true)
		elseif FAdmin and not ulx and (localPlayer:IsSuperAdmin() or localPlayer:IsAdmin() or localPlayer:IsUserGroup('owner')) then
			self.fadminSettingsButton:SetVisible(true)
		else
			self.fadminSettingsButton:SetVisible(false)
		end
	end
}

local scoreboard = vgui.RegisterTable(scoreboard, 'EditablePanel')

hook.Add('ScoreboardShow', 'eds_OverrideShow', function()
	if IsValid(scoreboard) then
		scoreboard:Show()
		scoreboard:MakePopup()
		scoreboard:SetKeyboardInputEnabled(false)
	else
		scoreboard = vgui.CreateFromTable(scoreboard)
		scoreboard:Show()
		scoreboard:MakePopup()
		scoreboard:SetKeyboardInputEnabled(false)
	end

	-- Stop drawing FAdmin scoreboard
	return false
end)

hook.Add('ScoreboardHide', 'eds_OverrideHide', function()
	if IsValid(scoreboard) then
		scoreboard:Hide()
	end
end)
