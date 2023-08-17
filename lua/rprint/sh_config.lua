
rPrint.RemovePrintersOnDisconnect = true  --whether to remove printers on player disconnect
rPrint.OwnershipTransferEnabled = true  --whether to allow users to take ownership of someone else's printer
rPrint.UpdateDelay = 2  --the time in between updates to the datatable (in seconds)
rPrint.MaxPrinters = 50  --maximum number of printers a user can own (including those that have had their owner changed)

rPrint.DefaultPrinterParams = {
	AutoAddToDarkRP = true,  --automatically add printers to DarkRP
	Price = 20,  --price of the printer in DarkRP (only if automatically added)

	Max = 1, -- default printer max per-type

	Color = Color( 255, 255, 255, 255 ),  --color of the printer
	SoundEffectVolume = 50,  --sound effects volume (between 0 and 100)
	
	TempMin = 28,  --minimum temperature (won't go below this)
	TempMax = 80,  --maximum temperature (will explode or shut down at this temperature)
	TempStart = 30,  --starting temperature

	PrintRate = 4,  --printing rate (in money per second) ($/s)
	HeatRate = 1 / 15,  --heat rate (in degrees per money printed) (*/$)
	CoolRate = 1000 / 1000,  --cool rate (in degrees per second) (*/s)

	CoolerCost = 40,  --cooler cost
	CoolerCoolRate = 3 / 2,  --cooler cooling rate (in degrees per second) (*/s)
	CoolerBreakEnabled = false,  --should the cooler sometimes break
	CoolerBreakInterval = {  --the time interval between the coolers breaking (in seconds, randomized) (s)
		6 * 60,  --minimum amount of seconds between breaks
		10 * 60   --maximum amount of seconds between breaks
	},

	PowerConsumptionRate = 0 / 20, --power consumption rate (in percent power per money printed) (%/$)
	PowerConsumptionRateCooler = 0 / 12,  --power consumption rate for the cooler (in percent per second) (%/s)

	RechargeCost = 1,  --cost to recharge
	RechargeMax = 0,  --the value at which the recharge button becomes pressable

	FadeDistance = 125,  --maximum distance that the printers render the GUI
	UseDistance = 100,  --maximum distance a player can use the buttons

	AlertOwnerOnDestroyed = true,  --alert the owner when someone blows up their printer
	AlertOwnerOnOverheated = true,  --alert the owner when the printer overheats and blows up

	PrinterHealth = 100,  --printer health (resistance to damage)
	ExplodeOnOverheat = false,  --explode when the printer overheats
	ExplodeInWater = true,  --explode when submerged in water

	CanBeDestroyed = true,  --can the printers be broken
	DestroyPayout = 20,  --amount paid to the person who destroyed the printer
	DestroyPayoutTeamsExclusive = false,  -- 
	DestroyPayoutTeams = {  --teams which can receive money from destroying a printer; also supports team names as strings
		TEAM_UNIT1,
		TEAM_UNIT2,
		TEAM_UNIT3,
		TEAM_UNIT4,
		TEAM_UNIT5,
		TEAM_UNITENGINER,
		TEAM_PILIOTA,
		TEAM_UNITMEDIC,
		TEAM_CMDUNIT,
		TEAM_CMDOTA,
		TEAM_OTAUNION,
		TEAM_OTASECURITY,
		TEAM_OTAHEAVY,
		TEAM_OTAELITE,
		TEAM_SNIPER,
		TEAM_ZOMBIE,
		TEAM_ZOMBIFUTE,
		TEAM_ZOMBINE,
		TEAM_GLAVADSP,
		TEAM_ADMGORODA
	},

	Custom = { -- add custom properties here (like categories, stuff for your custom F4, etc.)
		-- category = "Printers", -- make sure you create the category first!
	}
}


--[[ Examples:

--Printer with all default settings
rPrint.RegisterPrinterType( "Default", {} )


--Printer with default settings, except it uses less power
rPrint.RegisterPrinterType( "Eco", {
	Price = 1500,

	PowerConsumptionRate = 30 / 35,
	PowerConsumptionRateCooler = 20 / 25
} )



--Special VIP printer, you'll want to change this depending on the teams/user groups that you want to have access
--In this example, it is available to users who are both TEAM_CITIZEN or TEAM_AOD, and of the user group "vip"
rPrint.RegisterPrinterType( "[VIP] Принтер", {
	Price = 20,
	--AllowedTeams = {}, --make it so only citizens and AODs can buy the printer
	AllowedUserGroups = { "VIP", "superadmin" }, --lock to user group vip
	SpawnCommand = "/buyvipprinter", --custom spawn commands are also supported

	PrintRate = 0.2, 

	HeatRate = 100 / 150,  --heat rate (in degrees per money printed) (*/$)
	CoolRate = 100 / 200, --cool down pretty fast, you shouldn't even need a cooler for this one
	CoolerCoolRate = 500, --super cooler for the hell of it
	CoolerBreakEnabled = false, --cooler never breaks

	PowerConsumptionRate = 0 / 20, --power consumption rate (in percent power per money printed) (%/$)
	PowerConsumptionRateCooler = 0 / 12,  --power consumption rate for the cooler (in percent per second) (%/s)
	RechargeCost = 30, 
	CoolerCost = 0
	PrinterHealth = 100, --super strong
	ExplodeOnOverheat = false, --don't blow up
	DestroyPayout = 20,  --Police jackpot!
}, "rprint__vip_printer" ) --give it the entity name "rprint_vipprinter" (this is optional, see README for default names)

--]]


rPrint.RegisterPrinterType( "Принтер", {
	Price = 20,
	ent = "rprint__printer",
	cmd = "buyadminprinter",
	PrintRate = 0.050, 
	DestroyPayout = 20, 
	Color = Color( 255, 255, 135, 255 ), 
	RechargeCost = 0, 
	CoolerCost = 0,
	AllowedTeams = {TEAM_GRAZHDANIN, TEAM_RAZNORABOCHIJ, TEAM_VIZHIVSHIJVOENNIJ, TEAM_PARTISAN, TEAM_PISHEVOJSNABDITEL, TEAM_GRUZHCHIK, TEAM_POSILNIJ, TEAM_DEZERTIR, TEAM_BEZHENEC, TEAM_POVSTANEC, TEAM_VORTIGONT, TEAM_MEDICPOVSTANEC, TEAM_TORGOVECPOVSTANCEV},
} )

rPrint.RegisterPrinterType( "[VIP] Принтер", {
	AllowedUserGroups = { "vip", "superadmin", "operator_vd", "operator_vn" }, --lock to user group vip
	Price = 20,
	ent = "rprint__vip_printer",
	cmd = "buyadminvipprinter",
	PrintRate = 0.050, 
	DestroyPayout = 20, 
	Color = Color( 255, 255, 135, 255 ), 
	RechargeCost = 0, 
	CoolerCost = 0,
	AllowedTeams = {TEAM_GRAZHDANIN, TEAM_RAZNORABOCHIJ, TEAM_VIZHIVSHIJVOENNIJ, TEAM_PARTISAN, TEAM_PISHEVOJSNABDITEL, TEAM_GRUZHCHIK, TEAM_POSILNIJ, TEAM_DEZERTIR, TEAM_BEZHENEC, TEAM_POVSTANEC, TEAM_VORTIGONT, TEAM_MEDICPOVSTANEC, TEAM_TORGOVECPOVSTANCEV},  {TEAM_GRAZHDANIN, TEAM_RAZNORABOCHIJ, TEAM_PISHEVOJSNABDITEL, TEAM_GRUZHCHIK, TEAM_POSILNIJ, TEAM_DEZERTIR, TEAM_BEZHENEC, TEAM_POVSTANEC, TEAM_VORTIGONT, TEAM_MEDICPOVSTANEC, TEAM_TORGOVECPOVSTANCEV},
} )