AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "sh_playerclass.lua" );
AddCSLuaFile( "gui/skin.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "cl_binds.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "cl_mapcycle.lua" );
AddCSLuaFile( "cl_scoreboard.lua" );
AddCSLuaFile( "cl_sound.lua" );

include( "shared.lua" );
include( "sh_playerclass.lua" );
include( "sv_player.lua" );
include( "sv_map.lua" );
include( "sv_mapcycle.lua" );
include( "sv_net.lua" );
include( "sv_resource.lua" );
include( "sv_think.lua" );

local files = file.Find( GM.FolderName .. "/gamemode/maps/" .. game.GetMap() .. ".lua", "LUA", "namedesc" );

if( #files > 0 ) then

	for _, v in pairs( files ) do
		
		include( "maps/" .. v );
		AddCSLuaFile( "maps/" .. v );
		
	end
	
	MsgC( Color( 200, 200, 200, 255 ), "Map lua file for " .. game.GetMap() .. " loaded serverside.\n" );
	
end

function GM:Initialize()
	
	self.BaseClass:Initialize();
	
	game.ConsoleCommand( "sv_sticktoground 0\n" );
	
end

function GM:OnReloaded()
	
	self.BaseClass:OnReloaded();
	
	for _, v in pairs( player.GetAll() ) do
		
		hook.Call( "PlayerInitialSpawn", GAMEMODE, v );
		
	end
	
	self.PlayersInitiallySpawned = false;
	
	for _, v in pairs( player.GetAll() ) do
		
		v.SetRandomTeam = false;
		
	end
	
end

function GM:CleanUpMap()
	
	game.CleanUpMap();
	hook.Call( "InitPostEntity", GAMEMODE, v );
	
end
