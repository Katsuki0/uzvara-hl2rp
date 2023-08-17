-- Game report

include("cl_awards.lua")

local table = table
local string = string
local vgui = vgui
local pairs = pairs

CLSCORE = {}
CLSCORE.Events = {}
CLSCORE.Scores = {}
CLSCORE.TraitorIDs = {}
CLSCORE.DetectiveIDs = {}
CLSCORE.Players = {}
CLSCORE.StartTime = 0
CLSCORE.Panel = nil



local top_round = {}

CLSCORE.EventDisplay = {}

local skull_icon = Material("HUD/killicons/default")

surface.CreateFont("WinHuge", {font = "Trebuchet24",
                               size = 72,
                               weight = 1000,
                               shadow = true})

-- so much text here I'm using shorter names than usual
local T = LANG.GetTranslation
local PT = LANG.GetParamTranslation

function CLSCORE:GetDisplay(key, event)
   local displayfns = self.EventDisplay[event.id]
   if not displayfns then return end
   local keyfn = displayfns[key]
   if not keyfn then return end

   return keyfn(event)
end

function CLSCORE:TextForEvent(e)
   return self:GetDisplay("text", e)
end

function CLSCORE:IconForEvent(e)
   return self:GetDisplay("icon", e)
end

function CLSCORE:TimeForEvent(e)
   local t = e.t - self.StartTime
   if t >= 0 then
      return util.SimpleTime(t, "%02i:%02i")
   else
      return "     "
   end
end

-- Tell CLSCORE how to display an event. See cl_scoring_events for examples.
-- Pass an empty table to keep an event from showing up.
function CLSCORE.DeclareEventDisplay(event_id, event_fns)
   -- basic input vetting, can't check returned value types because the
   -- functions may be impure
   if not tonumber(event_id) then
      Error("Event ??? display: invalid event id\n")
   end
   if (not event_fns) or not istable(event_fns) then
      Error(Format("Event %d display: no display functions found.\n", event_id))
   end
   if not event_fns.text then
      Error(Format("Event %d display: no text display function found.\n", event_id))
   end
   if not event_fns.icon then
      Error(Format("Event %d display: no icon and tooltip display function found.\n", event_id))
   end

   CLSCORE.EventDisplay[event_id] = event_fns
end

function CLSCORE:FillDList(dlst)

   for k, e in pairs(self.Events) do

      local etxt = self:TextForEvent(e)
      local eicon, ttip = self:IconForEvent(e)
      local etime = self:TimeForEvent(e)

      if etxt then
         if eicon then
            local mat = eicon
            eicon = vgui.Create("DImage")
            eicon:SetMaterial(mat)
            eicon:SetTooltip(ttip)
            eicon:SetKeepAspect(true)
            eicon:SizeToContents()
         end


         dlst:AddLine(etime, eicon, "  " .. etxt)
      end
   end
end

function CLSCORE:BuildEventLogPanel(dpanel)
   local margin = 10

   local w, h = dpanel:GetSize()

   local dlist = vgui.Create("DListView", dpanel)
   dlist:SetPos(0, 0)
   dlist:SetSize(w, h - margin*2)
   dlist:SetSortable(true)
   dlist:SetMultiSelect(false)

   local timecol = dlist:AddColumn(T("col_time"))
   local iconcol = dlist:AddColumn("")
   local eventcol = dlist:AddColumn(T("col_event"))

   iconcol:SetFixedWidth(16)
   timecol:SetFixedWidth(40)

   -- If sortable is off, no background is drawn for the headers which looks
   -- terrible. So enable it, but disable the actual use of sorting.
   iconcol.Header:SetDisabled(true)
   timecol.Header:SetDisabled(true)
   eventcol.Header:SetDisabled(true)

   self:FillDList(dlist)
end

