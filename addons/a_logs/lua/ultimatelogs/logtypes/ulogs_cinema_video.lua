/*----------------------------------------------------------------------
Leak by Famouse

Play good games:↓
store.steampowered.com/curator/32364216

Subscribe to the channel:↓
www.youtube.com/c/Famouse

More leaks in the discord:↓ 
discord.gg/rFdQwzm
------------------------------------------------------------------------*/

--[[
    
     _   _  _  _    _                    _           _                        
    | | | || || |  (_)                  | |         | |                       
    | | | || || |_  _  _ __ ___    __ _ | |_   ___  | |      ___    __ _  ___ 
    | | | || || __|| || '_ ` _ \  / _` || __| / _ \ | |     / _ \  / _` |/ __|
    | |_| || || |_ | || | | | | || (_| || |_ |  __/ | |____| (_) || (_| |\__ \
     \___/ |_| \__||_||_| |_| |_| \__,_| \__| \___| \_____/ \___/  \__, ||___/
                                                                    __/ |     
                                                                   |___/      
    
    
]]--





local INDEX = 29
local GM = 6

ULogs.AddLogType( INDEX, GM, "Videos", function( Player, Url )
	
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	if !Url then return end
	
	local Informations = {}
	local Base = ULogs.RegisterBase( Player )
	table.insert( Informations, { "Copy URL", Url } )
	local Data = {}
	Data[ 1 ] = Player:Name()
	Data[ 2 ] = {}
	table.Add( Data[ 2 ], Base )
	table.insert( Informations, Data )
	
	return Informations
	
end)

hook.Add( "PostVideoQueued", "ULogs_PostVideoQueued", function(Video, Theater)

	if !SERVER then return end
	local Player = Video:GetOwner()
	if !Player or !Player:IsValid() or !Player:IsPlayer() then return end
	
	local Title = SQLStr(Video:Title())
	
	ULogs.AddLog( INDEX, ULogs.PlayerInfo( Player ) .. " queued ".. Title, 
		ULogs.Register( INDEX, Player, Video:Data() ) )
end)






/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120 
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/