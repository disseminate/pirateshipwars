GM.RoundNum = 0;

GM.Ship = { };
GM.Ship[PSW_R] = { };
GM.Ship[PSW_B] = { };

GM.ShipParts = { };
GM.ShipParts[PSW_R] = { };
GM.ShipParts[PSW_B] = { };

GM.MastsBroken = { };

function GM:EngineSpawnShips()
	
	for _, v in pairs( ents.FindByName( "ship1*" ) ) do v:Remove() end
	for _, v in pairs( ents.FindByName( "ship2*" ) ) do v:Remove() end
	
	ents.FindByName( "buttonspawn" )[1]:Fire( "ForceSpawn", "", 0.1 );
	ents.FindByName( "buttonspawn2" )[1]:Fire( "ForceSpawn", "", 0.1 );
	
end

function GM:SpawnShips()
	
	self:CleanUpMap();
	
	for i = 1, 2 do
		
		if( timer.Exists( "masts1" .. i ) ) then timer.Remove( "masts1" .. i ) end
		if( timer.Exists( "masts2" .. i ) ) then timer.Remove( "masts2" .. i ) end
		if( timer.Exists( "masts3" .. i ) ) then timer.Remove( "masts3" .. i ) end
		
	end
	
	self:EngineSpawnShips();
	
	self.Ship[PSW_R].Sink = false;
	self.Ship[PSW_B].Sink = false;
	
	self.Ship[PSW_R].Disabled = false;
	self.Ship[PSW_B].Disabled = false;
	
	self.NextRegisterParts = CurTime() + 4;
	
end

function GM:MapThink()
	
	if( !self.ShipsSpawned ) then
		
		self:SpawnShips();
		self.ShipsSpawned = true;
		
	end
	
end

function GM:RegisterParts() -- Store all the ship parts in a table for later usage.
	
	for i = 1, 2 do
		
		self.ShipParts[i][1] = ents.FindByName( "ship" .. i .. "bottom2left" )[1];
		self.ShipParts[i][2] = ents.FindByName( "ship" .. i .. "bottom2right" )[1];
		self.ShipParts[i][3] = ents.FindByName( "ship" .. i .. "bottom3left" )[1];
		self.ShipParts[i][4] = ents.FindByName( "ship" .. i .. "bottom3right" )[1];
		self.ShipParts[i][5] = ents.FindByName( "ship" .. i .. "bottom4right" )[1];
		self.ShipParts[i][6] = ents.FindByName( "ship" .. i .. "keel2" )[1];
		self.ShipParts[i][7] = ents.FindByName( "ship" .. i .. "sinker2" )[1];
		self.ShipParts[i][8] = ents.FindByName( "ship" .. i .. "polefront" )[1];
		self.ShipParts[i][9] = ents.FindByName( "ship" .. i .. "mastfront" )[1];
		self.ShipParts[i][10] = ents.FindByName( "ship" .. i .. "mastback" )[1];
		self.ShipParts[i][11] = ents.FindByName( "ship" .. i .. "door" )[1];
		self.ShipParts[i][12] = ents.FindByName( "ship" .. i .. "explosive" )[1];
		self.ShipParts[i][13] = ents.FindByName( "ship" .. i .. "keel" )[1];
		self.ShipParts[i][14] = ents.FindByName( "ship" .. i .. "weldexplosive" )[1];
		self.ShipParts[i][15] = ents.FindByName( "ship" .. i .. "welddoor" )[1];
		self.ShipParts[i][16] = ents.FindByName( "ship" .. i .. "weldpolefront" )[1];
		self.ShipParts[i][17] = ents.FindByName( "ship" .. i .. "weldbottom2left" )[1];
		self.ShipParts[i][18] = ents.FindByName( "ship" .. i .. "weldbottom2right" )[1];
		self.ShipParts[i][19] = ents.FindByName( "ship" .. i .. "weldbottom3left" )[1];
		self.ShipParts[i][20] = ents.FindByName( "ship" .. i .. "weldbottom3right" )[1];
		self.ShipParts[i][21] = ents.FindByName( "ship" .. i .. "weldbottom4right" )[1];
		self.ShipParts[i][22] = ents.FindByName( "ship" .. i .. "weldkeel2" )[1];
		self.ShipParts[i][23] = ents.FindByName( "ship" .. i .. "weldsinker2" )[1];
		self.ShipParts[i][24] = ents.FindByName( "ship" .. i .. "weldmastback" )[1];
		self.ShipParts[i][25] = ents.FindByName( "ship" .. i .. "weldmastfront" )[1];
		self.ShipParts[i][26] = ents.FindByName( "ship" .. i .. "weldsystem" )[1];
		
		self.MastsBroken[i .. "front"] = false;
		self.MastsBroken[i .. "back"] = false;
		self.MastsBroken[i .. "pole"] = false;
		
	end
	
	if( self.PostSpawnShips ) then
		
		self:PostSpawnShips();
		
	end
	
	self:FixupOldPhysics();
	