function CLSCORE:BuildScorePanel(dpanel)
   local margin = 10
   local w, h = dpanel:GetSize()

   local dlist = vgui.Create("DListView", dpanel)
   dlist:SetPos(0, 0)
   dlist:SetSize(w, h)
   dlist:SetSortable(true)
   dlist:SetMultiSelect(false)

   local colnames = {"", "col_player", "col_role", "col_kills1", "col_kills2", "col_points", "col_team", "col_total"}
   for k, name in pairs(colnames) do
      if name == "" then
         -- skull icon column
         local c = dlist:AddColumn("")
         c:SetFixedWidth(18)
      else
         dlist:AddColumn(T(name))
      end
   end

   -- the type of win condition triggered is relevant for team bonus
   local wintype = WIN_NONE
   for i=#self.Events, 1, -1 do
      local e = self.Events[i]
      if e.id == EVENT_FINISH then
         wintype = e.win
         break
      end
   end

   local scores = self.Scores
   local nicks = self.Players
   local bonus = ScoreTeamBonus(scores, wintype)
   
   -- local top_round = {}
  
   for id, s in pairs(scores) do
      if id != -1 then
         local was_traitor = s.was_traitor
         local role = was_traitor and T("traitor") or (s.was_detective and T("detective") or "Невиновный")

         local surv = ""
         if s.deaths > 0 then
            surv = vgui.Create("ColoredBox", dlist)
            surv:SetColor(Color(150, 50, 50))
            surv:SetBorder(false)
            surv:SetSize(18,18)

            local skull = vgui.Create("DImage", surv)
            skull:SetMaterial(skull_icon)
            skull:SetTooltip("Dead")
            skull:SetKeepAspect(true)
            skull:SetSize(18,18)
         end

         local points_own   = KillsToPoints(s, was_traitor)
         local points_team  = (was_traitor and bonus.traitors or bonus.innos)
         local points_total = points_own + points_team

         
        
         table.insert(top_round, {nicks[id], points_total, s.innos, s.traitors, role })

         local sorting = table.sort( top_round, function( a, b ) return a[2] > b[2] end )

         LocalPlayer().TopRoundNick = top_round[1][1]
         LocalPlayer().TopRoundScore = top_round[1][2]
         LocalPlayer().TopKillInno = top_round[1][3]
         LocalPlayer().TopKillTraitors = top_round[1][4]
         LocalPlayer().TopRole = top_round[1][5]


         local l = dlist:AddLine(surv, nicks[id], role, s.innos, s.traitors, points_own, points_team, points_total)

         -- center align
         for k, col in pairs(l.Columns) do
            col:SetContentAlignment(5)
         end

         -- when sorting on the column showing survival, we would get an error
         -- because images can't be sorted, so instead hack in a dummy value
         local surv_col = l.Columns[1]
         if surv_col then
            surv_col.Value = type(surv_col.Value) == "Panel" and "1" or "0"
         end
      end
   end

   PrintTable(top_round)
   dlist:SortByColumn(6)
end


function CLSCORE:AddAward(y, pw, award, dpanel)
   local nick = award.nick
   local text = award.text
   local title = string.upper(award.title)

   local titlelbl = vgui.Create("DLabel", dpanel)
   titlelbl:SetText(title)
   titlelbl:SetFont("TabLarge")
   titlelbl:SizeToContents()
   local tiw, tih = titlelbl:GetSize()

   local nicklbl = vgui.Create("DLabel", dpanel)
   nicklbl:SetText(nick)
   nicklbl:SetFont("DermaDefaultBold")
   nicklbl:SizeToContents()
   local nw, nh = nicklbl:GetSize()

   local txtlbl = vgui.Create("DLabel", dpanel)
   txtlbl:SetText(text)
   txtlbl:SetFont("DermaDefault")
   txtlbl:SizeToContents()
   local tw, th = txtlbl:GetSize()

   titlelbl:SetPos((pw - tiw) / 2, y)
   y = y + tih + 2

   local fw = nw + tw + 5
   local fx = ((pw - fw) / 2)
   nicklbl:SetPos(fx, y)
   txtlbl:SetPos(fx + nw + 5, y)

   y = y + nh

   return y
end

-- double check that we have no nils
local function ValidAward(a)
   return a and a.nick and a.text and a.title and a.priority
end

local wintitle = {
   [WIN_TRAITOR] = {txt = "hilite_win_traitors", c = Color(190, 5, 5, 255)},
   [WIN_INNOCENT] = {txt = "hilite_win_innocent", c = Color(5, 190, 5, 255)}
}

