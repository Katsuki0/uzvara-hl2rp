
local Leak_Protection_Status=[[OK]]
/* READ THIS BEFORE HAVE PROBLEM PLEASE,

----1.Leak----
Our biggest issues here are people who purchase scripts, with the sole purpose of leaking them.
As a developer, if I see my scripts, or any other developer's scripts here for that matter leaked by a member of the ScriptFodder community,
rest assured that I will do everything in my power to ensure you fail.
This includes but not limited to, notifying a moderator / admin of ScriptFodder of your attempt to leak,
with proof of course (because we will find you); ensuring you are banned from the website.
Your access to my script completely revoked without any additional warning.
Your name publicly blasted, with SteamID, on any and all developer forums, including Facepunch.com.
As well as any Steam groups you may be part of (maybe even your friends).
And finally, a phone call to PayPal explaining who you are, and what you are attempting to do.
Which in the future can jeopardize your very own PayPal account and have it limited.
We are developers, this is partially how we make a living, and it helps support our families.
If you have an issue, simply tell me and I'll do everything in my power to fix it.
Attempting charge-backs is not the way to handle a business transaction.
If you are not a leaker, you have nothing to worry about, and I thank you for your purchase.

Keep in mind. The leak destroys the creation and the opportunity to see something new and different on Gmod.

----2.Copyright----
The Zworld-Afterlife scripts are placed at Copyright France since 2012.
zworld-afterlife.com© 2008-2015. Created by Nordahl
Do not publish without my authorization.
With my regards,
Thank You.

By Nordahl																																																							76561198033784269 
If you find my work serious know they are all my other scripts here: https://scriptfodder.com/users/view/76561198033784269/scripts
*/
local exemplesteamid64=""

local function eRight(a)
if a:SteamID()==JSP_CONFIG.OwnerSteamID then return true end
if a:IsAdmin()==true then if JSP_CONFIG.Allow_Admin==1 then return true end end
if a:IsSuperAdmin()==true then if JSP_CONFIG.Allow_SUPER_Admin==1 then return true end end
for _,c in ipairs(JSP_CONFIG.Allow_ULX_GROUP_CAN_ACCESS_PANEL)do if a:IsUserGroup(c) then return true end end
return false
end

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
AddCSLuaFile("config.lua")
include('config.lua')



--CONFIG SPJ --Dont touch it

-- resource.AddFile("models/twd/prop/compass.dx80.vtx")
-- resource.AddFile("models/twd/prop/compass.dx90.vtx")
-- resource.AddFile("models/twd/prop/compass.mdl")
-- resource.AddFile("models/twd/prop/compass.phy")
-- resource.AddFile("models/twd/prop/compass.sw.vtx")
-- resource.AddFile("models/twd/prop/compass.vvd")
-- resource.AddFile( "materials/weapons/zcompass.vtf" )
-- resource.AddFile( "materials/weapons/zcompass.vtm" )
-- resource.AddFile( "materials/vgui/entities/zworld_compass_entitie.vtf" )
-- resource.AddFile( "materials/vgui/entities/zworld_compass_entitie.vtm" )
-- resource.AddFile( "materials/compass/compassaig.vtf" )
-- resource.AddFile( "materials/compass/compassaig.vtm" )
-- resource.AddFile( "materials/compass/compassint.vtf" )
-- resource.AddFile( "materials/compass/compassint.vtm" )


function ENT:Initialize()
self.Entity:SetModel("models/hunter/blocks/cube025x025x025.mdl")
self.Entity:PhysicsInit(SOLID_VPHYSICS)
self.Entity:SetMoveType(MOVETYPE_NONE)
self.Entity:SetSolid(SOLID_VPHYSICS)
self.Entity:SetUseType(SIMPLE_USE)
self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
if self.zpersistance==nil then
self.ent_red=0
self.ent_green=200
self.ent_bleu=0
self.ent_job="Unassigned"
self.ent_text=""
self.ent_visible=1
self.zpersistance=0
end
local phys = self.Entity:GetPhysicsObject()
if (phys:IsValid()) then
phys:Wake()
self.Entity:GetPhysicsObject():EnableMotion(false)
end
self.Entity:DrawShadow(false)
timer.Simple(0.4,function()
if IsValid(self) then
self.Entity:SetNWInt("ent_red",self.ent_red)
end
end) timer.Simple(0.5,function()
if IsValid(self) then
self.Entity:SetNWInt("ent_green",self.ent_green)
end
end) timer.Simple(0.6,function()
if IsValid(self) then
self.Entity:SetNWInt("ent_bleu",self.ent_bleu)
end
end) timer.Simple(0.7,function()
if IsValid(self) then
self.Entity:SetNWString("ent_job",self.ent_job)
end
end) timer.Simple(0.9,function()
if IsValid(self) then
self.Entity:SetNWString("ent_text",self.ent_text)
self.Entity:SetColor(Color( math.Round(self.ent_red), math.Round(self.ent_green), math.Round(self.ent_bleu),255) )
end
end) timer.Simple(0.2,function()
if IsValid(self) then
self.Entity:SetNWInt("ent_visible",self.ent_visible)
end
end)
self.Cache={}
end

