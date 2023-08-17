---- VGUI panel version of the scoreboard, based on TEAM GARRY's sandbox mode
---- scoreboard.

local surface = surface
local draw = draw
local math = math
local string = string
local vgui = vgui

local GetTranslation = LANG.GetTranslation
local GetPTranslation = LANG.GetParamTranslation

include("sb_team.lua")

surface.CreateFont("cool_small", {font = "coolvetica",
                                  size = 20,
                                  weight = 400})
surface.CreateFont("cool_large", {font = "coolvetica",
                                  size = 24,
                                  weight = 400})
surface.CreateFont("treb_small", {font = "Trebuchet18",
                                  size = 14,
                                  weight = 700})

CreateClientConVar("ttt_scoreboard_sorting", "name", true, false, "name | role | karma | score | deaths | ping")
CreateClientConVar("ttt_scoreboard_ascending", "1", true, false, "Should scoreboard ordering be in ascending order")

-- local logo = surface.GetTextureID("vgui/ttt/g_logo.png")
-- local logo = Material( "typical_ttt/logo_new_year.png", "smooth noclamp" )
local logo = Material( "typical_ttt/logo_5.png", "smooth noclamp" )
-- Material('metaui/captureebalo/cpp.png', 'smooth noclamp')

local PANEL = {}

local max = math.max
local floor = math.floor
local function UntilMapChange()
   local rounds_left = max(0, GetGlobalInt("ttt_rounds_left", 6))
   local time_left = floor(max(0, ((GetGlobalInt("ttt_time_limit_minutes") or 60) * 60) - CurTime()))

   local h = floor(time_left / 3600)
   time_left = time_left - floor(h * 3600)
   local m = floor(time_left / 60)
   time_left = time_left - floor(m * 60)
   local s = floor(time_left)

   return rounds_left, string.format("%02i:%02i:%02i", h, m, s)
end


GROUP_TERROR = 1
GROUP_NOTFOUND = 2
GROUP_FOUND = 3
GROUP_SPEC = 4

GROUP_COUNT = 4

function AddScoreGroup(name) -- Utility function to register a score group
   if _G["GROUP_"..name] then error("Group of name '"..name.."' already exists!") return end
   GROUP_COUNT = GROUP_COUNT + 1
   _G["GROUP_"..name] = GROUP_COUNT
end

function ScoreGroup(p)
   if not IsValid(p) then return -1 end -- will not match any group panel

   local group = hook.Call( "TTTScoreGroup", nil, p )

   if group then -- If that hook gave us a group, use it
      return group
   end

   if DetectiveMode() then
      if p:IsSpec() and (not p:Alive()) then
         if p:GetNWBool("body_found", false) then
            return GROUP_FOUND
         else
            local client = LocalPlayer()
            -- To terrorists, missing players show as alive
            if client:IsSpec() or
               client:IsActiveTraitor() or
               ((GAMEMODE.round_state != ROUND_ACTIVE) and client:IsTerror()) then
               return GROUP_NOTFOUND
            else
               return GROUP_TERROR
            end
         end
      end
   end

   return p:IsTerror() and GROUP_TERROR or GROUP_SPEC
end


-- Comparison functions used to sort scoreboard
sboard_sort = {
   name = function (plya, plyb)
      -- Automatically sorts by name if this returns 0
      return 0
   end,
   ping = function (plya, plyb)
      return plya:Ping() - plyb:Ping()
   end,
   deaths = function (plya, plyb)
      return plya:Deaths() - plyb:Deaths()
   end,
   score = function (plya, plyb)
      return plya:Frags() - plyb:Frags()
   end,
   role = function (plya, plyb)
      local comp = (plya:GetRole() or 0) - (plyb:GetRole() or 0)
      -- Reverse on purpose;
      --    otherwise the default ascending order puts boring innocents first
      comp = 0 - comp
      return comp
   end,
   karma = function (plya, plyb)
      return (plya:GetBaseKarma() or 0) - (plyb:GetBaseKarma() or 0)
   end
}

----- PANEL START

