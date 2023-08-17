include("shared.lua")

-- Define GM12 fonts for compatibility
surface.CreateFont("DefaultBold", {font = "Tahoma",
                                   size = 13,
                                   weight = 1000})
surface.CreateFont("TabLarge",    {font = "Tahoma",
                                   size = 13,
                                   weight = 700,
                                   shadow = true, antialias = false})
surface.CreateFont("Trebuchet22", {font = "Trebuchet MS",
                                   size = 22,
                                   weight = 900})

include("scoring_shd.lua")
include("corpse_shd.lua")
include("player_ext_shd.lua")
include("weaponry_shd.lua")

include("vgui/ColoredBox.lua")
include("vgui/SimpleIcon.lua")
include("vgui/ProgressBar.lua")
include("vgui/ScrollLabel.lua")

include("cl_radio.lua")
include("cl_disguise.lua")
include("cl_transfer.lua")
include("cl_targetid.lua")
include("cl_search.lua")
include("cl_radar.lua")
include("cl_tbuttons.lua")
include("cl_scoreboard.lua")
include("cl_tips.lua")
include("cl_help.lua")
include("cl_hud.lua")
include("cl_msgstack.lua")
include("cl_hudpickup.lua")
include("cl_keys.lua")
include("cl_wepswitch.lua")
include("cl_scoring.lua")
include("cl_scoring_events.lua")
include("cl_popups.lua")
include("cl_equip.lua")
include("cl_voice.lua")

function GM:Initialize()
   MsgN("TTT Client initializing...")

   GAMEMODE.round_state = ROUND_WAIT

   LANG.Init()

   self.BaseClass:Initialize()
end

function GM:InitPostEntity()
   MsgN("TTT Client post-init...")

   net.Start("TTT_Spectate")
     net.WriteBool(GetConVar("ttt_spectator_mode"):GetBool())
   net.SendToServer()

   if not game.SinglePlayer() then
      timer.Create("idlecheck", 5, 0, CheckIdle)
   end

   -- make sure player class extensions are loaded up, and then do some
   -- initialization on them
   if IsValid(LocalPlayer()) and LocalPlayer().GetTraitor then
      GAMEMODE:ClearClientState()
   end

   timer.Create("cache_ents", 1, 0, GAMEMODE.DoCacheEnts)

   RunConsoleCommand("_ttt_request_serverlang")
   RunConsoleCommand("_ttt_request_rolelist")
end

function GM:DoCacheEnts()
   RADAR:CacheEnts()
   TBHUD:CacheEnts()
end

function GM:HUDClear()
   RADAR:Clear()
   TBHUD:Clear()
end

KARMA = {}
function KARMA.IsEnabled() return GetGlobalBool("ttt_karma", false) end

function GetRoundState() return GAMEMODE.round_state end

local function RoundStateChange(o, n)
   if n == ROUND_PREP then
      -- prep starts
      GAMEMODE:ClearClientState()
      GAMEMODE:CleanUpMap()

      -- show warning to spec mode players
      if GetConVar("ttt_spectator_mode"):GetBool() and IsValid(LocalPlayer())then
         LANG.Msg("spec_mode_warning")
      end

      -- reset cached server language in case it has changed
      RunConsoleCommand("_ttt_request_serverlang")
   elseif n == ROUND_ACTIVE then
      -- round starts
      VOICE.CycleMuteState(MUTE_NONE)

      CLSCORE:ClearPanel()

      -- people may have died and been searched during prep
      for _, p in ipairs(player.GetAll()) do
         p.search_result = nil
      end

      -- clear blood decals produced during prep
      RunConsoleCommand("r_cleardecals")

      GAMEMODE.StartingPlayers = #util.GetAlivePlayers()
   elseif n == ROUND_POST then
      RunConsoleCommand("ttt_cl_traitorpopup_close")
   end

   -- stricter checks when we're talking about hooks, because this function may
   -- be called with for example o = WAIT and n = POST, for newly connecting
   -- players, which hooking code may not expect
   if n == ROUND_PREP then
      -- can enter PREP from any phase due to ttt_roundrestart
      hook.Call("TTTPrepareRound", GAMEMODE)
   elseif (o == ROUND_PREP) and (n == ROUND_ACTIVE) then
      hook.Call("TTTBeginRound", GAMEMODE)
   elseif (o == ROUND_ACTIVE) and (n == ROUND_POST) then
      hook.Call("TTTEndRound", GAMEMODE)
   end

   -- whatever round state we get, clear out the voice flags
   for k,v in ipairs(player.GetAll()) do
      v.traitor_gvoice = false
   end
end

concommand.Add("ttt_print_playercount", function() print(GAMEMODE.StartingPlayers) end)

--- optional sound cues on round start and end
CreateConVar("ttt_cl_soundcues", "0", FCVAR_ARCHIVE)

local cues = {
   Sound("ttt/thump01e.mp3"),
   Sound("ttt/thump02e.mp3")
};
local function PlaySoundCue()
   if GetConVar("ttt_cl_soundcues"):GetBool() then
      surface.PlaySound(table.Random(cues))
   end
end

