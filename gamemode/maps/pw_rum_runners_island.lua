function GM:PostSpawnShips()
	
	for i = 1, 2 do
		
		for _, v in pairs( ents.FindByName( "ship" .. i .. "forwardthruster" ) ) do
			
			v:SetSaveValue( "force", 800 );
			
		end
		
		for _, v in pairs( ents.FindByName( "ship" .. i .. "leftthruster" ) ) do
			
			v:SetSaveValue( "force", 300 );
			
		end
		
		for _, v in pairs( ents.FindByName( "ship" .. i .. "rightthruster" ) ) do
			
			v:SetSaveValue( "force", 300 );
			
		end
		
		for _, v in pairs( ents.FindByName( "ship" .. i .. "backwardthruster" ) ) do
			
			v:SetSaveValue( "force", 400 );
			
		end
	
	end
	
end
