---- Trouble in Terrorist Town

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_msgstack.lua")
AddCSLuaFile("cl_hudpickup.lua")
AddCSLuaFile("cl_keys.lua")
AddCSLuaFile("cl_wepswitch.lua")
AddCSLuaFile("cl_awards.lua")
AddCSLuaFile("cl_scoring_events.lua")
AddCSLuaFile("cl_scoring.lua")
AddCSLuaFile("cl_popups.lua")
AddCSLuaFile("cl_equip.lua")
AddCSLuaFile("equip_items_shd.lua")
AddCSLuaFile("cl_help.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_tips.lua")
AddCSLuaFile("cl_voice.lua")
AddCSLuaFile("scoring_shd.lua")
AddCSLuaFile("util.lua")
AddCSLuaFile("lang_shd.lua")
AddCSLuaFile("corpse_shd.lua")
AddCSLuaFile("player_ext_shd.lua")
AddCSLuaFile("weaponry_shd.lua")
AddCSLuaFile("cl_radio.lua")
AddCSLuaFile("cl_radar.lua")
AddCSLuaFile("cl_tbuttons.lua")
AddCSLuaFile("cl_disguise.lua")
AddCSLuaFile("cl_transfer.lua")
AddCSLuaFile("cl_search.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("vgui/ColoredBox.lua")
AddCSLuaFile("vgui/SimpleIcon.lua")
AddCSLuaFile("vgui/ProgressBar.lua")
AddCSLuaFile("vgui/ScrollLabel.lua")
AddCSLuaFile("vgui/sb_main.lua")
AddCSLuaFile("vgui/sb_row.lua")
AddCSLuaFile("vgui/sb_team.lua")
AddCSLuaFile("vgui/sb_info.lua")

include("shared.lua")

include("karma.lua")
include("entity.lua")
include("scoring_shd.lua")
include("radar.lua")
include("admin.lua")
include("traitor_state.lua")
include("propspec.lua")
include("weaponry.lua")
include("gamemsg.lua")
include("ent_replace.lua")
include("scoring.lua")
include("corpse.lua")
include("player_ext_shd.lua")
include("player_ext.lua")
include("player.lua")

-- Round times
CreateConVar("ttt_roundtime_minutes", "10", FCVAR_NOTIFY)
CreateConVar("ttt_preptime_seconds", "30", FCVAR_NOTIFY)
CreateConVar("ttt_posttime_seconds", "30", FCVAR_NOTIFY)
CreateConVar("ttt_firstpreptime", "60")

-- Haste mode
local ttt_haste = CreateConVar("ttt_haste", "1", FCVAR_NOTIFY)
CreateConVar("ttt_haste_starting_minutes", "5", FCVAR_NOTIFY)
CreateConVar("ttt_haste_minutes_per_death", "0.5", FCVAR_NOTIFY)

-- Player Spawning
CreateConVar("ttt_spawn_wave_interval", "0")

CreateConVar("ttt_traitor_pct", "0.25")
CreateConVar("ttt_traitor_max", "32")

CreateConVar("ttt_detective_pct", "0.13", FCVAR_NOTIFY)
CreateConVar("ttt_detective_max", "32")
CreateConVar("ttt_detective_min_players", "8")
CreateConVar("ttt_detective_karma_min", "600")


-- Traitor credits
CreateConVar("ttt_credits_starting", "2")
CreateConVar("ttt_credits_award_pct", "0.35")
CreateConVar("ttt_credits_award_size", "1")
CreateConVar("ttt_credits_award_repeat", "1")
CreateConVar("ttt_credits_detectivekill", "1")

CreateConVar("ttt_credits_alonebonus", "1")

-- Detective credits
CreateConVar("ttt_det_credits_starting", "1")
CreateConVar("ttt_det_credits_traitorkill", "0")
CreateConVar("ttt_det_credits_traitordead", "1")

-- Other
CreateConVar("ttt_use_weapon_spawn_scripts", "1")
CreateConVar("ttt_weapon_spawn_count", "0")

CreateConVar("ttt_round_limit", "6", FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("ttt_time_limit_minutes", "75", FCVAR_NOTIFY + FCVAR_REPLICATED)

CreateConVar("ttt_idle_limit", "180", FCVAR_NOTIFY)

CreateConVar("ttt_voice_drain", "0", FCVAR_NOTIFY)
CreateConVar("ttt_voice_drain_normal", "0.2", FCVAR_NOTIFY)
CreateConVar("ttt_voice_drain_admin", "0.05", FCVAR_NOTIFY)
CreateConVar("ttt_voice_drain_recharge", "0.05", FCVAR_NOTIFY)

CreateConVar("ttt_namechange_kick", "1", FCVAR_NOTIFY)
CreateConVar("ttt_namechange_bantime", "10")

local ttt_detective = CreateConVar("ttt_sherlock_mode", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY)
local ttt_minply = CreateConVar("ttt_minimum_players", "2", FCVAR_ARCHIVE + FCVAR_NOTIFY)

-- debuggery
local ttt_dbgwin = CreateConVar("ttt_debug_preventwin", "0")

-- Localise stuff we use often. It's like Lua go-faster stripes.
local math = math
local table = table
local net = net
local player = player
local timer = timer
local util = util

-- Pool some network names.
util.AddNetworkString("TTT_RoundState")
util.AddNetworkString("TTT_RagdollSearch")
util.AddNetworkString("TTT_GameMsg")
util.AddNetworkString("TTT_GameMsgColor")
util.AddNetworkString("TTT_RoleChat")
util.AddNetworkString("TTT_TraitorVoiceState")
util.AddNetworkString("TTT_LastWordsMsg")
util.AddNetworkString("TTT_RadioMsg")
util.AddNetworkString("TTT_ReportStream")
util.AddNetworkString("TTT_LangMsg")
util.AddNetworkString("TTT_ServerLang")
util.AddNetworkString("TTT_Equipment")
util.AddNetworkString("TTT_Credits")
util.AddNetworkString("TTT_Bought")
util.AddNetworkString("TTT_BoughtItem")
util.AddNetworkString("TTT_InterruptChat")
util.AddNetworkString("TTT_PlayerSpawned")
util.AddNetworkString("TTT_PlayerDied")
util.AddNetworkString("TTT_CorpseCall")
util.AddNetworkString("TTT_ClearClientState")
util.AddNetworkString("TTT_PerformGesture")
util.AddNetworkString("TTT_Role")
util.AddNetworkString("TTT_RoleList")
util.AddNetworkString("TTT_ConfirmUseTButton")
util.AddNetworkString("TTT_C4Config")
util.AddNetworkString("TTT_C4DisarmResult")
util.AddNetworkString("TTT_C4Warn")
util.AddNetworkString("TTT_ShowPrints")
util.AddNetworkString("TTT_ScanResult")
util.AddNetworkString("TTT_FlareScorch")
util.AddNetworkString("TTT_Radar")
util.AddNetworkString("TTT_Spectate")
---- Round mechanics
function GM:Initialize()
   MsgN("Trouble In Terrorist Town gamemode initializing...")

   -- Force friendly fire to be enabled. If it is off, we do not get lag compensation.
   RunConsoleCommand("mp_friendlyfire", "1")

   -- Default crowbar unlocking settings, may be overridden by config entity
   GAMEMODE.crowbar_unlocks = {
      [OPEN_DOOR] = true,
      [OPEN_ROT] = true,
      [OPEN_BUT] = true,
      [OPEN_NOTOGGLE]= true
   };

   -- More map config ent defaults
   GAMEMODE.force_plymodel = ""
   GAMEMODE.propspec_allow_named = true

   GAMEMODE.MapWin = WIN_NONE
   GAMEMODE.AwardedCredits = false
   GAMEMODE.AwardedCreditsDead = 0

   GAMEMODE.round_state = ROUND_WAIT
   GAMEMODE.FirstRound = true
   GAMEMODE.RoundStartTime = 0

   GAMEMODE.DamageLog = {}
   GAMEMODE.LastRole = {}
   GAMEMODE.playermodel = GetRandomPlayerModel()
   GAMEMODE.playercolor = COLOR_WHITE

   -- Delay reading of cvars until config has definitely loaded
   GAMEMODE.cvar_init = false

   SetGlobalFloat("ttt_round_end", -1)
   SetGlobalFloat("ttt_haste_end", -1)

   -- For the paranoid
   math.randomseed(os.time())

   WaitForPlayers()

   if cvars.Number("sv_alltalk", 0) > 0 then
      ErrorNoHalt("TTT WARNING: sv_alltalk is enabled. Dead players will be able to talk to living players. TTT will now attempt to set sv_alltalk 0.\n")
      RunConsoleCommand("sv_alltalk", "0")
   end

   local cstrike = false
   for _, g in ipairs(engine.GetGames()) do
      if g.folder == 'cstrike' then cstrike = true end
   end
   if not cstrike then
      ErrorNoHalt("TTT WARNING: CS:S does not appear to be mounted by GMod. Things may break in strange ways. Server admin? Check the TTT readme for help.\n")
   end
end

-- Used to do this in Initialize, but server cfg has not always run yet by that
-- point.
function GM:InitCvars()
   MsgN("TTT initializing convar settings...")

   -- Initialize game state that is synced with client
   SetGlobalInt("ttt_rounds_left", GetConVar("ttt_round_limit"):GetInt())
   GAMEMODE:SyncGlobals()
   KARMA.InitState()

   self.cvar_init = true
end

function GM:InitPostEntity()
   WEPS.ForcePrecache()
end

-- Convar replication is broken in gmod, so we do this.
-- I don't like it any more than you do, dear reader.
function GM:SyncGlobals()
   SetGlobalBool("ttt_detective", ttt_detective:GetBool())
   SetGlobalBool("ttt_haste", ttt_haste:GetBool())
   SetGlobalInt("ttt_time_limit_minutes", GetConVar("ttt_time_limit_minutes"):GetInt())
   SetGlobalBool("ttt_highlight_admins", GetConVar("ttt_highlight_admins"):GetBool())
   -- SetGlobalBool("ttt_locational_voice", GetConVar("ttt_locational_voice"):GetBool())
   SetGlobalInt("ttt_idle_limit", GetConVar("ttt_idle_limit"):GetInt())

   SetGlobalBool("ttt_voice_drain", GetConVar("ttt_voice_drain"):GetBool())
   SetGlobalFloat("ttt_voice_drain_normal", GetConVar("ttt_voice_drain_normal"):GetFloat())
   SetGlobalFloat("ttt_voice_drain_admin", GetConVar("ttt_voice_drain_admin"):GetFloat())
   SetGlobalFloat("ttt_voice_drain_recharge", GetConVar("ttt_voice_drain_recharge"):GetFloat())
end

function SendRoundState(state, ply)
   net.Start("TTT_RoundState")
      net.WriteUInt(state, 3)
   return ply and net.Send(ply) or net.Broadcast()
end

-- Round state is encapsulated by set/get so that it can easily be changed to
-- eg. a networked var if this proves more convenient
function SetRoundState(state)
   GAMEMODE.round_state = state

   SCORE:RoundStateChange(state)

   SendRoundState(state)
end

function GetRoundState()
   return GAMEMODE.round_state
end

local function EnoughPlayers()
   local ready = 0
   -- only count truly available players, ie. no forced specs
   for _, ply in ipairs(player.GetAll()) do
      if IsValid(ply) and ply:ShouldSpawn() then
         ready = ready + 1
      end
   end
   return ready >= ttt_minply:GetInt()
end

-- Used to be in Think/Tick, now in a timer
function WaitingForPlayersChecker()
   if GetRoundState() == ROUND_WAIT then
      if EnoughPlayers() then
         timer.Create("wait2prep", 1, 1, PrepareRound)

         timer.Stop("waitingforply")
      end
   end
end

-- Start waiting for players
function WaitForPlayers()
   SetRoundState(ROUND_WAIT)

   if not timer.Start("waitingforply") then
      timer.Create("waitingforply", 2, 0, WaitingForPlayersChecker)
   end
end

-- When a player initially spawns after mapload, everything is a bit strange;
-- just making him spectator for some reason does not work right. Therefore,
-- we regularly check for these broken spectators while we wait for players
-- and immediately fix them.
function FixSpectators()
   for k, ply in ipairs(player.GetAll()) do
      if ply:IsSpec() and not ply:GetRagdollSpec() and ply:GetMoveType() < MOVETYPE_NOCLIP then
         ply:Spectate(OBS_MODE_ROAMING)
      end
   end
end

-- Used to be in think, now a timer
local function WinChecker()
   if GetRoundState() == ROUND_ACTIVE then
      if CurTime() > GetGlobalFloat("ttt_round_end", 0) then
         EndRound(WIN_TIMELIMIT)
      else
         local win = hook.Call("TTTCheckForWin", GAMEMODE)
         if win != WIN_NONE then
            EndRound(win)
         end
      end
   end
end

local function NameChangeKick()
   if not GetConVar("ttt_namechange_kick"):GetBool() then
      timer.Remove("namecheck")
      return
   end

   if GetRoundState() == ROUND_ACTIVE then
      for _, ply in ipairs(player.GetHumans()) do
         if ply.spawn_nick then
            if ply.has_spawned and ply.spawn_nick != ply:Nick() and not hook.Call("TTTNameChangeKick", GAMEMODE, ply) then
               local t = GetConVar("ttt_namechange_bantime"):GetInt()
               local msg = "Changed name during a round"
               if t > 0 then
                  ply:KickBan(t, msg)
               else
                  ply:Kick(msg)
               end
            end
         else
            ply.spawn_nick = ply:Nick()
         end
      end
   end
end

function StartNameChangeChecks()
   if not GetConVar("ttt_namechange_kick"):GetBool() then return end

   -- bring nicks up to date, may have been changed during prep/post
   for _, ply in ipairs(player.GetAll()) do
      ply.spawn_nick = ply:Nick()
   end

   if not timer.Exists("namecheck") then
      timer.Create("namecheck", 3, 0, NameChangeKick)
   end
end

function StartWinChecks()
   if not timer.Start("winchecker") then
      timer.Create("winchecker", 1, 0, WinChecker)
   end
end

function StopWinChecks()
   timer.Stop("winchecker")
end

local function CleanUp()
   local et = ents.TTT
   -- if we are going to import entities, it's no use replacing HL2DM ones as
   -- soon as they spawn, because they'll be removed anyway
   et.SetReplaceChecking(not et.CanImportEntities(game.GetMap()))

   et.FixParentedPreCleanup()

   -- game.CleanUpMap(false, "{}")
   // Возможный фикс? Узнаем позднее!
   game.CleanUpMap( false, { "env_fire", "entityflame", "_firesmoke", "dmglog_sync_ent" } )

   et.FixParentedPostCleanup()

   -- Strip players now, so that their weapons are not seen by ReplaceEntities
   for k,v in ipairs(player.GetAll()) do
      if IsValid(v) then
         v:StripWeapons()
      end
   end

   -- a different kind of cleanup
   hook.Remove("PlayerSay", "ULXMeCheck")
end

local function SpawnEntities()
   local et = ents.TTT
   -- Spawn weapons from script if there is one
   local import = et.CanImportEntities(game.GetMap())

   if import then
      et.ProcessImportScript(game.GetMap())
   else
      -- Replace HL2DM/ZM ammo/weps with our own
      et.ReplaceEntities()

      -- Populate CS:S/TF2 maps with extra guns
      et.PlaceExtraWeapons()
   end

   -- Finally, get players in there
   SpawnWillingPlayers()
end


local function StopRoundTimers()
   -- remove all timers
   timer.Stop("wait2prep")
   timer.Stop("prep2begin")
   timer.Stop("end2prep")
   timer.Stop("winchecker")
end

-- Make sure we have the players to do a round, people can leave during our
-- preparations so we'll call this numerous times
local function CheckForAbort()
   if not EnoughPlayers() then
      LANG.Msg("round_minplayers")
      StopRoundTimers()

      WaitForPlayers()
      return true
   end

   return false
end

function GM:TTTDelayRoundStartForVote()
   -- Can be used for custom voting systems
   --return true, 30
   return false
end

function PrepareRound()
   -- Check playercount
   if CheckForAbort() then return end

   local delay_round, delay_length = hook.Call("TTTDelayRoundStartForVote", GAMEMODE)

   if delay_round then
      delay_length = delay_length or 30

      LANG.Msg("round_voting", {num = delay_length})

      timer.Create("delayedprep", delay_length, 1, PrepareRound)
      return
   end

   -- Cleanup
   CleanUp()

   GAMEMODE.MapWin = WIN_NONE
   GAMEMODE.AwardedCredits = false
   GAMEMODE.AwardedCreditsDead = 0

   SCORE:Reset()

   -- Update damage scaling
   KARMA.RoundBegin()

   -- New look. Random if no forced model set.
   GAMEMODE.playermodel = GAMEMODE.force_plymodel == "" and GetRandomPlayerModel() or GAMEMODE.force_plymodel
   GAMEMODE.playercolor = hook.Call("TTTPlayerColor", GAMEMODE, GAMEMODE.playermodel)

   if CheckForAbort() then return end

   -- Schedule round start
   local ptime = GetConVar("ttt_preptime_seconds"):GetInt()
   if GAMEMODE.FirstRound then
      ptime = GetConVar("ttt_firstpreptime"):GetInt()
      GAMEMODE.FirstRound = false
   end

   -- Piggyback on "round end" time global var to show end of phase timer
   SetRoundEnd(CurTime() + ptime)

   timer.Create("prep2begin", ptime, 1, BeginRound)

   -- Mute for a second around traitor selection, to counter a dumb exploit
   -- related to traitor's mics cutting off for a second when they're selected.
   timer.Create("selectmute", ptime - 1, 1, function() MuteForRestart(true) end)

   LANG.Msg("round_begintime", {num = ptime})
   SetRoundState(ROUND_PREP)

   -- Delay spawning until next frame to avoid ent overload
   timer.Simple(0.01, SpawnEntities)

   -- Undo the roundrestart mute, though they will once again be muted for the
   -- selectmute timer.
   timer.Create("restartmute", 1, 1, function() MuteForRestart(false) end)

   net.Start("TTT_ClearClientState") net.Broadcast()

   -- In case client's cleanup fails, make client set all players to innocent role
   timer.Simple(1, SendRoleReset)

   -- Tell hooks and map we started prep
   hook.Call("TTTPrepareRound")

   ents.TTT.TriggerRoundStateOutputs(ROUND_PREP)
end

function SetRoundEnd(endtime)
   SetGlobalFloat("ttt_round_end", endtime)
end

function IncRoundEnd(incr)
   SetRoundEnd(GetGlobalFloat("ttt_round_end", 0) + incr)
end

function TellTraitorsAboutTraitors()
  local plys = player.GetAll()

   local traitornicks = {}
   for k,v in ipairs(plys) do
      if v:IsTraitor() then
         table.insert(traitornicks, v:Nick())
      end
   end

   -- This is ugly as hell, but it's kinda nice to filter out the names of the
   -- traitors themselves in the messages to them
   for k,v in ipairs(plys) do
      if v:IsTraitor() then
         if #traitornicks < 2 then
            LANG.Msg(v, "round_traitors_one")
            return
         else
            local names = ""
            for i,name in ipairs(traitornicks) do
               if name != v:Nick() then
                  names = names .. name .. ", "
               end
            end
            names = string.sub(names, 1, -3)
            LANG.Msg(v, "round_traitors_more", {names = names})
         end
      end
   end
end


function SpawnWillingPlayers(dead_only)
   local plys = player.GetAll()
   local wave_delay = GetConVar("ttt_spawn_wave_interval"):GetFloat()

   -- simple method, should make this a case of the other method once that has
   -- been tested.
   if wave_delay <= 0 or dead_only then
      for k, ply in ipairs(plys) do
         if IsValid(ply) then
            ply:SpawnForRound(dead_only)
         end
      end
   else
      -- wave method
      local num_spawns = #GetSpawnEnts()

      local to_spawn = {}
      for _, ply in RandomPairs(plys) do
         if IsValid(ply) and ply:ShouldSpawn() then
            table.insert(to_spawn, ply)
            GAMEMODE:PlayerSpawnAsSpectator(ply)
         end
      end

      local sfn = function()
                     local c = 0
                     -- fill the available spawnpoints with players that need
                     -- spawning
                     while c < num_spawns and #to_spawn > 0 do
                        for k, ply in ipairs(to_spawn) do
                           if IsValid(ply) and ply:SpawnForRound() then
                              -- a spawn ent is now occupied
                              c = c + 1
                           end
                           -- Few possible cases:
                           -- 1) player has now been spawned
                           -- 2) player should remain spectator after all
                           -- 3) player has disconnected
                           -- In all cases we don't need to spawn them again.
                           table.remove(to_spawn, k)

                           -- all spawn ents are occupied, so the rest will have
                           -- to wait for next wave
                           if c >= num_spawns then
                              break
                           end
                        end
                     end

                     MsgN("Spawned " .. c .. " players in spawn wave.")

                     if #to_spawn == 0 then
                        timer.Remove("spawnwave")
                        MsgN("Spawn waves ending, all players spawned.")
                     end
                  end

      MsgN("Spawn waves starting.")
      timer.Create("spawnwave", wave_delay, 0, sfn)

      -- already run one wave, which may stop the timer if everyone is spawned
      -- in one go
      sfn()
   end
