util.AddNetworkString("emitradius")
net.Receive( "emitradius", function( len, pl )
    local sound = net.ReadString()
    pl:EmitSound(sound)
end )