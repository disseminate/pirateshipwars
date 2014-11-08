DrawMapCycleOn = false;
CurHoveredMap = "";
MapCycleButtons = { };
AvailableMaps = { };
MapVotes = { };
MapVoteStart = 0;

function nSendMapList( len )
	
	AvailableMaps = net.ReadTable();
	
end
net.Receive( "nSendMapList", nSendMapList );

function nSendMapVotes( len )
	
	MapVotes = net.ReadTable();
	
end
net.Receive( "nSendMapVotes", nSendMapVotes );

function nCreateMapCycleGUI( len )
	
	MapVoteStart = CurTime();
	GAMEMODE:CreateMapCycleGUI();
	
end
net.Receive( "nCreateMapCycleGUI", nCreateMapCycleGUI );

function GM:CreateMapCycleGUI()
	
	DrawMapCycleOn = true;
	
	for k, v in pairs( AvailableMaps ) do
		
		local but = vgui.Create( "DButton" );
		but:SetPos( 30, 148 + 40 * ( k - 1 ) );
		but:SetSize( 300, 30 );
		but:SetText( v );
		but.DoClick = function()
			
			net.Start( "nSubmitMapVote" );
				net.WriteString( v );
			net.SendToServer();
			
		end
		but.OnCursorEntered = function( self )
			
			self:InvalidateLayout( true );
			CurHoveredMap = self.Map;
			
		end
		but.OnCursorExited = function( self )
			
			self:InvalidateLayout( true );
			CurHoveredMap = "";
			
		end
		but.Map = v;
		
		table.insert( MapCycleButtons, but );
		
	end
	
	gui.EnableScreenClicker( true );
	
end

function GM:DestroyMapCycleGUI()
	
	DrawMapCycleOn = false;
	
	for _, v in pairs( MapCycleButtons ) do
		
		v:Remove();
		
	end
	
	MapCycleButtons = { };
	
	gui.EnableScreenClicker( false );
	
end