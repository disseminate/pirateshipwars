include( "shared.lua" );
include( "sh_playerclass.lua" );
include( "gui/skin.lua" );
include( "cl_binds.lua" );
include( "cl_hud.lua" );
include( "cl_mapcycle.lua" );
include( "cl_scoreboard.lua" );
include( "cl_sound.lua" );

local files = file.Find( GM.FolderName .. "/gamemode/maps/" .. game.GetMap() .. ".lua", "LUA", "namedesc" );

if( #files > 0 ) then

	for _, v in pairs( files ) do
		
		include( "maps/" .. v );
		
	end
	
	MsgC( Color( 200, 200, 200, 255 ), "Map lua file for " .. game.GetMap() .. " loaded clientside.\n" );
	
end

language.Add( "func_physbox", "Cannonball" );
language.Add( "func_breakable", "Ship" );
language.Add( "worldspawn", "Ship" );
language.Add( "trigger_hurt", "Ocean" );
language.Add( "env_explosion", "Explosion" );