function ENT:OnRemove(a)
local zpersistance=self.zpersistance
if zpersistance!=1 then return end
local GetPos=self:GetPos()
local ent_red=self.ent_red
local ent_green=self.ent_green
local ent_bleu=self.ent_bleu
local ent_job=self.ent_job
local ent_text=self.ent_text
local ent_visible=self.ent_visible
timer.Simple(2,function()
local ent2=ents.Create("job_spawn_point")
ent2:SetAngles(Angle(0,0,0))
ent2:SetPos(GetPos)
ent2:Spawn()
ent2.ent_red=ent_red
ent2.ent_green=ent_green
ent2.ent_bleu=ent_bleu
ent2.ent_job=ent_job
ent2.ent_text=ent_text
ent2.ent_visible=ent_visible
ent2.zpersistance=1
end)
end

function ENT:Use(a)
if eRight(a) then
self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
a:ConCommand('zworld_spawnpoint '..self:GetNWInt('ent_red')..' '..self:GetNWInt('ent_green')..' '..self:GetNWInt('ent_bleu')..' "'..self:GetNWString('ent_job')..'" '..self:GetNWInt('ent_visible')..' '..self.zpersistance)
a.dernenti=self
end
end

function ENT:Think()
return true
end

local function sprecoitlescoulor(a,b,c)
if eRight(a) and IsValid(a.dernenti) then
a.dernenti:SetNWInt("ent_red",math.Round(tonumber(c[1])))
a.dernenti.ent_red=math.Round(tonumber(c[1]))
a.dernenti:SetNWInt("ent_green",math.Round(tonumber(c[2])))
a.dernenti.ent_green=math.Round(tonumber(c[2]))
a.dernenti:SetNWInt("ent_bleu",math.Round(tonumber(c[3])))
a.dernenti.ent_bleu=math.Round(tonumber(c[3]))
a.dernenti:SetColor(Color( math.Round(tonumber(c[1])), math.Round(tonumber(c[2])), math.Round(tonumber(c[3])),255) )
end
end
concommand.Add("sprecoitlescoulor",sprecoitlescoulor)
function spawncubedebug(a,b,c)
if eRight(a) and IsValid(a.dernenti) then
if a:GetNWInt("spawncubedebug")==1 then
a:SetNWInt("spawncubedebug",0)
else
a:SetNWInt("spawncubedebug",1)
end
end
end
concommand.Add("spawncubedebug",spawncubedebug)

function spHidethecube(a,b,c)
if eRight(a) and IsValid(a.dernenti) then
if a.dernenti:GetNWInt("ent_visible")==1 then
a.dernenti:SetNWInt("ent_visible",0)
a.dernenti.ent_visible=0
else
a.dernenti:SetNWInt("ent_visible",1)
a.dernenti.ent_visible=1
end
end
end
concommand.Add("spHidethecube",spHidethecube)

function spsetjob(a,b,c)
if eRight(a) and IsValid(a.dernenti) then
a.dernenti.ent_job=c[1]
a.dernenti.ent_red=math.Round((c[2]))
a.dernenti.ent_green=math.Round((c[3]))
a.dernenti.ent_bleu=math.Round((c[4]))
a.dernenti:SetNWInt("ent_job",c[1])
a.dernenti:SetNWInt("ent_red",math.Round((c[2])))
a.dernenti:SetNWInt("ent_green",math.Round((c[3])))
a.dernenti:SetNWInt("ent_bleu",math.Round((c[4])))
a.dernenti:SetColor(Color( math.Round((c[2])), math.Round((c[3])), math.Round((c[4])),255) )
end
end
concommand.Add("spsetjob",spsetjob)

function RemovetheSPJ(a,b,c)
if eRight(a) and IsValid(a.dernenti) then
print("Spawn Point is deleted by ",a)
a.dernenti:Remove()
end
end
concommand.Add("RemovetheSPJ",RemovetheSPJ)


