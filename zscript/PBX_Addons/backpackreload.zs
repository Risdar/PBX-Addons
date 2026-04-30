Class PB_backpackreloadItem : inventory
{
	override void tick()
	{
		if(getage() % PBBCKPR_Time == 0)
		{
            if(!(PBXAddons_SettingsFlags & ePBXAddons_DisableSmartScav))
				refillweapons();
		}
	}
	
	void refillweapons()
	{
		for(inventory item = owner.inv; item != null; item = item.inv)
		{
			if(!isPBweapon(item))
				continue;
			let wep = PB_WeaponBase(item);
			if(!wep)
				continue;
			if(wep.getclassname() == owner.player.readyweapon.getclassname())
				continue;
			if(!isReloadable(wep))
				continue;
			
			if(!wep.ammo1 || !wep.ammo2)
				continue;
			
			if(wep.ammo1.amount < 1 && !hasInfiniteAmmo(owner))
				continue;
			
			ReloadWeapon(wep, wep.ammo1, wep.ammo2, false);
			
			if(wep.akimboMode && wep.amount > 1)
			{
				if(!wep.ammoLeft)
					continue;
				ReloadWeapon(wep, wep.ammo1, wep.ammoleft, true);
			}
		}
	}
	
	void ReloadWeapon(PB_WeaponBase wep, ammo am1, ammo am2, bool isLeft = false)
	{
		int cur, maxm, eq, res;
		cur 	= am2.amount;
		maxm 	= am2.maxamount;
		res 	= am1.amount;
		eq 		= wep.ReserveToMagAmmoFactor;
		
		if(res < eq)
			return;
		
		int pendin, releq, amt, giveam;
		
		if(cur < maxm && res >= eq)
		{
			pendin = maxm - cur;
			pendin = min(pendin, PBBCKPR_Ref);
				
			releq = pendin * eq;
			amt = min(releq, res);
			
			giveam = amt / eq;
			
			owner.A_GiveInventory(am2.getclassname(), giveam);
			owner.A_takeinventory(am1.getclassname(), int(giveam * eq), TIF_NOTAKEINFINITE);
			
			// Reset staged reload bools since the weapon has been reloaded
			ResetStagedReload(wep, isLeft);
			
			if(PBBCKPR_Tell && am2.amount >= maxm)
				printreloadedmsg(wep.gettag(), isLeft);
		}
	}

	void ResetStagedReload(PB_WeaponBase wep, bool isLeft = false)
	{
		if(isLeft)
		{
			wep.leftChamberEmpty	= false;
			wep.leftMagEmpty		= false;
			wep.leftMagUnloaded		= false;
		}
		else
		{
			wep.chamberEmpty	= false;
			wep.magEmpty		= false;
			wep.magUnloaded		= false;
		}
	}
	
	bool hasInfiniteAmmo(actor who)
	{
		return (sv_infiniteammo || who.findinventory("PowerInfiniteAmmo", true) != null);
	}
	
	void printreloadedmsg(name w, bool lefts)
	{
		console.printf("%s\cv%s\c- reloaded.", lefts ? "Left " : "", w);
	}
	
	bool isPBweapon(inventory it)
	{
		return it is "PB_WeaponBase";
	}
	
	bool isReloadable(PB_WeaponBase wep)
	{
		if(wep.ammo1 != null && wep.ammo2 != null)
		{
			for(int i = 0; i < self.PB_noreloadweapons.size(); i++)
			{
				if(wep.getclassname() == self.PB_noreloadweapons[i])
					return false;
			}
			return true;
		}
		return false;
	}
	
    // UNUSED
	// int getammoequal(PB_WeaponBase wep)
	// {
	// 	switch(wep.getclassname())
	// 	{
	// 		case 'PBX_Prosurv_LeverAction':
	// 			let LA = PBX_Prosurv_LeverAction(wep);
	// 			if(!LA) return 1;
	// 			switch(LA.LAMode)
	// 			{
	// 				case 0: return 2;
	// 				default:
	// 				case 1: return 1;
	// 			}
	// 		case 'PBX_MetalSniper':
	// 			let sniper = PBX_MetalSniper(wep);
	// 			if(!sniper) return 1;
	// 			int a = sniper.resonanceAmmoLoaded ? 4 : 2;
	// 			return a;
	// 		case 'PBX_Excavator':
	// 		case 'PBX_CyberdemonRL':
	// 		case 'PB_Deagle':
	// 			return 2;
	// 		default:
	// 			return 1;
	// 	}
	// }
	
	static const string PB_noreloadweapons[] = {
		"PB_Unmaker","PBX_DemonExt"
	};
}