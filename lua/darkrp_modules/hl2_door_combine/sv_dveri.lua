function KeyPressedUse (ply, key)
if (ply:Team() == TEAM_UNIT1) or (ply:Team() == TEAM_UNIT2) or (ply:Team() == TEAM_UNIT3) or (ply:Team() == TEAM_UNIT4) or (ply:Team() == TEAM_UNIT5) or (ply:Team() == TEAM_UNITENGINER) or (ply:Team() == TEAM_DEZERTIR) or (ply:Team() == TEAM_PILIOTA) or (ply:Team() == TEAM_ADMGORODA) or (ply:Team() == TEAM_UNITMEDIC) or (ply:Team() == TEAM_CMDUNIT) or (ply:Team() == TEAM_CMDOTA) or (ply:Team() == TEAM_OTAUNION) or (ply:Team() == TEAM_OTASECURITY) or (ply:Team() == TEAM_OTAHEAVY) or (ply:Team() == TEAM_OTAELITE) or (ply:Team() == TEAM_SNIPER) then 
    if key == IN_USE then 
        local t = {}   
        t.start = ply:GetPos()   
        t.endpos = ply:GetShootPos() + ply:GetAimVector() * 100   
        t.filter = ply
        local trace = util.TraceLine(t)          
        if trace.Entity and trace.Entity:IsValid() and (trace.Entity:GetClass() == "func_door" or trace.Entity:GetClass() == "prop_door_rotating" or trace.Entity:GetClass() == "prop_dynamic") then
            trace.Entity:Fire("Open")
        end
    end
end
end
hook.Add( "KeyPress", "KeyPressedUse", KeyPressedUse  )