function CLSCORE:BuildHilitePanel(dpanel)
   local w, h = dpanel:GetSize()

   local title = wintitle[WIN_INNOCENT]
   local endtime = self.StartTime
   for i=#self.Events, 1, -1 do
      local e = self.Events[i]
      if e.id == EVENT_FINISH then
         endtime = e.t

         -- when win is due to timeout, innocents win
         local wintype = e.win
         if wintype == WIN_TIMELIMIT then wintype = WIN_INNOCENT end

         title = wintitle[wintype]
         break
      end
   end

   local roundtime = endtime - self.StartTime

   local numply = table.Count(self.Players)
   local numtr = table.Count(self.TraitorIDs)


   local bg = vgui.Create("ColoredBox", dpanel)
   bg:SetColor(Color(50, 50, 50, 255))
   bg:SetSize(w,h)
   bg:SetPos(0,0)

   local winlbl = vgui.Create("DLabel", dpanel)
   winlbl:SetFont("WinHuge")
   winlbl:SetText( T(title.txt) )
   winlbl:SetTextColor(COLOR_WHITE)
   winlbl:SizeToContents()
   local xwin = (w - winlbl:GetWide())/2
   local ywin = 30
   winlbl:SetPos(xwin, ywin)

   bg.PaintOver = function()
                     draw.RoundedBox(8, xwin - 15, ywin - 5, winlbl:GetWide() + 30, winlbl:GetTall() + 10, title.c)
                  end

   local ysubwin = ywin + winlbl:GetTall()
   local partlbl = vgui.Create("DLabel", dpanel)

   local plytxt = PT(numtr == 1 and "hilite_players2" or "hilite_players1",
                     {numplayers = numply, numtraitors = numtr})

   partlbl:SetText(plytxt)
   partlbl:SizeToContents()
   partlbl:SetPos(xwin, ysubwin + 8)

   local timelbl = vgui.Create("DLabel", dpanel)
   timelbl:SetText(PT("hilite_duration", {time= util.SimpleTime(roundtime, "%02i:%02i")}))
   timelbl:SizeToContents()
   timelbl:SetPos(xwin + winlbl:GetWide() - timelbl:GetWide(), ysubwin + 8)

   -- Awards
   local wa = math.Round(w * 0.9)
   local ha = h - ysubwin - 40
   local xa = (w - wa) / 2
   local ya = h - ha

   local awardp = vgui.Create("DPanel", dpanel)
   awardp:SetSize(wa, ha)
   awardp:SetPos(xa, ya)
   awardp:SetPaintBackground(false)

   -- Before we pick awards, seed the rng in a way that is the same on all
   -- clients. We can do this using the round start time. To make it a bit more
   -- random, involve the round's duration too.
   math.randomseed(self.StartTime + endtime)

   -- Attempt to generate every award, then sort the succeeded ones based on
   -- priority/interestingness
   local award_choices = {}
   for k, afn in pairs(AWARDS) do
      local a = afn(self.Events, self.Scores, self.Players, self.TraitorIDs, self.DetectiveIDs)
      if ValidAward(a) then
         table.insert(award_choices, a)
      end
   end

   local num_choices = table.Count(award_choices)
   local max_awards = 5

   -- sort descending by priority
   table.SortByMember(award_choices, "priority")

   -- put the N most interesting awards in the menu
   for i=1,max_awards do
      local a = award_choices[i]
      if a then
         self:AddAward((i - 1) * 42, wa, a, awardp)
      end
   end
end

function CLSCORE:ShowPanel()
   local margin = 15

   local dpanel = vgui.Create("DFrame")
   local w, h = 700, 500
   dpanel:SetSize(700, 500)
   dpanel:Center()
   dpanel:SetTitle(T("report_title"))
   dpanel:SetVisible(true)
   dpanel:ShowCloseButton(true)
   dpanel:SetMouseInputEnabled(true)
   dpanel:SetKeyboardInputEnabled(true)
   dpanel.OnKeyCodePressed = util.BasicKeyHandler

   -- keep it around so we can reopen easily
   dpanel:SetDeleteOnClose(false)
   self.Panel = dpanel

   local dbut = vgui.Create("DButton", dpanel)
   local bw, bh = 100, 25
   dbut:SetSize(bw, bh)
   dbut:SetPos(w - bw - margin, h - bh - margin/2)
   dbut:SetText(T("close"))
   dbut.DoClick = function() dpanel:Close() end

   local dsave = vgui.Create("DButton", dpanel)
   dsave:SetSize(bw,bh)
   dsave:SetPos(margin, h - bh - margin/2)
   dsave:SetText(T("report_save"))
   dsave:SetTooltip(T("report_save_tip"))
   dsave:SetConsoleCommand("ttt_save_events")

   local dtabsheet = vgui.Create("DPropertySheet", dpanel)
   dtabsheet:SetPos(margin, margin + 15)
   dtabsheet:SetSize(w - margin*2, h - margin*3 - bh)
   local padding = dtabsheet:GetPadding()


   -- Highlight tab
   local dtabhilite = vgui.Create("DPanel", dtabsheet)
   dtabhilite:SetPaintBackground(false)
   dtabhilite:StretchToParent(padding,padding,padding,padding)
   self:BuildHilitePanel(dtabhilite)

   dtabsheet:AddSheet(T("report_tab_hilite"), dtabhilite, "icon16/star.png", false, false, T("report_tab_hilite_tip"))

   -- Event log tab
   local dtabevents = vgui.Create("DPanel", dtabsheet)