GM.TTTBeginRound = PlaySoundCue
GM.TTTEndRound = PlaySoundCue

--- usermessages

local function ReceiveRole()
   local client = LocalPlayer()
   local role = net.ReadUInt(2)

   -- after a mapswitch, server might have sent us this before we are even done
   -- loading our code
   if not client.SetRole then return end

   client:SetRole(role)

   Msg("You are: ")
   if client:IsTraitor() then MsgN("TRAITOR")
   elseif client:IsDetective() then MsgN("DETECTIVE")
   else MsgN("INNOCENT") end
end
net.Receive("TTT_Role", ReceiveRole)

local function ReceiveRoleList()
   local role = net.ReadUInt(2)
   local num_ids = net.ReadUInt(8)

   for i=1, num_ids do
      local eidx = net.ReadUInt(7) + 1 -- we - 1 worldspawn=0

      local ply = player.GetByID(eidx)
      if IsValid(ply) and ply.SetRole then
         ply:SetRole(role)

         if ply:IsTraitor() then
            ply.traitor_gvoice = false -- assume traitorchat by default
         end
      end
   end
end
net.Receive("TTT_RoleList", ReceiveRoleList)

-- Round state comm
local function ReceiveRoundState()
   local o = GetRoundState()
   GAMEMODE.round_state = net.ReadUInt(3)

   if o != GAMEMODE.round_state then
      RoundStateChange(o, GAMEMODE.round_state)
   end

   MsgN("Round state: " .. GAMEMODE.round_state)
end
net.Receive("TTT_RoundState", ReceiveRoundState)

-- Cleanup at start of new round
function GM:ClearClientState()
   GAMEMODE:HUDClear()

   local client = LocalPlayer()
   if not client.SetRole then return end -- code not loaded yet

   client:SetRole(ROLE_INNOCENT)

   client.equipment_items = EQUIP_NONE
   client.equipment_credits = 0
   client.bought = {}
   client.last_id = nil
   client.radio = nil
   client.called_corpses = {}

   VOICE.InitBattery()

   for _, p in ipairs(player.GetAll()) do
      if IsValid(p) then
         p.sb_tag = nil
         p:SetRole(ROLE_INNOCENT)
         p.search_result = nil
      end
   end

   VOICE.CycleMuteState(MUTE_NONE)
   RunConsoleCommand("ttt_mute_team_check", "0")

   if GAMEMODE.ForcedMouse then
      gui.EnableScreenClicker(false)
   end
end
net.Receive("TTT_ClearClientState", GM.ClearClientState)

function GM:CleanUpMap()
   -- Ragdolls sometimes stay around on clients. Deleting them can create issues
   -- so all we can do is try to hide them.
   for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do
      if IsValid(ent) and CORPSE.GetPlayerNick(ent, "") != "" then
         ent:SetNoDraw(true)
         ent:SetSolid(SOLID_NONE)
         ent:SetColor(Color(0,0,0,0))

         -- Horrible hack to make targetid ignore this ent, because we can't
         -- modify the collision group clientside.
         ent.NoTarget = true
      end
   end

   -- This cleans up decals since GMod v100
   game.CleanUpMap()
end

-- server tells us to call this when our LocalPlayer has spawned
local function PlayerSpawn()
   local as_spec = net.ReadBit() == 1
   if as_spec then
      TIPS.Show()
   else
      TIPS.Hide()
   end
end
net.Receive("TTT_PlayerSpawned", PlayerSpawn)

local function PlayerDeath()
   TIPS.Show()
end
net.Receive("TTT_PlayerDied", PlayerDeath)

function GM:ShouldDrawLocalPlayer(ply) return false end

local view = {origin = vector_origin, angles = angle_zero, fov=0}
function GM:CalcView( ply, origin, angles, fov )
   view.origin = origin
   view.angles = angles
   view.fov    = fov

   -- first person ragdolling
   if ply:Team() == TEAM_SPEC and ply:GetObserverMode() == OBS_MODE_IN_EYE then
      local tgt = ply:GetObserverTarget()
      if IsValid(tgt) and (not tgt:IsPlayer()) then
         -- assume if we are in_eye and not speccing a player, we spec a ragdoll
         local eyes = tgt:LookupAttachment("eyes") or 0
         eyes = tgt:GetAttachment(eyes)
         if eyes then
            view.origin = eyes.Pos
            view.angles = eyes.Ang
         end
      end
   end


   local wep = ply:GetActiveWeapon()
   if IsValid(wep) then
      local func = wep.CalcView
      if func then
         view.origin, view.angles, view.fov = func( wep, ply, origin*1, angles*1, fov )
      end
   end

   return view
end

function GM:AddDeathNotice() end
function GM:DrawDeathNotice() end

function GM:Tick()
   local client = LocalPlayer()
   if IsValid(client) then
      if client:Alive() and client:Team() != TEAM_SPEC then
         WSWITCH:Think()
         RADIO:StoreTarget()
      end

      VOICE.Tick()
   end
end


