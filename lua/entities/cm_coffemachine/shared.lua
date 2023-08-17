ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Раздатчик еды"
ENT.Author = ""
ENT.Category = "Терминалы"

ENT.Spawnable			= true
ENT.AdminOnly			= true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0 , "price" )
	self:NetworkVar( "Entity", 1, "owning_ent" )
end