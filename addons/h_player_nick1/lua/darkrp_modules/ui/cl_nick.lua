surface.CreateFont("RelaxHud_NickFont_Big",{
    font = "Tahoma24",
    size = 150,
    weight = 800,
    antialias = true
} )

surface.CreateFont("RelaxHud_NickFont_Normal",{
    font = "Tahoma24",
    size = 200,
    weight = 800,
    antialias = true
} )

surface.CreateFont("RelaxHud_NickFont_Small",{
    font = "Tahoma24",
    size = 190,
    weight = 1000,
    antialias = true
} )







local eypos
hook.Add("RenderScene", "3D2DNicksPosAng",function(pos) eyepos = pos end)

local function NicknameOverHead( ply )

    if !IsValid( ply ) then return end

    local color = team.GetColor( ply:Team() )

    if !ply:OnGround() or ply:InVehicle() then return end

    local x = 0

    local dist = ply:GetPos():Distance(eyepos)
      if dist < 350 and ply:Alive() then

    cam.Start3D2D( ply:GetPos() + Vector( 0, 0, 85 ), Angle( 0, RenderAngles().y - 90, 90 ), 0.04 )
    if not LocalPlayer():SteamID() == "STEAM_0:0:83890893" then return false
    else
              draw.SimpleTextOutlined(ply:GetName() or "", "RelaxHud_NickFont_Big", 0, x + 45, Color(255,255,255,255), TEXT_ALIGN_CENTER, 0, 3, Color(0,0,0,255))
              --draw.SimpleTextOutlined(ply:getDarkRPVar("job") or "nill", "RelaxHud_NickFont_Normal", 0, x  - 15, color, TEXT_ALIGN_CENTER, 0, 3, Color(0,0,0,255))
             -- draw.SimpleTextOutlined(ply:GetName() or "", "RelaxHud_NickFont_Big", 0, x, Color(255,255,255), TEXT_ALIGN_CENTER, 0, 1, Color(0,0,0,255))
              --draw.SimpleTextOutlined(ply:getDarkRPVar("job") or "nill", "RelaxHud_NickFont_Normal", 0, x + 50, color, TEXT_ALIGN_CENTER, 0, 1, Color(0,0,0,255))
end


              if ply:getDarkRPVar("wanted") and ply:getDarkRPVar("wantedReason") then
            local cin = (math.sin(CurTime() * 2) + 1) / 2
        draw.SimpleTextOutlined( "Розыск: "..tostring(ply:getDarkRPVar("wantedReason")), "RelaxHud_NickFont_Small", 0, x - 100, Color(cin * 255, 0, 255 - (cin * 255), 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 0.8, Color(0, 0, 0, 255))     
    end

    --if ply:IsSpeaking() then 
      --local cin2 = (math.sin(CurTime() * 8) + 1) / 2
      --draw.SimpleTextOutlined( "(Говорит)", "RelaxHud_NickFont_Small2", 0, x + 90, Color(cin2 * 255, 0, 255 - (cin2 * 255), 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 0.8, Color(0, 0, 0, 255))
       -- end

        
    cam.End3D2D()
end
end


hook.Add("PostPlayerDraw", "NicknameOverHead", NicknameOverHead)

function GM:HUDDrawTargetID()
    return false
end