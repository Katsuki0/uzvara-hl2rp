--[[-----------------------------------
AUTHOR: dougRiss
DATE: 11/7/2014
PURPOSE: Separates the bulk of all the 
clientside lua that is called when an 
entity interacts with a sign or book.
--]]-----------------------------------

include("open_file.lua")
include("save_file.lua")
include("build.lua")
include("config/config.lua")

local function writeToServer(aTable, nwstring)
	net.Start(nwstring)
		net.WriteTable(aTable)
	net.SendToServer()
	
	if(DEBUGGING_MODE) then print("table \""..aTable.name.."\" sent to server; expecting success...") end
end

function buildClaimPanel(mainFrame, theName, theOwner, theID, nwstring)
	mainFrame = buildFrame("Выберите: ", false, 175, 100, true)	
	
	claimButton = buildButton(mainFrame, "Выбрать", 167, 30, 4, 30)
	claimButton.DoClick = function ()
		local t = {text = "", name = theName, owner = theOwner, id = theID}
		writeToServer(t, nwstring)
		displayNotification("Выбрано")
		mainFrame:Remove()
		mainFrame = nil
	end --end DoClick
	
	closeButton = buildButton(mainFrame, "Закрыть", 167, 30, 4, 64)
	closeButton.DoClick = function ()
		mainFrame:Remove()
		mainFrame = nil
	end
end

function buildOwnerPanel(mainFrame, theName, theOwner, theID, theText, nwstring)
	mainFrame = buildFrame("Выберите: ", false, 400, 400)

	nameBox = buildTextEntry(mainFrame, theName, true, 305, 20, 5, 30)
	nameBox:SetEditable(false)

	textBox = buildTextEntry(mainFrame, theText, true, 305, 340, 5, 55)
	textBox:SetEditable(false)

	closeButton = buildButton(mainFrame, "Закрыть", 80, 45, 315, 350)
	closeButton.DoClick = function ()
		mainFrame:Remove()
		mainFrame = nil
		if(DEBUGGING_MODE) then print("Выход из панели") end
	end --end DoClick

	editButton = buildButton(mainFrame, "Изменить", 80, 45, 315, 30)
	editButton.DoClick = function ()
		if editButton:GetText() == "Изменить" then
			editButton:SetText("Принять")
			closeButton:SetText("Закрыть")
			textBox:SetEditable(true)
			nameBox:SetEditable(true)
			if(DEBUGGING_MODE) then print("Редактирование читается...") end
		else
			t = {name = nameBox:GetValue(), owner = theOwner, id = theID, text = textBox:GetValue()}
			writeToServer(t, nwstring)
			displayNotification("Изменения сохранены")
			editButton:SetText("Изменить")
			closeButton:SetText("Принять")
			textBox:SetEditable(false)
			nameBox:SetEditable(false)
			if(DEBUGGING_MODE) then print("Читаемый Сохраненный") end
		end --end if
	end --end DoClick

	openButton = buildButton(mainFrame, "Открыть...", 80, 45, 315, 80)
	openButton.DoClick = function ()
		openFileDialog(theOwner, theID, nwstring)
		mainFrame:Remove()
		mainFrame = nil
	end --end DoClick()

	saveButton = buildButton(mainFrame, "Сохранить...", 80, 45, 315, 130)
	saveButton.DoClick = function ()
		t = {name = nameBox:GetValue(), owner = theOwner, id = theID, text = textBox:GetValue()}
		writeToServer(t, nwstring)
		saveFileDialog(textBox:GetValue(), nameBox:GetValue(), nwstring)
		editButton:SetText("Изменить")
		closeButton:SetText("Закрыть")
		textBox:SetEditable(false)
		nameBox:SetEditable(false)
		if(DEBUGGING_MODE) then print("Читаемый Сохраненный") end
	end --end DoClick()
end

function buildGuestPanel(mainFrame, theName, theOwner, theID, theText, nwstring)
	mainFrame = buildFrame(theName, false, 400, 400)
	
	textBox = buildTextEntry(mainFrame, theText, true, 305, 360, 5, 30)
	textBox:SetEditable(false)
	
	if(ALLOW_SAVE_ON_VIEW) then
		local saveButton = vgui.Create("DButton", mainPanel)
		saveButton:SetPos(315, 30)
		saveButton:SetSize(80, 45)
		saveButton:SetText("Сохранить")
		saveButton.DoClick = function ()
			saveFileDialog(textBox:GetValue(), name, nwstring)
			mainPanel:Remove()
			mainPanel = nil
		end --end DoClick
	end
	
	acceptButton = buildButton(mainFrame, "Закрыть", 80, 45, 315, 350)
	acceptButton.DoClick = function ()
		mainFrame:Remove()
		mainFrame = nil
	end --end DoClick
end