function nordahl_admineyes_disable(a,b,c)
if eRight(a) and IsValid(a) then
a:SetNWInt("spawncubedebug",0)
end
end
concommand.Add("nordahl_admineyes_disable",nordahl_admineyes_disable)

function nordahl_admineyes_enable(a,b,c)
if eRight(a) and IsValid(a) then
a:SetNWInt("spawncubedebug",1)
end
end
concommand.Add("nordahl_admineyes_enable",nordahl_admineyes_enable)

function nordahl_hide_all_cubemodel(a,b,c)
if eRight(a) and IsValid(a) then for _,c in ipairs(ents.FindByClass("job_spawn_point"))do c:SetNWInt("ent_visible",0)c.ent_visible=0 end end
end
concommand.Add("nordahl_hide_all_cubemodel",nordahl_hide_all_cubemodel)

function nordahl_show_all_cubemodel(a,b,c)
if eRight(a) and IsValid(a) then for _,c in ipairs(ents.FindByClass("job_spawn_point"))do c:SetNWInt("ent_visible",1)c.ent_visible=1 end end
end
concommand.Add("nordahl_show_all_cubemodel",nordahl_show_all_cubemodel)

function nordahl_make_allspawnpoint_persistent(a,b,c)
if eRight(a) and IsValid(a) then
local zontentmap={}
for _,c in ipairs(ents.FindByClass("job_spawn_point"))do
table.insert(zontentmap,{"job_spawn_point",c:GetPos(),c:GetNWInt("ent_red"),c:GetNWInt("ent_green"),c:GetNWInt("ent_bleu"),c:GetNWString("ent_job"),c:GetNWString("ent_text"),c:GetNWInt("ent_visible")})
end
local icifconvert= util.TableToJSON(zontentmap)
file.CreateDir("nordahl_spawnpoint")
file.Write("nordahl_spawnpoint/"..game.GetMap()..".txt",icifconvert)
end
end
concommand.Add("nordahl_make_allspawnpoint_persistent",nordahl_make_allspawnpoint_persistent)

function Zworld_SPJSauvegarde1(a)
if eRight(a) and IsValid(a.dernenti) then
a.dernenti.zpersistance=1
local zontentmap={}
for _,c in ipairs(ents.FindByClass("job_spawn_point"))do
if c.zpersistance==1 then
table.insert(zontentmap,{"job_spawn_point",c:GetPos(),c:GetNWInt("ent_red"),c:GetNWInt("ent_green"),c:GetNWInt("ent_bleu"),c:GetNWString("ent_job"),c:GetNWString("ent_text"),c:GetNWInt("ent_visible")})
end
end
local icifconvert= util.TableToJSON(zontentmap)
file.CreateDir("nordahl_spawnpoint")
file.Write("nordahl_spawnpoint/"..game.GetMap()..".txt",icifconvert)
end
end
concommand.Add("Zworld_SPJSauvegarde1",Zworld_SPJSauvegarde1)

function Zworld_SPJSauvegarde0(a)
if eRight(a) and IsValid(a.dernenti) then
a.dernenti.zpersistance=0
local zontentmap={}
for _,c in ipairs(ents.FindByClass("job_spawn_point"))do
if c.zpersistance==1 then
table.insert(zontentmap,{"job_spawn_point",c:GetPos(),c:GetNWInt("ent_red"),c:GetNWInt("ent_green"),c:GetNWInt("ent_bleu"),c:GetNWString("ent_job"),c:GetNWString("ent_text"),c:GetNWInt("ent_visible")})
end
end
local icifconvert= util.TableToJSON(zontentmap)
file.CreateDir("nordahl_spawnpoint")
file.Write("nordahl_spawnpoint/"..game.GetMap()..".txt",icifconvert)
end
end
concommand.Add("Zworld_SPJSauvegarde0",Zworld_SPJSauvegarde0)

function nordahl_spawnpoint_cleanup(a)
if eRight(a) then
for _,c in ipairs(ents.FindByClass("job_spawn_point"))do
c:Remove()
file.Write("nordahl_spawnpoint/"..game.GetMap()..".txt","")
end
end
end
concommand.Add("nordahl_spawnpoint_cleanup",nordahl_spawnpoint_cleanup)

