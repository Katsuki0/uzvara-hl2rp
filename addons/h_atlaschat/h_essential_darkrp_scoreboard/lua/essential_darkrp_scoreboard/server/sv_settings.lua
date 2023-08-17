util.AddNetworkString('scoreboardColorUpdate')
util.AddNetworkString('addNewGroupSettings')
util.AddNetworkString('removeGroupSettings')
util.AddNetworkString('scoreboardSettingsUpdate')
util.AddNetworkString('showSettingsButtonChange')
util.AddNetworkString('enableUserGroupsChange')

essentialDarkRPScoreboard = essentialDarkRPScoreboard or {}
essentialDarkRPScoreboard.groupColors = essentialDarkRPScoreboard.groupColors or {}
essentialDarkRPScoreboard.settings = essentialDarkRPScoreboard.settings or {}

local function settingsToJson()
	file.Write('essential_darkrp_scoreboard/settings.txt', util.TableToJSON(essentialDarkRPScoreboard.settings, true))
end

if file.Exists('essential_darkrp_scoreboard/settings.txt', 'DATA') then
	essentialDarkRPScoreboard.settings = util.JSONToTable(file.Read('essential_darkrp_scoreboard/settings.txt', 'DATA'))

	if essentialDarkRPScoreboard.settings == nil or essentialDarkRPScoreboard.settings == '' then
		essentialDarkRPScoreboard.settings['showSettingsButton'] = true
		essentialDarkRPScoreboard.settings['displayUserGroups'] = true

		settingsToJson()
	end
else
	essentialDarkRPScoreboard.settings['showSettingsButton'] = true
	essentialDarkRPScoreboard.settings['displayUserGroups'] = true

	settingsToJson()
end

local function groupsToJson()
	file.Write('essential_darkrp_scoreboard/group_colors.txt', util.TableToJSON(essentialDarkRPScoreboard.groupColors, true))
end

local function updateGroups(group, settings)
	essentialDarkRPScoreboard.groupColors[group] = settings

	net.Start('scoreboardColorUpdate')
		net.WriteTable(essentialDarkRPScoreboard.groupColors)
	net.Broadcast()

	groupsToJson()
end

local function removeGroup(group)
	essentialDarkRPScoreboard.groupColors[group] = nil

	net.Start('scoreboardColorUpdate')
		net.WriteTable(essentialDarkRPScoreboard.groupColors)
	net.Broadcast()

	groupsToJson()
end

local function writeDefaultGroups()
	essentialDarkRPScoreboard.groupColors['superadmin'] = {
		['display_name'] = 'Создатель',
		['color'] = Color(128, 0, 0, 255)
	}

	essentialDarkRPScoreboard.groupColors['admin'] = {
		['display_name'] = 'Администратор',
		['color'] = Color(102, 153, 255, 255)
	}
	
	essentialDarkRPScoreboard.groupColors['operator_N'] = {
		['display_name'] = 'Оператор[Н]',
		['color'] = Color(72, 61, 139, 255)
	}
	
	essentialDarkRPScoreboard.groupColors['operator_D'] = {
		['display_name'] = 'Оператор[Д]',
		['color'] = Color(184, 134, 11, 255)
	}
	
	essentialDarkRPScoreboard.groupColors['operator_VD'] = {
		['display_name'] = 'Оператор[Д]',
		['color'] = Color(184, 134, 11, 255)
	}
	
	essentialDarkRPScoreboard.groupColors['operator_VN'] = {
		['display_name'] = 'Оператор[Н]',
		['color'] = Color(72, 61, 139, 255)
	}
	
	essentialDarkRPScoreboard.groupColors['VIP'] = {
		['display_name'] = 'VIP',
		['color'] = Color(255, 255, 0, 255)
	}

	groupsToJson()
end

if file.Exists('essential_darkrp_scoreboard/group_colors.txt', 'DATA') then
	essentialDarkRPScoreboard.groupColors = util.JSONToTable(file.Read('essential_darkrp_scoreboard/group_colors.txt', 'DATA'))

	if essentialDarkRPScoreboard.groupColors == nil or essentialDarkRPScoreboard.groupColors == '' then
		writeDefaultGroups()
	end
else
	writeDefaultGroups()
end

hook.Add('PlayerInitialSpawn', 'eds_SendGroupColorsOnSpawn', function(ply)
	timer.Simple(1, function()
		net.Start('scoreboardColorUpdate')
			net.WriteTable(essentialDarkRPScoreboard.groupColors)
		net.Send(ply)

		net.Start('scoreboardSettingsUpdate')
			net.WriteTable(essentialDarkRPScoreboard.settings)
		net.Send(ply)
	end)
end)

net.Receive('addNewGroupSettings', function(len, ply)
	if not ply:IsSuperAdmin() or ply:IsUserGroup('owner') then return end

	local newGroup = net.ReadString()
	local newGroupSettings = net.ReadTable()

	updateGroups(newGroup, newGroupSettings)
end)

net.Receive('removeGroupSettings', function(len, ply)
	if not ply:IsSuperAdmin() or ply:IsUserGroup('owner') then return end

	local groupToRemove = net.ReadString()

	removeGroup(groupToRemove)
end)

net.Receive('showSettingsButtonChange', function(len, ply)
	if not ply:IsSuperAdmin() or ply:IsUserGroup('owner') then return end

	essentialDarkRPScoreboard.settings['showSettingsButton'] = not essentialDarkRPScoreboard.settings['showSettingsButton']

	net.Start('scoreboardSettingsUpdate')
		net.WriteTable(essentialDarkRPScoreboard.settings)
	net.Broadcast()

	settingsToJson()
end)

net.Receive('enableUserGroupsChange', function(len, ply)
	if not ply:IsSuperAdmin() or ply:IsUserGroup('owner') then return end

	essentialDarkRPScoreboard.settings['displayUserGroups'] = not essentialDarkRPScoreboard.settings['displayUserGroups']

	net.Start('scoreboardSettingsUpdate')
		net.WriteTable(essentialDarkRPScoreboard.settings)
	net.Broadcast()

	settingsToJson()
end)