-- Simple client-based idle checking
local idle = {ang = nil, pos = nil, mx = 0, my = 0, t = 0}
function CheckIdle()
   local client = LocalPlayer()
   if not IsValid(client) then return end

   if not idle.ang or not idle.pos then
      -- init things
      idle.ang = client:GetAngles()
      idle.pos = client:GetPos()
      idle.mx = gui.MouseX()
      idle.my = gui.MouseY()
      idle.t = CurTime()

      return
   end

   if GetRoundState() == ROUND_ACTIVE and client:IsTerror() and client:Alive() then
      local idle_limit = GetGlobalInt("ttt_idle_limit", 300) or 300
      if idle_limit <= 0 then idle_limit = 300 end -- networking sucks sometimes


      if client:GetAngles() != idle.ang then
         -- Normal players will move their viewing angles all the time
         idle.ang = client:GetAngles()
         idle.t = CurTime()
      elseif gui.MouseX() != idle.mx or gui.MouseY() != idle.my then
         -- Players in eg. the Help will move their mouse occasionally
         idle.mx = gui.MouseX()
         idle.my = gui.MouseY()
         idle.t = CurTime()
      elseif client:GetPos():Distance(idle.pos) > 10 then
         -- Even if players don't move their mouse, they might still walk
         idle.pos = client:GetPos()
         idle.t = CurTime()
      elseif CurTime() > (idle.t + idle_limit) then
         RunConsoleCommand("say", "(AUTOMATED MESSAGE) I have been moved to the Spectator team because I was idle/AFK.")

         timer.Simple(0.3, function()
                              RunConsoleCommand("ttt_spectator_mode", 1)
                               net.Start("TTT_Spectate")
                                 net.WriteBool(true)
                               net.SendToServer()
                              RunConsoleCommand("ttt_cl_idlepopup")
                           end)
      elseif CurTime() > (idle.t + (idle_limit / 2)) then
         -- will repeat
         LANG.Msg("idle_warning")
      end
   end
end

function GM:OnEntityCreated(ent)
   -- Make ragdolls look like the player that has died
   if ent:IsRagdoll() then
      local ply = CORPSE.GetPlayer(ent)

      if IsValid(ply) then
         -- Only copy any decals if this ragdoll was recently created
         if ent:GetCreationTime() > CurTime() - 1 then
            ent:SnatchModelInstance(ply)
         end

         -- Copy the color for the PlayerColor matproxy
         local playerColor = ply:GetPlayerColor()
         ent.GetPlayerColor = function()
            return playerColor
         end
      end
   end

   return self.BaseClass.OnEntityCreated(self, ent)
end


local pos = math.random(40, - 70)

hook.Add("HUDPaint", "damageShowing", function ()
   if LocalPlayer():GetNWInt("DamageDealedToPlayer") > 0 then
      draw.SimpleTextOutlined(LocalPlayer():GetNWInt("DamageDealedToPlayer"),"ButtonFont",ScrW()/2 - pos,ScrH()/2 - pos,Color(255,0,0,255),1,0,1,Color(0,0,0,255))
   end
end)



-- timer.Create("cleanitUP", 1, 0, function ()
   -- if LocalPlayer().CleanUPTimer and LocalPlayer().CleanUPTimer < SysTime() then
      -- LocalPlayer().DamageDealed = 0
      -- pos = math.random(40, -70)
   -- end
-- end)

local color_and_shit = {
   [1] = {
      color = Color(255,0,0),
      name = "Предатель",
   },
   [2] = {
      color = Color(0,0,255),
      name = "Детектив",
   },
   [0] = {
      color = Color(0,255,0),
      name = "Невиновный"
   }
}


net.Receive("TTTMessages.PrintWhoKilldYou", function ()
   local role = net.ReadString()
   local ply = net.ReadEntity()

   print (role, ply)

   chat.AddText(Color(102, 255, 51), "[Смерть Инфо]", Color(255, 255, 255),
    " Вы были убиты : ", color_and_shit[tonumber(role)].color, ply:Nick(), " (", color_and_shit[tonumber(role)].name, ")")
end)


local last_sound = CurTime()
net.Receive("chatSound.Play", function ()
   if tobool(GetConVarNumber("ttt_mute_chatsounds")) == true then return end
   local str = net.ReadString()
   local target = net.ReadEntity()
   if not target:Alive() then return end
   if str and last_sound < CurTime() then
      sound.PlayURL(str, "", function (st) if IsValid(st) then st:Play() end end)
      last_sound = CurTime() + 1.5
   end
end)


// Maybe later?
-- hook.Add("TTTPrepareRound", "musicRicardo", function ()
--    local DrawText = ""
--    if PowerRounds.RoundsLeft == 0 then
--       DrawText = PowerRounds.NextTextCurrent
--    elseif PowerRounds.RoundsLeft == 1 then
--       DrawText = string.gsub(PowerRounds.NextTextOne, "{Num}", PowerRounds.RoundsLeft)
--    elseif PowerRounds.RoundsLeft == -1 then
--       DrawText = PowerRounds.NextTextForced
--    else
--       DrawText = string.gsub(PowerRounds.NextTextMultiple, "{Num}", PowerRounds.RoundsLeft)
--    end
--    chat.AddText(Color(102, 255, 51), "[Специальные раунды] ", Color(255, 255, 255), DrawText)
-- end)

