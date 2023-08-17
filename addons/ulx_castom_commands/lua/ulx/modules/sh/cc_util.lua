local watch = ulx.command( "Utility", "ulx watch", ulx.watch, "!watch", true )
watch:addParam{ type=ULib.cmds.PlayerArg }
watch:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.takeRestOfLine }
watch:addParam{ type=ULib.cmds.BoolArg, invisible=true }
watch:defaultAccess( ULib.ACCESS_ADMIN )
watch:help( "Слежка за игроками" )
watch:setOpposite( "ulx unwatch", { _, _, false, true }, "!unwatch", true )

function ulx.watchlist( calling_ply )
	
	if calling_ply:IsValid() then
		umsg.Start( "open_watchlist", calling_ply )
		umsg.End()
	end
	
end
local watchlist = ulx.command( "Utility", "ulx watchlist", ulx.watchlist, "!watchlist", true )
watchlist:defaultAccess( ULib.ACCESS_ADMIN )
watchlist:help( "Проверить watchlist" )

if ( CLIENT ) then

	local tab = {}
	
	usermessage.Hook( "open_watchlist", function()
		
		local main = vgui.Create( "DFrame" )	
	
			main:SetPos( 50,50 )
			main:SetSize( 700, 400 )
			main:SetTitle( "Watchlist" )
			main:SetVisible( true )
			main:SetDraggable( true )
			main:ShowCloseButton( true )
			main:MakePopup()
			main:Center()

		local list = vgui.Create( "DListView", main )
			list:SetPos( 4, 27 )
			list:SetSize( 692, 369 )
			list:SetMultiSelect( false )
			list:AddColumn( "SteamID" )
			list:AddColumn( "Name" )
			list:AddColumn( "Admin" )
			list:AddColumn( "Reason" )
			list:AddColumn( "Time" )

			net.Start( "RequestFiles" )
			net.SendToServer()
			
			net.Receive( "RequestFilesCallback", function()
			
				table.Empty( tab )
				
				local name = net.ReadString()
				local toIns = net.ReadTable()
				
				table.insert( tab, { name:gsub( "X", ":" ):sub( 1, -5 ), toIns[ 1 ], toIns[ 2 ], toIns[ 3 ], toIns[ 4 ] } )
				
				for k, v in pairs( tab ) do
					list:AddLine( v[ 1 ], v[ 2 ], v[ 3 ], v[ 4 ], v[ 5 ] )
				end
				
			end )
			
			list.OnRowRightClick = function( main, line )
			
				local menu = DermaMenu()
				
					menu:AddOption( "Copy SteamID", function()
						SetClipboardText( list:GetLine( line ):GetValue( 1 ) )
						chat.AddText( "SteamID Copied" )
					end ):SetIcon( "icon16/tag_blue_edit.png" )
					
					menu:AddOption( "Copy Name", function()
						SetClipboardText( list:GetLine( line ):GetValue( 2 ) )
						chat.AddText( "Username Copied" )
					end ):SetIcon( "icon16/user_edit.png" )
					
					menu:AddOption( "Copy Reason", function()
						SetClipboardText( list:GetLine( line ):GetValue( 4 ) )
						chat.AddText( "Reason Copied" )
					end ):SetIcon( "icon16/note_edit.png" )
					
					menu:AddOption( "Copy Time", function()
						SetClipboardText( list:GetLine( line ):GetValue( 5 ) )
						chat.AddText( "Time Copied" )
					end ):SetIcon( "icon16/clock_edit.png" )	
					
					menu:AddOption( "Remove", function()
					
						net.Start( "RequestDeletion" )
							net.WriteString( list:GetLine( line ):GetValue( 1 ) )
							net.WriteString( list:GetLine( line ):GetValue( 2 ) )
						net.SendToServer()
						
						list:Clear()
						
						table.Empty( tab )
						
						net.Start( "RequestFiles" )
						net.SendToServer()
						
						net.Receive( "RequestFilesCallback", function()
						
							local name = net.ReadString()
							local toIns = net.ReadTable()
							
							table.insert( tab, { name:gsub( "X", ":" ):sub( 1, -5 ), toIns[ 1 ], toIns[ 2 ], toIns[ 3 ], toIns[ 4 ] } )
							
							for k, v in pairs( tab ) do
								list:AddLine( v[ 1 ], v[ 2 ], v[ 3 ], v[ 4 ], v[ 5 ] )
							end
							
						end )	
						
					end ):SetIcon( "icon16/table_row_delete.png" )

					menu:AddOption( "Ban by SteamID", function()
					
						local Frame = vgui.Create( "DFrame" )
						Frame:SetSize( 250, 98 )
						Frame:Center()
						Frame:MakePopup()
						Frame:SetTitle( "Ban by SteamID..." )
						
						local TimeLabel = vgui.Create( "DLabel", Frame )
						TimeLabel:SetPos( 5,27 )
						TimeLabel:SetColor( Color( 0,0,0,255 ) )
						TimeLabel:SetFont( "DermaDefault" )
						TimeLabel:SetText( "Time:" )
						
						local Time = vgui.Create( "DTextEntry", Frame )
						Time:SetPos( 47, 27 )
						Time:SetSize( 198, 20 )
						Time:SetText( "" )
						
						local ReasonLabel = vgui.Create( "DLabel", Frame )
						ReasonLabel:SetPos( 5,50 )
						ReasonLabel:SetColor( Color( 0,0,0,255 ) )
						ReasonLabel:SetFont( "DermaDefault" )
						ReasonLabel:SetText( "Reason:" )
						
						local Reason = vgui.Create( "DTextEntry", Frame )
						Reason:SetPos( 47, 50 )
						Reason:SetSize( 198, 20 )
						Reason:SetText("")
						
						local execbutton = vgui.Create( "DButton", Frame )
						execbutton:SetSize( 75, 20 )
						execbutton:SetPos( 47, 73 )
						execbutton:SetText( "Ban!" )
						execbutton.DoClick = function()
							RunConsoleCommand( "ulx", "banid", tostring( list:GetLine( line ):GetValue( 1 ) ), Time:GetText(), Reason:GetText() )
							Frame:Close()
						end
		
						local cancelbutton = vgui.Create( "DButton", Frame )
						cancelbutton:SetSize( 75, 20 )
						cancelbutton:SetPos( 127, 73 )
						cancelbutton:SetText( "Cancel" )
						cancelbutton.DoClick = function( cancelbutton )
							Frame:Close()
						end
						
					end ):SetIcon( "icon16/tag_blue_delete.png" )	
					
				menu:Open()	
				
			end
			
	end )
	
end