end

local function InitRoundEndTime()
   -- Init round values
   local endtime = CurTime() + (GetConVar("ttt_roundtime_minutes"):GetInt() * 60)
   if HasteMode() then
      endtime = CurTime() + (GetConVar("ttt_haste_starting_minutes"):GetInt() * 60)
      -- this is a "fake" time shown to innocents, showing the end time if no
      -- one would have been killed, it has no gameplay effect
      SetGlobalFloat("ttt_haste_end", endtime)
   end

   SetRoundEnd(endtime)
end

function BeginRound()
   GAMEMODE:SyncGlobals()

   if CheckForAbort() then return end

   InitRoundEndTime()

   if CheckForAbort() then return end

   -- Respawn dumb people who died during prep
   SpawnWillingPlayers(true)

   -- Remove their ragdolls
   ents.TTT.RemoveRagdolls(true)

   if CheckForAbort() then return end

   -- Select traitors & co. This is where things really start so we can't abort
   -- anymore.
   SelectRoles()
   LANG.Msg("round_selected")
   SendFullStateUpdate()

   -- Edge case where a player joins just as the round starts and is picked as
   -- traitor, but for whatever reason does not get the traitor state msg. So
   -- re-send after a second just to make sure everyone is getting it.
   timer.Simple(1, SendFullStateUpdate)
   timer.Simple(10, SendFullStateUpdate)

   SCORE:HandleSelection() -- log traitors and detectives

   -- Give the StateUpdate messages ample time to arrive
   timer.Simple(1.5, TellTraitorsAboutTraitors)
   timer.Simple(2.5, ShowRoundStartPopup)

   -- Start the win condition check timer
   StartWinChecks()
   StartNameChangeChecks()
   timer.Create("selectmute", 1, 1, function() MuteForRestart(false) end)

   GAMEMODE.DamageLog = {}
   GAMEMODE.RoundStartTime = CurTime()

   -- Sound start alarm
   SetRoundState(ROUND_ACTIVE)
   LANG.Msg("round_started")
   ServerLog("Round proper has begun...\n")

   GAMEMODE:UpdatePlayerLoadouts() -- needs to happen when round_active

   hook.Call("TTTBeginRound")

   ents.TTT.TriggerRoundStateOutputs(ROUND_BEGIN)
