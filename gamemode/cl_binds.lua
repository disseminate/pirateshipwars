function GM:ShowTeam()
	
	if( self.Team ) then
		
		self.Team:Remove();
		
	end
	
	self.Team = vgui.Create( "DFrame" );
	self.Team:SetSize( 300, 100 );
	self.Team:SetTitle( "Select Team" );
	self.Team:Center();
	self.Team:MakePopup();
	
	self.TeamRed = vgui.Create( "DButton", self.Team );
	self.TeamRed:SetSize( 135, 56 );
	self.TeamRed:SetPos( 10, 34 );
	self.TeamRed:SetText( "Red" );
	self.TeamRed.DoClick = function()
		
		self.Team:Remove();
		net.Start( "nChangeTeam" );
			net.WriteFloat( PSW_R );
		net.SendToServer();
		
	end
	self.TeamRed.CustomColor = team.GetColor( PSW_R );
	
	self.TeamBlue = vgui.Create( "DButton", self.Team );
	self.TeamBlue:SetSize( 135, 56 );
	self.TeamBlue:SetPos( 155, 34 );
	self.TeamBlue:SetText( "Blue" );
	self.TeamBlue.DoClick = function()
		
		self.Team:Remove();
		net.Start( "nChangeTeam" );
			net.WriteFloat( PSW_B );
		net.SendToServer();
		
	end
	self.TeamBlue.CustomColor = team.GetColor( PSW_B );
	
	local t = LocalPlayer():Team();
	
	if( t == PSW_R or !LocalPlayer():CanChangeTeam( PSW_R ) ) then
		
		self.TeamRed:SetDisabled( true );
		
	end
	
	if( t == PSW_B or !LocalPlayer():CanChangeTeam( PSW_B ) ) then
		
		self.TeamBlue:SetDisabled( true );
		
	end
	
end

GM.WeaponSelectOpenTime = 2;

GM.WeaponSelectRef = GM.WeaponSelectRef or GM.WeaponSelectOpenTime * -1;
GM.WeaponSelectSlot = GM.WeaponSelectSlot or NULL;

function GM:WeaponSelectOpen()
	
	return CurTime() - self.WeaponSelectRef < GAMEMODE.WeaponSelectOpenTime;
	
end

GM.BaseWepSlots = { };
GM.BaseWepSlots["weapon_357"] = { 1, 1 };
GM.BaseWepSlots["weapon_alyxgun"] = { 1, 4 };
GM.BaseWepSlots["weapon_annabelle"] = { 2, 1 };
GM.BaseWepSlots["weapon_ar2"] = { 2, 1 };
GM.BaseWepSlots["weapon_bugbait"] = { 5, 0 };
GM.BaseWepSlots["weapon_citizenpackage"] = { 2, 0 };
GM.BaseWepSlots["weapon_citizensuitcase"] = { 2, 0 };
GM.BaseWepSlots["weapon_crossbow"] = { 3, 1 };
GM.BaseWepSlots["weapon_crowbar"] = { 0, 0 };
GM.BaseWepSlots["weapon_cubemap"] = { 2, 0 };
GM.BaseWepSlots["weapon_frag"] = { 4, 0 };
GM.BaseWepSlots["weapon_physcannon"] = { 0, 1 };
GM.BaseWepSlots["weapon_physgun"] = { 4, 4 };
GM.BaseWepSlots["weapon_pistol"] = { 1, 0 };
GM.BaseWepSlots["weapon_rpg"] = { 4, 1 };
GM.BaseWepSlots["weapon_shotgun"] = { 3, 0 };
GM.BaseWepSlots["weapon_smg1"] = { 2, 0 };
GM.BaseWepSlots["weapon_stunstick"] = { 0, 3 };