surface.CreateFont("ButtonFont", {font = "Trebuchet24",
                               size = 22,
                               weight = 1000,
                               shadow = true})



local function charWrap(text, pxWidth)
    local total = 0

    text = text:gsub(".", function(char)
        total = total + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if total >= pxWidth then
            total = 0
            return "\n" .. char
        end

        return char
    end)

    return text, total
end

function textWrap(text, font, pxWidth)
    local total = 0

    surface.SetFont(font)

    local spaceSize = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                total = 0
            end

            local wordlen = surface.GetTextSize(word)
            total = total + wordlen


            -- Wrap around when the max width is reached
            if wordlen >= pxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, pxWidth)
                total = splitPoint
                return splitWord
            elseif total < pxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                total = wordlen - spaceSize
                return '\n' .. string.sub(word, 2)
            end

            total = wordlen
            return '\n' .. word
        end)

    return text
end


net.Receive("DonatModels.Synth", function ()
   local db = net.ReadTable()
   LocalPlayer().DonatModels = db

end)


local zapret = {
   "RDM (Random kill) - убийство игрока без всяких на то оснований, исключительно основываясь на подозрении без веских доказательств или по личным причинам.",
   "Prop-push (толкание игроков пропами) и Propkill (убийство с помощью пропов или взрывающихся бочек) считаются разновидностью RDM .",
   "Запрещено убийство АФК. Кроме того, убийство АФК является Предательским действием.",
   "Запрещено стрелять в воздух или рядом с игроками с целью привлечения или опознания предателей.",
   "Запрещено блокировать проход в помещения другим игрокам.",
   "Запрещена месть в любых ее проявлениях.",
   "Играя предателем, запрещено убивать членов своей команды, как просто так, так и с целью соблюсти конспирацию (Teamkill). Однако Teamkillом не считается убийство Растяжкой/С4, если убитый Предатель был в курсе о том, что вы собираетесь их установить.",
   "Предателю запрещено сидеть в Т-комнате дольше 3 минут.",
   "Запрещено использовать читы или эксплоиты (баги в картах).",
   "Запрещено выдавать себя за администратора.",
   "Запрещено выходить с сервера с целью избежать наказания, или обойти уже наложенное. (слей, мут, гаг).",
   "Запрещен спам звуками из таба.",
   "Запрещен спам озвучиваемого текста и так называемый троллинг в виде: бубубубу, я@ты@я@ и так далее.",
   "Запрещено использовать голосовой чат, если вам не исполнилось 16 лет. Исключения могут быть предприняты, если ваш голос не раздражает других игроков (т.е. если он не писклявый по мнению большинства) - это решается путем голосования.",
   "Запрещено использовать голосовой чат для каких -либо иных целей, кроме общения (включение песен и тому подобное).",
   "Запрещено оскорблять администрацию/проявлять к ней неуважительное отношение.",
   "Запрещено кричать в голосовой чат.",
   "Запрещено использовать матерные выражения. - Слово Мудак тоже под запретом.",
   "Запрещен спамы, флуд.",
   "Запрещено использовать чат с целью рекламы любого рода.",
   "Запрещено использовать сторонние программы (Skype, Discord, RK, TeamSpeak, чат Steam и т.д) для общения с другими игроками Skype,RK,TeamSpeak и т.д). с целью передачи внутриигровой информации (личности и местонахождение предателей, других игроков, оборудования и т.д.).",
   ""

}

local info = {
   "Если вы собираетесь обезвредить C4 , то следует объявить об этом, так чтобы игроки не подумали, что вы его закладываете.",
   "Стрельба в кого - либо случайно или 'по приколу' считается Предательским действием.",
   "Выталкивание игроков с выступов с использованием отталкивающих гранат с целью подтолкнуть кого-то с уступа является Предательским действием.",
   "Уничтожение оборудования детектива является Предательским действием, кроме случаев, когда на это дано разрешение детектива, которому оно принадлежит. Кража оборудования также является предательским действием.",
   "Метание зажигательных гранат в человека/толпу является Предательским действием.",
   "Метание отталкивающих гранат, повлекшее гибель или урон игроков, является Предательским действием.",
   "Cамосуд по методу 'RDM за RDM' запрещен, вне зависимости от того, есть на сервере администрация или нет.",
   "Уничтожения тестера на карте 67th_way является Предательским действием. Вы вправе убить игрока, который разрушил тестер, но только если у вас есть прямые доказательства его причастности. Если тестер был разрушен перед началом раунда (во время подготовки), то вы не имеете права убить игрока, который его разрушил.",
   "Только детектив имеет право приказать кому - либо пройти проверку, если вы откажетесь детектив может вас убить. ",
   "Не пытайтесь ТРЕБОВАТЬ что-либо от администрации. Добром для вас это не кончится.",
   "Если вы просите вынести наказание какому - либо игроку, то вы должны иметь на то внятную причину и быть в состоянии адекватно ее объяснить.",
   "Отправляя жалобу на RDM, вы должны описать ситуацию, в которой произошло данное нарушение (т.е. кто, когда и при каких обстоятельствах совершил RDM). Пустые жалобы не рассматриваются.",
   "Приветствуется фиксация правонарушений посредством скриншотов, видеозаписей, особенно в отсутствие на сервере администрации.",
   "Вы можете оставить жалобу на игроков и администрацию в дискорд сервере DamnTTT, согласно указанным там правилам размещения жалоб.",
   "Администратор вправе потребовать объяснение в каком - либо вашем действии.",
   "Администратору запрещается угрожать игрокам без причины.",
   "Администратор обязан наказывать игроков сообразно серьезности их нарушений, основываясь на данных правилах, здравом смысле и логике, а не на личных побуждениях, желаниях, отношениях с другими игроками.",
   "Администратор может начать на сервере фан, но только с одобрения большей части игроков.",
   "Когда детектив отдаёт какой либо приказ, он обязан давать отсчёт в 5 секунд, если за 5 секунд человек не слушается приказа дека - его можно посчитать предателем.",
   "Prop Surf - Запрещено с помощью пропов летать и взбираться куда либо"
}



