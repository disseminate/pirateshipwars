local PLAYER = { };

PLAYER.DisplayName			= "Pirate Ship Wars";

PLAYER.WalkSpeed 			= 200		-- How fast to move when not running
PLAYER.RunSpeed				= 400		-- How fast to move when running
PLAYER.CrouchedWalkSpeed 	= 0.3		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 200		-- How powerful our jump should be
PLAYER.CanUseFlashlight     = true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide 	= false		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= false		-- Automatically swerves around other players
PLAYER.UseVMHands			= true		-- Uses viewmodel hands

function PLAYER:StartMove( move )
end

function PLAYER:FinishMove( move )
end

function PLAYER:Loadout()
end

function PLAYER:SetModel()
	
	local cl_playermodel = self.Player:GetInfo( "cl_playermodel" );
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel );
	util.PrecacheModel( modelname );
	self.Player:SetModel( modelname );
	
	self.Player:SetupHands();
	
end

player_manager.RegisterClass( "player_psw", PLAYER, "player_default" );