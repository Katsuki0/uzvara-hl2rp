// Полезное : 
// ent.isFadingDoor
// ent.fadeActive
hook.Add("HUDPaint", "hudPaintFadingDoor", function ()
    local pos = LocalPlayer():GetPos()
    local ents = ents.FindInSphere(pos, 100)
 
 
    for _,v in pairs (ents) do
        if v:IsValid() then
            if v:GetClass() == "prop_physics" then
                local owner, uid = v:CPPIGetOwner()
                if owner != nil and owner:IsValid() then
                    if v:IsEffectActive(16) then
                        local pos_2 = v:GetPos():ToScreen()
                        draw.SimpleTextOutlined("STEAM NICK : "..steamworks.GetPlayerName(owner:SteamID64()) or "ERROR", "Trebuchet24", pos_2.x, pos_2.y, Color(255,255,255,255), 1, 1, 1, Color(0,0,0))
                        draw.SimpleTextOutlined("RP NICK : "..owner:Nick().." ("..owner:SteamID()..")", "Trebuchet24", pos_2.x, pos_2.y + 25, Color(255,255,255,255), 1, 1, 1, Color(0,0,0))
                    end
                end
            end
        end
    end
end)