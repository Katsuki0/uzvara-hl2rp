hook.Add( "PreGamemodeLoaded", "TickWidgets", function()
	widgets.PlayerTick = function() end
	hook.Remove( "PlayerTick", "TickWidgets" )
end )