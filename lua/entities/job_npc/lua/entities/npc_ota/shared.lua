ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "NPC OTA"
ENT.Instructions = "Base entity"
ENT.Category = "NPC"
ENT.Author = "Vend"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "JobName")
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end