function GM:WeaponSelectWeapons()
	
	local tab = { };
	
	for _, v in pairs( LocalPlayer():GetWeapons() ) do
		
		if( v.Slot ) then
			
			if( !tab[v.Slot] ) then tab[v.Slot] = { } end
			
			table.insert( tab[v.Slot], v );
			
		elseif( self.BaseWepSlots[v:GetClass()] ) then
			
			if( !tab[self.BaseWepSlots[v:GetClass()][1]] ) then tab[self.BaseWepSlots[v:GetClass()][1]] = { } end
			
			table.insert( tab[self.BaseWepSlots[v:GetClass()][1]], v );
			
		else
			
			if( !tab[0] ) then tab[0] = { } end
			
			table.insert( tab[0], v );
			
		end
		
	end
	
	for k, v in pairs( tab ) do
		
		table.sort( v, function( a, b )
			
			local apos = 0;
			local bpos = 0;
			
			if( a.SlotPos ) then
				
				apos = a.SlotPos;
				
			end
			
			if( self.BaseWepSlots[a:GetClass()] ) then
				
				apos = self.BaseWepSlots[a:GetClass()][2];
				
			end
			
			if( b.SlotPos ) then
				
				bpos = b.SlotPos;
				
			end
			
			if( self.BaseWepSlots[b:GetClass()] ) then
				
				apos = self.BaseWepSlots[b:GetClass()][2];
				
			end
			
			if( apos == bpos ) then
				
				return a:GetPrintName() < b:GetPrintName();
				
			else
				
				return apos < bpos;
				
			end
			
		end );
		
	end
	
	local max = table.GetKeys( tab )[#table.GetKeys( tab )];
	
	for i = 1, max do
		
		if( !tab[i] ) then tab[i] = { } end
		
	end
	
	return tab;
	
end

function GM:WeaponSelectActivePos()
	
	for k, v in pairs( self:WeaponSelectWeapons() ) do
		
		for m, n in pairs( v ) do
			
			if( n == LocalPlayer():GetActiveWeapon() ) then
				
				return k, m;
				
			end
			
		end
		
	end
	
end

function GM:WeaponSelectCurPos()
	
	for k, v in pairs( self:WeaponSelectWeapons() ) do
		
		for m, n in pairs( v ) do
			
			if( n == self.WeaponSelectSlot ) then
				
				return k, m;
				
			end
			
		end
		
	end
	
end

function GM:GetNextWep( slot, pos )
	
	if( #LocalPlayer():GetWeapons() < 2 ) then return LocalPlayer():GetActiveWeapon() end
	
	local ent = self:WeaponSelectWeapons()[slot][pos - 1];
	
	if( !ent or !ent:IsValid() ) then
		
		for k, v in pairs( self:WeaponSelectWeapons() ) do
			
			if( k == slot ) then
				
				if( self:WeaponSelectWeapons()[k - 1] ) then
					
					return self:GetNextWep( k - 1, #self:WeaponSelectWeapons()[k - 1] + 1 );
					
				else
					
					local weps = self:WeaponSelectWeapons();
					
					return self:GetNextWep( #weps, #weps[#weps] + 1 );
					
				end
				
			end
			
		end
		
	end
	
	return ent;
	
end

function GM:GetPrevWep( slot, pos )
	
	if( #LocalPlayer():GetWeapons() < 2 ) then return LocalPlayer():GetActiveWeapon() end
	
	local s = self:WeaponSelectWeapons()[slot];
	
	if( !s ) then
		
		return self:GetPrevWep( slot + 1, 0 );
		
	end
	
	local ent = self:WeaponSelectWeapons()[slot][pos + 1];
	
	if( !ent or !ent:IsValid() ) then
		
		for k, v in pairs( self:WeaponSelectWeapons() ) do
			
			if( k == slot ) then
				
				if( self:WeaponSelectWeapons()[k + 1] ) then
					
					return self:GetPrevWep( k + 1, 0 );
					
				else
					
					return self:GetPrevWep( 0, 0 );
					
				end
				
			end
			
		end
		
	end
	
	return ent;
	
end

function GM:WeaponSelectScrollUp()
	
	if( #LocalPlayer():GetWeapons() == 0 ) then return end
	
	if( #LocalPlayer():GetWeapons() == 1 ) then
		
		surface.PlaySound( "common/wpn_moveselect.wav" );
		self.WeaponSelectRef = CurTime();
		
		self.WeaponSelectSlot = LocalPlayer():GetActiveWeapon();
		
		return;
		
	end
	
	surface.PlaySound( "common/wpn_moveselect.wav" );
	
	local slot, pos = self:WeaponSelectCurPos();
	
	if( !self.WeaponSelectSlot or !self.WeaponSelectSlot:IsValid() ) then
		
		slot, pos = self:WeaponSelectActivePos();
		
	end
	
	self.WeaponSelectSlot = self:GetNextWep( slot, pos );
	
	self.WeaponSelectRef = CurTime();
	
end

function GM:WeaponSelectScrollDown()
	
	if( #LocalPlayer():GetWeapons() == 0 ) then return end
	
	if( #LocalPlayer():GetWeapons() == 1 ) then
		
		surface.PlaySound( "common/wpn_moveselect.wav" );
		self.WeaponSelectRef = CurTime();
		
		self.WeaponSelectSlot = LocalPlayer():GetActiveWeapon();
		
		return;
		
	end
	
	surface.PlaySound( "common/wpn_moveselect.wav" );
	
	local slot, pos = self:WeaponSelectCurPos();
	
	if( !self.WeaponSelectSlot or !self.WeaponSelectSlot:IsValid() ) then
		
		slot, pos = self:WeaponSelectActivePos();
		
	end
	
	self.WeaponSelectSlot = self:GetPrevWep( slot, pos );
	
	self.WeaponSelectRef = CurTime();
	
end

function GM:WeaponSelectClick()
	
	if( #LocalPlayer():GetWeapons() < 1 ) then return end
	if( !self.WeaponSelectSlot or !self.WeaponSelectSlot:IsValid() ) then return end
	
	surface.PlaySound( "common/wpn_select.wav" );
	
	self.WeaponSelectRef = 0;
	
	net.Start( "nSelectWeapon" );
		net.WriteString( self.WeaponSelectSlot:GetClass() );
	net.SendToServer();
	
	self.WeaponSelectSlot = NULL;
	
end

function GM:WeaponSelectNumber( n )
	
	if( #LocalPlayer():GetWeapons() == 0 ) then return end
	
	local pos = n - 1;
	
	if( GAMEMODE.WeaponSelectFloored ) then
		
		pos = n;
		
	end
	
	surface.PlaySound( "common/wpn_moveselect.wav" );
	
	if( !self:WeaponSelectOpen() or !self.WeaponSelectSlotIndex ) then
		
		self.WeaponSelectSlotIndex = 1;
		
	end
	
	if( self.WeaponSelectSlotPos != n ) then
		
		self.WeaponSelectSlotIndex = 1;
		self.WeaponSelectSlotPos = n;
		
	end
	
	if( self:WeaponSelectWeapons()[pos] ) then
		
		self.WeaponSelectSlot = self:WeaponSelectWeapons()[pos][self.WeaponSelectSlotIndex];
		
		if( !self.WeaponSelectSlot ) then
			
			self.WeaponSelectSlotIndex = 1;
			self.WeaponSelectSlot = self:WeaponSelectWeapons()[pos][self.WeaponSelectSlotIndex];
			
		end
		
		self.WeaponSelectSlotIndex = self.WeaponSelectSlotIndex + 1;
		
	end
	
	self.WeaponSelectRef = CurTime();
	
end

function GM:ShowHelp()
	
	if( self.Help ) then
		
		self.Help:Remove();
		
	end
	
	self.Help = vgui.Create( "DFrame" );
	self.Help:SetSize( 600, 400 );
	self.Help:SetTitle( "Help" );
	self.Help:Center();
	self.Help:MakePopup();
	
	self.Help.Content = vgui.Create( "DPanel", self.Help );
	self.Help.Content:SetPos( 120, 34 );
	self.Help.Content:SetSize( 470, 400 - 34 - 10 );
	self.Help.Content.Paint = function( p, w, h )
		
		surface.SetDrawColor( Color( 0, 0, 0, 200 ) );
		surface.DrawRect( 0, 0, w, h );
		
	end
	
	self.Help.Content.Title = vgui.Create( "DLabel", self.Help.Content );
	self.Help.Content.Title:SetPos( 10, 10 );
	self.Help.Content.Title:SetSize( 450, 30 );
	self.Help.Content.Title:SetFont( "PSW_30" );
	self.Help.Content.Title:SetText( "Help" );
	
	self.Help.Content.Text = vgui.Create( "DLabel", self.Help.Content );
	self.Help.Content.Text:SetPos( 10, 50 );
	self.Help.Content.Text:SetSize( 450, 20 );
	self.Help.Content.Text:SetAutoStretchVertical( true );
	self.Help.Content.Text:SetWrap( true );
	self.Help.Content.Text:SetText( "Select an option on the left." );
	
	local y = 34;
	
	if( GAMEMODE.HelpOptions ) then
		
		for _, v in pairs( GAMEMODE.HelpOptions ) do
			
			local but = vgui.Create( "DButton", self.Help );
			but:SetPos( 10, y );
			but:SetSize( 100, 20 );
			but:SetText( v[1] );
			but.DoClick = function( b )
				
				self.Help.Content.Title:SetText( v[1] );
				
				self.Help.Content.Text:SetText( string.gsub( v[2], "\t", "" ) );
				self.Help.Content.Text:PerformLayout();
				
			end
			
			y = y + 30;
			
		end
		
	end
	
end

function GM:PlayerBindPress( ply, b, d )
	
	if( d and b == "gm_showhelp" ) then
		
		GAMEMODE:ShowHelp();
		return true;
		
	end
	
	if( d and b == "gm_showteam" ) then
		
		GAMEMODE:ShowTeam();
		return true;
		
	end
	
	if( d and string.find( b, "invnext" ) and LocalPlayer():Alive() ) then
		
		self:WeaponSelectScrollDown();
		return true;
		
	end
	
	if( d and string.find( b, "invprev" ) and LocalPlayer():Alive() ) then
		
		self:WeaponSelectScrollUp();
		return true;
		
	end
	
	if( d and string.find( b, "attack" ) and self:WeaponSelectOpen() and LocalPlayer():Alive() ) then
		
		self:WeaponSelectClick();
		return true;
		
	end
	
	if( d and string.find( b, "slot" ) and LocalPlayer():Alive() ) then
		
		local a, _ = string.gsub( b, "slot", "" );
		local n = tonumber( a );
		
		self:WeaponSelectNumber( n );
		
		return true;
		
	end
	
	return self.BaseClass:PlayerBindPress( ply, b, d );
	
end