end

function PrintResultMessage(type)
   ServerLog("Round ended.\n")
   if type == WIN_TIMELIMIT then
      LANG.Msg("win_time")
      ServerLog("Result: timelimit reached, traitors lose.\n")
   elseif type == WIN_TRAITOR then
      LANG.Msg("win_traitor")
      ServerLog("Result: traitors win.\n")
   elseif type == WIN_INNOCENT then
      LANG.Msg("win_innocent")
      ServerLog("Result: innocent win.\n")
   else
      ServerLog("Result: unknown victory condition!\n")
   end
end

function CheckForMapSwitch()
   -- Check for mapswitch
   local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)
   SetGlobalInt("ttt_rounds_left", rounds_left)

   local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
   local switchmap = false
   local nextmap = string.upper(game.GetMapNext())

   if rounds_left <= 0 then
      LANG.Msg("limit_round", {mapname = nextmap})
      switchmap = true
   elseif time_left <= 0 then
      LANG.Msg("limit_time", {mapname = nextmap})
      switchmap = true
   end

   if switchmap then
      timer.Stop("end2prep")
      MapVote.Start(20, false, 24, nil)
      -- timer.Simple(15, game.LoadNextMap)
   else
      LANG.Msg("limit_left", {num = rounds_left,
                              time = math.ceil(time_left / 60),
                              mapname = nextmap})
   end
end

function EndRound(type)
   PrintResultMessage(type)

   -- first handle round end
   SetRoundState(ROUND_POST)

   local ptime = math.max(5, GetConVar("ttt_posttime_seconds"):GetInt())
   LANG.Msg("win_showreport", {num = ptime})
   timer.Create("end2prep", ptime, 1, PrepareRound)

   -- Piggyback on "round end" time global var to show end of phase timer
   SetRoundEnd(CurTime() + ptime)

   timer.Create("restartmute", ptime - 1, 1, function() MuteForRestart(true) end)

   -- Stop checking for wins
   StopWinChecks()

   -- We may need to start a timer for a mapswitch, or start a vote
   CheckForMapSwitch()

   KARMA.RoundEnd()

   -- now handle potentially error prone scoring stuff

   -- register an end of round event
   SCORE:RoundComplete(type)

   -- update player scores
   SCORE:ApplyEventLogScores(type)

   -- send the clients the round log, players will be shown the report
   SCORE:StreamToClients()

   -- server plugins might want to start a map vote here or something
   -- these hooks are not used by TTT internally
   hook.Call("TTTEndRound", GAMEMODE, type)

   ents.TTT.TriggerRoundStateOutputs(ROUND_POST, type)
end

function GM:MapTriggeredEnd(wintype)
   self.MapWin = wintype
end

-- The most basic win check is whether both sides have one dude alive
function GM:TTTCheckForWin()
   if ttt_dbgwin:GetBool() then return WIN_NONE end

   if GAMEMODE.MapWin == WIN_TRAITOR or GAMEMODE.MapWin == WIN_INNOCENT then
      local mw = GAMEMODE.MapWin
      GAMEMODE.MapWin = WIN_NONE
      return mw
   end

   local traitor_alive = false
   local innocent_alive = false
   for k,v in ipairs(player.GetAll()) do
      if v:Alive() and v:IsTerror() then
         if v:GetTraitor() then
            traitor_alive = true
         else
            innocent_alive = true
         end
      end

      if traitor_alive and innocent_alive then
         return WIN_NONE --early out
      end
   end

   if traitor_alive and not innocent_alive then
      return WIN_TRAITOR
   elseif not traitor_alive and innocent_alive then
      return WIN_INNOCENT
   elseif not innocent_alive then
      -- ultimately if no one is alive, traitors win
      return WIN_TRAITOR
   end

   return WIN_NONE
end

local function GetTraitorCount(ply_count)
   -- get number of traitors: pct of players rounded down
   local traitor_count = math.floor(ply_count * GetConVar("ttt_traitor_pct"):GetFloat())
   -- make sure there is at least 1 traitor
   traitor_count = math.Clamp(traitor_count, 1, GetConVar("ttt_traitor_max"):GetInt())

   return traitor_count
end


local function GetDetectiveCount(ply_count)
   if ply_count < GetConVar("ttt_detective_min_players"):GetInt() then return 0 end

   local det_count = math.floor(ply_count * GetConVar("ttt_detective_pct"):GetFloat())
   -- limit to a max
   det_count = math.Clamp(det_count, 1, GetConVar("ttt_detective_max"):GetInt())

   return det_count
end


