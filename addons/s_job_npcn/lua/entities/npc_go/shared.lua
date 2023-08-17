ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName = "Гражданская Оборона"
ENT.Instructions = "Base entity"
ENT.Category = "Профессии"
ENT.Author = "Vend"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "JobName")
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end