net.Receive("OpenRulesMenu", function ()

   local main_frame = vgui.Create("CRFrame")
   main_frame:SetSize(ScrW(),600)
   main_frame:Center()
   main_frame:SetTitle("Правила")
   main_frame:MakePopup()


   local zapret_button = vgui.Create("CRButton", main_frame)
   zapret_button:Dock(TOP)
   zapret_button:SetText("Запреты")
   zapret_button:DockMargin(0, 0, main_frame:GetWide()/2, 0)
   zapret_button:SetImage("icon16/cross.png")

   local info_button = vgui.Create("CRButton", main_frame)
   info_button:Dock(TOP)
   info_button:SetText("Общая информация")
   info_button:DockMargin(main_frame:GetWide()/2, -22, 0, 0)
   info_button:SetImage("icon16/information.png")

   local panel_info = vgui.Create("DScrollPanel", main_frame)
   panel_info:Dock(TOP)
   panel_info:DockMargin(main_frame:GetWide()/2, 0, 0, 0)
   panel_info:SetTall(main_frame:GetTall() - 60)


   local panel_zapret = vgui.Create("DScrollPanel", main_frame)
   panel_zapret:Dock(TOP)
   panel_zapret:DockMargin(0,-540, main_frame:GetWide()/2, 0)
   panel_zapret:SetTall(main_frame:GetTall() - 60)
   

   -- -- local panel_info = vgui.Create("DPanel", main_frame)
   -- -- panel_info:Dock(FILL)
   
   for _, info_zapret in pairs (zapret) do
      local but = vgui.Create("DButton", panel_zapret)
      but:Dock(TOP)
      -- but:SetDisabled(true)
      -- but:SetImage("icon16/cross.png")
      -- but:MakeCustomText(info_zapret, "default")
      but:SetText(textWrap(info_zapret, "ui.20", 900))
      -- but:SetText("")
      -- but:SetFont("ui.20")
      but:SizeToContents()
      but:SetColor(Color(255,255,255))
      -- but:SetTall(30)
      but:DockMargin( 0, 0, 0, 5 )

      but.Paint = function (self, w, h)
      -- if self:IsHovered() then
         draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
      -- else
         -- draw.RoundedBox(0, 0, 0, w, h, Color(80,12,216))
      -- end

         surface.SetDrawColor(Color(0,0,0,255))
         surface.DrawOutlinedRect( 0, 0, w, h )


         -- draw.SimpleTextOutlined(textWrap(info_zapret, "ui.20", 650), "ui.20", 0, 10, Color( 255, 255, 255, 255 ), 0, 1, 1, Color(0,0,0,255))
      end
   end


   for _, info in pairs (info) do
      local but = vgui.Create("DButton", panel_info)
      but:Dock(TOP)
      -- but:SetDisabled(true)
      -- but:SetImage("icon16/information.png")
      -- but:MakeCustomText(info_zapret, "default")
      but:SetText(textWrap(info, "ui.20", 900))
      but:SizeToContents()
      but:SetColor(Color(255,255,255))
      but:DockMargin( 0, 0, 0, 5 )

       but.Paint = function (self, w, h)
         draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))

         surface.SetDrawColor(Color(0,0,0,255))
         surface.DrawOutlinedRect( 0, 0, w, h )

      end
   end


end)

net.Receive("DonatModels.OpenMenu", function ()
   local main = vgui.Create("CRFrame")
   main:SetSize(1000,600)
   main:ShowCloseButton(true)
   main:Center()
   main:SetTitle("Донат модели")
   main:MakePopup()

   if LocalPlayer().DonatModels then
      for _, models in pairs (LocalPlayer().DonatModels) do

         local panel = vgui.Create("DPanel", main)
         panel:SetSize(100,0)
         panel:Dock(LEFT)

         local d_models = vgui.Create("SpawnIcon", panel)
         d_models:SetSize(900,0)
         d_models:Dock(FILL)
         d_models:SetModel(models)


         d_models.DoClick = function ()

            RunConsoleCommand("set_my_model", models)
            main:Remove()
         end

      end
      local d_models = vgui.Create("DModelPanel", main)
      d_models:Dock(FILL)
   else
      local idi_naxoy = vgui.Create("DLabel", main)
      idi_naxoy:SetFont("Trebuchet24")
      idi_naxoy:SetText("У вас нет купленных моделей =(")
      idi_naxoy:SizeToContents()
      idi_naxoy:SetPos(main:GetWide()/3, main:GetTall()/2)
   end

end)