end

function GM:InitPostEntity()
	
	self.BaseClass:InitPostEntity();
	
	for _, v in pairs( ents.FindByClass( "trigger_hurt" ) ) do
		
		v:Remove();
		
	end
	
	for _, v in pairs( ents.FindByName( "spawnbutton" ) ) do
		
		v:Remove();
		
	end
	
end

function GM:FixupOldPhysics() -- Convert welds to parents.
	
	for i = 1, 2 do
		
		for k, v in pairs( self.ShipParts[i] ) do
			
			local p = v:GetPhysicsObject();
			
			if( p and p:IsValid() ) then
				
				p:EnableDrag( false );
				
				if( k <= 4 ) then
					p:SetMass( 40000 );
				elseif( k == 5 ) then
					p:SetMass( 35000 );
				end
				
			end
			
		end
		
		self.ShipParts[i][14]:Remove(); -- Explosives
		self.ShipParts[i][12]:SetParent( self.ShipParts[i][13] );
		
		self.ShipParts[i][15]:Remove(); -- Doors
		self.ShipParts[i][11]:SetParent( self.ShipParts[i][13] );
		
	end
	
end

function GM:ShipDisable( i )
	
	if( !self.Ship[i].Disabled ) then
		
		self.Ship[i].Disabled = true;
		
		local n = {
			"ship" .. i .. "backwardthruster",
			"ship" .. i .. "forwardthruster",
			"ship" .. i .. "rightthruster",
			"ship" .. i .. "leftthruster",
			"ship" .. i .. "forwardthruster1"
		}
		
		for _, v in pairs( n ) do
			
			for _, n in pairs( ents.FindByName( v ) ) do
				
				n:Remove();
				
			end
			
		end
		
	end
	
end

function GM:ForceSinkShip( i ) -- For debugging
	
	self:ShipDisable( i );
	
	self.Ship[i].n = 35;
	self.Ship[i].NextCounter = CurTime() + 1;
	self.Ship[i].Sink = true;
	
	for v = 1, 4 do
		
		self.ShipParts[i][v]:SetMass( 1000 );
		
	end
	
	self.ShipParts[i][5]:SetMass( 1000 );
	self.ShipParts[i][6]:SetMass( 25000 );
	self.ShipParts[i][7]:SetMass( 15000 );
	
end