function PANEL:Init()
   -- self.hostname = vgui.Create( "DLabel", self )
   -- self.hostname:SetText( GetHostName() )
   -- self.hostname:SetContentAlignment(6)

   self.rtv_button = vgui.Create("CRButton", self)
   self.rtv_button:SetText("Сменить карту ("..tonumber(GetGlobalString("RTV_PlayerVoted")).."/"..math.Round(#player.GetAll() * 0.66)..")")
   self.rtv_button:SetConsoleCommand("say", "!rtv")


   self.rtv_button.Think = function ()
      self.rtv_button:SetText("Сменить карту ("..tonumber(GetGlobalString("RTV_PlayerVoted")).."/"..math.Round(#player.GetAll() * 0.66)..")")
   end
   
   self.top_10 = vgui.Create("CRButton", self)
   self.top_10:SetText("Открыть TOP 10 игроков сервера")
   self.top_10:SetConsoleCommand("open_top10")


   self.top_10.DoClick = function ()
      RunConsoleCommand("open_top10")
   end

   self.mapchange = vgui.Create("DLabel", self)
   self.mapchange:SetText("Map changes in 00 rounds or in 00:00:00")
   self.mapchange:SetContentAlignment(9)

   self.mapchange.Think = function (sf)
                             local r, t = UntilMapChange()

                             sf:SetText(GetPTranslation("sb_mapchange",
                                                        {num = r, time = t}))
                             sf:SizeToContents()
                          end


   self.ply_frame = vgui.Create( "TTTPlayerFrame", self )

   self.ply_groups = {}

   local t = vgui.Create("TTTScoreGroup", self.ply_frame:GetCanvas())
   t:SetGroupInfo(GetTranslation("terrorists"), Color(0,200,0,100), GROUP_TERROR)
   self.ply_groups[GROUP_TERROR] = t

   t = vgui.Create("TTTScoreGroup", self.ply_frame:GetCanvas())
   t:SetGroupInfo(GetTranslation("spectators"), Color(200, 200, 0, 100), GROUP_SPEC)
   self.ply_groups[GROUP_SPEC] = t

   if DetectiveMode() then
      t = vgui.Create("TTTScoreGroup", self.ply_frame:GetCanvas())
      t:SetGroupInfo(GetTranslation("sb_mia"), Color(130, 190, 130, 100), GROUP_NOTFOUND)
      self.ply_groups[GROUP_NOTFOUND] = t

      t = vgui.Create("TTTScoreGroup", self.ply_frame:GetCanvas())
      t:SetGroupInfo(GetTranslation("sb_confirmed"), Color(130, 170, 10, 100), GROUP_FOUND)
      self.ply_groups[GROUP_FOUND] = t
   end

   hook.Call( "TTTScoreGroups", nil, self.ply_frame:GetCanvas(), self.ply_groups )

   -- the various score column headers
   self.cols = {}
   self:AddColumn( GetTranslation("sb_ping"), nil, nil,         "ping" )
   self:AddColumn( GetTranslation("sb_deaths"), nil, nil,       "deaths" )
   self:AddColumn( GetTranslation("sb_score"), nil, nil,        "score" )

   if KARMA.IsEnabled() then
      self:AddColumn( GetTranslation("sb_karma"), nil, nil,     "karma" )
   end

   self.sort_headers = {}
   -- Reuse some translations
   -- Columns spaced out a bit to allow for more room for translations
   self:AddFakeColumn( GetTranslation("sb_sortby"), nil, 70,       nil ) -- "Sort by:"
   self:AddFakeColumn( GetTranslation("equip_spec_name"), nil, 70, "name" )
   self:AddFakeColumn( GetTranslation("col_role"), nil, 70,        "role" )

   -- Let hooks add their column headers (via AddColumn() or AddFakeColumn())
   hook.Call( "TTTScoreboardColumns", nil, self )

   self:UpdateScoreboard()
   self:StartUpdateTimer()
end

local function sort_header_handler(self_, lbl)
   return function()
      surface.PlaySound("ui/buttonclick.wav")

      local sorting = GetConVar("ttt_scoreboard_sorting")
      local ascending = GetConVar("ttt_scoreboard_ascending")

      if lbl.HeadingIdentifier == sorting:GetString() then
         ascending:SetBool(not ascending:GetBool())
      else
         sorting:SetString( lbl.HeadingIdentifier )
         ascending:SetBool(true)
      end

      for _, scoregroup in pairs(self_.ply_groups) do
         scoregroup:UpdateSortCache()
         scoregroup:InvalidateLayout()
      end

      self_:ApplySchemeSettings()
   end
end

-- For headings only the label parameter is relevant, second param is included for
-- parity with sb_row
local function column_label_work(self_, table_to_add, label, width, sort_identifier, sort_func )
   local lbl = vgui.Create( "DLabel", self_ )
   lbl:SetText( label )
   local can_sort = false
   lbl.IsHeading = true
   lbl.Width = width or 50 -- Retain compatibility with existing code

   if sort_identifier != nil then
      can_sort = true
      -- If we have an identifier and an existing sort function then it was a built-in
      -- Otherwise...
      if _G.sboard_sort[sort_identifier] == nil then
         if sort_func == nil then
            ErrorNoHalt( "Sort ID provided without a sorting function, Label = ", label, " ; ID = ", sort_identifier )
            can_sort = false
         else
            _G.sboard_sort[sort_identifier] = sort_func
         end
      end
   end

   if can_sort then
      lbl:SetMouseInputEnabled(true)
      lbl:SetCursor("hand")
      lbl.HeadingIdentifier = sort_identifier
      lbl.DoClick = sort_header_handler(self_, lbl)
   end

   table.insert( table_to_add, lbl )
   return lbl
end

function PANEL:AddColumn( label, _, width, sort_id, sort_func )
   return column_label_work( self, self.cols, label, width, sort_id, sort_func )
end

-- Adds just column headers without player-specific data
-- Identical to PANEL:AddColumn except it adds to the sort_headers table instead
function PANEL:AddFakeColumn( label, _, width, sort_id, sort_func )
   return column_label_work( self, self.sort_headers, label, width, sort_id, sort_func )
end

function PANEL:StartUpdateTimer()
   if not timer.Exists("TTTScoreboardUpdater") then
      timer.Create( "TTTScoreboardUpdater", 0.3, 0,
                    function()
                       local pnl = GAMEMODE:GetScoreboardPanel()
                       if IsValid(pnl) then
                          pnl:UpdateScoreboard()
                       end
                    end)
   end
end

local colors = {
   bg = Color(34, 40, 49),
   bar = Color(57, 62, 70)
};

local y_logo_off = 72

function PANEL:Paint()
   -- Logo sticks out, so always offset bg


   draw.RoundedBox( 8, 0, y_logo_off, self:GetWide(), self:GetTall() - y_logo_off, colors.bg)



   -- Server name is outlined by orange/gold area
   -- draw.RoundedBox( 8, 0, y_logo_off, self:GetWide(), 110, colors.bar)

   draw.RoundedBox( 8, 100, y_logo_off + 1, 350, 20, Color(238, 238, 238, 200))



   -- draw.RoundedBox( 0, 0, y_logo_off + 32, self:GetWide(), 30, Color(255, 211, 105, 200))

   -- TTT Logo
   // New year logo : 
   // surface.DrawTexturedRect( -10, 40, 600, 150 )
   // Not new year logo : 
   // surface.DrawTexturedRect( 20, 30, 500, 200 )
   surface.SetMaterial( logo )
   surface.SetDrawColor( 255, 255, 255, 250 )
   surface.DrawTexturedRect( 20, 30, 500, 200 )

end

function PANEL:PerformLayout()


   -- position groups and find their total size
   local gy = 0
   -- can't just use pairs (undefined ordering) or ipairs (group 2 and 3 might not exist)
   for i=1, GROUP_COUNT do
      local group = self.ply_groups[i]
      if IsValid(group) then
         if group:HasRows() then
            group:SetVisible(true)
            group:SetPos(0, gy)
            group:SetSize(self.ply_frame:GetWide(), group:GetTall())
            group:InvalidateLayout()
            gy = gy + group:GetTall() + 5
         else
            group:SetVisible(false)
         end
      end
   end

   self.ply_frame:GetCanvas():SetSize(self.ply_frame:GetCanvas():GetWide(), gy)

   local h = y_logo_off + 110 + self.ply_frame:GetCanvas():GetTall()

   -- if we will have to clamp our height, enable the mouse so player can scroll
   local scrolling = h > ScrH() * 0.95
--   gui.EnableScreenClicker(scrolling)
   self.ply_frame:SetScroll(scrolling)

   h = math.Clamp(h, 110 + y_logo_off, ScrH() * 0.95)

   local w = math.max(ScrW() * 0.6, 640)

   self:SetSize(w, h)
   self:SetPos( (ScrW() - w) / 2, math.min(72, (ScrH() - h) / 4))

   self.ply_frame:SetPos(8, y_logo_off + 109)
   self.ply_frame:SetSize(self:GetWide() - 16, self:GetTall() - 109 - y_logo_off - 5)

   -- server stuff
   -- self.hostdesc:SizeToContents()
   -- self.hostdesc:SetPos(w - self.hostdesc:GetWide() - 8, y_logo_off + 5)

   local hw = w - 180 - 8
   -- self.hostname:SetSize(hw, 32)
   -- self.hostname:SetPos(w - self.hostname:GetWide() - 210, y_logo_off + 5)

   -- local w_top, h_top = surface.GetTextSize( "ТОП 10 игроков" )

   self.rtv_button:SetSize(260,20)
   self.rtv_button:SetPos(450, y_logo_off + 25)

   self.top_10:SetSize(260,20)
   self.top_10:SetPos(450, y_logo_off + 50)

   -- self.vote_for_pr:SetSize(170,20)
   -- self.vote_for_pr:SetPos(w - self.hostname:GetWide() + 350, y_logo_off + 65)
   -- vote_for_pr


   surface.SetFont("cool_large")
   -- local hname = self.hostname:GetValue()
   local hname = GetHostName()
   local tw, _ = surface.GetTextSize(hname)
   while tw > hw do
      hname = string.sub(hname, 1, -6) .. "..."
      tw, th = surface.GetTextSize(hname)
   end

   -- self.hostname:SetText(hname)

   self.mapchange:SizeToContents()
   self.mapchange:SetPos(115, y_logo_off + 5)

   -- score columns
   local cy = y_logo_off + 90
   local cx = w - 8 -(scrolling and 16 or 0)
   for k,v in ipairs(self.cols) do
      v:SizeToContents()
      cx = cx - v.Width
      v:SetPos(cx - v:GetWide()/2, cy)
   end

   -- sort headers
   -- reuse cy
   -- cx = logo width + buffer space
   local cx = 256 + 8
   for k,v in ipairs(self.sort_headers) do
      v:SizeToContents()
      cx = cx + v.Width
      v:SetPos(cx - v:GetWide()/2, cy)
   end
end

function PANEL:ApplySchemeSettings()
   -- self.hostdesc:SetFont("cool_small")
   -- self.hostname:SetFont("cool_large")
   self.mapchange:SetFont("treb_small")

   -- self.hostdesc:SetTextColor(COLOR_WHITE)
   -- self.hostname:SetTextColor(COLOR_WHITE)
   self.mapchange:SetTextColor(Color(0,0,0))

   local sorting = GetConVar("ttt_scoreboard_sorting"):GetString()

   local highlight_color = Color(175, 175, 175, 255)
   local default_color = COLOR_WHITE

   for k,v in pairs(self.cols) do
      v:SetFont("treb_small")
      if sorting == v.HeadingIdentifier then
         v:SetTextColor(highlight_color)
      else
         v:SetTextColor(default_color)
      end
   end

   for k,v in pairs(self.sort_headers) do
      v:SetFont("treb_small")
      if sorting == v.HeadingIdentifier then
         v:SetTextColor(highlight_color)
      else
         v:SetTextColor(default_color)
      end
   end
end

function PANEL:UpdateScoreboard( force )
   if not force and not self:IsVisible() then return end

   local layout = false

   -- Put players where they belong. Groups will dump them as soon as they don't
   -- anymore.
   for k, p in ipairs(player.GetAll()) do
      if IsValid(p) then
         local group = ScoreGroup(p)
         if self.ply_groups[group] and not self.ply_groups[group]:HasPlayerRow(p) then
            self.ply_groups[group]:AddPlayerRow(p)
            layout = true
         end
      end
   end

   for k, group in pairs(self.ply_groups) do
      if IsValid(group) then
         group:SetVisible( group:HasRows() )
         group:UpdatePlayerData()
      end
   end

   if layout then
      self:PerformLayout()
   else
      self:InvalidateLayout()
   end
end

vgui.Register( "TTTScoreboard", PANEL, "Panel" )

---- PlayerFrame is defined in sandbox and is basically a little scrolling
---- hack. Just putting it here (slightly modified) because it's tiny.

local PANEL = {}
function PANEL:Init()
   self.pnlCanvas  = vgui.Create( "Panel", self )
   self.YOffset = 0

   self.scroll = vgui.Create("DVScrollBar", self)
end

function PANEL:GetCanvas() return self.pnlCanvas end

function PANEL:OnMouseWheeled( dlta )
   self.scroll:AddScroll(dlta * -2)

   self:InvalidateLayout()
end

function PANEL:SetScroll(st)
   self.scroll:SetEnabled(st)
end

function PANEL:PerformLayout()
   self.pnlCanvas:SetVisible(self:IsVisible())

   -- scrollbar
   self.scroll:SetPos(self:GetWide() - 16, 0)
   self.scroll:SetSize(16, self:GetTall())

   local was_on = self.scroll.Enabled
   self.scroll:SetUp(self:GetTall(), self.pnlCanvas:GetTall())
   self.scroll:SetEnabled(was_on) -- setup mangles enabled state

   self.YOffset = self.scroll:GetOffset()

   self.pnlCanvas:SetPos( 0, self.YOffset )
   self.pnlCanvas:SetSize( self:GetWide() - (self.scroll.Enabled and 16 or 0), self.pnlCanvas:GetTall() )
end
vgui.Register( "TTTPlayerFrame", PANEL, "Panel" )



local chat_sounds = {
   ["Что вы забыли на моем болоте?"] = "swamp",
   ["Уфф (ROBLOX)"] = "oof",
   ["Зактнись"] = "shut up",
   ["Ты гей"] = "gay",
   ["Привет"] = "hello",
   ["Сюрприз"] = "surprise",
   ["Ейййййт"] = "yeet",
   ["Вай ю булли ми?"] = "why you bully me",
   ["Ты обосрался"] = "fuck up",
   ["Bruh"] = "bruh",
   ["Что это за хрень?"] = "what the fuck is that",
   ["Неа"] = "nope",
   ["Тутуру"] = "tuturu",
   ["ФБР ОТКРЫВАЙ"] = "fbi",
   ["GG"] = "gg",
   ["Найс"] = "nice",
   ["Беги"] = "run",
   ["Почему ты убегаешь?"] = "why are you running",
   ["Нани?"] = "nani",
   ["Хадукэн"] = "hadoken",
   ["ВНИМАНИЕ!"] = "alert",
   ["Делай бочку!"] = "barrel roll",
   ["Привет вам"] = "hello there",
   ["Довны"] = "довн",
   ['Ауч'] = "hurt",
   ["Убейте этого мазафаку"] = "get that",
   ["Пошел ты"] = "fuck you",
   ["Святое дерьмо!"] = "holy shit",
   ["[VIP] Hit or Miss"] = "hit or miss",
   ["Пацан к успеху шел"] = "не фортануло",
   ["Сильное заявление"] = "Сильное заявление",
   ["Ты че дурак?"] = "ты дурак?",
   ["Чича"] = "У вас чича!",
   ["Шедевр!"] = "Это шедевр!",
   ["Флеймерское UWU"] = "uwu",
   ["Nya"] = "nya",
   ["Гномское УУУ"] = "gnome",
   ["О, привет!"] = "Привет",
   ["Ошибка"] = "error",
   ["Пошли нахуй"] = "пошли они нахуй",
   ["Что бл?"] = "что блять?"
}




hook.Add("ScoreboardShow", "helpTab", function ()
   chatsounds_tab = vgui.Create("CRFrame")
   chatsounds_tab:SetPos(ScrW()-250, 150)
   chatsounds_tab:SetTitle("")
   chatsounds_tab:SetSize(250,550)
   chatsounds_tab:ShowCloseButton(true)


   local sub_panel = vgui.Create("DScrollPanel", chatsounds_tab)
   sub_panel:Dock(FILL)

   local mute_button = vgui.Create("DButton",chatsounds_tab)
   mute_button:Dock(TOP)
   mute_button:SetText("")
   -- mute_button:SetConsoleCommand("ttt_mute_chatsounds "..tobool(GetConVarNumber("ttt_mute_chatsounds")) and 0 or 1)

   mute_button.DoClick = function ()
      RunConsoleCommand("ttt_mute_chatsounds", tobool(GetConVarNumber("ttt_mute_chatsounds")) and 0 or 1)
   end

   mute_button.Paint = function (self, w, h)
      if self:IsHovered() then
         draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
      else
         draw.RoundedBox(0, 0, 0, w, h, Color(80,12,216))
      end

      surface.SetDrawColor(Color(0,0,0,255))
      surface.DrawOutlinedRect( 0, 0, w, h )


      draw.SimpleTextOutlined(tobool(GetConVarNumber("ttt_mute_chatsounds")) and "Включить звук" or "Выключить звук", "treb_small", 65, 10, Color( 255, 255, 255, 255 ), 0, 1, 1, Color(0,0,0,255))
   end

   for k,v in pairs (chat_sounds) do
      local s = vgui.Create("CRButton",sub_panel)
      s:Dock(TOP)
      s:SetText(k)
      s:SetConsoleCommand("say", v)
   end
end)

hook.Add("ScoreboardHide", "helpTabHide", function ()
   if IsValid(chatsounds_tab) then
      chatsounds_tab:Remove()
   end
end)
