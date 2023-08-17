
CreateClientConVar("unionrp_combineoverlay", "1", true, false)

---Указывать профессию
---Так же профессии должны быть в таблице OTA

hook.Add( "RenderScreenspaceEffects", "BinocDraw", function()
  if (LocalPlayer():Team() == TEAM_UNIT1) or (LocalPlayer():Team() == TEAM_UNIT2) or (LocalPlayer():Team() == TEAM_UNIT3) or (LocalPlayer():Team() == TEAM_UNIT4) or (LocalPlayer():Team() == TEAM_UNIT5) or (LocalPlayer():Team() == TEAM_DEZERTIR) or (LocalPlayer():Team() == TEAM_UNITENGINER) or (LocalPlayer():Team() == TEAM_PILIOTA) or (LocalPlayer():Team() == TEAM_UNITMEDIC) or (LocalPlayer():Team() == TEAM_CMDUNIT) or (LocalPlayer():Team() == TEAM_CMDOTA) or (LocalPlayer():Team() == TEAM_OTAUNION) or (LocalPlayer():Team() == TEAM_OTASECURITY) or (LocalPlayer():Team() == TEAM_OTAHEAVY) or (LocalPlayer():Team() == TEAM_OTAELITE) or (LocalPlayer():Team() == TEAM_SNIPER) then
    DrawMaterialOverlay( "effects/combine_binocoverlay.vmt", 0.1 )
  end
end)