function GM:SinkShip( i )
	
	if( !self.Ship[i].Sink ) then
		
		if( self.ShipParts[i][5]:GetMass() < 9000 ) then
			
			self.ShipParts[i][5]:SetMass( self.ShipParts[i][5]:GetMass() - 1000 );
			
			if( self.ShipParts[i][7]:GetMass() < 40000 ) then
				
				self.ShipParts[i][7]:SetMass( self.ShipParts[i][7]:GetMass() + 2000 );
				
			end
			
		end
		
		if( self.ShipParts[i][1]:GetMass() > 2000 ) then
			
			for v = 1, 4 do
				
				self.ShipParts[i][v]:SetMass( self.ShipParts[i][v]:GetMass() - 1000 );
				
			end
			
		else
			
			self:ShipDisable( i );
			
			if( self.ShipParts[i][1]:GetMass() > 1000 ) then
				
				for v = 1, 4 do
					
					self.ShipParts[i][v]:SetMass( self.ShipParts[i][v]:GetMass() - 1000 );
					
				end
				
				self.ShipParts[i][5]:SetMass( 1000 );
				self.ShipParts[i][6]:SetMass( 25000 );
				self.ShipParts[i][7]:SetMass( 15000 );
				
			else
				
				if( !self.Ship[self:InvertTeam( i )].Sink ) then
					
					self.Ship[i].n = 35;
					self.Ship[i].NextCounter = CurTime() + 1;
					self.Ship[i].Sink = true;
					
				end
				
			end
		
		end
		
	end
	
end

function GM:SinkThink()
	
	if( self.NextRegisterParts and CurTime() >= self.NextRegisterParts ) then
		
		self:RegisterParts();
		self.NextRegisterParts = nil;
		
	end
	
	for i = 1, 2 do
		
		if( self.Ship[i].n and self.Ship[i].NextCounter and CurTime() > self.Ship[i].NextCounter ) then
			
			if( self.Ship[i].n == 30 ) then
				
				self.RoundNum = self.RoundNum + 1;
				
				net.Start( "nRoundEnd" );
					net.WriteFloat( self:InvertTeam( i ) );
				net.Broadcast();
				
				for _, v in pairs( team.GetPlayers( i ) ) do
					
					v:StripWeapons();
					
				end
				
				if( GAMEMODE.PointshopPointsRoundWin > 0 ) then
					
					if( i == 1 ) then
						
						for _, v in pairs( team.GetPlayers( 2 ) ) do
							
							if( Pointshop2 ) then
								
								v:PS2_AddStandardPoints( GAMEMODE.PointshopPointsRoundWin, "You won the round!" );
								
							elseif( PS ) then
								
								v:PS_GivePoints( GAMEMODE.PointshopPointsRoundWin );
								
							end
							
						end
						
					else
						
						for _, v in pairs( team.GetPlayers( 1 ) ) do
							
							if( Pointshop2 ) then
								
								v:PS2_AddStandardPoints( GAMEMODE.PointshopPointsRoundWin, "You won the round!" );
								
							elseif( PS ) then
								
								v:PS_GivePoints( GAMEMODE.PointshopPointsRoundWin );
								
							end
							
						end
						
					end
					
				end
				
				self.PlayersCanSpawn = false;
				
			end
			
			if( self.Ship[i].n == 7 ) then
				
				net.Start( "nFadeOut" );
				net.Broadcast();
				
				if( self.RoundNum < self.NumRoundsBeforeCycle ) then
					
					net.Start( "nRestartHUD" );
					net.Broadcast();
					
				end
				
			end
			
			if( self.Ship[i].n == 5 ) then
				
				for _, v in pairs( player.GetAll() ) do
					
					v:StripWeapons();
					v:Spectate( OBS_MODE_FIXED );
					
				end
				
				if( self.RoundNum < self.NumRoundsBeforeCycle ) then
					
					self:SpawnShips();
					
				end
				
			end
			
			if( self.Ship[i].n == 1 ) then
				
				if( self.RoundNum < self.NumRoundsBeforeCycle ) then
					
					net.Start( "nSetRoundNum" );
						net.WriteFloat( self.RoundNum );
					net.Broadcast();
					
					self.Ship[i].NextCounter = nil;
					self.PlayersCanSpawn = true;
					
					for _, v in pairs( player.GetAll() ) do
						
						v:KillSilent();
						v:Spawn();
						
					end
					
					net.Start( "nFadeIn" );
					net.Broadcast();
					
				else
					
					GAMEMODE:StartMapVote(); -- Start a map vote
					
				end
				
			end
			
			self.Ship[i].NextCounter = CurTime() + 1;
			self.Ship[i].n = self.Ship[i].n - 1;
			
			if( self.Ship[i].Sink ) then
				
				if( self.ShipParts[i][1]:GetMass() > 400 ) then
					
					self.ShipParts[i][1]:SetMass( self.ShipParts[i][1]:GetMass() - 200 );
					self.ShipParts[i][2]:SetMass( self.ShipParts[i][1]:GetMass() - 200 );
					
				end
				
				self.ShipParts[i][5]:SetMass( 1000 );
				
				if( self.ShipParts[i][7]:GetMass() <= 40000 ) then
					
					self.ShipParts[i][3]:SetMass( 500 );
					self.ShipParts[i][4]:SetMass( 500 );
					self.ShipParts[i][7]:SetMass( self.ShipParts[i][7]:GetMass() + 1000 );
				
				end
				
				if( self.ShipParts[i][7]:GetMass() > 40000 ) then
					
					self.ShipParts[i][3]:SetMass( 1000 );
					self.ShipParts[i][4]:SetMass( 1000 );
					
					if( self.ShipParts[i][6]:GetMass() > 2000 ) then
						
						self.ShipParts[i][6]:SetMass( self.ShipParts[i][6]:GetMass() - 1000 );
						
					end
					
				end
				
			end
			
		end
		
	end
	
