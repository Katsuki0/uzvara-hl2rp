local player = LocalPlayer()
local numSlider

	hook.Add( "AddToolMenuCategories", "DeathGunDrop_Category", function()
		spawnmenu.AddToolCategory( "Utilities", "DeathDrop", "#Death Drop" )
	end )

	hook.Add( "PopulateToolMenu", "DeathGunDrop_Settings", function()
		spawnmenu.AddToolMenuOption( "Utilities", "DeathDrop", "DeathGrunDropMenu", "#Settings", "", "", function( panel )
			panel:ClearControls()
			numSlider = panel:NumSlider( "Max Drops", "sv_maxdrops", 0, 20 )
			numSlider:SetDecimals(20)
			numSlider.ValueChanged = function(pSelf, fValue)
				print("Max Drops changed to: "..fValue)
				net.Start( "MaxDrops_Update" )
				net.WriteInt( fValue, 6) -- Only 2 bits are needed to store the number "3", but we add one because of the rule.
				net.SendToServer()
			end
		end )
	end )