--   dtab1:SetSize(650, 450)
   dtabevents:StretchToParent(padding, padding, padding, padding)
   self:BuildEventLogPanel(dtabevents)

   dtabsheet:AddSheet(T("report_tab_events"), dtabevents, "icon16/application_view_detail.png", false, false, T("report_tab_events_tip"))

   -- Score tab
   local dtabscores = vgui.Create("DPanel", dtabsheet)
   dtabscores:SetPaintBackground(false)
   dtabscores:StretchToParent(padding, padding, padding, padding)
   self:BuildScorePanel(dtabscores)

   dtabsheet:AddSheet(T("report_tab_scores"), dtabscores, "icon16/user.png", false, false, T("report_tab_scores_tip"))

   dpanel:MakePopup()

   -- makepopup grabs keyboard, whereas we only need mouse
   dpanel:SetKeyboardInputEnabled(false)

   timer.Simple(1, function ()
      if LocalPlayer().MapVoteStarted == true then
         dpanel:Remove()
      end
   end)
end

function CLSCORE:ClearPanel()

   if self.Panel then
      -- move the mouse off any tooltips and then remove the panel next tick

      -- we need this hack as opposed to just calling Remove because gmod does
      -- not offer a means of killing the tooltip, and doesn't clean it up
      -- properly on Remove
      input.SetCursorPos( ScrW()/2, ScrH()/2 )
      local pnl = self.Panel
      timer.Simple(0, function() pnl:Remove() end)
   end
end

function CLSCORE:SaveLog()
   if self.Events and #self.Events <= 0 then
      chat.AddText(COLOR_WHITE, T("report_save_error"))
      return
   end

   local logdir = "ttt/logs"
   if not file.IsDir(logdir, "DATA") then
      file.CreateDir(logdir)
   end

   local logname = logdir .. "/ttt_events_" .. os.time() .. ".txt"
   local log = "Trouble in Terrorist Town - Round Events Log\n".. string.rep("-", 50) .."\n"

   log = log .. string.format("%s | %-25s | %s\n", " TIME", "TYPE", "WHAT HAPPENED") .. string.rep("-", 50) .."\n"

   for _, e in pairs(self.Events) do
      local etxt = self:TextForEvent(e)
      local etime = self:TimeForEvent(e)
      local _, etype = self:IconForEvent(e)
      if etxt then
         log = log .. string.format("%s | %-25s | %s\n", etime, etype, etxt)
      end
   end

   file.Write(logname, log)

   chat.AddText(COLOR_WHITE, T("report_save_result"), COLOR_GREEN, " /garrysmod/data/" .. logname)
end

function CLSCORE:Reset()
   self.Events = {}
   --self.StoredEvents = nil
   self.TraitorIDs = {}
   self.DetectiveIDs = {}
   self.Scores = {}
   self.Players = {}
   self.RoundStarted = 0

   self:ClearPanel()
end

function CLSCORE:Init(events)
   -- Get start time and traitors
   local starttime = nil
   local traitors = nil
   local detectives = nil
   for k, e in pairs(events) do
      if e.id == EVENT_GAME and e.state == ROUND_ACTIVE then
         starttime = e.t
      elseif e.id == EVENT_SELECTED then
         traitors = e.traitor_ids
         detectives = e.detective_ids
      end

      if starttime and traitors then
         break
      end
   end

   -- Get scores and players
   local scores = {}
   local nicks = {}
   for k, e in pairs(events) do
      if e.id == EVENT_SPAWN then
         scores[e.sid] = ScoreInit()
         nicks[e.sid] = e.ni
      end
   end

   scores = ScoreEventLog(events, scores, traitors, detectives)

   self.Players = nicks
   self.Scores = scores
   self.TraitorIDs = traitors
   self.DetectiveIDs = detectives
   self.StartTime = starttime
   self.Events = events
end

function CLSCORE:ReportEvents(events)
   self:Reset()

   self:Init(events)
   self:ShowPanel()
end

function CLSCORE:Toggle()
   if IsValid(self.Panel) then
      self.Panel:ToggleVisible()
   end