end

function GM:FixTeleportAngles() -- Fix the spawnpoint so that we don't spawn with a tilted view!
	
	for i = 1, 2 do
		
		local ent = ents.FindByName( "ship" .. i .. "playerdestination*" );
		
		for _, v in pairs( ent ) do
			
			local a = v:GetAngles();
			v:SetAngles( Angle( 0, a.y, 0 ) );
			
		end
		
	end
	
end

function GM:FindBoatTeam( ent )
	
	if( type( ent ) == "string" ) then
		
		if( string.find( ent, "ship1" ) or string.find( ent, "s1" ) ) then return PSW_R end
		if( string.find( ent, "ship2" ) or string.find( ent, "s2" ) ) then return PSW_B end
		return;
		
	end
	
	local n = ent:GetName();
	
	if( string.find( n, "ship1" ) or string.find( n, "s1" ) ) then return PSW_R end
	if( string.find( n, "ship2" ) or string.find( n, "s2" ) ) then return PSW_B end
	
end

function GM:BustMasts( name ) -- Break a mast or post off the ship
	
	local c = self:FindBoatTeam( name );
	
	if( c ) then
		
		local rope = ents.FindByName( "ship" .. c .. "rope" ); -- Ropes break and dangle!
		
		for _, v in pairs( rope ) do
			
			v:Remove();
			
		end
		
		if( name == "s" .. c .. "polebreak" ) then
			
			local e = ents.FindByName( "ship" .. c .. "polefront" )[1];
			
			if( e and e:IsValid() ) then
				
				e:Fire( "Kill" );
				
			end
			
		end
		
		if( name == "s" .. c .. "mainbreak" ) then
			
			local e = ents.FindByName( "ship" .. c .. "mastfront" )[1];
			
			if( e and e:IsValid() ) then
				
				e:Fire( "Kill" );
				
			end
			
		end
		
		if( name == "s" .. c .. "rearbreak" ) then
			
			local e = ents.FindByName( "ship" .. c .. "mastback" )[1];
			
			if( e and e:IsValid() ) then
				
				e:Fire( "Kill" );
				
			end
			
		end
		
	end
	
end

function GM:GetRandomShipPart( i )
	
	local ttab = ents.FindByName( "ship" .. i .. "*" );
	table.Merge( ttab, ents.FindByName( "s" .. i .. "*" ) );
	local tab = { };
	
	for _, v in pairs( ttab ) do
		
		if( v:GetClass() == "func_breakable" or v:GetClass() == "func_physbox" ) then
			
			table.insert( tab, v );
			
		end
		
	end
	
	return table.Random( tab );
	
end