// Prefix Shit

net.Receive("ttt.OpenPrefixAdminMenu", function ()
   local prefix_table = net.ReadTable()
   local menu_prefix = vgui.Create("CRFrame")
   menu_prefix:SetSize(500,600)
   menu_prefix:Center()
   menu_prefix:ShowCloseButton(true)
   menu_prefix:MakePopup()
   menu_prefix:SetTitle("Menu prefix")



   local list_of_prefix = vgui.Create("DListView", menu_prefix)
   list_of_prefix:Dock(FILL)
   list_of_prefix:AddColumn("Ник или группа")
   list_of_prefix:AddColumn("Префикс")
   list_of_prefix:AddColumn("Цвет")
   list_of_prefix:SetMultiSelect( false )


   for _, v in pairs (prefix_table) do
      if v.type == "1" then
         list_of_prefix:AddLine(v.S64, v.prefix_name, v.prefix_color, v.type)
      end

      if v.type == "0" then
         list_of_prefix:AddLine(v.prefix_group, v.prefix_name, v.prefix_color, v.type)
      end
   end

   local add_prefix = vgui.Create("CRButton", menu_prefix)
   add_prefix:Dock(BOTTOM)
   add_prefix:SetText("Добавить префикс группе или игроку")
   add_prefix.DoClick = function ()
      menu_prefix:Remove()
      local add_frame = vgui.Create("CRFrame")
      add_frame:SetSize(300,400)
      add_frame:Center()
      add_frame:ShowCloseButton(true)
      add_frame:MakePopup()

      local d_string = vgui.Create("DTextEntry", add_frame)
      d_string:Dock(TOP)
      d_string:SetValue("СТИМ ИД")


      local d_groups = vgui.Create("DComboBox", add_frame)
      d_groups:Dock(TOP)
      d_groups:SetValue( "Группы пользователей" )
      d_groups.OnSelect = function (_ , _, value)
         d_groups.choice = value
      end

      // Ками нам больше никогда ничего не скажет =()
      -- for k,v in pairs (CAMI.GetUsergroups()) do
         -- d_groups:AddChoice(k)
      -- end

      for k,_ in pairs (serverguard.ranks:GetStored()) do
         d_groups:AddChoice(k)
      end

      local d_prefix = vgui.Create("DTextEntry", add_frame)
      d_prefix:Dock(TOP)
      d_prefix:SetValue("ВВЕДИТЕ НАЗВАНИЕ ПРЕФИКСА")

      local Mixer = vgui.Create("DColorMixer", add_frame)
      Mixer:Dock(FILL)
      Mixer:SetPalette(true) 
      Mixer:SetAlphaBar(true)
      Mixer:SetWangs(true)
      Mixer:SetColor(Color(30,100,160))


      local group_prefix_button = vgui.Create("CRButton", add_frame)
      group_prefix_button:Dock(BOTTOM)
      group_prefix_button:SetText("Установить префикс по группе")


      group_prefix_button.DoClick = function ()
         if d_groups.choice then
            // Для всех тупых кто сюда полезет в надежде заабузить код
            // Я не такой тупой что-бы не проверять игрока на суперадмина.
            // Так что отсосите
            local color_table = Mixer:GetColor()
            add_frame:Remove()
            net.Start("ttt.AddNewGroupPrefix")
            net.WriteString(d_groups.choice)
            net.WriteString(d_prefix:GetValue())
            net.WriteColor(Color(color_table.r, color_table.g,color_table.b, 255))
            net.SendToServer()
         end
      end


      local steamid_prefix_button = vgui.Create("CRButton", add_frame)
      steamid_prefix_button:Dock(BOTTOM)
      steamid_prefix_button:SetText("Установить префикс по STEAMID")
      steamid_prefix_button.DoClick = function ()
         // Для всех тупых кто сюда полезет в надежде заабузить код
         // Я не такой тупой что-бы не проверять игрока на суперадмина.
         // Так что отсосите
         local color_table = Mixer:GetColor()
         add_frame:Remove()
         net.Start("ttt.AddNewSteamIDPrefix")
         net.WriteString(d_string:GetValue())
         net.WriteString(d_prefix:GetValue())
         net.WriteColor(Color(color_table.r, color_table.g,color_table.b, 255))
         net.SendToServer()
      end

   end

   list_of_prefix.OnRowSelected = function( panel, rowIndex, row )
      list_of_prefix.Chosen = row:GetValue(1)
      list_of_prefix.Type = row:GetValue(4)
   end
   
   local remove_prefix = vgui.Create("CRButton", menu_prefix)
   remove_prefix:Dock(BOTTOM)
   remove_prefix:SetText("Удалить префикс группе или игроку")


   remove_prefix.DoClick = function ()

      menu_prefix:Remove()
      net.Start("ttt.RemoveChatPrefix")
      net.WriteInt(list_of_prefix.Type, 3)
      net.WriteString(list_of_prefix.Chosen)
      net.SendToServer()

   end
end)


