function GM:Think()
	
	self.BaseClass:Think();
	
	self:MapCycleThink();
	
	if( !self.PlayersInitiallySpawned and CurTime() >= 3 ) then
		
		self:EnableSpawning();
		self.PlayersInitiallySpawned = true;
		
	end
	
	self:MapThink();
	self:SinkThink();
	self:PlayerThink();
	
end

function GM:PlayerThink()
	
	if( !self.WaterDamage ) then return end
	
	for _, v in pairs( player.GetAll() ) do
		
		if( !v.LastWaterDamage ) then
			
			v.LastWaterDamage = 0;
			
		end
		
		if( v:WaterLevel() > 1 and CurTime() > v.LastWaterDamage + self.WaterDamageDelay ) then
			
			v.LastWaterDamage = CurTime();
			v:TakeDamage( self.WaterDamageAmount, game.GetWorld(), game.GetWorld() );
			
		end
		
	end
	
end