if( SERVER ) then
	
	AddCSLuaFile( "shared.lua" );
	
end

SWEP.PrintName 		= "Base";
SWEP.Author			= "disseminate";
SWEP.Slot 			= 1;
SWEP.SlotPos 		= 1;
SWEP.ViewModelFlip 	= false;

SWEP.BounceWeaponIcon 	= false;
SWEP.DrawWeaponInfoBox 	= false;

SWEP.Spawnable		= true;

SWEP.ViewModel 		= "";
SWEP.WorldModel 	= "";

SWEP.SwayScale		= 0;

SWEP.HolsterDelay	= 0.5;

SWEP.Primary.ClipSize 		= -1;
SWEP.Primary.DefaultClip 	= -1;
SWEP.Primary.Ammo			= "";
SWEP.Primary.Automatic		= false;

SWEP.Secondary.ClipSize 	= -1;
SWEP.Secondary.DefaultClip 	= -1;
SWEP.Secondary.Ammo			= "";
SWEP.Secondary.Automatic	= false;

local ActIndex = {
	[ "pistol" ] 		= ACT_HL2MP_IDLE_PISTOL,
	[ "revolver" ] 		= ACT_HL2MP_IDLE_REVOLVER,
	[ "smg" ] 			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ] 		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ] 			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ] 		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]	 		= ACT_HL2MP_IDLE_RPG,
	[ "gravgun" ] 		= ACT_HL2MP_IDLE_GRAVGUN,
	[ "crossbow" ] 		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ] 		= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ] 			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "zombie" ]		= ACT_HL2MP_IDLE_ZOMBIE,
}

function SWEP:SetWeaponHoldType( t )
	
	local index = ActIndex[ t ]
	
	self.ActivityTranslate = { }
	self.ActivityTranslate [ ACT_MP_STAND_IDLE ] 				= index
	self.ActivityTranslate [ ACT_MP_WALK ] 						= index+1
	self.ActivityTranslate [ ACT_MP_RUN ] 						= index+2
	self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] 				= index+3
	self.ActivityTranslate [ ACT_MP_CROUCHWALK ] 				= index+4
	self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] 	= index+5
	self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index+5
	self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]		 		= index+6
	self.ActivityTranslate [ ACT_MP_JUMP ] 						= index+7
	self.ActivityTranslate [ ACT_RANGE_ATTACK1 ] 				= index+8
	
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end

end

function SWEP:TranslateActivity( act )
	
	if( self.ActivityTranslate[ act ] ) then
		return self.ActivityTranslate[ act ]
	end
	
	return -1
	
end

function SWEP:Initialize()
	
	self:SetWeaponHoldType( "normal" );
	
end

function SWEP:Reload()
end

function SWEP:Deploy()
	
	self:SendWeaponAnim( ACT_VM_DRAW );
	self:ChildDeploy();
	
	return true;
	
end

function SWEP:ChildDeploy()
end

function SWEP:Holster()
	
	return true;
	
end

function SWEP:Think()
	
	self:ChildThink();
	
end

function SWEP:ChildThink()
end

function SWEP:PlaySound( snd, vol, pit )
	
	if( SERVER ) then
		
		self.Owner:EmitSound( snd, vol, pit );
		
	end
	
end

function SWEP:DropToGround()
	
	local trace = { };
	trace.start = self:GetPos();
	trace.endpos = trace.start - Vector( 0, 0, 4096 );
	trace.filter = self;
	
	local tr = util.TraceLine( trace );
	self:SetPos( tr.HitPos );
	
	self:SetAngles( Angle() );
	
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:GetViewModelPosition( pos, ang )
	
	local vOriginalOrigin = pos;
	local vOriginalAngles = ang;
	
	if( !self.m_vecLastFacing ) then
		
		self.m_vecLastFacing = vOriginalOrigin;
		
	end
	
	local forward = vOriginalAngles:Forward();
	local right = vOriginalAngles:Right();
	local up = vOriginalAngles:Up();
	
	local vDifference = self.m_vecLastFacing - forward;
	
	local flSpeed = 7;
	
	local flDiff = vDifference:Length();
	if( flDiff > 1.5 ) then
		
		flSpeed = flSpeed * ( flDiff / 1.5 );
		
	end
	
	vDifference:Normalize();
	
	self.m_vecLastFacing = self.m_vecLastFacing + vDifference * flSpeed * FrameTime();
	self.m_vecLastFacing:Normalize();
	pos = pos + ( vDifference * -1 ) * 5;
	
	return pos, ang;
	
end

function SWEP:DrawWorldModel()
	
	if( self.CustomWorldPos and self.Owner and self.Owner:IsValid() ) then
		
		local hand = self.Owner:GetAttachment( self.Owner:LookupAttachment( "anim_attachment_rh" ) );
		
		if( hand ) then
			
			local pos = hand.Pos;
			local ang = hand.Ang;
			
			ang = ang + self.CustomWorldPosA;
			pos = pos + ang:Forward() * self.CustomWorldPosP.x + ang:Right() * self.CustomWorldPosP.y + ang:Up() * self.CustomWorldPosP.z;
			
			self:SetRenderOrigin( pos );
			self:SetRenderAngles( ang );
			self:SetModelScale( self.CustomWorldPosS, 0 );
			
		end
		
	end
	
	self:DrawModel();
	
end

function SWEP:ShootBullets( n, spread, force, dmg )
	
	local bullet = { };
	bullet.Num = n;
	bullet.Src = self.Owner:GetShootPos();
	bullet.Dir = self.Owner:GetAimVector();
	bullet.Spread = Vector( spread, spread, 0 );
	bullet.Tracer = 1;
	bullet.Force = force;
	bullet.Attacker = self.Owner;
	bullet.Damage = dmg;
	
	self:FireBullets( bullet );
	
end