function GM:EntityTakeDamage( ent, dmg )
	
	self.BaseClass:EntityTakeDamage( ent, dmg );
	
	local inflictor = dmg:GetInflictor();
	local attacker = dmg:GetAttacker();
	local amt = dmg:GetDamage();
	
	if( ent:IsPlayer() and attacker:IsPlayer() and ent:Team() == attacker:Team() ) then return false end
	if( ent:IsPlayer() ) then return end
	
	if( attacker:IsPlayer() and string.find( ent:GetName(), "ship" ) ) then
		
		if( attacker:Team() == PSW_R and string.find( ent:GetName(), "ship1" ) ) then dmg:SetDamage( 0 ) return end
		if( attacker:Team() == PSW_B and string.find( ent:GetName(), "ship2" ) ) then dmg:SetDamage( 0 ) return end
		
		if( dmg:GetDamageType() == DMG_SLASH and !string.find( ent:GetName(), "door" ) ) then dmg:SetDamage( 0 ) return end -- No melee damage to ships!
		
	end
	
	local p = ent:GetPhysicsObject();
	local c = self:FindBoatTeam( ent );
	local n = ent:GetName();
	
	if( c ) then
		
		if( n == "ship" .. c .. "polefront" ) then
			
			if( string.find( inflictor:GetClass(), "func_physbox" ) and ents.FindByName( "ship" .. c .. "weldpolefront" )[1] ) then
				
				ents.FindByName( "ship" .. c .. "weldpolefront" )[1]:Fire( "Break", "", 1 );
				timer.Create( "masts1" .. c, self.MastRemoveDelay, 1, function() self:BustMasts( "s" .. c .. "polebreak" ) end );
				
			end
			
		end
		
		if( n == "ship" .. c .. "mastfront" ) then
			
			if( string.find( inflictor:GetClass(), "func_physbox" ) and ents.FindByName( "ship" .. c .. "weldmastfront" )[1] ) then
				
				ents.FindByName( "ship" .. c .. "weldmastfront" )[1]:Fire( "Break", "", 1 );
				timer.Create( "masts2" .. c, self.MastRemoveDelay, 1, function() self:BustMasts( "s" .. c .. "mainbreak" ) end );
				
			end
			
		end
		
		if( n == "ship" .. c .. "mastback" ) then
			
			if( string.find( inflictor:GetClass(), "func_physbox" ) and ents.FindByName( "ship" .. c .. "weldmastback" )[1] ) then
				
				ents.FindByName( "ship" .. c .. "weldmastback" )[1]:Fire( "Break", "", 1 );
				timer.Create( "masts3" .. c, self.MastRemoveDelay, 1, function() self:BustMasts( "s" .. c .. "rearbreak" ) end );
				
			end
			
		end
		
		if( string.find( n, "ship" .. c .. "explosive" ) ) then
			
			self:ShipDisable( c );
			
			for i = 1, math.random( 3, 10 ) do
				
				local ent = self:GetRandomShipPart( c );
				
				if( ent and ent:IsValid() ) then
					
					local fireEnt = ents.Create( "env_fire" );
					fireEnt:SetPos( ent:GetPos() );
					fireEnt:SetKeyValue( "spawnflags", "1" );
					fireEnt:SetKeyValue( "attack", "4" );
					fireEnt:SetKeyValue( "firesize", math.random( 64, 128 ) );
					fireEnt:Spawn();
					fireEnt:Activate();
					fireEnt:SetParent( ent );
					fireEnt:Fire( "Enable", "", del );
					fireEnt:Fire( "StartFire", "", del );
					
					SafeRemoveEntityDelayed( fireEnt, math.random( 28, 35 ) );
					
				end
				
			end
			
		elseif( string.find( n, "ship" ) ) then
			
			if( ent:IsPlayer() and dmg:GetDamageType() == DMG_SLASH and !string.find( ent:GetName(), "door" ) ) then return end
			
			ent:SetMass( ent:GetMass() - amt );
			self:SinkShip( c );
			
		end
		
	end
	
end