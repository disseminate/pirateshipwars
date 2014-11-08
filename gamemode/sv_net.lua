function nChangeTeam( len, ply )
	
	local team = net.ReadFloat();
	
	if( ply:CanChangeTeam( team ) ) then
		
		ply:SetTeam( team );
		
		if( GAMEMODE.PlayersCanSpawn ) then
			
			if( ply:Alive() ) then
				
				ply:KillSilent();
				
			end
			
			ply:Spawn();
			
		end
		
	end
	
end
net.Receive( "nChangeTeam", nChangeTeam );
util.AddNetworkString( "nChangeTeam" );

util.AddNetworkString( "nFadeOut" );
util.AddNetworkString( "nFadeIn" );

util.AddNetworkString( "nRoundEnd" );
util.AddNetworkString( "nRestartHUD" );

util.AddNetworkString( "nSetRoundNum" );

util.AddNetworkString( "nSelectWeapon" );

util.AddNetworkString( "nSendMapList" );
util.AddNetworkString( "nSendMapVotes" );
util.AddNetworkString( "nCreateMapCycleGUI" );
util.AddNetworkString( "nSubmitMapVote" );