local meta = FindMetaTable( "Player" );

GM.MapChangeStart = nil;
GM.ChosenMap = nil;

function GM:StartMapVote()
	
	self.MapChangeStart = CurTime();
	
	net.Start( "nCreateMapCycleGUI" );
	net.Broadcast();
	
end

function GM:MapCycleThink()
	
	if( self.MapChangeStart ) then
		
		if( CurTime() >= self.MapChangeStart + self.MapCycleDelay and !self.ChosenMap ) then
			
			self.ChosenMap = self:GetMapVoteResult();
			
			if( self.ChosenMap ) then
				
				game.ConsoleCommand( "changelevel " .. self.ChosenMap .. "\n" );
				
			else
				
				game.ConsoleCommand( "changelevel " .. game.GetMap() .. "\n" );
				
			end
			
		end
		
	end
	
end

function GM:GetMapVoteResult()
	
	local tab = { };
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v.MapVote ) then
			
			if( !tab[v.MapVote] ) then
				
				tab[v.MapVote] = 0;
				
			end
			
			tab[v.MapVote] = tab[v.MapVote] + 1;
			
		end
		
	end
	
	local b;
	local n = 0;
	
	for k, v in pairs( tab ) do
		
		if( v > n ) then
			
			n = v;
			b = k;
			
		end
		
	end
	
	return b;
	
end

function GM:SubmitMapVote( ply, map )
	
	if( table.HasValue( self:GetMapList(), map ) ) then
		
		ply.MapVote = map;
		self:RefreshMapVotes();
		
	end
	
end

function GM:RefreshMapVotes()
	
	local votes = { };
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v.MapVote ) then
			
			votes[v] = v.MapVote;
			
		end
		
	end
	
	net.Start( "nSendMapVotes" );
		net.WriteTable( votes );
	net.Broadcast();
	
end

function meta:SendMapList()
	
	local tab = GAMEMODE:GetMapList();
	
	net.Start( "nSendMapList" );
		net.WriteTable( tab );
	net.Send( self );
	
end

function nSubmitMapVote( len, ply )
	
	local map = net.ReadString();
	GAMEMODE:SubmitMapVote( ply, map );
	
end
net.Receive( "nSubmitMapVote", nSubmitMapVote );