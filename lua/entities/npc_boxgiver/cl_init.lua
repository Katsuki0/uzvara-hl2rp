/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/

include('shared.lua')

function ENT:Draw()
    self:DrawModel()
	if(LocalPlayer():GetEyeTrace().Entity == self) then
		if self:GetPos():Distance( LocalPlayer():GetPos() ) < 150 then
			cam.Start3D2D(self:GetPos() + self:GetAngles():Up() * 11, Angle( 0, LocalPlayer():EyeAngles().yaw - 90, 15 ), 0.1 )
				surface.SetDrawColor(161,161,161, 0)
				surface.DrawRect(-150, -30, 300, 45)
				draw.SimpleTextOutlined( "Коробка", "DermaLarge", 0, -10, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
				
				surface.SetDrawColor( Color( 0, 0, 0, 200 ) )
				surface.DrawRect( -135, 25, 270, 0)
				draw.SimpleTextOutlined( "Нажмите ["..input.LookupBinding("+use").."]", "DermaLarge", 0, 50, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "Что бы", "DermaLarge", 0, 80, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
				draw.SimpleTextOutlined( "взаимодействовать", "DermaLarge", 0, 110, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			cam.End3D2D()
		end
	end
end

/*----------------------------------------------------------------------
Leak by Uzvara

Support us in discord.:↓ 
https://discord.gg/aTWZxBP
------------------------------------------------------------------------*/