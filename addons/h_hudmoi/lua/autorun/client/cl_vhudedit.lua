function initFonts()
    surface.CreateFont( "", {
        font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        size = 20,
        weight = 600,
    } )
    


    surface.CreateFont( "ObvodkaHealth", {
        font = "Trebuchet24", -- не ебу что это в душе ебать
        size = 14,
        weight = 700,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )

    surface.CreateFont( "ObvodkaArmor", {
        font = "Trebuchet24", -- не ебу что это в душе ебать
        size = 14,
        weight = 700

    } )

    surface.CreateFont( "Lockdown", {
        font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 17,
        weight = 1000,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )
    
    surface.CreateFont( "Salary", {

    font = "Trebuchet MS",
    
    extended = true,
    
    size = 20,
    
    weight = 700,
    
    blursize = 0,
    
    scanlines = 0,
    
    antialias = true,
    
    })
    
    surface.CreateFont( "Money", {

    font = "Trebuchet MS",
    
    extended = true,
    
    size = 20,
    
    weight = 700,
    
    blursize = 0,
    
    scanlines = 0,
    
    antialias = true,
    
    })


    surface.CreateFont( "Nick", {
        font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = true,
        size = 30,
        weight = 300,
        antialias = true,
        italic = false,
        symbol = false,
    } )

    surface.CreateFont( "Job", {
        font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = true,
        size = 20,
        weight = 600,
        italic = false,
        symbol = false,
    } )

    surface.CreateFont( "Health", {
        font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 14,
        weight = 1000,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )

    surface.CreateFont( "HealthText", {
        font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 11,
        weight = 1000,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )

    surface.CreateFont( "Wanted", {
        font = "Trebuchet24", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 40,
        weight = 1000,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )
end

initFonts()

timer.Simple( .1, initFonts )

function drawOutlinedText(text, font, x, y, color, align)
    draw.SimpleText( text, "Obvodka" .. font, x-1, y-1, color_black, align )
    draw.SimpleText( text, font, x, y, color, align )
end

local gaybars = 0

function nullGayBars()
    gaybars = 0
end

function drawGayBar(round, val, x, y, w, h, color, text)
    draw.RoundedBox( 0, x, y + gaybars, w, h, Color(255,255,255,100) )
    draw.RoundedBox( 0, x, y + gaybars, w * val, h, color )

    if text then
        surface.SetFont("Health")
        local tw,th = surface.GetTextSize(text)

        --local align = tw >= w * val and TEXT_ALIGN_RIGHT or TEXT_ALIGN_CENTER
        --local align = w * val <= tw * 0.5 and TEXT_ALIGN_LEFT or align
        local align = TEXT_ALIGN_CENTER
        draw.SimpleTextOutlined(text, "Health", x + w * 0.95, y + gaybars,Color(255,255,255,255), 1, 0, 1, Color(0,0,0))
    end
    gaybars = gaybars + h + 2
end

-- local stamina = 0

function InitializeHUD()
    local smoothHealth = 100
    local smoothArmor = 100
    local smoothStamina = 100

    function MainHUD()

        local Money     = LocalPlayer():getDarkRPVar("money") or 0
        local Hunger    = LocalPlayer():getDarkRPVar("Energy") or 0
        local stamina = LocalPlayer().BurgerStamina or 0

        smoothHealth = Lerp(FrameTime()*2, smoothHealth, LocalPlayer():Health())
        smoothArmor = Lerp(FrameTime()*2, smoothArmor, LocalPlayer():Armor())
        smoothStamina = Lerp(FrameTime()*2, smoothStamina, stamina)

        nullGayBars()

        drawGayBar( 1, math.Clamp(smoothHealth, 0, 100)/100, 15, ScrH() - 80, 300, 14, Color(123,0,28), "" .. LocalPlayer():Health() .. "", Color(123,0,28) ) 
        drawGayBar( 0, math.Clamp(smoothArmor, 0, 100)/100, 15, ScrH() - 80, 300, 14, Color(0,49,83), "" .. LocalPlayer():Armor() .. "", Color(0,49, 83) )
        drawGayBar( 0, math.Clamp(Hunger, 0, 100)/100, 15, ScrH() - 80, 300, 14, Color(163,80,0), "" .. math.Round(Hunger) .. "", Color( 163, 80, 0) )
        drawGayBar( 0, math.Clamp(smoothStamina, 0, 100)/100, 15, ScrH() - 80, 300, 14, Color(0, 92, 5), "" .. math.Round(smoothStamina) .. "", Color(0, 92, 5) )

        draw.SimpleTextOutlined( "Uzvara HL2RP", "Nick", ScrW() - 95, ScrH() - 40, Color(255,255,255,255), 1, 0, 1,Color(0,0,0,255), TEXT_ALIGN_CENTER )
        draw.SimpleTextOutlined( DarkRP.formatMoney( Money or 0 ) .. "(Наличные)",  "Money", 85, ScrH() - 128,  Color(255,255,255,255), 1, 0, 1,Color(0,0,0,255), TEXT_ALIGN_LEFT )
        draw.SimpleTextOutlined( DarkRP.formatMoney( LocalPlayer():getDarkRPVar("salary") or 0 ) .. "(Зарплата)", "Salary", 85, ScrH() - 108, Color(255,255,255,255), 1, 0, 1,Color(0,0,0,255), TEXT_ALIGN_LEFT )


    end
    
    hook.Add("InitPostEntity", "PriselPlayerModel", function()

    local PriselPM = vgui.Create("DModelPanel")

    PriselPM:SetPos(42, ScrH() - 145)

    PriselPM:SetSize(80, 75)

    PriselPM:SetModel(LocalPlayer():GetModel())

    PriselPM.LayoutEntity = function() return false end

    PriselPM:SetFOV(50)

    PriselPM:SetCamPos(Vector(25, -10, 64))--64

    PriselPM:SetLookAt(Vector(0, 0, 62))

    PriselPM.Entity:SetEyeTarget(Vector(200, 200, 100))



    timer.Create("updateHUDModel", 1, 0, function()

        PriselPM:SetPos(15, ScrH() - 93)

        PriselPM:SetSize(80, 75)

        PriselPM:SetModel(LocalPlayer():GetModel())

        PriselPM.Entity:SetColor(LocalPlayer():GetColor())

    end)

end)



hook.Add("PreGamemodeLoaded", "disable_playervoicechat_base", function()

    hook.Remove("InitPostEntity", "CreateVoiceVGUI")

end)



local PlayerVoiceList = {}



hook.Add("PlayerStartVoice", "StartVoice", function(ply)

    PlayerVoiceList[ply] = true

end)



hook.Add("PlayerEndVoice", "EndVoice", function(ply)

    PlayerVoiceList[ply] = nil

end)
    
    hook.Add("HUDPaint", "MainHUD", MainHUD)

    local ammo_alpha = 0
    local ammo_text = ""

    function LerpAmmo()
        if ammo_alpha > 0 then
            ammo_alpha = Lerp(FrameTime()*10, ammo_alpha, 0)
        end
    end

    function AmmoHUD()

        local weapon = LocalPlayer():GetActiveWeapon()
        if weapon and IsValid( weapon ) then
            local clip = weapon:Clip1()
            local ammo = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())

            if ammo and clip >= 0 and not (clip == -1 or clip <= 0 and ammo <= 0) then

                ammo_text = clip .. " / " .. ammo

                ammo_alpha = 255

            else LerpAmmo() end
        else LerpAmmo() end

        draw.SimpleTextOutlined( ammo_text, "Nick", ScrW() - 240, ScrH() - 40, Color(255,255,255,ammo_alpha), 1, 0, 1,Color(0,0,0,ammo_alpha), TEXT_ALIGN_RIGHT )

        draw.RoundedBox( 0, ScrW()-185, ScrH()-40, 2, 30, Color(255,120,0,ammo_alpha) )

    end
    hook.Add("HUDPaint", "AmmoHUD", AmmoHUD)

    function AgendaHUD()

        local agenda = LocalPlayer():getAgendaTable()
        if not agenda then return end

        draw.RoundedBox( 0, 5, 5, 350, 150, Color(255,0,0) )
        surface.SetDrawColor( color_gray )
        surface.DrawOutlinedRect( 5, 5, 350, 150 )

        draw.RoundedBox( 0, 5, 5, 350, 40, color_white )
        surface.SetDrawColor( color_gray )
        surface.DrawOutlinedRect( 500, 5, 350, 40 )

        draw.DrawText( agenda.Title, "Job", 175, 10, color_black, TEXT_ALIGN_CENTER )

        local text = LocalPlayer():getDarkRPVar("agenda") or ""
        text = text:gsub("//", "\n"):gsub("\\n", "\n")
        text = DarkRP.textWrap(text, "DarkRPHUD1", 300)

        draw.DrawText(text, "Зарплата", 10, 50, color_black )
        -- draw.SimpleTextOutlined(text.."(Запрлата)", "Trebuchet24", 10, 50, Color(255,255,255,255), 1, 1, 1, Color(0,0,0))
        -- draw.SimpleTextOutlined( string Text, string font = "DermaDefault", number x = 0, number y = 0, table color = Color( 255, 255, 255, 255 ), number xAlign = TEXT_ALIGN_LEFT, number yAlign = TEXT_ALIGN_TOP, number outlinewidth, table outlinecolor = Color( 255, 255, 255, 255 ) )

    end
    -- p
    hook.Add("HUDPaint", "Agenda", AgendaHUD)

    function LockdownHUD()

        if GetGlobalBool("DarkRP_LockDown") then

            draw.SimpleText( "Начался ком. час!  Возвращайтесь домой!", "Lockdown", 170, ScrH() - 150, color_white, TEXT_ALIGN_CENTER )
        end

    end
    hook.Add("HUDPaint", "Lockdown", LockdownHUD)


    function hidehud(name)
        for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "DarkRP_HUD", "DarkRP_Hungermod", "CHudSecondaryAmmo", "DarkRP_LocalPlayerHUD"})do
            if name == v then return false end
        end
    end
    hook.Add("HUDShouldDraw", "hide", hidehud)
end

InitializeHUD()

local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")
    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify) 