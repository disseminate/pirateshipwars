GM.LastWave = 0;
GM.LastBird = 0;

function GM:Think()
	
	self.BaseClass:Think();
	
	if( !self.SeasideAmbience ) then return end
	
	if( LocalPlayer():WaterLevel() == 3 ) then return end
	
	if( CurTime() > self.LastWave + 2 ) then
		
		self.LastWave = CurTime();
		LocalPlayer():EmitSound( "ambient/water/wave" .. math.random( 1, 6 ) .. ".wav", math.random( 20, 40 ) );
		
	end
	
	if( CurTime() > self.LastBird + 6 ) then
		
		self.LastBird = CurTime();
		sound.Play( "ambient/levels/coast/seagulls_ambient" .. math.random( 1, 5 ) .. ".wav", LocalPlayer():EyePos() + Vector( math.random( -256, 256 ), math.random( -256, 256 ), math.random( 0, 256 ) ), 75, 100, math.Rand( 0.2, 0.3 ) );
		
	end
	
end
