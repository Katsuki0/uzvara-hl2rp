timer.Simple( .1, function()
    hook.Remove( 'PlayerNoClip', 'FAdmin_noclip' )
end)

hook.Add( "PlayerNoClip", "noclip", function( ply )
    if ply:CheckGroup('superadmin') or ply:CheckGroup('Admin') or ply:CheckGroup('operator_VN') or ply:CheckGroup('operator_VD') or ply:CheckGroup('operator_N') or ply:CheckGroup('operator_D') or ply:CheckGroup('Leader') or ply:CheckGroup('Leader_A') then
        return true
    end
end)