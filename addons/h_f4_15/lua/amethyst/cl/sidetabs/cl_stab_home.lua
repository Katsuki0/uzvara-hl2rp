/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel:↓
https://www.youtube.com/c/Famouse

More leaks in the discord:↓ 
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/


local PANEL = {}

function PANEL:Init()

    Amethyst.Init = self
    Amethyst.Init:Dock(FILL)
    Amethyst.Init:DockMargin(0,0,0,0)
    Amethyst.Init.Paint = function(self, w, h) end

	self.Avatar_PlayerCircular = vgui.Create( "Amethyst.Avatar", Amethyst.Init )
	self.Avatar_PlayerCircular:SetSize( 128, 128 )
    if ScrH() >= 900 then
	   self.Avatar_PlayerCircular:SetPos(ScreenScale(80) / 2 - 64, 10)
    else
        self.Avatar_PlayerCircular:SetPos(ScreenScale(100) / 2 - 64, 10)
    end
	self.Avatar_PlayerCircular:DockMargin(5, 4, 0, 0)
	self.Avatar_PlayerCircular:SetPlayer( LocalPlayer():SteamID64() )

    self.DPanel_RightTop = vgui.Create("DPanel", Amethyst.Init )
    self.DPanel_RightTop:Dock(TOP)
    self.DPanel_RightTop:DockMargin(0,150,0,0)
    self.DPanel_RightTop:SetTall(30)
    self.DPanel_RightTop.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
        draw.SimpleText(LocalPlayer():Name() or Amethyst.Language["welcome"] or "Welcome", "Amethyst.Font.SidePlayerName", w / 2, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local countPlayerData = 0
    for k, v in pairs( Amethyst.Settings.PlayerData ) do
        if not v.Enabled then continue end
        countPlayerData = countPlayerData + 1
    end

    self.DPanel_Playerdata = vgui.Create("DPanel", Amethyst.Init )
    self.DPanel_Playerdata:Dock(TOP)
    self.DPanel_Playerdata:SetTall(countPlayerData * 25 or 100)
    self.DPanel_Playerdata:DockMargin(0,0,0,0)
    self.DPanel_Playerdata.Paint = function(self, w, h) end

    for k, v in pairs( Amethyst.Settings.PlayerData ) do

        if not v.Enabled then continue end

        self.DButton_PlayerData = self.DPanel_Playerdata:Add( "DButton" )
        self.DButton_PlayerData:SetText( "" )
        self.DButton_PlayerData:SetTall( ScreenScale(9) )
        self.DButton_PlayerData:Dock( TOP )
        self.DButton_PlayerData:SetTall( 25 )
        self.DButton_PlayerData:DockMargin( 0, 0, 0, 0 )
        self.DButton_PlayerData.Func = v.BlockFunc
        self.DButton_PlayerData.Paint = function( self, w, h )

            local Value = v.BlockFunc()

            if not Value or Value == "" or Value == NULL then
                Value = "N/A"
            end

            EndText = Value or ""

            if GetConVar("amethyst_m_stabs_text_type"):GetString() == "icons" then
                surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
                surface.SetMaterial( Material( v.BlockIcon, "noclamp smooth" ) )
                surface.DrawTexturedRect( 7, h / 2 - 6, 12, 12 )
            else
                draw.SimpleText( v.BlockName, "Amethyst.Font.PlayerInfo", 5, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            end

            draw.SimpleText( EndText, "Amethyst.Font.PlayerInfo", w - 5, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

        end

    end

    self.DPanel_Statistics = vgui.Create("DPanel", Amethyst.Init )
    self.DPanel_Statistics:Dock(TOP)
    self.DPanel_Statistics:DockMargin(0,0,0,0)
    self.DPanel_Statistics:SetTall(30)
    self.DPanel_Statistics.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color(GetConVar("amethyst_m_secondarycolor_red"):GetInt(), GetConVar("amethyst_m_secondarycolor_green"):GetInt(), GetConVar("amethyst_m_secondarycolor_blue"):GetInt(), GetConVar("amethyst_m_secondarycolor_alpha"):GetInt()) or Color( 68, 114, 71, 255 ) )
        draw.SimpleText(Amethyst.Language["statistics"] or "Statistics", "Amethyst.Font.SidePlayerName", w / 2, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self.DPanel_LeftTop_Spacer_2 = vgui.Create("DPanel", Amethyst.Init)
    self.DPanel_LeftTop_Spacer_2:Dock(TOP)
    self.DPanel_LeftTop_Spacer_2:SetTall(2)
    self.DPanel_LeftTop_Spacer_2.Paint = function(self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 129, 60, 89, 15 ) )
    end

    local function CreateBlock( blockName, blockType, blockMax, blockIcon )

        local CalcProg = 0

        self.DPanel_BlockContainer = vgui.Create("DPanel", Amethyst.Init)
        self.DPanel_BlockContainer:Dock(TOP)
        self.DPanel_BlockContainer:DockMargin(0, 0, 0, 1)
        self.DPanel_BlockContainer:SetTall(20)
        self.DPanel_BlockContainer.Paint = function(self, w, h) end

        self.DPanel_BlockProgress = self.DPanel_BlockContainer:Add("DPanel")
        self.DPanel_BlockProgress:SetSize(10, 20)
        self.DPanel_BlockProgress:DockMargin(0, 0, 0, 0)
        self.DPanel_BlockProgress:Dock(TOP)
        self.DPanel_BlockProgress.Paint = function(self, w, h)

            local getBlockColor
            if blockType == "health" then
                getBlockColor = Color(GetConVar("amethyst_m_stats_hcolor_red"):GetInt(), GetConVar("amethyst_m_stats_hcolor_green"):GetInt(), GetConVar("amethyst_m_stats_hcolor_blue"):GetInt(), GetConVar("amethyst_m_stats_hcolor_alpha"):GetInt())
            elseif blockType == "armor" then
                getBlockColor = Color(GetConVar("amethyst_m_stats_acolor_red"):GetInt(), GetConVar("amethyst_m_stats_acolor_green"):GetInt(), GetConVar("amethyst_m_stats_acolor_blue"):GetInt(), GetConVar("amethyst_m_stats_acolor_alpha"):GetInt())
            elseif blockType == "hunger" then
                getBlockColor = Color(GetConVar("amethyst_m_stats_hungercolor_red"):GetInt(), GetConVar("amethyst_m_stats_hungercolor_green"):GetInt(), GetConVar("amethyst_m_stats_hungercolor_blue"):GetInt(), GetConVar("amethyst_m_stats_hungercolor_alpha"):GetInt())
            elseif blockType == "stamina" then
                getBlockColor = Color(GetConVar("amethyst_m_stats_scolor_red"):GetInt(), GetConVar("amethyst_m_stats_scolor_green"):GetInt(), GetConVar("amethyst_m_stats_scolor_blue"):GetInt(), GetConVar("amethyst_m_stats_scolor_alpha"):GetInt())
            elseif blockType == "xp" and (DARKRP_LVL_SYSTEM or LevelSystemConfiguration) then
                getBlockColor = Color(GetConVar("amethyst_m_stats_xpcolor_red"):GetInt(), GetConVar("amethyst_m_stats_xpcolor_green"):GetInt(), GetConVar("amethyst_m_stats_xpcolor_blue"):GetInt(), GetConVar("amethyst_m_stats_xpcolor_alpha"):GetInt())
            else
                getBlockColor = Color(255, 255, 255, 255)
            end

            surface.SetDrawColor(getBlockColor)
            surface.DrawRect(0, 0, w * ( math.Clamp( CalcProg or 0, 0, 1) ), h)

            surface.SetDrawColor(Color(10,10,10,66))
            surface.DrawRect(0, 10, w * ( math.Clamp( CalcProg or 0, 0, 1 ) ), h)
        end
        self.DPanel_BlockProgress.Think = function()

            if not IsValid(LocalPlayer()) then return end

            local getBlockData
                if blockType == "health" then getBlockData = LocalPlayer():Health() + 1 or 0
                elseif blockType == "armor" then getBlockData = LocalPlayer():Armor() or 0
                elseif blockType == "hunger" then getBlockData = math.Round(LocalPlayer():getDarkRPVar( "Energy" ) or 0)
                elseif blockType == "stamina" then getBlockData = LocalPlayer():getDarkRPVar("Stamina") or LocalPlayer():getDarkRPVar("stamina") or LocalPlayer():GetNWInt("tcb_Stamina") or LocalPlayer():GetNWFloat("stamina",0) or 0
                elseif blockType == "xp" and (DARKRP_LVL_SYSTEM or LevelSystemConfiguration) then
                    local playerLevel = LocalPlayer():getDarkRPVar('level') or LocalPlayer():getDarkRPVar('lvl') or 0
                    local playerXP = LocalPlayer():getDarkRPVar('xp') or 0
                    local expFormat = 0
                    local calcXP = 0
                    if LevelSystemConfiguration then
                        local xpPercent = ( ( playerXP or 0 ) / ( ( ( 10 + ( ( ( playerLevel or 1 ) * ( ( playerLevel or 1 ) + 1 ) * 90 ) ) ) ) * LevelSystemConfiguration.XPMult or 1.0 ) ) or 0
                        calcXP = xpPercent * 100 or 0
                        calcXP = math.Round(calcXP) or 0
                        expFormat = math.Clamp(calcXP, 0, 99)
                        getBlockData = expFormat or 0
                    elseif DARKRP_LVL_SYSTEM then
                        local formatPlayerlevel = DARKRP_LVL_SYSTEM["XP"][tonumber(playerLevel)]
                        if not formatPlayerlevel then return end
                        playerXP = math.floor(playerXP) or 0
                        calcXP = (playerXP*100/formatPlayerlevel) or 0
                        expFormat = math.floor(calcXP) or 0
                        getBlockData = expFormat or 0
                    end
                else getBlockData = "0"
            end

            local prog = (getBlockData / blockMax) or 0
            CalcProg = Lerp(FrameTime()*3, CalcProg or 0, prog or 0)

        end

        self.DLabel_BlockLeft = vgui.Create("DLabel", self.DPanel_BlockProgress)
        self.DLabel_BlockLeft:Dock(LEFT)
        self.DLabel_BlockLeft:DockMargin(6,0,0,0)
        self.DLabel_BlockLeft:SetWide(250)
        self.DLabel_BlockLeft:SetFont("Amethyst.Font.PlayerInfo")
        self.DLabel_BlockLeft:SetText("")
        self.DLabel_BlockLeft.Paint = function(self, w, h)
            if GetConVar("amethyst_m_stabs_text_type"):GetString() == "icons" then
                local ImageBlock = Material(blockIcon, "noclamp smooth")
                surface.SetDrawColor( Color(GetConVar("amethyst_m_iconcolor_red"):GetInt(), GetConVar("amethyst_m_iconcolor_green"):GetInt(), GetConVar("amethyst_m_iconcolor_blue"):GetInt(), GetConVar("amethyst_m_iconcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
                surface.SetMaterial(ImageBlock)
                surface.DrawTexturedRect(1, 4, 12, 12)
            else
                draw.SimpleText( blockName, "Amethyst.Font.PlayerInfo", 0, h / 2, Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            end
        end

        local LabelBlockNameR = vgui.Create("DLabel", self.DPanel_BlockProgress)
        LabelBlockNameR:Dock(RIGHT)
        LabelBlockNameR:DockMargin(0,0,5,0)
        LabelBlockNameR:SetWide(75)
        LabelBlockNameR:SetFont("Amethyst.Font.PlayerInfo")
        LabelBlockNameR:SetTextColor( Color(GetConVar("amethyst_m_tcolor_red"):GetInt(), GetConVar("amethyst_m_tcolor_green"):GetInt(), GetConVar("amethyst_m_tcolor_blue"):GetInt(), GetConVar("amethyst_m_tcolor_alpha"):GetInt()) or Color( 255, 255, 255, 255 ) )
        LabelBlockNameR:SetText("")
        LabelBlockNameR:SetContentAlignment(6)
        LabelBlockNameR.Paint = function(what, w, h)
            local getBlockData
            if blockType == "money" then getBlockData = DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")) or 0
                elseif blockType == "salary" then getBlockData = DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary")) .. " / hr"
                elseif blockType == "health" then getBlockData = LocalPlayer():Health()
                elseif blockType == "armor" then getBlockData = LocalPlayer():Armor()
                elseif blockType == "hunger" then getBlockData = math.Round(LocalPlayer():getDarkRPVar( "Energy" ) or 0)
                elseif blockType == "stamina" then getBlockData = LocalPlayer():getDarkRPVar("Stamina") or LocalPlayer():getDarkRPVar("stamina") or LocalPlayer():GetNWInt("tcb_Stamina") or LocalPlayer():GetNWFloat("stamina",0)
                elseif blockType == "xp" and (DARKRP_LVL_SYSTEM or LevelSystemConfiguration) then
                    local playerLevel = LocalPlayer():getDarkRPVar('level') or LocalPlayer():getDarkRPVar('lvl') or 0
                    local playerXP = LocalPlayer():getDarkRPVar('xp') or 0
                    local expFormat = 0
                    local calcXP = 0
                    if LevelSystemConfiguration then
                        local xpPercent = ( ( playerXP or 0 ) / ( ( ( 10 + ( ( ( playerLevel or 1 ) * ( ( playerLevel or 1 ) + 1 ) * 90 ) ) ) ) * LevelSystemConfiguration.XPMult or 1.0 ) )
                        calcXP = xpPercent * 100
                        calcXP = math.Round(calcXP)
                        expFormat = math.Clamp(calcXP, 0, 99)
                        getBlockData = expFormat
                    elseif DARKRP_LVL_SYSTEM then
                        local formatPlayerlevel = DARKRP_LVL_SYSTEM["XP"][tonumber(playerLevel)]
                        if not formatPlayerlevel then return end
                        playerXP = math.floor( playerXP )
                        calcXP = ( playerXP * 100 / formatPlayerlevel ) or 0
                        expFormat = math.floor(calcXP)
                        getBlockData = expFormat
                    end
                else getBlockData = "0"
            end
            if ( GetConVar("amethyst_m_stabs_text_statsenabled"):GetInt() == 1 ) then
                if blockType == "xp" and ( LevelSystemConfiguration or DARKRP_LVL_SYSTEM ) then
                    local XPAddition = LocalPlayer():getDarkRPVar("level") or LocalPlayer():getDarkRPVar("lvl")
                    LabelBlockNameR:SetText("LVL ".. XPAddition ..  " | " .. getBlockData .. "%" or "Error")
                else
                    LabelBlockNameR:SetText(getBlockData or "Error")
                end
            else
                LabelBlockNameR:SetText("")
            end
        end

        return self.DPanel_BlockContainer

    end

    for k, v in pairs( Amethyst.Settings.Datablocks ) do
        if not v.enabled then continue end
        local ItemHealth = CreateBlock(v.blockName, v.blockType, v.blockMax, v.blockIcon)
    end

end
vgui.Register("Amethyst_STab_Home", PANEL, "DPanel")

/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/