end

local buff = ""
local function ReceiveReportStream(len)
   if LocalPlayer().MapVoteStarted == true then return end
   local cont = net.ReadBit() == 1

   buff = buff .. net.ReadString()

   if cont then
      return
   else
      -- do stuff with buffer contents

      local json_events = buff -- util.Decompress(buff)
      if not json_events then
         ErrorNoHalt("Round report decompression failed!\n")
      else
         -- convert the json string back to a table
         local events = util.JSONToTable(json_events)

         if istable(events) then
            CLSCORE:ReportEvents(events)
         else
            ErrorNoHalt("Round report event decoding failed!\n")
         end
      end

      -- flush
      buff = ""
   end
end
net.Receive("TTT_ReportStream", ReceiveReportStream)

local function SaveLog(ply, cmd, args)
   CLSCORE:SaveLog()
end
concommand.Add("ttt_save_events", SaveLog)



concommand.Add("open_top10", function (ply, cmd, arg)
   net.Start("TOP10.GetScoreList")
   net.SendToServer()
end)


net.Receive("TOP10.OpenScoreList", function ()
   local tbl_all_time = net.ReadTable()
   local tbl_today = net.ReadTable()
   if istable(tbl_all_time) then
      LocalPlayer().ScoreTable = tbl_all_time
   end

   if istable(tbl_today) then
      LocalPlayer().ScoreTableToday = tbl_today
   end

   if istable(LocalPlayer().ScoreTable) then
      local main_frame = vgui.Create("CRFrame")
      main_frame:SetSize(600,700)
      main_frame:Center()
      main_frame:MakePopup()
      main_frame:SetTitle("Топ 10")

      local l = vgui.Create("DListLayout",main_frame)
      l:Dock(FILL)
      l:DockMargin(0, 10, 0, 0)


      for k,v in pairs (LocalPlayer().ScoreTableToday) do


            local q = vgui.Create("CRButton")
            q:SetText("")
            q:SetTall(57)
            q:SetDisabled(true)
            q:MakeCustomText(v.nick.." : "..v.score.." очков")

            local avatar = vgui.Create("AvatarImage",q)
            avatar:Dock(LEFT)
            avatar:DockMargin(3, 3, 0, 3)
            avatar:SetSteamID(v.S64,184)



            l:Add(q)
         end

      local myself = vgui.Create("CRButton", main_frame)
      myself:SetText("")
      myself:SetTall(57)
      myself:Dock(BOTTOM)
      myself:MakeCustomText("У вас "..LocalPlayer():GetNWInt("TodayPlayerScore").." очков за сегодня")

      local my_avatar = vgui.Create("AvatarImage",myself)
      my_avatar:Dock(LEFT)
      my_avatar:DockMargin(3, 3, 0, 3)
      my_avatar:SetPlayer(LocalPlayer(),184)



      local top_10_today = vgui.Create("CRButton", main_frame)
      top_10_today:Dock(TOP)
      top_10_today:SetText("ТОП 10 за сегодняшний день")
      top_10_today:DockMargin(0, 0, main_frame:GetWide()/2, 0)

      local top_10_alltime = vgui.Create("CRButton", main_frame)
      top_10_alltime:Dock(TOP)
      top_10_alltime:SetText("ТОП 10 за все время сервера")
      top_10_alltime:DockMargin(main_frame:GetWide()/2, -22, 0, 0)


      top_10_today.DoClick = function ()
      l:Clear()

      myself:MakeCustomText("У вас "..LocalPlayer():GetNWInt("TodayPlayerScore").." очков за сегодня")

         for k,v in pairs (LocalPlayer().ScoreTableToday) do


            local q = vgui.Create("CRButton")
            q:SetText("")
            q:SetTall(57)
            q:SetDisabled(true)
            q:MakeCustomText(v.nick.." : "..v.score.." очков")

            local avatar = vgui.Create("AvatarImage",q)
            avatar:Dock(LEFT)
            avatar:DockMargin(3, 3, 0, 3)
            avatar:SetSteamID(v.S64)

            l:Add(q)
         
         end

      end


      top_10_alltime.DoClick = function ()
      l:Clear()

      myself:MakeCustomText("У вас "..LocalPlayer():GetNWInt("PlayerScore").." очков за все время игры")
         for k,v in pairs (LocalPlayer().ScoreTable) do


            local q = vgui.Create("CRButton")
            q:SetText("")
            q:SetTall(57)
            q:SetDisabled(true)
            q:MakeCustomText(v.nick.." : "..v.score.." очков")

            local avatar = vgui.Create("AvatarImage",q)
            avatar:Dock(LEFT)
            avatar:DockMargin(3, 3, 0, 3)
            avatar:SetSteamID(v.S64,184)



            l:Add(q)
         end

      end

   end
end)