if rered==nil then
rered=1
timer.Simple(2,function()

local files = file.Read( "nordahl_spawnpoint/"..game.GetMap()..".txt", "DATA" )
if (!files) then
file.CreateDir("nordahl_spawnpoint")
file.Write("nordahl_spawnpoint/"..game.GetMap()..".txt","")
end

local barricade=file.Read("nordahl_spawnpoint/"..game.GetMap()..".txt")
if barricade!="" then 

for k,v in pairs(util.JSONToTable( file.Read("nordahl_spawnpoint/"..game.GetMap()..".txt") ))do
local ent2=ents.Create(v[1])
ent2:SetAngles(Angle(0,0,0))
ent2:SetPos(v[2])
ent2:Spawn()
ent2.ent_red=tonumber(v[3])
ent2.ent_green=tonumber(v[4])
ent2.ent_bleu=tonumber(v[5])
ent2.ent_job=tostring(v[6])
ent2.ent_text=(v[7])
ent2.ent_visible=tonumber(v[8])
timer.Simple(1.5,function()
if IsValid(ent2) then
ent2:SetNWInt("ent_red",tonumber(v[3]))
end
end) timer.Simple(1.6,function()
if IsValid(ent2) then
ent2:SetNWInt("ent_green",tonumber(v[4]))
end
end) timer.Simple(1.7,function()
if IsValid(ent2) then
ent2:SetNWInt("ent_bleu",tonumber(v[5]))
end
end) timer.Simple(1.8,function()
if IsValid(ent2) then
ent2:SetNWString("ent_job",tostring(v[6]))
end
end) timer.Simple(2,function()
if IsValid(ent2) then
ent2:SetNWString("ent_text",v[7])
end
end) timer.Simple(1.3,function()
if IsValid(ent2) then
ent2:SetNWInt("ent_visible",tonumber(v[8]))
end
end)
ent2.Cache={}
ent2:DrawShadow(false)
ent2.zpersistance=1
end
end
end)
end

function Zworld_SPsave(a)
if eRight(a) and IsValid(a.dernenti) then
local zontentmap={}
for _,c in ipairs(ents.FindByClass("job_spawn_point"))do
if c.zpersistance==1 then
table.insert(zontentmap,{"job_spawn_point",c:GetPos(),c:GetNWInt("ent_red"),c:GetNWInt("ent_green"),c:GetNWInt("ent_bleu"),c:GetNWString("ent_job"),c:GetNWString("ent_text"),c:GetNWInt("ent_visible")})
end
end
local icifconvert= util.TableToJSON(zontentmap)
file.CreateDir("nordahl_spawnpoint")
file.Write("nordahl_spawnpoint/"..game.GetMap()..".txt",icifconvert)
end
end
concommand.Add("Zworld_SPsave",Zworld_SPsave)

function Zworld_SP_Dup(a)
local self=a.dernenti
if eRight(a) and IsValid(a.dernenti) then
local ent2=ents.Create("job_spawn_point")
ent2:SetAngles(Angle(0,0,0))
ent2:SetPos(self:GetPos()+Vector(0,0,20))
ent2.ent_red=self.ent_red
ent2.ent_green=self.ent_green
ent2.ent_bleu=self.ent_bleu
ent2.ent_job=self.ent_job
ent2.ent_text=(self.ent_text)
ent2.ent_visible=tonumber(self.ent_visible)
ent2.zpersistance=0
ent2:Spawn()

end
end
concommand.Add("Zworld_SP_Dup",Zworld_SP_Dup)

local function XYZPOS(ply)
print(ply:GetUserGroup())
end
concommand.Add("XYZPOS",XYZPOS)


local function XYZNordJSP(ply,dif)
	if NordJSP.JSP_ENABLE_DARKRP_JOB=="1" then
	for _,c in ipairs(ents.FindByClass("job_spawn_point"))do
	if c:GetNWString("ent_job")=="All Job" then
	table.insert(dif,{c,c:GetPos()})
	elseif c:GetNWString("ent_job")==team.GetName( ply:Team() ) then
	table.insert(dif,{c,c:GetPos()})
	end
	end
	end
	if NordJSP.JSP_ENABLE_TEAM_GROUP=="1" then
	for _,c in ipairs(ents.FindByClass("job_spawn_point"))do
	if c:GetNWString("ent_job")==team.GetName( ply:Team() ) then
	print(ply,c:GetNWString("ent_job"),team.GetName( ply:Team() ))
	table.insert(dif,{c,c:GetPos()})
	end
	end
	end
	if NordJSP.JSP_ENABLE_ULX_GROUP=="1" then
	for _,c in ipairs(ents.FindByClass("job_spawn_point"))do
	if c:GetNWString("ent_job")== ply:GetUserGroup() then
	table.insert(dif,{c,c:GetPos()})
	end
	end
	end
