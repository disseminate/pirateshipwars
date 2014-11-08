if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base 			= "weapon_pw_base";

SWEP.PrintName 		= "Pistol";

SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;
SWEP.DrawCrosshair 	= true;
SWEP.CrosshairTeam 	= true;
SWEP.CrosshairDelta = 20;
SWEP.ViewModelFlip	= false;

--killicon.Add("weapon_sabre", "deathnotify/pistol_kill", Color(255,255,255,255))
--SWEP.WepSelectIcon = surface.GetTextureID("gmod/SWEP/pistol_select")

SWEP.ViewModel 		= "models/pistol_a/v_pistol_a.mdl";
SWEP.WorldModel 	= "models/pistol_a/w_pistol_a.mdl";

SWEP.Primary.ClipSize 		= 1;
SWEP.Primary.DefaultClip 	= 2;
SWEP.Primary.Ammo			= "pistol";
SWEP.Primary.Automatic		= false;

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "pistol" );
	
end

function SWEP:Reload()
	
	self.Weapon:DefaultReload( ACT_VM_RELOAD );
	
end

function SWEP:PrimaryAttack()
	
	if( !self:CanPrimaryAttack() ) then return end
	self:TakePrimaryAmmo( 1 );
	
	self:SetNextPrimaryFire( CurTime() + 0.30 );
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	self:PlaySound( Sound( "Weapon_357.Single" ) );
	
	local bullet 		= { };
	bullet.Num			= 1;
	bullet.Src 			= self.Owner:GetShootPos();
	bullet.Dir 			= self.Owner:GetAimVector();
	bullet.Spread 		= Vector( 0.05, 0.05, 0 );
	bullet.AmmoType 	= "pistol";
	bullet.TracerName	= "Tracer";
	bullet.Tracer		= 1;
	bullet.Force		= 0;
	bullet.Damage		= 90;
	bullet.Attacker		= self.Owner;
	bullet.Inflictor	= self;
	
	self:FireBullets( bullet );
	
end