net.Receive("TOP10.ScoreList", function ()
   local tb = net.ReadTable()

   local pnl = vgui.Create("ui_panel")
   pnl:SetPos(ScrW()* 0.79, 170)
   pnl:SetSize(265,605)

   local l = vgui.Create("DListLayout",pnl)
   l:Dock(FILL)

   local myself = vgui.Create("CRButton", pnl)
   myself:SetTall(55)
   myself:Dock(BOTTOM)
   myself:SetDisabled(true)
   myself:SetWide(10)
   -- myself:MakeCustomText(LocalPlayer():Nick().. " : "..LocalPlayer():GetNWInt("TodayPlayerScore"))
   myself:MakeCustomText("У вас за сегодня "..LocalPlayer():GetNWInt("TodayPlayerScore").." очков")

   local avatar = vgui.Create("AvatarImage",myself)
   avatar:Dock(LEFT)
   avatar:DockMargin(5, 3, 0, 3)
   avatar:SetPlayer(LocalPlayer(),184)



   for k,v in pairs (tb) do

      local q = vgui.Create("CRButton")
      q:SetTall(55)
      q:SetDisabled(true)
      q:MakeCustomText(v.nick.." : "..v.score.." очков")

      local avatar = vgui.Create("AvatarImage",q)
      avatar:Dock(LEFT)
      avatar:DockMargin(3, 3, 0, 3)
      avatar:SetSteamID(v.S64 or NULL,184)



      l:Add(q)
   end


   timer.Simple(15, function ()
      pnl:Remove()
   end)
end)


hook.Add("TTTEndRound", "TopRound", function ()
   timer.Simple(0.5, function ()
        local Nick, Score, Inno, Traitors = LocalPlayer().TopRoundNick, LocalPlayer().TopRoundScore, LocalPlayer().TopKillInno, LocalPlayer().TopKillTraitors
        local find

        for k,v in pairs (player.GetAll()) do
         if v:Nick() == Nick then
            find = v
         end
        end
        if Nick and Score and Inno and Traitors then
         local top_panel = vgui.Create("DPanel")
         top_panel:SetSize(350, 150)
         top_panel:SetPos(ScrW()/2 - 175, 10)

         top_panel.Paint = function (self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(60, 45, 132, 255))

            draw.RoundedBox(0, 0, 0, w, 30, Color(96, 96, 96, 255))

            draw.SimpleTextOutlined("Лучший игрок раунда", "Trebuchet24", self:GetWide()/5, 15, Color( 255, 255, 255, 255 ), 0, 1, 1, Color(0,0,0,255))

            draw.SimpleTextOutlined(Nick, "Trebuchet24", 85, 65, Color( 255, 255, 255, 255 ), 0, 1, 1, Color(0,0,0,255))
            draw.SimpleTextOutlined("Общий счет : "..Score, "Trebuchet24", 85, 90, Color( 255, 255, 255, 255 ), 0, 1, 1, Color(0,0,0,255))

            if LocalPlayer().TopRole == "Предатель" then
               draw.SimpleTextOutlined("Убито невиновных: "..Inno, "Trebuchet24", 85, 115, Color( 255, 0, 0, 255 ), 0, 1, 1, Color(0,0,0,255))
            else
               draw.SimpleTextOutlined("Убито предателей: "..Traitors, "Trebuchet24", 85, 115, Color( 0, 255, 0, 255 ), 0, 1, 1, Color(0,0,0,255))
            end

            surface.SetDrawColor(Color(0,0,0,255))
            surface.DrawOutlinedRect( 0, 0, w, h )
        end


        local avatar = vgui.Create("AvatarImage", top_panel)
        avatar:Dock(LEFT)
        avatar:SetPlayer(find, 184)
        avatar:DockMargin(15, 45, 0, 20)



         timer.Simple(15, function ()
            top_panel:Remove()
            top_round = {}
            LocalPlayer().TopRoundNick = nil
            LocalPlayer().TopRoundScore = nil
            LocalPlayer().TopKillInno = nil
            LocalPlayer().TopKillTraitors = nil
            LocalPlayer().TopRole = nil
         end)
      end
   end)
end)