end

local function XYZNordJSP2(pl,self)
	if ( self.TeamBased ) then
		local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
		if ( IsValid( ent ) ) then return ent end
	end
	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then
		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass( "info_player_start" )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_combine" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_rebel" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_terrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_axis" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_allies" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "gmod_player_start" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_teamspawn" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "ins_spawnpoint" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "aoc_spawnpoint" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "dys_spawn_point" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_pirate" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_viking" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_knight" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "diprip_start_team_blue" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "diprip_start_team_red" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_red" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_blue" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_coop" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_human" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_zombie" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_zombiemaster" ) )
	end
	local Count = table.Count( self.SpawnPoints )
	if ( Count == 0 ) then
		return nil
	end
	for k, v in pairs( self.SpawnPoints ) do
		if ( v:HasSpawnFlags( 1 ) && hook.Call( "IsSpawnpointSuitable", self, pl, v, true ) ) then
			return v
		end
	end
	local ChosenSpawnPoint = nil
	for i = 1, Count do
		ChosenSpawnPoint = table.Random( self.SpawnPoints )
		if ( IsValid( ChosenSpawnPoint ) && ChosenSpawnPoint:IsInWorld() ) then
			if ( ( ChosenSpawnPoint == pl:GetVar( "LastSpawnpoint" ) || ChosenSpawnPoint == self.LastSpawnPoint ) && Count > 1 ) then continue end
			
			if ( hook.Call( "IsSpawnpointSuitable", self, pl, ChosenSpawnPoint, i == Count ) ) then
			
				self.LastSpawnPoint = ChosenSpawnPoint
				pl:SetVar( "LastSpawnpoint", ChosenSpawnPoint )
				return ChosenSpawnPoint
			end
		end
	end
	return ChosenSpawnPoint

end

--timer.Simple(5,function()
function GAMEMODE:PlayerSelectSpawn(ply) 
    local spawn = nil
    local POS = Vector(0,0,0)
	local dif={}
	if self.Sandbox==nil then
	spawn = XYZNordJSP2(ply,self)
	else
	spawn = self.Sandbox.PlayerSelectSpawn(self, ply)
	end
	XYZNordJSP(ply,dif)
    if spawn and spawn.GetPos then
	if dif[1]==nil then
	POS = spawn:GetPos()
	else
	local tab=table.Random(dif)
	spawn,POS = tab[1],tab[2]
	end
    else
	if dif[1]==nil then
	POS = ply:GetPos()
	else
	local tab=table.Random(dif)
	spawn,POS = tab[1],tab[2]
	end
    end
	if DarkRP then
	if NordJSP.DISABLE_setspawn=="0" then
	local jobTable = ply:getJobTable()
	if jobTable!=nil then --Some server use an addon broke "ply:getJobTable()" so jobTable become nil. I dont know yet the name of this one. The one guy have this problem have this addon I dont know if he have edited the darkrp file maybe that can help you "arcbank,arcslots,bank_vault,banmsg,clearchat,crash_menu,cuffs,customzones,arivia_f4menu,darkrpmodification-master,hr_cm,itemstore,mining_sytem,neutron,ngmoneyprinters,rp name menu,rprotect-1.7,server_ticker,shardhud,vcmod_main_autoupdate,williamscardealer,williamsshopsystem"
    if jobTable.PlayerSelectSpawn then
    jobTable.PlayerSelectSpawn(ply, spawn)
    end
	end
    local CustomSpawnPos = DarkRP.retrieveTeamSpawnPos(ply:Team())
    if GAMEMODE.Config.customspawns and not ply:isArrested() and CustomSpawnPos and next(CustomSpawnPos) ~= nil then
    POS = CustomSpawnPos[math.random(1, #CustomSpawnPos)]
    end
	end
    if GAMEMODE.Config.strictsuicide and ply.DeathPos then
        POS = ply.DeathPos
    end
    if ply:isArrested() then
        POS = DarkRP.retrieveJailPos() or ply.DeathPos
    end
    POS = DarkRP.findEmptyPos(POS, {ply}, 600, 30, Vector(16, 16, 64))
	else
	end
    return spawn, POS
end
--end)

/*
{{ user.id }}
*/

print("Spawn Point Management by Nordahl: OK")


if JSP_CONFIG.USeWorkshopContent==1 then
resource.AddWorkshop("493897275")
end