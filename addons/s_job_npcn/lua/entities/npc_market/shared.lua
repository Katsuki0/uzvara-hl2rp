ENT.Base = "base_ai" 
ENT.Type = "ai"

ENT.PrintName= "Торговец"
ENT.Category = "Easy NPC Shop"
ENT.Author= "Ferzux"
ENT.Spawnable = true
ENT.AdminSpawnable = false
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

hook.Add("HUDPaint", "SellerName", function()
	for i, v in pairs (ents.FindByClass("npc_market")) do
		if v:GetPos():Distance(LocalPlayer():GetPos()) < 300 && v:GetPos():Distance(LocalPlayer():GetPos()) > 50 then
			local _pos = v:GetPos() + Vector( 0, 0, 73 );
			_pos = _pos:ToScreen();
			if( LocalPlayer():IsLineOfSightClear( v:GetPos() + Vector( 0, 0, 73 ) ) ) then
				local _title = ""
				local _w, _h = 30;
				draw.DrawText( _title, "SalesName", _pos.x - ( _w / 1 ) - 1 - 18, _pos.y - 30, Color( 255, 255, 255, 255 ), ALIGN_CENTER );
			end
		end
	end
end)