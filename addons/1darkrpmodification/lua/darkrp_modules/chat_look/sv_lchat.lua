
local function localChat(ply, args)
	if args == "" then return "" end
	DarkRP.talkToRange(ply, "[LOOC] "..ply:Nick(), args, 200)
	return ""
end
	 
	 
DarkRP.defineChatCommand("looc", localChat)