if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base 			= "weapon_pw_base";

SWEP.PrintName 		= "Musket";

SWEP.Slot 			= 1;
SWEP.SlotPos 		= 2;
SWEP.DrawCrosshair 	= true;
SWEP.CrosshairTeam 	= true;
SWEP.ViewModelFlip	= false;

SWEP.ViewModel 		= "models/charleville/v_charleville.mdl";
SWEP.WorldModel 	= "models/brownbess/w_brownbess.mdl";

SWEP.Primary.ClipSize 		= 1;
SWEP.Primary.DefaultClip 	= 2;
SWEP.Primary.Ammo			= "buckshot";
SWEP.Primary.Automatic		= false;

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "shotgun" );
	
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
	
	self:PlaySound( Sound( "Weapon_Shotgun.Single" ) );
	
	local bullet 		= { };
	bullet.Num			= 1;
	bullet.Src 			= self.Owner:GetShootPos();
	bullet.Dir 			= self.Owner:GetAimVector();
	bullet.Spread 		= Vector( 0.02, 0.02, 0 );
	bullet.AmmoType 	= "buckshot";
	bullet.TracerName	= "Tracer";
	bullet.Tracer		= 1;
	bullet.Force		= 0;
	bullet.Damage		= 150;
	bullet.Attacker		= self.Owner;
	bullet.Inflictor	= self;
	
	self:FireBullets( bullet );
	
end

function SWEP:SecondaryAttack()
	
	self:SetNextSecondaryFire( CurTime() + 0.50 );
	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK );
	
	self:PlaySound( "weapons/iceaxe/iceaxe_swing1.wav" );
	
	local trace = { };
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 100;
	trace.filter = self.Owner;
	local tr = util.TraceLine( trace );
	
	if( tr.Hit ) then
		
		if( tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) then
			tr.Entity:EmitSound( "physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav" );
			util.Decal( "Impact.BloodyFlesh", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
		else
			tr.Entity:EmitSound( "physics/wood/wood_plank_impact_hard" .. math.random( 1, 5 ) .. ".wav" );
			util.Decal( "Impact.Wood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
		end
		
		if( SERVER ) then
			
			if( tr.Entity and tr.Entity:IsValid() ) then
				
				local dmg = DamageInfo();
				dmg:SetDamage( 40 );
				dmg:SetDamageForce( tr.Normal * 50 );
				dmg:SetDamagePosition( tr.HitPos );
				dmg:SetDamageType( DMG_SLASH );
				dmg:SetAttacker( self.Owner );
				dmg:SetInflictor( self );
				
				tr.Entity:DispatchTraceAttack( dmg, tr );
				
			end
			
		end
		
	end
	
end
