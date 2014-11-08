if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base 			= "weapon_pw_base";

SWEP.PrintName 		= "Cutlass";

SWEP.Slot 			= 0;
SWEP.SlotPos 		= 1;
SWEP.DrawAmmo 		= false;
SWEP.DrawCrosshair 	= true;
SWEP.CrosshairTeam 	= true;
SWEP.CrosshairDelta = 24;
SWEP.ViewModelFlip	= false;

SWEP.ViewModel 		= "models/sabre/v_sabre.mdl";
SWEP.WorldModel 	= "models/sabre/w_sabre.mdl";

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "melee" );
	
end

function SWEP:PrimaryAttack()
	
	self:SetNextPrimaryFire( CurTime() + 0.50 );
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	
	self:PlaySound( "weapons/iceaxe/iceaxe_swing1.wav" );
	
	local trace = { };
	trace.start = self.Owner:GetShootPos();
	trace.endpos = trace.start + self.Owner:GetAimVector() * 75;
	trace.filter = self.Owner;
	local tr = util.TraceLine( trace );
	
	if( tr.Hit ) then
		
		if( tr.Entity:IsPlayer() or tr.Entity:IsNPC() ) then
			self:PlaySound( "physics/flesh/flesh_impact_bullet" .. math.random( 3, 5 ) .. ".wav" );
			util.Decal( "Impact.BloodyFlesh", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
		else
			self:PlaySound( "physics/wood/wood_plank_impact_hard" .. math.random( 1, 5 ) .. ".wav" );
			util.Decal( "Impact.Wood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
		end
		
	end
	
	if( SERVER ) then
		
		if( tr.Entity and tr.Entity:IsValid() ) then
			
			local dmg = DamageInfo();
			dmg:SetDamage( 25 );
			dmg:SetDamageForce( Vector( 0, 0, 1 ) );
			dmg:SetDamagePosition( tr.HitPos );
			dmg:SetDamageType( DMG_SLASH );
			dmg:SetAttacker( self.Owner );
			dmg:SetInflictor( self );
			
			tr.Entity:DispatchTraceAttack( dmg, tr.StartPos, tr.HitPos );
			
		end
		
	end
	
end
