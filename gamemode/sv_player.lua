GM.PlayersCanSpawn = false;

function GM:EnableSpawning()
	
	self.PlayersCanSpawn = true;
	
	for _, v in pairs( player.GetAll() ) do
		
		v:KillSilent();
		
	end
	
end

function GM:PlayerInitialSpawn( ply )
	
	self.BaseClass:PlayerInitialSpawn( ply );
	
	player_manager.SetPlayerClass( ply, "player_psw" );
	
	ply:SetCustomCollisionCheck( true );
	
	net.Start( "nSetRoundNum" );
		net.WriteFloat( self.RoundNum );
	net.Send( ply );
	
end

function GM:PlayerInitialSpawnSafe( ply )
	
	ply:SendMapList();
	
end

function GM:PlayerSpawn( ply )
	
	self.BaseClass:PlayerSpawn( ply );
	
	if( !ply.SafeSpawned ) then
		
		ply.SafeSpawned = true;
		self:PlayerInitialSpawnSafe( ply );
		
	end
	
	if( !ply.SetRandomTeam ) then
		
		ply.SetRandomTeam = true;
		
		local r = team.NumPlayers( PSW_R );
		local b = team.NumPlayers( PSW_B );
		
		if( r == b ) then
			
			ply:SetTeam( math.random( 1, 2 ) );
			
		elseif( r > b ) then
			
			ply:SetTeam( PSW_B );
			
		else
			
			ply:SetTeam( PSW_R );
			
		end
		
		ply:Spawn();
		
	end
	
end

function GM:PlayerLoadout( ply )
	
	if( ply:Team() == PSW_R ) then
		
		ply:Give( "weapon_r_sabre" );
		ply:Give( "weapon_r_pistol" );
		ply:Give( "weapon_r_musket" );
		
	elseif( ply:Team() == PSW_B ) then
		
		ply:Give( "weapon_b_sabre" );
		ply:Give( "weapon_b_pistol" );
		ply:Give( "weapon_b_musket" );
		
	end
	
end

function nSelectWeapon( len, ply )
	
	local wep = net.ReadString();
	ply:SelectWeapon( wep );
	
end
net.Receive( "nSelectWeapon", nSelectWeapon );

function GM:PlayerSelectSpawn( ply )
	
	self:FixTeleportAngles();
	
	local r = team.NumPlayers( PSW_R ); -- Autobalance
	local b = team.NumPlayers( PSW_B );
	
	if( r > b + 1 ) then
		
		ply:SetTeam( PSW_B );
		
	elseif( b > r + 1 ) then
		
		ply:SetTeam( PSW_R );
		
	end
	
	local t = { };
	
	if( ply:Team() == PSW_R ) then
		
		t = ents.FindByClass( "info_player_start" );
		
	else
		
		t = ents.FindByClass( "info_player_deathmatch" );
		
	end
	
	local n = { };
	local c = false;
	
	for _, v in pairs( t ) do
		
		if( v:IsValid() and v:IsInWorld() ) then
			
			if( !ply.LastSpawn or ply.LastSpawn != v ) then
				
				c = true;
				ply.LastSpawn = v;
				
				return v;
				
			end
			
		end
		
	end
	
	if( !c ) then
		
		return ply;
		
	end
	
end

function GM:PlayerDeathThink( ply )
	
	if( ply.NextSpawnTime and ply.NextSpawnTime > CurTime() ) then return end
	if( !self.PlayersCanSpawn ) then return end
	
	if( ply:KeyPressed( IN_ATTACK ) or ply:KeyPressed( IN_ATTACK2 ) or ply:KeyPressed( IN_JUMP ) ) then
		
		ply:Spawn();
		
	end
	
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	
	if( attacker:IsPlayer() ) then
		
		if( ply:Team() == attacker:Team() ) then
			
			return false;
			
		end
		
	end
	
	return self.BaseClass:PlayerShouldTakeDamage( ply, attacker );
	
end

local meta = FindMetaTable( "Player" );

if( !meta.OldSetTeam ) then meta.OldSetTeam = meta.SetTeam end

function meta:SetTeam( i )
	
	self:OldSetTeam( i );
	
	local c = team.GetColor( i );
	self:SetPlayerColor( Vector( c.r / 255, c.g / 255, c.b / 255 ) );
	
end
