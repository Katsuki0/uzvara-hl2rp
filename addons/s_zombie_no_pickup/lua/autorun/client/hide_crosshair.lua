local hide = {
    ["CHudCrosshair"] = true,

}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
    if ( hide[ name ] ) then return false end

end )

hook.Remove("StartChat", "DarkRP_StartFindChatReceivers")
hook.Remove("PlayerStartVoice", "DarkRP_VoiceChatReceiverFinder")


hook.Add("RenderScreenspaceEffects", "ZombieEffect", function()
		if LocalPlayer():Team() == TEAM_OTAELITE --[[or LocalPlayer():Team() == TEAM_CITIZEN]] then
		local ply = LocalPlayer()
		local alpha = 0
		local tab = {
			["$pp_colour_addr"] = -0.7,
			["$pp_colour_addg"] = -1,
			["$pp_colour_addb"] = -1,
		    ["$pp_colour_brightness"] = 0.8,
			["$pp_colour_contrast"]  = 2,
			["$pp_colour_colour"] = 0.3,
			["$pp_colour_mulr"] = 0 ,
			["$pp_colour_mulg"] = 0.1,
			["$pp_colour_mulb"] = 0
		}
		DrawColorModify(tab)
		end
end)