function SelectRoles()
   local choices = {}
   local prev_roles = {
      [ROLE_INNOCENT] = {},
      [ROLE_TRAITOR] = {},
      [ROLE_DETECTIVE] = {}
   };

   if not GAMEMODE.LastRole then GAMEMODE.LastRole = {} end

   local plys = player.GetAll()

   for k,v in ipairs(plys) do
      -- everyone on the spec team is in specmode
      if IsValid(v) and (not v:IsSpec()) then
         -- save previous role and sign up as possible traitor/detective

         local r = GAMEMODE.LastRole[v:SteamID()] or v:GetRole() or ROLE_INNOCENT

         table.insert(prev_roles[r], v)

         table.insert(choices, v)
      end

      v:SetRole(ROLE_INNOCENT)
   end

   -- determine how many of each role we want
   local choice_count = #choices
   local traitor_count = GetTraitorCount(choice_count)
   local det_count = GetDetectiveCount(choice_count)

   if choice_count == 0 then return end

   -- first select traitors
   local ts = 0
   while ts < traitor_count do
      -- select random index in choices table
      local pick = math.random(1, #choices)

      -- the player we consider
      local pply = choices[pick]

      -- make this guy traitor if he was not a traitor last time, or if he makes
      -- a roll
      if IsValid(pply) and
         ((not table.HasValue(prev_roles[ROLE_TRAITOR], pply)) or (math.random(1, 3) == 2)) then
         pply:SetRole(ROLE_TRAITOR)

         table.remove(choices, pick)
         ts = ts + 1
      end
   end

   -- now select detectives, explicitly choosing from players who did not get
   -- traitor, so becoming detective does not mean you lost a chance to be
   -- traitor
   local ds = 0
   local min_karma = GetConVarNumber("ttt_detective_karma_min") or 0
   while (ds < det_count) and (#choices >= 1) do

      -- sometimes we need all remaining choices to be detective to fill the
      -- roles up, this happens more often with a lot of detective-deniers
      if #choices <= (det_count - ds) then
         for k, pply in ipairs(choices) do
            if IsValid(pply) then
               pply:SetRole(ROLE_DETECTIVE)
            end
         end

         break -- out of while
      end


      local pick = math.random(1, #choices)
      local pply = choices[pick]

      -- we are less likely to be a detective unless we were innocent last round
      if (IsValid(pply) and
          ((tonumber(pply:GetBaseKarma()) > tonumber(min_karma) and
           table.HasValue(prev_roles[ROLE_INNOCENT], pply)) or
           math.random(1,3) == 2)) then

         -- if a player has specified he does not want to be detective, we skip
         -- him here (he might still get it if we don't have enough
         -- alternatives)
         if not pply:GetAvoidDetective() then
            pply:SetRole(ROLE_DETECTIVE)
            ds = ds + 1
         end

         table.remove(choices, pick)
      end
   end

   GAMEMODE.LastRole = {}

   for _, ply in ipairs(plys) do
      -- initialize credit count for everyone based on their role
      ply:SetDefaultCredits()

      -- store a steamid -> role map
      GAMEMODE.LastRole[ply:SteamID()] = ply:GetRole()
   end
end


local function ForceRoundRestart(ply, command, args)
   -- ply is nil on dedicated server console
   if (not IsValid(ply)) or ply:IsAdmin() or ply:IsSuperAdmin() or cvars.Bool("sv_cheats", 0) then
      LANG.Msg("round_restart")

      StopRoundTimers()

      -- do prep
      PrepareRound()
   else
      ply:PrintMessage(HUD_PRINTCONSOLE, "You must be a GMod Admin or SuperAdmin on the server to use this command, or sv_cheats must be enabled.")
   end
end
concommand.Add("ttt_roundrestart", ForceRoundRestart)

function ShowVersion(ply)
   local text = Format("This is TTT version %s\n", GAMEMODE.Version)
   if IsValid(ply) then
      ply:PrintMessage(HUD_PRINTNOTIFY, text)
   else
      Msg(text)
   end
end
concommand.Add("ttt_version", ShowVersion)


local all_traitors, all_detective, all_inno = 0,0,0



util.AddNetworkString("TTTMessages.PrettyPrint")
util.AddNetworkString("TTTMessages.PrintWhoKilldYou")

hook.Add("DoPlayerDeath", "WhoKilldYou?", function (ply, attacker, dmg)
   if ply:IsValid() and attacker:IsPlayer() and attacker:IsValid() then
      if ply == attacker then return end

      net.Start("TTTMessages.PrintWhoKilldYou")
      net.WriteString(attacker:GetRole())
      net.WriteEntity(attacker)
      net.Send(ply)
   end

end)

hook.Add("TTTBeginRound", "countOnMembers", function ()
   for k,v in pairs (player.GetAll()) do
      if v:IsActiveTraitor() then
         all_traitors = all_traitors + 1
      end
      if v:IsActiveDetective() then
         all_detective = all_detective + 1
      end

      if not v:IsSpecial() and not v:GetForceSpec() == true then
         all_inno = all_inno + 1
      end
   end

   net.Start("TTTMessages.PrettyPrint")
   net.WriteString(all_traitors)
   net.WriteString(all_detective)
   net.WriteString(all_inno)
   net.Broadcast()

   all_traitors, all_detective, all_inno = 0,0,0

end)

-- hook.Add("TTTEndRound", "roundClearInfo", function ()
--    all_traitors, all_detective, all_inno = 0, 0, 0
-- end)


hook.Add("OnGamemodeLoaded", "Top10.DBCreating", function ()
   if sql.TableExists("ttt_top_players") then
      print ("[TopPlayers] DB already created")
   else
      sql.Query("CREATE TABLE ttt_top_players( S64, score INT, nick)")
      print ("[TopPlayers] DB was created!")
   end

   if sql.TableExists("ttt_top_players_today") then
      print ("[TopPlayers TODAY] DB already created")
   else
      local now_time = os.date( "%d/%m/%Y" , os.time())
      sql.Query("CREATE TABLE ttt_top_players_today( S64, score INT, nick, time_stamp)")
      sql.Query("INSERT INTO ttt_top_players_today( S64, score, nick, time_stamp ) VALUES( '123456789', '0', 'Локальный Бот', '"..now_time.."')")
      print ("[TopPlayers TODAY] DB was created!")
   end


   if sql.TableExists("ttt_bans") then
      print ("[TTT Bans] DB already created")
   else
       sql.Query("CREATE TABLE ttt_bans( S64, time INT, banned_by VARCHAR, reason VARCHAR)")
       print ("[TTT Bans] DB Created")
   end

   if sql.TableExists("ttt_donate_models") then
      print ("[DonatModels] DB already created")
   else
      sql.Query("CREATE TABLE ttt_donate_models( S64, models VARCHAR)")
      print ("[DonatModels] DB was created!")
   end

   if sql.TableExists("ttt_vip_players") then
      print ("[VIP PLAYERS] DB already created")
   else
      sql.Query("CREATE TABLE ttt_vip_players( S64, timeLeft VARCHAR)")
      print ("[VIP PLAYERS] DB was created!")
   end


   -- local q = sql.Query( "CREATE TABLE IF NOT EXISTS online_admnins( SteamID TEXT, Nick TEXT, UserGroup TEXT, Monday TEXT, Tuesday TEXT, Wednesday TEXT, Thursday TEXT, Friday TEXT, Saturday TEXT, Sunday TEXT )" )
end)


hook.Add("OnGamemodeLoaded", "SQL.Querus", function ()
   if sql.TableExists("ttt_top_players_today") then
      local query = sql.Query("SELECT time_stamp FROM ttt_top_players_today WHERE S64 = '123456789'")
      -- local 
      if query then
         local transfer = query[1].time_stamp 
         local now_time = os.date( "%d/%m/%Y" , os.time())

         if tostring(now_time) != tostring(transfer) then

            local today_table = sql.Query('SELECT * FROM ttt_top_players_today ORDER BY score DESC LIMIT 3;')
            for _,v in pairs (today_table) do
               print ("[TOP10 AddDonat] Add 10 donat points to "..tostring(v.nick).."("..util.SteamIDFrom64(v.S64)..")")
               -- IGS.Transaction(tostring(v.S64), 10, "За взятие ТОП 10 дня.")
            end


            print ("[TOP10 TODAY DB] Starting to wipe ALL data because a new day coming!")
            sql.Query("DROP TABLE ttt_top_players_today")
            print ("[TOP10 TODAY DB] Succefull wiped DataBase.")
            sql.Query("CREATE TABLE ttt_top_players_today( S64, score INT, nick, time_stamp)")
            print ("[TOP10 TODAY DB] Succefull created new DB.")
            sql.Query("INSERT INTO ttt_top_players_today( S64, score, nick, time_stamp ) VALUES( '123456789', '0', 'Локальный Бот', '"..now_time.."')")
            print ("[TOP10 TODAY DB] Succefull inserted BOT to detect DATE.")
         else
            print ("[TOP10 TODAY DB] Date is ok. ")
            print ("[TOP10 TODAY DB] Now time is "..tostring(now_time))
            print ("[TOP10 TODAY DB] And DB time is "..tostring(transfer))
         end
      end
      
      -- local today_table = sql.Query('SELECT * FROM ttt_top_players_today ORDER BY score DESC LIMIT 3;')
   end
end)


-- hook.Add("PlayerInitialSpawn","Top10.PlayerFirstScoreSelect",function (ply)
--    if ply:IsBot() then return end
--    local query = sql.Query("SELECT score FROM ttt_top_players WHERE S64 = '"..ply:SteamID64().."'")
--    if (query) then
--       timer.Simple(1, function ()
--          ply:SetNWInt("PlayerScore", query[1].score)
--         print ("[TOP10 FIRST SPAWN] Restored "..query[1].score.." for player "..ply:Nick().."(SELECT)")
--       end)
--    else
--          print ("[TOP10 FIRST SPAWN] Player "..ply:Nick().." has no active score in DB so we setted it to zero (NONE)")
--          ply:SetNWInt("PlayerScore", 0)
--    end


--    if ply:IsBot() then return end
--    local query = sql.Query("SELECT score FROM ttt_top_players_today WHERE S64 = '"..ply:SteamID64().."'")
--    if (query) then
--       timer.Simple(1, function ()
--          ply:SetNWInt("TodayPlayerScore", query[1].score)
--         print ("[TOP10 TODAY FIRST SPAWN] Restored "..query[1].score.." for player "..ply:Nick().."(SELECT)")
--       end)
--    else
--       print ("[TOP10 TODAY FIRST SPAWN] Player "..ply:Nick().." has no active score in DB so we setted it to zero (NONE)")
--       ply:SetNWInt("TodayPlayerScore", 0)
--    end
-- end)


-- hook.Add("TTTEndRound", "Top10.SaveScoreToLocalINT", function ()
--    for k,v in pairs (player.GetAll()) do
--       local score = v:GetNWInt("PlayerScore")
--       local today_score = v:GetNWInt("TodayPlayerScore")
--       if v:IsValid() and not v:IsBot() then
--          v:SetNWInt("PlayerScore",score + v:Frags())
--          v:SetNWInt("TodayPlayerScore", today_score + v:Frags())
--       end
--    end

--    // Попробуем убрать.
--    for k,v in pairs (player.GetAll()) do
--       local score_saver = v:GetNWInt("PlayerScore")
--       local today_score_today = v:GetNWInt("TodayPlayerScore")
--       local query = sql.Query("SELECT score FROM ttt_top_players WHERE S64 = '"..v:SteamID64().."'")
--          if (query) then
--          sql.Query( "UPDATE ttt_top_players SET score = '"..score_saver.."' WHERE S64 = '"..v:SteamID64().."'" )

--             print ("[TOP10 END ROUND] Saved "..score_saver.." for player "..v:Nick().."(update)")
--          else
--             sql.Query( "INSERT INTO ttt_top_players( S64, score, nick ) VALUES( '"..v:SteamID64().."', '"..score_saver.."', '"..v:Nick().."' )" )
--             print ("[TOP10 END ROUND] Saved "..score_saver.." for player "..v:Nick().." (insert)")
--          end

--          local query_today = sql.Query("SELECT score FROM ttt_top_players_today WHERE S64 = '"..v:SteamID64().."'")
--          if query_today then
--             sql.Query( "UPDATE ttt_top_players_today SavedET score = '"..today_score_today.."' WHERE S64 = '"..v:SteamID64().."'" )
--          else
--             sql.Query( "INSERT INTO ttt_top_players_today( S64, score, nick ) VALUES( '"..v:SteamID64().."', '"..today_score_today.."', '"..v:Nick().."' )" )
--          end


--    end
-- end)



-- hook.Add("PlayerDisconnected", "Top10.PlayerLeaveServerWeSaveHisScore", function (ply)
--    if ply:IsBot() then return end
--    local score = ply:GetNWInt("PlayerScore")
--    local today_score = ply:GetNWInt("TodayPlayerScore")
--    local query = sql.Query("SELECT score FROM ttt_top_players WHERE S64 = '"..ply:SteamID64().."'")
--    if (query) then
--       sql.Query( "UPDATE ttt_top_players SET score = '"..score.."' WHERE S64 = '"..ply:SteamID64().."'" )
--       print ("[TOP10 DISCONNECT] Saved "..score.." score for player "..ply:Nick().."(update)")
--    else
--       sql.Query( "INSERT INTO ttt_top_players( S64, score, nick ) VALUES( '"..ply:SteamID64().."', '"..score.."', '"..ply:Nick().."' )" )
--       print ("[TOP10 DISCONNECT] Saved "..score.." score for player "..ply:Nick().." (insert)")
--    end

--    local query_today = sql.Query("SELECT score FROM ttt_top_players_today WHERE S64 = '"..ply:SteamID64().."'")
--    if query_today then
--       sql.Query( "UPDATE ttt_top_players_today SET score = '"..today_score.."' WHERE S64 = '"..ply:SteamID64().."'" )
--    else
--       sql.Query( "INSERT INTO ttt_top_players_today( S64, score, nick ) VALUES( '"..ply:SteamID64().."', '"..today_score.."', '"..ply:Nick().."' )" )
--    end

-- end)


-- hook.Add("ShutDown", "Top10.SavePlayersCHangeLevelOrShutDown", function ()
--    for k,v in pairs (player.GetAll()) do
--       local score = v:GetNWInt("PlayerScore")
--       local today_score = v:GetNWInt("TodayPlayerScore")
--       local query = sql.Query("SELECT score FROM ttt_top_players WHERE S64 = '"..v:SteamID64().."'")
--          if (query) then
--          sql.Query( "UPDATE ttt_top_players SET score = '"..score.."' WHERE S64 = '"..v:SteamID64().."'" )
--             print ("[TOP10 SHUTDOWN] Saved "..score.." for player "..v:Nick().."(update)")
--          else
--             sql.Query( "INSERT INTO ttt_top_players( S64, score, nick ) VALUES( '"..v:SteamID64().."', '"..score.."', '"..v:Nick().."' )" )
--             print ("[TOP10 SHUTDOWN] Saved "..score.." for player "..v:Nick().." (insert)")
--          end

--       local query_today = sql.Query("SELECT score FROM ttt_top_players_today WHERE S64 = '"..v:SteamID64().."'")
--       if query_today then
--          sql.Query( "UPDATE ttt_top_players_today SET score = '"..today_score.."' WHERE S64 = '"..v:SteamID64().."'" )
--       else
--          sql.Query( "INSERT INTO ttt_top_players_today( S64, score, nick ) VALUES( '"..v:SteamID64().."', '"..today_score.."', '"..v:Nick().."' )" )
--       end

--    end
-- end)  

util.AddNetworkString("TOP10.ScoreList")
util.AddNetworkString("TOP10.GetScoreList")
util.AddNetworkString("TOP10.OpenScoreList")

net.Receive("TOP10.GetScoreList", function (len, ply)
   -- if ply.ScoreListOpened and ply.ScoreListOpened > CurTime() then
   --    net.Start("TOP10.OpenScoreList")
   --    net.Send(ply)
   -- else
      local info_all_time = sql.Query('SELECT * FROM ttt_top_players ORDER BY score DESC LIMIT 10;')
      local info_today = sql.Query('SELECT * FROM ttt_top_players_today ORDER BY score DESC LIMIT 10;')
      net.Start("TOP10.OpenScoreList")
      net.WriteTable(info_all_time)
      net.WriteTable(info_today)
      net.Send(ply)

      ply.ScoreListOpened = CurTime() + 60
   -- end
end)

-- hook.Add("TTTPrepareRound", "TOP10.SendingTOP10", function ()
--    local query = sql.Query('SELECT * FROM ttt_top_players_today ORDER BY score DESC LIMIT 10;')

--    net.Start("TOP10.ScoreList")
--    net.WriteTable(query)
--    net.Broadcast()

-- end)

util.AddNetworkString("chatSound.Play")

local chat_sounds = {
   ["swamp"] = "https://www.myinstants.com/media/sounds/what-are-you-doing-in-my-swamp-.mp3",
   -- ["fail"] = "https://www.myinstants.com/media/sounds/fail-sound-effect.mp3",
   ["oof"] = "https://www.myinstants.com/media/sounds/roblox-death-sound_1.mp3",
   ["shut up"] = "https://www.myinstants.com/media/sounds/shut-the-fuck-up.mp3",
   ["gay"] = "https://www.myinstants.com/media/sounds/ha-gay.mp3",
   ["hello"] = "https://www.myinstants.com/media/sounds/hello_motherfrucker.mp3",
   ["suprise"] = "https://www.myinstants.com/media/sounds/surprise-motherfucka.mp3",
   ["yeet"] = "https://www.myinstants.com/media/sounds/yeet.mp3",
   ["why you bully me"] = "https://www.myinstants.com/media/sounds/why-you-bully-me_tAonLVq.mp3",
   ["fuck up"] = "https://www.myinstants.com/media/sounds/itwasatthismomentthatheknewhefckedupsoundeffectmusic.mp3",
   ["bruh"] = "https://www.myinstants.com/media/sounds/movie_1.mp3",
   ["what the fuck is that"] = "https://www.myinstants.com/media/sounds/what-the-fuck.mp3",
   ["nope"] = "https://www.myinstants.com/media/sounds/engineer_no01.mp3",
   ["tuturu"] = "https://www.myinstants.com/media/sounds/tuturu_1.mp3",
   ["fbi"] = "https://www.myinstants.com/media/sounds/fbi-open-up-sfx.mp3",
   ["gg"] = "https://www.myinstants.com/media/sounds/gg.mp3",
   ["nice"] = "https://www.myinstants.com/media/sounds/nioce.mp3",
   ["run"] = "https://www.myinstants.com/media/sounds/run-bitch-ruun-mp3cut.mp3",
   ["why are you running"] = "https://www.myinstants.com/media/sounds/why-are-you-running-original-vine-audiotrimmer_pJyxLm1.mp3",
   ["nani"] = "https://www.myinstants.com/media/sounds/nani_mkANQUf.mp3",
   ["hadoken"] = "https://www.myinstants.com/media/sounds/hadouken.mp3",
   ["alert"] = "https://www.myinstants.com/media/sounds/tindeck_1.mp3",
   ["barrel roll"] = "https://www.myinstants.com/media/sounds/peproll1.mp3",
   ["hello there"] = "https://www.myinstants.com/media/sounds/obi-wan-hello-there.mp3",
   ["довн"] = "https://www.myinstants.com/media/sounds/untitled_994.mp3",
   ['hurt'] = "https://www.myinstants.com/media/sounds/classic_hurt.mp3",
   ["get that"] = "https://www.myinstants.com/media/sounds/get-that-motherfucker.mp3",
   ["fuck you"] = "https://www.myinstants.com/media/sounds/fuck-you-ashole_22.mp3",
   ["holy shit"] = "https://www.myinstants.com/media/sounds/hfs.mp3",
   ["не фортануло"] = "https://www.myinstants.com/media/sounds/.mp3_EJEYxUZ",
   ["Сильное заявление"] = "https://www.myinstants.com/media/sounds/.mp3_7WGnznL",
   ["ты дурак?"] = "https://www.myinstants.com/media/sounds/.mp3_75MSZkZ",
   ["У вас чича!"] = "https://www.myinstants.com/media/sounds/.mp3_3fuTVQ8",
   ["Это шедевр!"] = "https://www.myinstants.com/media/sounds/.mp3_ZYP2iOm",
   ["nya"] = "https://www.myinstants.com/media/sounds/nyaa-3.mp3",
   ["gnome"] = "https://www.myinstants.com/media/sounds/im-a-gnome-meme-sound-effect-woo.mp3",
   ["Привет"] = "https://www.myinstants.com/media/sounds/-audiotrimmer_6I1UY0j.mp3",
   ["error"] = "https://www.myinstants.com/media/sounds/error_CDOxCYm.mp3",
   ["пошли они нахуй"] = "https://www.myinstants.com/media/sounds/v1lat-cut-mp3.mp3",
   ["что блять?"] = "https://www.myinstants.com/media/sounds/a_Yp3NngD.mp3",
   ["uwu"] = "https://www.myinstants.com/media/sounds/voiceload-edd0de80b3.mp3",
   -- ["creeper"] = "https://wwwww.myinstants.com/media/sounds/revenge3.mp3",
}

-- hook.Add("Discord_ShouldRelay", "stopSendingSomeMessagesToDiscord", function (text, ply)
--    if chat_sounds[string.lower(text)] then return false end
--    if admin_sounds[string.lower(text)] then return false end
--    return true
-- end)

hook.Remove("Discord_ShouldRelay", "stopSendingSomeMessagesToDiscord")


local admin_sounds = {
   ["hit or miss"] = "https://www.myinstants.com/media/sounds/hit-or-miss.mp3",
   ["срать тебе на голову"] = "https://www.myinstants.com/media/sounds/spigun.mp3"
}
hook.Add("PlayerSay", "AdminSpeaker", function (sender, text, chat_t)
   -- if not sender:IsSuperAdmin() or sender:GetUserGroup() != "vip" then return end
   if sender:GetUserGroup() == "vip" or sender:IsSuperAdmin() then
      if admin_sounds[string.lower(text)] and not sender:GetNetworkedBool("serverguard_muted") and not chat_t then
         if sender:Alive() then
            net.Start("chatSound.Play")
            net.WriteString(admin_sounds[string.lower(text)])
            net.WriteEntity(sender)
            net.Broadcast()
         else
            for k,v in pairs (player.GetAll()) do
               if not v:Alive() then
                  net.Start("chatSound.Play")
                  net.WriteString(admin_sounds[string.lower(text)])
                  net.WriteEntity(sender)
                  net.Send(v)
               end
            end
         end
      end
   end
end)


-- string.lower(string str)

hook.Add("PlayerSay", "PlayersChatSound", function (sender, text, chat_t)
   if chat_sounds[string.lower(text)] and not sender:GetNetworkedBool("serverguard_muted") and not chat_t then
      if sender:Alive() then
         net.Start("chatSound.Play")
         net.WriteString(chat_sounds[string.lower(text)])
         net.WriteEntity(sender)
         net.Broadcast()
      else
         for k,v in pairs (player.GetAll()) do
            if not v:Alive() then
               net.Start("chatSound.Play")
               net.WriteString(chat_sounds[string.lower(text)])
               net.WriteEntity(sender)
               net.Send(v)
            end
         end
      end
   end
end)



// Spawn Random Weapons

-- hook.Add("OnGamemodeLoaded", "AddSomeSpawns", function ()
   -- if sql.TableExists("ttt_placer_weapons") then
   --    print ("[PLACER] DB already created")
   -- else
   --    sql.Query("CREATE TABLE ttt_placer_weapons(map, pos)")
   --    print ("[PLACER] DB was created!")
   -- end
-- end)




-- game.GetMap()

-- hook.Add("TTTPrepareRound", "HelloWorld", function ()
--    local query = sql.Query("SELECT pos FROM ttt_placer_weapons WHERE map = '"..game.GetMap().."'")
   
--    if query then
--       for k,v in pairs (query) do
--          local q = ents.Create("ttt_random_weapon")
--          q:SetPos(Vector(v.pos))
--          q.AutoAmmo = 2
--          q:Spawn()
--       end
--    end
-- end)


-- hook.Add("PlayerInitialSpawn","Top10.DiscordJoinedInitalHook",function (ply)
--    if ply:IsBot() then return end
--    local query = sql.Query("SELECT joined FROM ttt_discord_join WHERE S64 = '"..ply:SteamID64().."'")
--    if (query) then
--          ply:SetNWBool("DiscordJoined", query[1].joined )
--    else
--          sql.Query( "INSERT INTO ttt_discord_join( S64, joined) VALUES( '"..ply:SteamID64().."', 'false')")
--       end
-- end)





-- concommand.Add("trace_random", function (ply)
--    if ply:IsSuperAdmin() then
--    if not sql.TableExists("ttt_placer_weapons") then return ply:ChatPrint("ДБ нету дэбил") end
--       local info = sql.Query("INSERT INTO ttt_placer_weapons( map, pos) VALUES( '"..game.GetMap().."', '"..tostring(ply:GetPos()).."')")
--       if info then
--          ply:ChatPrint("Saved!")
--       else
--          ply:ChatPrint(tostring(info))
--       end
--    end
-- end)

hook.Add("EntityTakeDamage", "damageInformer", function (target, dmginfo)
   if target:IsValid() and target:IsPlayer() then
      local damage_dealer = dmginfo:GetAttacker()
      if not damage_dealer:IsValid() and not damage_dealer:IsPlayer() then return end
      if damage_dealer:IsPlayer() then
         if damage_dealer:GetNWInt("DamageDealedToPlayer") > 0 then
            damage_dealer:SetNWInt("DamageDealedToPlayer", damage_dealer:GetNWInt("DamageDealedToPlayer") + math.ceil(damage_dealer:GetDamageFactor() * dmginfo:GetDamage()))
            damage_dealer.CleanUP = CurTime() + 1
         else
            damage_dealer:SetNWInt("DamageDealedToPlayer", math.ceil(damage_dealer:GetDamageFactor() * dmginfo:GetDamage()))
            damage_dealer.CleanUP = CurTime() + 1
         end
      end
   end
end)

timer.Create("cleanUPimer", 1, 0, function ()
   for k,v in pairs (player.GetAll()) do
      if v:GetNWInt("DamageDealedToPlayer") > 0  and v.CleanUP < CurTime() then
         v:SetNWInt("DamageDealedToPlayer", 0)
      end
   end
end)

// Synh
-- util.AddNetworkString("DonatModels.Synth")
-- util.AddNetworkString("DonatModels.OpenMenu")
util.AddNetworkString("OpenRulesMenu")
util.AddNetworkString("OpenAchivkiMenu")

hook.Add("PlayerSay", "modelsMenu", function (ply, text)
   if ply:IsValid() and string.find(text, "/rules") then
      ply:ConCommand("rules_url_open")
   end

   -- if ply:IsValid() and string.find(text, "!ачивки") then
   --    net.Start("OpenAchivkiMenu")
   --    net.Send(ply)
   -- end
end)


function timeToStr( time )
   local tmp = time
   local s = tmp % 60
   tmp = math.floor( tmp / 60 )
   local m = tmp % 60
   tmp = math.floor( tmp / 60 )
   local h = tmp % 24
   tmp = math.floor( tmp / 24 )
   local d = tmp % 7
   local w = math.floor( tmp / 7 )

   return string.format( "%02iw %id %02ih %02im %02is", w, d, h, m, s )
end

// Prefix shit

local prefix_table = {}
local next_synth = CurTime() + 2
local allowed_groups = {
	["founder"] = true,
	["sponsor"] = true,
}

-- local allowed_steamid = {
	-- [""]
-- }


hook.Add("OnGamemodeLoaded", "ttt.PrefixModels", function ()
    if sql.TableExists("ttt_chat_prefix") then
      print ("[PrefixDB] DB already created")
   else
      sql.Query("CREATE TABLE ttt_chat_prefix( type, S64, prefix_group, prefix_name, prefix_color)")
      print ("[PrefixDB] DB was created!")
   end

   local query_synth = sql.Query("SELECT * FROM ttt_chat_prefix")

   prefix_table = query_synth or {}


end)



util.AddNetworkString("ttt.AddNewSteamIDPrefix")
util.AddNetworkString("ttt.AddNewGroupPrefix")
util.AddNetworkString("ttt.SynthPrefixTable")
util.AddNetworkString("ttt.OpenPrefixAdminMenu")
util.AddNetworkString("ttt.RemoveChatPrefix")



net.Receive("ttt.RemoveChatPrefix", function (len, ply)
   -- if not ply:IsSuperAdmin() then return end
   if not allowed_groups[ply:GetUserGroup()] then return end
   local id_type, target = net.ReadInt(3), net.ReadString()

   if id_type == 0 then
      sql.Query("DELETE FROM ttt_chat_prefix WHERE prefix_group = '"..target.."'")
      ply:ChatPrint("Удалено")
   elseif id_type == 1 then
      sql.Query("DELETE FROM ttt_chat_prefix WHERE S64 = '"..target.."'")
      ply:ChatPrint("Удалено")
   end

   SynthPrefix()

end)




hook.Add("PlayerSay", "ttt.OpenPrefixAdminMenu", function (ply, text)
   if not allowed_groups[ply:GetUserGroup()] then return end
   if text == "!prefix" then
      net.Start("ttt.OpenPrefixAdminMenu")
      net.WriteTable(prefix_table)
      net.Send(ply)
   end
end)




hook.Add("PlayerInitialSpawn", "ttt.PrefixSetupPlayer", function (ply)
   timer.Simple(1, function ()
      net.Start("ttt.SynthPrefixTable")
      net.WriteTable(prefix_table)
      net.Send(ply)
   end)
end)




function SynthPrefix()
   if next_synth > CurTime() then return end

   // Не знаю почему так. Лол
   prefix_table = {}

   local query_synth = sql.Query("SELECT * FROM ttt_chat_prefix")


   prefix_table = query_synth or {}

   net.Start("ttt.SynthPrefixTable")
   net.WriteTable(prefix_table)
   net.Broadcast()

   print ("[PrefixSynth] Synh all!")

   next_synth = CurTime() + 2
end





net.Receive("ttt.AddNewSteamIDPrefix", function (len, ply)
   -- if not ply:IsSuperAdmin() then return end
   if not allowed_groups[ply:GetUserGroup()] then return end

   local sid, prefix_name, color = net.ReadString(), net.ReadString(), net.ReadColor()

   local query = sql.Query("SELECT type FROM ttt_chat_prefix WHERE sid = '"..sid.."'")

   if query then return ply:ChatPrint("Игрок с таким STEAM ID уже есть в БД") end

   sql.Query( "INSERT INTO ttt_chat_prefix( type, S64, prefix_name, prefix_color ) VALUES( '1', '"..sid.."', '"..prefix_name.."', '"..string.FromColor(color).."')" )

   ply:ChatPrint("Успешно установлен префикс по стим иду")

   SynthPrefix()

end)


net.Receive("ttt.AddNewGroupPrefix", function (len, ply)
   -- if not ply:IsSuperAdmin() then return end
   if not allowed_groups[ply:GetUserGroup()] then return end

   local group_name, prefix_name, color = net.ReadString(), net.ReadString(), net.ReadColor()

   local query = sql.Query("SELECT type FROM ttt_chat_prefix WHERE group = '"..group_name.."'")

   if query then return ply:ChatPrint("У группы уже установлен префикс. Удалите его и создайте снова") end

   sql.Query( "INSERT INTO ttt_chat_prefix( type, prefix_group, prefix_name, prefix_color ) VALUES( '0', '"..group_name.."', '"..prefix_name.."', '"..string.FromColor(color).."')" )

   ply:ChatPrint("Успешно установлен префикс по группе")

   SynthPrefix()

end)


util.AddNetworkString("ttt.PrettyPrintString")



// VIP Players Stuff
-- ttt_vip_players

function sendYourTime(ply)
   if ply:IsValid() then
      net.Start("ttt.PrettyPrintString")
      net.WriteString("За все сервера вы отыграли : "..timeToStr(ply:GetUTimeTotalTime()))
      net.Send(ply)
   end
end

hook.Add("PlayerSay", "showMyTimePlease", function (ply, text)
   -- if string.find(test
   if text == "!mytime" then
      sendYourTime(ply)
   end
end)

function MsgToPlayer(str, target)
   if str then
      net.Start("ttt.PrettyPrintString")
      net.WriteString(str)
      if target then
         net.Send(target)
      else
         net.Broadcast()
      end
   end
end


local vip_groups = {
   ["premium"] = true,
   ["vip"] = true,
   ["founder"] = true,
   ["superadmin"] = true,
}

hook.Add("PlayerInitialSpawn", "TTT.VipCheck", function (ply)
   if vip_groups[ply:GetUserGroup()] then
      local info = sql.Query("SELECT timeLeft FROM ttt_vip_players WHERE S64 = '"..ply:SteamID64().."'")
      if info and info[1].timeLeft then
         ply:SetNWInt("TraitorAbuse", info[1].timeLeft)
      else
         sql.Query( "INSERT INTO ttt_vip_players(S64, timeLeft) VALUES ('"..ply:SteamID64().."', '"..os.time().."')")
         ply:SetNWInt("TraitorAbuse", os.time())
      end
   end
end)

concommand.Add("ttt_make_me_traitor_please", function (ply, cmd, arg)
   if vip_groups[ply:GetUserGroup()] then
      if not GetRoundState() == ROUND_PREP then return MsgToPlayer("В данный момент вы не можете стать предателем!", ply) end
      if ply:GetNWInt("TraitorAbuse") == 0 or tostring(os.time()) >= tostring(ply:GetNWInt("TraitorAbuse")) then
         ply:SetNWInt("TraitorAbuse", (os.time() + 1800))
         sql.Query( "UPDATE ttt_vip_players SET timeLeft = '"..(os.time() + 1800).."' WHERE S64 = '"..ply:SteamID64().."'" )
         
         timer.Create(ply:UniqueID().."traitor", 1, 0, function ()
            if GetRoundState() == 3 then
               ply:SetRole(ROLE_TRAITOR);
               SendFullStateUpdate();
               timer.Destroy(ply:UniqueID().."traitor")
               MsgToPlayer("Пссс, мы сделали вас трейтором т.к вы этого захотели.", ply)
            end
         end)
         MsgToPlayer("Вы использовали свою возможность стать трейтором. Следующая возможность через 30 минут!", ply)
      else
         MsgToPlayer("У вас превышен лимит. Попробуйте через 30 минут!", ply)
      end
   end
end)





// Achivki

-- local nw_table = {}
-- local upd_table_2 = {}
-- local upd_table = {}

-- hook.Add("OnGamemodeLoaded", "ttt.AchivkiDat", function ()
--    if not sql.TableExists("ttt_achivment_data") then
--       sql.Query("CREATE TABLE ttt_achivment_data ( S64, achivki_data, achivki_completed)")
--       print ("[Achivment] DB Created!")
--    end



--    for k,v in pairs (achivki_table) do
--       hook.Add(v.shook, v.achiv_name, v.shook_func)
--       table.insert(nw_table, v.NW_To_Check)
--    end
-- end)


-- hook.Add("PlayerDisconnected", "ttt.AchivmentSaveDisconnect", function (ply)
--    if ply:IsValid() then
--       upd_table = {}
--       for _,v in pairs (nw_table) do
--          upd_table[v] = ply:GetNWInt(v)
--       end

--       local query = sql.Query("SELECT achivki_completed FROM ttt_achivment_data WHERE S64 = '"..ply:SteamID64().."'")
--       if query then
--          sql.Query( "UPDATE ttt_achivment_data SET achivki_data = '"..util.TableToJSON(upd_table).."' WHERE S64 = '"..ply:SteamID64().."'" )
--       else
--          sql.Query( "INSERT INTO ttt_achivment_data( S64, achivki_data, achivki_completed ) VALUES( '"..ply:SteamID64().."', '"..util.TableToJSON(upd_table).."', '"..util.TableToJSON({}).."')" )
--       end
--    end
-- end)


-- hook.Add("ShutDown", "ttt.AchivmentSaveShutDown", function ()
--    for _, v in pairs (player.GetAll()) do
--       if v:IsValid() then
--          upd_table_2 = {}
--          for _,w in pairs (nw_table) do
--             upd_table_2[w] = v:GetNWInt(w)
--          end

--          local query = sql.Query("SELECT achivki_completed FROM ttt_achivment_data WHERE S64 = '"..v:SteamID64().."'")
--          if query then
--             local cs_q = sql.Query( "UPDATE ttt_achivment_data SET achivki_data = '"..util.TableToJSON(upd_table_2).."' WHERE S64 = '"..v:SteamID64().."'" )
--          else
--             for i=0, 10 do
--                print ("Something went terrobly wrong!")
--             end
--          end
--       end
--    end
-- end)




-- hook.Add("PlayerInitialSpawn", "achivki_DataLoading", function (ply)
--    if ply:IsValid() then
--       local query = sql.Query("SELECT achivki_data FROM ttt_achivment_data WHERE S64 = '"..ply:SteamID64().."'")
--       if query then
--          local db = util.JSONToTable(query[1].achivki_data)
--          for k,v in pairs (db) do
--             ply:SetNWInt(k, v)
--          end
--       else
--          local upd_table_2 = {""}
--          for _,w in pairs (nw_table) do
--             upd_table_2[w] = ply:GetNWInt(w)
--          end
--          sql.Query( "INSERT INTO ttt_achivment_data( S64, achivki_data, achivki_completed) VALUES( '"..ply:SteamID64().."', '"..util.TableToJSON(upd_table_2).."', '"..util.TableToJSON({}).."')")
--       end

--       local query_2 = sql.Query("SELECT achivki_completed FROM ttt_achivment_data WHERE S64 = '"..ply:SteamID64().."'")
      

--       if query_2[1].achivki_completed != "NULL" then
--          db = util.JSONToTable(query_2[1].achivki_completed)
--       else
--          db = {""}
--       end

--       net.Start("ttt.SynthUnlockedAchivments")
--       net.WriteTable(db)
--       net.Send(ply)
--    end
-- end)


-- util.AddNetworkString("ttt.AchivmentReadyToGo")
-- util.AddNetworkString("ttt.PrettyPrintAchivment")
-- util.AddNetworkString("ttt.SynthUnlockedAchivments")


-- // govno kod
-- net.Receive("ttt.AchivmentReadyToGo", function (len, ply)
--    print (ply:Nick().." sended us [ttt.AchivmentReadyToGo]")
--    local str = net.ReadString()
--    local contine = false
--    local db = {}
--    local new_db = {}


--    for k,v in pairs (achivki_table) do
--       if v.achiv_name == str and ply:GetNWInt(v.NW_To_Check) >= v.goal then
--          contine = true
--          local query = sql.Query("SELECT achivki_completed FROM ttt_achivment_data WHERE S64 = '"..ply:SteamID64().."'")
--          db = util.JSONToTable(query[1].achivki_completed)
--          if query[1].achivki_completed == "NULL" or not db[v.achiv_name] then
--             if query[1].achivki_completed == "NULL" then
--                new_db[str] = true
--             else
--                new_db = db
--                new_db[str] = true
--             end

--             sql.Query( "UPDATE ttt_achivment_data SET achivki_completed = '"..util.TableToJSON(new_db).."' WHERE S64 = '"..ply:SteamID64().."'" )
            
--             net.Start("ttt.PrettyPrintAchivment")
--             net.WriteString(ply:Nick())
--             net.WriteString(k)
--             net.Broadcast()

--             net.Start("ttt.SynthUnlockedAchivments")
--             net.WriteTable(new_db)
--             net.Send(ply)
--          else
--             ply:ChatPrint ("[Ошибка] Вы уже выполнили это достижение")
--          end
--       end
--    end

--    if not contine then
--       ply:ChatPrint("Вы не можете выполнить эту ачивку")
--    end
-- end)



// Admin Onnline
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

 local groups = {
   ["nabor_admin"] = true,
   ["founder"] = true,
   ["sponsor"] = true,
   ["manager"] = true,
}

local acces_menu = {
   ["founder"] = true,
}


hook.Add("OnGamemodeLoaded", "AdminDBOnline", function ()
   local q = sql.Query( "CREATE TABLE IF NOT EXISTS online_admnins( SteamID TEXT, Nick TEXT, UserGroup TEXT, Monday TEXT, Tuesday TEXT, Wednesday TEXT, Thursday TEXT, Friday TEXT, Saturday TEXT, Sunday TEXT )" )
   print ('[Admin Online] DB has been created or not...idk')
end)

-- PlayerInitialSpawn
hook.Add("PlayerInitialSpawn", "AdminDBInitialSpawn", function (ply)
   // Какой-то ебаный бред.
   // Почему-то сервер не успевает устанавливать группу игроку. Я даже функцию медленно сделал.
   // Однохуйственно. Ладно, похуй.
   timer.Simple(1, function ()
      print ("[A-ONLINE] Player "..ply:Nick().." connected!")
         if groups[ply:GetUserGroup()] then
         print ("[A-ONLINE] Player "..ply:Nick().." passed groups check")
         local Timestamp = os.time()
         local day_of_week = os.date( "%A" , Timestamp )
         // Фиксим то что дни недели не совпадают.
         ply.day_of_week = day_of_week
         print ("[A-ONLINE] Setted day of the week")
         local s = sql.Query("SELECT UserGroup FROM online_admnins WHERE SteamID = '"..ply:SteamID().."'")
         if not s then
            local q_s = sql.Query( "INSERT INTO online_admnins( SteamID, Nick, UserGroup, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday  ) VALUES( '"..ply:SteamID().."','"..ply:Nick().."', '"..ply:GetUserGroup().."', 0, 0, 0, 0, 0, 0, 0 )" )
            print ("[A-ONLIE] Inserted!")
            -- ply:ChatPrint("[БД] Ваш админ аккаунт был занесен в Бд. Удачи админить.")
            MsgToPlayer("Ваш админ аккаунт был занесен в базу данных. Удачи админить", ply)
         else
            MsgToPlayer("Ваш аккаунт уже существует в базе данных.", ply)
         end
      end
   end)
end)

-- hook.Add("PlayerDisconnected", "AdminDBDisconnectFromServer", function (ply)
--    -- if groups[ply:GetUserGroup()] then
--    if table.HasValue(groups, ply:GetUserGroup()) then
--       local session_time = ply:GetUTimeSessionTime()
--       local total_today = sql.Query("SELECT "..ply.day_of_week.." FROM online_admnins WHERE SteamID = '"..ply:SteamID().."'")

--       sql.Query("UPDATE online_admnins SET "..ply.day_of_week.." = '"..total_today[1][ply.day_of_week].."' + '"..session_time.."' WHERE SteamID = '"..ply:SteamID().."'")
--       print ("[A-ONLIE] UPDATE!")
--    end

-- end)


-- hook.Add("ShutDown", "AdminDBOnChangeMap", function ()
--    for _, pl in pairs(player.GetAll()) do
--       if table.HasValue(groups, pl:GetUserGroup()) then
--          local session_time = pl:GetUTimeSessionTime()
--          local total_today = sql.Query("SELECT "..pl.day_of_week.." FROM online_admnins WHERE SteamID = '"..pl:SteamID().."'")

--          sql.Query("UPDATE online_admnins SET "..pl.day_of_week.." = '"..total_today[1][pl.day_of_week].."' + '"..session_time.."' WHERE SteamID = '"..pl:SteamID().."'")
--          print ("[A-ONLIE] UPDATE!")
--       end
--    end
-- end)


timer.Create("CountingAdminOnline", 60, 0, function ()
   for _, pl in pairs(player.GetAll()) do
      if groups[pl:GetUserGroup()] then
         if not pl:GetForceSpec() == true then
            local session_time = pl:GetUTimeSessionTime()
            local total_today = sql.Query("SELECT "..pl.day_of_week.." FROM online_admnins WHERE SteamID = '"..pl:SteamID().."'")

            sql.Query("UPDATE online_admnins SET "..pl.day_of_week.." = '"..total_today[1][pl.day_of_week].."' + '"..session_time.."' WHERE SteamID = '"..pl:SteamID().."'")
            print ("[A-ONLINE] Admin "..pl:Nick().."["..pl:SteamID().."] was updated in DB")
            pl:UpdateSessionTime()
         else
            print ("[A-ONLINE] Admin "..pl:Nick().."["..pl:SteamID().."] currently in spectators. Ignoring him...")
         end
      end
   end
end)


util.AddNetworkString("open_online_menu")
util.AddNetworkString("admins.WipeDB")


net.Receive("admins.WipeDB", function (len, ply)
   if acces_menu[ply:GetUserGroup()] then
      local query_wipe = sql.Query("DROP TABLE online_admnins")
      local query_create = sql.Query( "CREATE TABLE IF NOT EXISTS online_admnins( SteamID TEXT, Nick TEXT, UserGroup TEXT, Monday TEXT, Tuesday TEXT, Wednesday TEXT, Thursday TEXT, Friday TEXT, Saturday TEXT, Sunday TEXT )" )

      ply:ChatPrint("[SERVER] База данных вернула на запрос вайпа вернула "..tostring(query_wipe))
      ply:ChatPrint("[SERVER] Базы данных вернула на запрос о создании базы данных "..tostring(query_create))

      for k,v in pairs (player.GetAll()) do
         -- if table.HasValue(groups, v:GetUserGroup()) then
         if groups[v:GetUserGroup()] then
            local q_s = sql.Query( "INSERT INTO online_admnins( SteamID, Nick, UserGroup, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday  ) VALUES( '"..v:SteamID().."','"..v:Nick().."', '"..v:GetUserGroup().."', 0, 0, 0, 0, 0, 0, 0 )" )
            print ("[A-ONLIE] Inserted!")
         end
      end

      ply:ChatPrint("[SERVER] Так же скрипт занес всех активных в данный момент админов в БД.")
   end
end)

hook.Add("PlayerSay", "open_online_menu", function (ply, text)
      if acces_menu[ply:GetUserGroup()] then
      if text == "!aonline" then
         local s = sql.Query("SELECT * FROM online_admnins")
         net.Start("open_online_menu")
         net.WriteTable(s)
         net.Send(ply)
      end
   end
end)

hook.Add("PlayerSay", "discordOpenURL", function (ply, text)
   if text == "!discord" then
      ply:ConCommand("discord_open_url")
      MsgToPlayer("Сейчас вам откроется браузер нашего дискорда. Если не вы можете его открыть, в CTRL+V залита ссылка на дискорд", ply)
   end

   if text == "!css" then
      ply:ConCommand("css_content_url")
      MsgToPlayer("Сейчас вам откроется браузер с контентом CSS", ply)
   end
end)

-- util.AddNetworkString("openDiscordURL")



// debug hooks
hook.Add("TTTOrderedEquipment", "debugeEqupiment", function(ply, eq, is_item)
	print ("[Order DEBUG] Player "..ply:Nick().."["..ply:SteamID().."] has bought item "..tostring(eq))
end)



// Some shitty anti-prop kill shit
hook.Add("EntityTakeDamage", "AntiPropKillDamnBoy", function(target, dmginfo)
   if not IsValid(target) or not target:IsPlayer() or not dmginfo:IsDamageType(DMG_CRUSH) then return end

   if target:Alive() and target:IsTerror() then
      dmginfo:ScaleDamage(0)
   end
end)


// Anti-Voice Flood
// In test!
timer.Create("antiVoiceFloodForRias", 5, 0, function ()
   if #player.GetAll() >= 15 and GetConVar("ttt_voice_drain"):GetInt() == 0 then
      RunConsoleCommand("ttt_voice_drain", "1")
      print ("[Voice Controll] Voice cheks enabled")
      MsgToPlayer("Из-за большого количества игроков была включена система энергии голосового чата.")
      MsgToPlayer("Система контроля голоса начнет работать сразу же после конца раунда.")
   elseif #player.GetAll() < 15 and GetConVar("ttt_voice_drain"):GetInt() == 1 then
      RunConsoleCommand("ttt_voice_drain", "0")
      print ("[Voice Controll] Voice cheks disabled.")
      MsgToPlayer("Система энергии голосового чата была выключена.")
      MsgToPlayer("Ограничения на голосовой чат сняты.")
   end
end)