local pretty_print_cooldown = CurTime() + 1
net.Receive("ttt.PrettyPrintString", function ()
    if pretty_print_cooldown >= CurTime() then return end
    local str = net.ReadString()

    chat.AddText(Color(255, 0, 0), "[Информация] ", Color(255, 255, 255), str)
    pretty_print_cooldown = CurTime() + 1
end)


net.Receive("ttt.PrettyPrintAchivment", function ()
   local nick = net.ReadString()
   local str = net.ReadString()
   chat.AddText(Color(102, 255, 51), "[Достижения] ", Color(255, 255, 255), "Игрок ", Color(153, 204, 255), nick, Color(255,255,255), " выполнил достижение ", Color(204, 204, 0), str)
end)

net.Receive("OpenAchivkiMenu", function ()
   local achivka_menu = vgui.Create("CRFrame")
   achivka_menu:SetSize(900,900)
   achivka_menu:SetTitle("")
   achivka_menu:Center()
   achivka_menu:MakePopup()
   achivka_menu:ShowCloseButton(true)
   achivka_menu.Paint = function (self,w,h)
      draw.RoundedBox(0, 0, 0, w, h, Color(96, 96, 96, 250))
   end


   local dscroll_shit = vgui.Create("DScrollPanel",  achivka_menu)
   dscroll_shit:Dock(FILL)


   for k,v in pairs (achivki_table) do
      local button = vgui.Create("CRButton", dscroll_shit)
      button:Dock(TOP)
      button:SetTall(60)
      button:DockMargin(15, 15, 15, 0)
      button:SetText("")
      button:SetDisabled(true)


      local button_name = vgui.Create("DButton", button)
      button_name:Dock(LEFT)
      button_name:DockMargin(10, 10, 0, 10)
      button_name:SetSize(240,0)
      button_name:SetText("")
      button_name.Paint = function (self, w, h)
         draw.RoundedBox(0, 0, 0, w, h, Color(2, 155, 34, 150))
         
         surface.SetDrawColor(Color(0,0,0,255))
           surface.DrawOutlinedRect( 0, 0, w, h )
         
         draw.SimpleTextOutlined(k, "ui.20", 5, 5, Color(255,255,255,255), 0, 0, 1, Color(0,0,0))
      end

      local button_desc = vgui.Create("DButton", button)
      button_desc:Dock(LEFT)
      button_desc:DockMargin(10, 10, 0, 0)
      button_desc:SetSize(380,0)
      button_desc:SetText("")
      button_desc.Paint = function (self, w, h)
         draw.RoundedBox(0, 0, 0, w, 27, Color(23, 23, 255, 150))

         // Полоска достижения
         draw.RoundedBox(0, 0, 30, w, 15, Color(255, 255, 255, 255))
         draw.RoundedBox(0, 0, 30, LocalPlayer():GetNWInt(v.NW_To_Check) * (380/v.goal), 15, Color(255, 153, 0, 200))      

         draw.SimpleTextOutlined(LocalPlayer():GetNWInt(v.NW_To_Check).."/"..v.goal, "default", 170, 37, Color(255,255,255,255), 0, 1, 1, Color(0,0,0))

         surface.SetDrawColor(Color(0,0,0,255))
           surface.DrawOutlinedRect( 0, 0, w, 27 )

           surface.SetDrawColor(Color(0,0,0,255))
           surface.DrawOutlinedRect( 0, 30, w, 15 )
         
         draw.SimpleTextOutlined(v.desc, "ui.20", 10, 10, Color(255,255,255,255), 0, 1, 1, Color(0,0,0))
      end


      local button_ready = vgui.Create("DButton", button)
      button_ready:Dock(LEFT)
      button_ready:SetSize(180,0)
      button_ready:DockMargin(10, 10, 15, 10)
      button_ready:SetText("")
      button_ready.color_hover = Color(102, 102, 255)
      button_ready.Paint = function (self, w, h)
         draw.RoundedBox(0, 0, 0, w, h, self.color_hover)
         
         surface.SetDrawColor(Color(0,0,0,255))
           surface.DrawOutlinedRect( 0, 0, w, h )
         
         draw.SimpleTextOutlined("Выполнить", "DermaLarge", 20, 5, Color(255,255,255,255), 0, 0, 1, Color(0,0,0))
      end

      button_ready.OnCursorExited = function (da)
         button_ready.color_hover = Color(102, 102, 255)
      end

      button_ready.OnCursorEntered = function (da)
         button_ready.color_hover = Color(0, 0, 50,255)
      end


      button_ready.DoClick = function ()
         net.Start("ttt.AchivmentReadyToGo")
         net.WriteString(v.achiv_name)
         net.SendToServer()

      end
   end
end)

local prefix_table = {}

