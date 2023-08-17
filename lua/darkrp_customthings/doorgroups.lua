--[[---------------------------------------------------------------------------
Door groups
---------------------------------------------------------------------------
The server owner can set certain doors as owned by a group of people, identified by their jobs.


HOW TO MAKE A DOOR GROUP:
AddDoorGroup("NAME OF THE GROUP HERE, you will see this when looking at a door", Team1, Team2, team3, team4, etc.)
---------------------------------------------------------------------------]]


-- Example: AddDoorGroup("Cops and Mayor only", TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR)
-- Example: AddDoorGroup("Gundealer only", TEAM_GUN)

AddDoorGroup("Альянс", TEAM_DEZERTIR, TEAM_UNIT1, TEAM_UNIT2, TEAM_UNIT3, TEAM_UNIT4, TEAM_UNIT5, TEAM_UNITENGINER, TEAM_PILIOTA, TEAM_UNITMEDIC, TEAM_CMDUNIT, TEAM_OTAUNION, TEAM_OTASECURITY, TEAM_OTAHEAVY, TEAM_OTAELITE, TEAM_SNIPER)
AddDoorGroup("ГСР", TEAM_RAZNORABOCHIJ, TEAM_PISHEVOJSNABDITEL, TEAM_GRUZHCHIK, TEAM_POSILNIJ, TEAM_PRACWS, TEAM_DSPMEDIK, TEAM_GLAVADSP)
AddDoorGroup("Партизаны", TEAM_PARTISAN)
