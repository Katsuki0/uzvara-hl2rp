
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = ""
ENT.Author = "Dan"
ENT.Spawnable = false
ENT.AdminSpawnable = false


function ENT:AddNetworkVar( type, name )
	self.nwvarscnt = self.nwvarscnt or {}

	self.nwvarscnt[type] = (self.nwvarscnt[type] or -1) + 1

	self:NetworkVar( type, self.nwvarscnt[type], name )
end

function ENT:SetupDataTables()
	self:AddNetworkVar( "Int", "Money" )

	self:AddNetworkVar( "Float", "Temp" )
	self:AddNetworkVar( "Float", "Power" )

	self:AddNetworkVar( "Entity", "owning_ent" )

	self:AddNetworkVar( "Bool", "HasCooler" )


	rPrint.TriggerEvent( "PRINTER_SetupDataTables", self )
end
