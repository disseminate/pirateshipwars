DeriveGamemode( "base" );

GM.Name = "Pirate Ship Wars";

-------------------- BEGIN CONFIG --------------------

GM.NumRoundsBeforeCycle		= 5; -- Number of rounds before the map cycle pops up
GM.PointshopPointsRoundWin	= 5; -- Pointshop points to be awarded upon winning the round
GM.PlayersNoCollide			= true; -- Should players be nocollided to each other?
GM.SeasideAmbience			= true; -- Should seagulls and waves be played?
GM.ShowOtherPlayersHealth	= true; -- Should players be able to see other players' health?
GM.WaterDamage				= true; -- Should the water damage players?
GM.WaterDamageDelay			= 0.5; -- Damage below is dealt after this many seconds in the water
GM.WaterDamageAmount		= 2.5; -- Damage to be taken in the water
GM.MastRemoveDelay			= 60; -- Broken masts are deleted this many seconds after breaking off
GM.MapCycleDelay			= 30; -- How many seconds map voting lasts

GM.HelpOptions = {
	{ "Pirate Ship Wars", [[The goal of the game is to sink the enemy team's boat using your weapons and cannons.

	Beware of the water - it's cold!

	If nobody's moving the ship, press E on the wheel to pilot it and use normal movement controls to reposition your ship.

	Press F2 to change your team.

	When you sink the other team's ship, you win the round!]] },
	{ "Credits", [[Gamemode by disseminate.]] },
};

GM.WorkshopMaps = { };
GM.WorkshopMaps["pw_rum_runners_island"] = 136503995; -- Workshop ID (http://steamcommunity.com/sharedfiles/filedetails/?id=316995439)
GM.WorkshopMaps["pw_ocean_day"] = 135717355;
GM.WorkshopMaps["pw_fort_thunder"] = 188267379;
GM.WorkshopMaps["pw_canyonwars"] = 188266487;
GM.WorkshopMaps["pw_waterfalls"] = 188236499;

-------------------- END CONFIG --------------------

local meta = FindMetaTable( "Entity" );
local pmeta = FindMetaTable( "Player" );

PSW_R = 1;
PSW_B = 2;

team.SetUp( PSW_R, "Red", Color( 255, 40, 40, 255 ) );
team.SetUp( PSW_B, "Blue", Color( 50, 150, 255, 255 ) );

function GM:InvertTeam( i )
	
	return 3 - i; -- Return the other team
	
end

function meta:GetMass()
	
	local p = self:GetPhysicsObject();
	
	if( p and p:IsValid() ) then
		
		return p:GetMass();
		
	end
	
	return 0;
	
end

function GM:GetMapList()
	
	local f, d = file.Find( "maps/pw*.bsp", "GAME" );
	
	for k, v in pairs( f ) do
		
		f[k] = string.sub( v, 1, -5 ); -- remove .bsp
		
	end
	
	return f;
	
end

function GM:ShouldCollide( a, b )
	
	if( self.PlayersNoCollide and a:IsPlayer() and b:IsPlayer() ) then return false end
	return self.BaseClass:ShouldCollide( a, b );
	
end

function meta:SetMass( i )
	
	if( i < 5 ) then
		i = 5;
	end
	
	local p = self:GetPhysicsObject();
	
	if( p and p:IsValid() ) then
		
		p:SetMass( i );
		
	end
	
end

function pmeta:CanChangeTeam( t )
	
	if( self:Team() != t ) then
		
		if( team.NumPlayers( t ) + 1 <= team.NumPlayers( self:Team() ) ) then
			
			return true;
			
		end
		
	end
	
	return false;
	
end