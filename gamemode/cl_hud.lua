surface.CreateFont( "PSW_Pirate", {
	font = "Benegraphic",
	size = 128,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "PSW_20", {
	font = "BebasNeue",
	size = 20,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "PSW_22", {
	font = "BebasNeue",
	size = 22,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "PSW_30", {
	font = "BebasNeue",
	size = 30,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "PSW_40", {
	font = "BebasNeue",
	size = 40,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "PSW_60", {
	font = "BebasNeue",
	size = 60,
	weight = 400,
	antialias = true,
	additive = false
} );

surface.CreateFont( "PSW_128", {
	font = "BebasNeue",
	size = 128,
	weight = 400,
	antialias = true,
	additive = false
} );

function GM:DrawGradientBox( col, x, y, w, h )
	
	surface.SetDrawColor( col );
	surface.DrawRect( x, y, w, h );
	
	for i = 1, 20 do
		
		surface.SetDrawColor( Color( col.r + 1 * i, col.g + 1 * i, col.b + 1 * i, col.a ) );
		surface.DrawRect( x, y + ( 20 - i ), w, 1 );
		
	end
	
end

function GM:DrawBoxLines( col, x, y, w, h, density )
	
	surface.SetDrawColor( col );
	
	for i = 0, w + h, density do
		
		if( i < h ) then
			
			surface.DrawLine( x + i, y, x, y + i );
			
		elseif( i > w ) then
			
			surface.DrawLine( x + w, y + i - w, x - h + i, y + h );
			
		else
			
			surface.DrawLine( x + i, y, x + i - h, y + h );
			
		end
		
	end
	
end

function GM:HUDShouldDraw( str )
	
	if( str == "CHudCrosshair" ) then return false end
	if( str == "CHudHealth" or str == "CHudBattery" ) then return false; end
	if( str == "CHudAmmo" or str == "CHudSecondaryAmmo" ) then return false; end
	
	return self.BaseClass:HUDShouldDraw( str );
	
end

local HUDRoundEndStart;
local HUDRoundEndTeam;
local HUDRoundEndBW = 0;
local HUDRoundEndW = 0;

function nRoundEnd()
	
	HUDRoundEndTeam = net.ReadFloat();
	HUDRoundEndStart = CurTime();
	
	local text = "Red Win!";
	
	if( HUDRoundEndTeam == PSW_B ) then
		
		text = "Blue Win!";
		
	end
	
	surface.SetFont( "PSW_Pirate" );
	local w, h = surface.GetTextSize( text );
	
	HUDRoundEndBW = -w;
	HUDRoundEndW = HUDRoundEndBW;
	
	surface.PlaySound( "luashake/sfx/roundover.mp3" );
	
end
net.Receive( "nRoundEnd", nRoundEnd );

GM.RoundNum = 1;

function nSetRoundNum( len )
	
	GAMEMODE.RoundNum = net.ReadFloat() + 1;
	
end
net.Receive( "nSetRoundNum", nSetRoundNum );

function GM:HUDPaintRoundNum()
	
	local col = team.GetColor( LocalPlayer():Team() );
	local text = "Round " .. self.RoundNum;
	
	if( self.RoundNum == self.NumRoundsBeforeCycle ) then
		
		col = Color( 0, 200, 0, 255 );
		text = "Final Round";
		
	end
	
	draw.SimpleTextOutlined( text, "PSW_60", ScrW() - 10, ScrH() - 70, col, 2, 0, 1, Color( 0, 0, 0, 255 ) );
	
end

function GM:HUDPaintRound()
	
	if( HUDRoundEndStart ) then
		
		local col = team.GetColor( HUDRoundEndTeam );
		local text = "Red Win!";
		
		if( HUDRoundEndTeam == PSW_B ) then
			
			text = "Blue Win!";
			
		end
		
		local d = CurTime() - HUDRoundEndStart;
		
		if( d < 1 ) then
			
			HUDRoundEndW = HUDRoundEndBW + ( math.EaseInOut( d, 0, 1 ) * ( ( ScrW() / 2 ) - HUDRoundEndBW ) );
			
		elseif( d < 24 ) then
			
		elseif( d < 25 ) then
			
			HUDRoundEndW = ScrW() / 2 + ( math.EaseInOut( d - 24, 1, 0 ) * ( ( ScrW() / 2 ) - HUDRoundEndBW ) );
			
		else
			
			HUDRoundEndW = ScrW() - HUDRoundEndBW;
			
		end
		
		draw.SimpleTextOutlined( text, "PSW_Pirate", HUDRoundEndW, ScrH() / 4, col, 1, 1, 2, Color( 0, 0, 0, 255 ) );
		
	end
	
end

local HUDRestartStart;
local HUDRestartA = 0;

function nRestartHUD()
	
	HUDRestartStart = CurTime();
	
end
net.Receive( "nRestartHUD", nRestartHUD );

function GM:HUDPaintRestart()
	
	if( HUDRestartStart ) then
		
		local d = CurTime() - HUDRestartStart;
		
		if( d < 1 ) then
			
			HUDRestartA = d;
			
		elseif( d < 6 ) then
			
			HUDRestartA = 1;
			
		elseif( d < 7 ) then
			
			HUDRestartA = 1 - ( d - 6 );
			
		else
			
			HUDRestartA = 0;
			
		end
		
		draw.DrawText( "Please wait, rebuilding ships...", "PSW_Pirate", ScrW() - 10, ScrH() - 128 - 10, Color( 255, 255, 255, HUDRestartA * 255 ), 2 );
		
	end
	
end

function GM:HUDPaintWeaponSelect()
	
	if( self:WeaponSelectOpen() and LocalPlayer():Alive() ) then
		
		local d = CurTime() - self.WeaponSelectRef;
		local a = 1;
		
		if( d > 1.8 ) then
			
			a = 1 - ( d - 1.8 ) / 0.2;
			
		end
		
		local t = LocalPlayer():Team();
		local str = "weapon_" .. ( t == PSW_RED and "r" or "b" ) .. "_";
		
		local y = ScrH() - 30 - 10 - 64 - 64 - 64;
		
		local nslots = #self:WeaponSelectWeapons();
		
		local slot, pos = self:WeaponSelectCurPos();
		
		local w = 40;
		
		local x = ScrW() / 2 - ( nslots * w + ( nslots - 1 ) * 10 + 200 ) / 2;
		
		for i = 0, nslots do
			
			local col = Color( 0, 0, 0, 100 * a );
			local w = 40;
			
			if( slot == i ) then
				
				col = Color( 0, 0, 0, 200 * a );
				w = 200;
				
			end
			
			draw.RoundedBox( 0, x, 10, w, 48, col );
			
			local col = team.GetColor( LocalPlayer():Team() );
			
			if( slot == i ) then
				
				col = Color( 255, 255, 255, 255 );
				
			end
			
			col.a = col.a * a;
			draw.SimpleTextOutlined( i + 1, "PSW_40", x + ( w / 2 ), 14, col, 1, 0, 1, Color( 0, 0, 0, 255 * a ) );
			
			if( slot == i ) then
				
				local y = 68;
				
				for k, v in pairs( self:WeaponSelectWeapons()[slot] ) do
					
					local col = Color( 0, 0, 0, 100 * a );
					
					if( pos == k ) then
						
						col = Color( 0, 0, 0, 200 * a );
						
					end
					
					draw.RoundedBox( 0, x, y, 200, 48, col );
					
					local col = team.GetColor( LocalPlayer():Team() );
					
					if( pos == k ) then
						
						col = Color( 255, 255, 255, 255 );
						
					end
					
					col.a = col.a * a;
					draw.SimpleTextOutlined( v:GetPrintName(), "PSW_40", x + 10, y + 4, col, 0, 0, 1, Color( 0, 0, 0, 255 * a ) );
					
					y = y + 58;
					
				end
				
			end
			
			x = x + w + 10;
			
		end
		
	end
	
end

function GM:HUDPaintHealth()
	
	local h = LocalPlayer():Health();
	
	draw.RoundedBox( 0, 10, ScrH() - 30 - 10, 250, 30, Color( 0, 0, 0, 200 ) );
	
	if( h > 0 ) then
		
		GAMEMODE:DrawGradientBox( Color( 200, 0, 0, 255 ), 12, ScrH() - 30 - 10 + 2, 246 * ( h / 100 ), 26 );
		
	end
	
end

function GM:HUDPaintAmmo()
	
	local w = LocalPlayer():GetActiveWeapon();
	
	if( w and w:IsValid() ) then
		
		if( w.DrawAmmo != false ) then
			
			local c = w:Clip1();
			local r = LocalPlayer():GetAmmoCount( w:GetPrimaryAmmoType() );
			
			local col = team.GetColor( LocalPlayer():Team() );
			draw.SimpleTextOutlined( tostring( c ) .. "/" .. tostring( r ), "PSW_60", 10, ScrH() - 30 - 10 - 64, col, 0, 0, 1, Color( 0, 0, 0, 255 ) );
			
		end
		
	end
	
end

local CurCrossDelta = 12;
local CurCrossThickness = 2;

function GM:HUDPaintCrosshair()
	
	local w = LocalPlayer():GetActiveWeapon();
	
	if( w and w:IsValid() ) then
		
		if( w.DrawCrosshair or self.BaseWepSlots[w:GetClass()] ) then
			
			local col = Color( 255, 255, 255, 255 );
			
			if( w.CrosshairTeam ) then
				
				col = team.GetColor( LocalPlayer():Team() );
				
			end
			
			local d = 12;
			local t = 2;
			
			if( w.CrosshairDelta ) then
				
				d = w.CrosshairDelta;
				
			end
			
			if( w.CrosshairThickness ) then
				
				t = w.CrosshairThickness;
				
			end
			
			if( math.abs( d - CurCrossDelta ) > 0.5 ) then
				
				if( CurCrossDelta > d ) then
					
					CurCrossDelta = CurCrossDelta * 0.98;
					
				else
					
					CurCrossDelta = CurCrossDelta * 1.02;
					
				end
				
			end
			
			if( math.abs( t - CurCrossThickness ) > 0.5 ) then
				
				if( CurCrossThickness > d ) then
					
					CurCrossThickness = CurCrossThickness * 0.98;
					
				else
					
					CurCrossThickness = CurCrossThickness * 1.02;
					
				end
				
			end
			
			local cw = ScrW() / 2;
			local ch = ScrH() / 2;
			
			if( !w.NoCrosshairOutline ) then
				
				surface.SetDrawColor( Color( 0, 0, 0, 200 ) );
				
				surface.DrawRect( cw - 1, ch - 1, CurCrossThickness + 2, CurCrossThickness + 2 );
				surface.DrawRect( cw - CurCrossDelta - 1, ch - 1, CurCrossThickness + 2, CurCrossThickness + 2 );
				surface.DrawRect( cw + CurCrossDelta - 1, ch - 1, CurCrossThickness + 2, CurCrossThickness + 2 );
				surface.DrawRect( cw - 1, ch - CurCrossDelta - 1, CurCrossThickness + 2, CurCrossThickness + 2 );
				surface.DrawRect( cw - 1, ch + CurCrossDelta - 1, CurCrossThickness + 2, CurCrossThickness + 2 );
				
			end
			
			surface.SetDrawColor( col );
			
			surface.DrawRect( cw, ch, CurCrossThickness, CurCrossThickness );
			surface.DrawRect( cw - CurCrossDelta, ch, CurCrossThickness, CurCrossThickness );
			surface.DrawRect( cw + CurCrossDelta, ch, CurCrossThickness, CurCrossThickness );
			surface.DrawRect( cw, ch - CurCrossDelta, CurCrossThickness, CurCrossThickness );
			surface.DrawRect( cw, ch + CurCrossDelta, CurCrossThickness, CurCrossThickness );
			
		end
		
	end
	
end

function GM:HUDPaintOthers()
	
	local trace = { };
	trace.start = LocalPlayer():EyePos();
	trace.endpos = trace.start + LocalPlayer():GetAimVector() * 16384;
	trace.filter = LocalPlayer();
	local tr = util.TraceLine( trace );
	
	if( tr.Entity and tr.Entity:IsValid() ) then
		
		if( tr.Entity:IsPlayer() ) then
			
			local n = tr.Entity:Nick();
			
			surface.SetFont( "PSW_20" );
			local w = 100;
			
			local c = team.GetColor( tr.Entity:Team() );
			
			draw.DrawText( n, "PSW_20", ScrW() / 2, ScrH() / 2 + 40, Color( c.r, c.g, c.b, 255 ), 1 );
			
			if( self.ShowOtherPlayersHealth ) then
				
				draw.RoundedBox( 0, ScrW() / 2 - ( w / 2 ), 34 + ScrH() / 2 - 10 + 40, w, 24, Color( 0, 0, 0, 200 ) );
				
				local h = tr.Entity:Health();
				
				if( h > 0 ) then
					
					GAMEMODE:DrawGradientBox( Color( 200, 0, 0, 255 ), ScrW() / 2 - ( w / 2 ) + 2, 34 + ScrH() / 2 - 8 + 40, ( w - 4 ) * ( h / 100 ), 20 );
					
				end
				
			end
			
		end
		
	end
	
end

local BlackScreenDir = 0;
local BlackScreenStart = 0;
local BlackScreenAlpha = 0;

function nFadeOut( len )
	
	BlackScreenDir = 1;
	BlackScreenStart = CurTime();
	
end
net.Receive( "nFadeOut", nFadeOut );

function nFadeIn( len )
	
	BlackScreenDir = -1;
	BlackScreenStart = CurTime();
	
end
net.Receive( "nFadeIn", nFadeIn );

function GM:HUDPaintFade()
	
	local d = CurTime() - BlackScreenStart;
	
	if( d < 1 ) then
		
		if( BlackScreenDir == 1 ) then
			BlackScreenAlpha = d * 255;
		else
			BlackScreenAlpha = ( 1 - d ) * 255;
		end
		
	else
		
		if( BlackScreenDir == 1 ) then
			BlackScreenAlpha = 255;
		else
			BlackScreenAlpha = 0;
		end
		
	end
	
	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, BlackScreenAlpha ) );
	
end

VotedMap = "";

GM.StarMat = Material( "icon16/star.png" );
GM.SmileMat = Material( "icon16/emoticon_smile.png" );

function GM:HUDPaintMapCycle()
	
	if( DrawMapCycleOn ) then
		
		draw.DrawText( "Vote For Map", "PSW_128", 30, 10, Color( 255, 255, 255, 255 ), 0 );
		
		local tr = math.ceil( 30 - ( CurTime() - MapVoteStart ) );
		draw.DrawText( tostring( tr ), "PSW_128", ScrW() - 30, 10, Color( 255, 255, 255, 255 ), 2 );
		
		for _, n in pairs( MapCycleButtons ) do
			
			n.Votes = 0;
			
		end
		
		for k, v in pairs( MapVotes ) do
			
			for _, n in pairs( MapCycleButtons ) do
				
				local map = n.Map;
				
				if( map == v ) then
					
					n.Votes = n.Votes + 1;
					
					if( k == LocalPlayer() ) then
						
						VotedMap = v;
						
					end
					
				end
				
			end
			
		end
		
		for k, n in pairs( MapCycleButtons ) do
			
			local cx = 330 + 10;
			local cy = 148 + 40 * ( k - 1 ) + 7;
			
			if( n.Map == VotedMap ) then
				
				surface.SetDrawColor( 255, 255, 255, 255 );
				surface.SetMaterial( self.SmileMat );
				surface.DrawTexturedRect( cx, cy, 16, 16 );
				
				cx = cx + 20;
				n.Votes = n.Votes - 1;
				
			end
			
			local v = n.Votes;
			
			if( v > 0 ) then
				
				for i = 1, v do
					
					surface.SetDrawColor( 255, 255, 255, 255 );
					surface.SetMaterial( self.StarMat );
					surface.DrawTexturedRect( cx, cy, 16, 16 );
					
					cx = cx + 20;
					
				end
				
			end
			
		end
		
	end
	
end

function GM:HUDPaint()
	
	if( !GetConVar( "cl_drawhud" ):GetBool() ) then return end
	
	self:HUDPaintHUD();
	self:HUDPaintOthers();
	self:HUDPaintFade();
	self:HUDPaintPostFade();
	
end

function GM:HUDPaintHUD()
	
	self:HUDPaintCrosshair();
	self:HUDPaintWeaponSelect();
	self:HUDPaintHealth();
	self:HUDPaintAmmo();
	self:HUDPaintRound();
	self:HUDPaintRoundNum();
	
end

function GM:HUDPaintPostFade()
	
	self:HUDPaintRestart();
	self:HUDPaintMapCycle();
	
end