net.Receive("ttt.SynthPrefixTable", function ()
   local tbl = net.ReadTable()
   prefix_table = tbl or {}
end)




local prefix, color_pref
hook.Add("OnPlayerChat", "PrefixHookName", function (ply, text, teamChat, dead)
   if ply:IsValid() then
      for _, p in pairs (prefix_table) do
         if p.type == "1" and string.gsub(p.S64, " ", "") == ply:SteamID() then
            prefix = "["..p.prefix_name.. "] "
            color_pref = tostring(p.prefix_color)
         elseif p.type == "0" and p.prefix_group == ply:GetUserGroup() then
            prefix = "["..p.prefix_name.. "] "
            color_pref = tostring(p.prefix_color)
         end
      end

      if prefix and color_pref then
         chat.AddText(string.ToColor(color_pref), prefix, team.GetColor(ply:Team()), ply:Nick(), Color(255,255,255), " : "..text)
         prefix, color_pref = nil, nil
         return true
      else
         chat.AddText(team.GetColor(ply:Team()), ply:Nick(), Color(255,255,255), " : "..text)
         prefix, color_pref = nil, nil
         return true
      end
   end

end)



function timeToStr( time )
  local tmp = time
  local s = tmp % 60
  tmp = math.floor( tmp / 60 )
  local m = tmp % 60
  tmp = math.floor( tmp / 60 )
  local h = tmp 
  tmp = math.floor( tmp )

  return string.format( "%02iч %02iм %02iс", h, m, s )
end


net.Receive("open_online_menu", function ()
  -- if LocalPlayer():IsSuperAdmin() then
    local tbl = net.ReadTable()

    local Timestamp = os.time()
    local day_of_week = os.date( "%A" , Timestamp )

    local main_frame = vgui.Create("DFrame")
    main_frame:SetSize(900,600)
    main_frame:Center()
    main_frame:MakePopup()
    main_frame:SetTitle("Меню")
    main_frame:ShowCloseButton(true)


    local adm_list = vgui.Create("DListView",main_frame)
    adm_list:Dock(FILL)
    adm_list:AddColumn("SID")
    adm_list:AddColumn("Ник")
    adm_list:AddColumn("Ур.Админки")
    adm_list:AddColumn("Понедельник")
    adm_list:AddColumn("Вторник")
    adm_list:AddColumn("Среда")
    adm_list:AddColumn("Четверг")
    adm_list:AddColumn("Пятница")
    adm_list:AddColumn("Суббота")
    adm_list:AddColumn("Воскресенье")


    for k,v in pairs (tbl) do
        adm_list:AddLine(v.SteamID, v.Nick, v.UserGroup,  timeToStr(v.Monday),  timeToStr(v.Tuesday),  timeToStr(v.Wednesday), timeToStr(v.Thursday),  timeToStr(v.Friday),  timeToStr(v.Saturday),  timeToStr(v.Sunday))
    end
    
    local find_but = vgui.Create("DButton", main_frame)
    find_but:Dock(BOTTOM)
    find_but:SetText("Поиск по нику/SteamID")

    local wipe_button = vgui.Create("DButton", main_frame)
    wipe_button:Dock(TOP)
    wipe_button:SetText("Очистить базу данных. ЭТО УДАЛИТ ВСЕ ДАННЫЕ С СЕРВЕРА.")

    wipe_button.DoClick = function ()
      net.Start('admins.WipeDB')
      net.SendToServer()

    end

    local find = vgui.Create("DTextEntry", main_frame)
    find:Dock(BOTTOM)


    find_but.DoClick = function ()
      for _, l in pairs (tbl) do
        if l.Nick == find:GetText() or l.SteamID == find:GetText() then
          adm_list:Clear()
          adm_list:AddLine(l.SteamID, l.Nick, l.UserGroup,  timeToStr(l.Monday),  timeToStr(l.Tuesday),  timeToStr(l.Wednesday), timeToStr(l.Thursday),  timeToStr(l.Friday),  timeToStr(l.Saturday),  timeToStr(l.Sunday))

        end
      end
    end
  -- end

end)


concommand.Add("discord_open_url", function ()
    gui.OpenURL("http://discord.gg/WmVWVzgf8r")
    SetClipboardText("discord.gg/WmVWVzgf8r")
end)

concommand.Add("css_content_url", function ()
    gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2345341371")
    -- SetClipboardText("discord.gg/WmVWVzgf8r")
end)

concommand.Add("rules_url_open", function ()
  gui.OpenURL("https://docs.google.com/document/d/1B0zUwnuapHvbTPI9AFW6LpC4wmYDP17_Ikl1j54ahi8/")
end)

-- // Лень было делать свое. Спиздил с вики
-- hook.Add( "OnPlayerChat", "DiscordOpenWindow", function( ply, strText, bTeam, bDead ) 
--   if ( ply != LocalPlayer() ) then return end

--   strText = string.lower( strText ) -- make the string lower case

--   if ( strText == "!discord" ) then 
--     gui.OpenURL("http://discord.gg/WmVWVzgf8r")
--     SetClipboardText("discord.gg/WmVWVzgf8r")
--     return true
--   end
-- end )