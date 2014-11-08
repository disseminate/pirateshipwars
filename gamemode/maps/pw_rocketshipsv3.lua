function GM:PostSpawnShips()
	
	for _, v in pairs( ents.FindByClass( "prop_vehicle_prisoner_pod" ) ) do
		
		local pos = v:GetPos();
		local ang = v:GetAngles();
		local parent = v:GetParent();
		
		ang:RotateAroundAxis( ang:Up(), -90 );
		
		v:Remove();
		
		local chair = ents.Create( "prop_vehicle_prisoner_pod" );
		chair:SetPos( pos + v:GetUp() * -20 );
		chair:SetAngles( ang );
		chair:SetModel( "models/nova/chair_wood01.mdl" );
		chair:SetKeyValue( "vehiclescript", "scripts/vehicles/prisoner_pod.txt" );
		chair:SetKeyValue( "limitview", "0" );
		chair:Spawn();
		chair:Activate();
		chair:SetParent( parent );
		
	end
	
end
