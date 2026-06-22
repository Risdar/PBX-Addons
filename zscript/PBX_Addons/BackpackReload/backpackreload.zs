Class PB_backpackreloadItem : inventory
{
	// Always do every tic
	override void tick()
	{
		// Check if disabled
		if(PBXAddons_SettingsFlags & ePBXAddons_DisableBackpackReload)
			return;
			
		// Reload every PBBCKPR_Time
		if(getage() % PBBCKPR_Time == 0)
		{
			refillweapons();
		}
	}
	
	// The function that does the backpack reload
	// Mostly does a series of checks and calls ReloadWeapon() which is the actual reload function
	void refillweapons()
	{
		// Loop through all the weapons in the player's inventory
		for(inventory item = owner.inv; item != null; item = item.inv)
		{
			// Do a series of checks
			if(!isPBweapon(item))
				continue;

			// Cast the weapon and check
			let wep = PB_WeaponBase(item);
			if(!wep)
				continue;

			// Is the weapon currently being held
			if(wep.getclassname() == owner.player.readyweapon.getclassname())
				continue;

			// Can it be reloaded (using ammotype2)
			if(!isReloadable(wep))
				continue;

			// Does the weapon actually have ammo
			if(!wep.ammo1 || !wep.ammo2)
				continue;

			// Does the weaponn still have reserver ammo
			if(wep.ammo1.amount < 1 && !hasInfiniteAmmo(owner))
				continue;

			// Do reload
			ReloadWeapon(wep, wep.ammo1, wep.ammo2, false);

			// Do reload for dual wield (if it has one)
			if(wep.akimboMode && wep.amount > 1)
			{
				if(!wep.ammoLeft)
					continue;
				ReloadWeapon(wep, wep.ammo1, wep.ammoleft, true);
			}
		}
	}
	
	// Thee function that actually does the reload, is called inside refillweapons()
	void ReloadWeapon(PB_WeaponBase wep, ammo am1, ammo am2, bool isLeft = false)
	{
		// Sets up variables
		int cur, maxm, eq, res;
		cur 	= am2.amount;					// Current ammo in the magazine
		maxm 	= am2.maxamount;				// Max ammo in the magazine
		res 	= am1.amount;					// Reserve ammo
		eq 		= wep.ReserveToMagAmmoFactor;	// How much reserve is needed for one amount of magazine ammo
		
		// If the reserve is less than whats needed for one magazine amount, stop
		if(res < eq)
			return;
		
		// Sets up more variables
		int pendin, releq, amt, giveam;
		
		// Do reload
		// If the current magazine is less than max and we have enough reserve for one mag ammo, reload
		if(cur < maxm && res >= eq)
		{
			// Quick maths
			pendin = maxm - cur;				// Get how much ammo is needed to fill the magazine to full
			pendin = min(pendin, PBBCKPR_Ref);	// Compares it with the amount the user set in the cvar and takes the smaller of the two
				
			releq = pendin * eq;				// Get the actual amount of reserve needed to fill the magazine
			amt = min(releq, res);				// Compares it with the current reserve and takes the smaller of the two, this is so it always takes whats available in the reserve
			
			giveam = amt / eq;					// Get the actual amount of magazine ammo to give based on the reserve we are taking
			
			// Give magazine and take reserve
			owner.A_GiveInventory(am2.getclassname(), giveam);
			owner.A_takeinventory(am1.getclassname(), int(giveam * eq), TIF_NOTAKEINFINITE); // This is so the infinite ammo powerup works
			
			// Reset staged reload bools since the weapon has been reloaded, this is for the staged reload system
			ResetStagedReload(wep, isLeft);
			
			// Print reload message if enabled
			if(PBBCKPR_Tell && am2.amount >= maxm)
				printreloadedmsg(wep.gettag(), isLeft);
		}
	}

	// Reset staged reload variables, called in ReloadWeapon()
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
			wep.chamberEmpty		= false;
			wep.magEmpty			= false;
			wep.magUnloaded			= false;
		}
	}
	
	// Check if the player has the infinite ammo powerup or sv_infiniteammo is enabled, called in refillweapons()
	bool hasInfiniteAmmo(actor who)
	{
		return (sv_infiniteammo || who.findinventory("PowerInfiniteAmmo", true) != null);
	}
	
	// Prints reload message, called in ReloadWeapon()
	void printreloadedmsg(name w, bool lefts)
	{
		console.printf("%s\cv%s\c- reloaded.", lefts ? "Left " : "", w);
	}
	
	// Check if an inventory item is a PB weapon, called in refillweapons()
	bool isPBweapon(inventory it)
	{
		return it is "PB_WeaponBase";
	}
	
	// Check if a weapon can be reloaded, called in refillweapons()
	bool isReloadable(PB_WeaponBase wep)
	{
		// Check if the weapon has both ammo1 and ammo2
		if(wep.ammo1 != null && wep.ammo2 != null)
		{
			// Check exception list
			for(int i = 0; i < self.PB_noreloadweapons.size(); i++)
			{
				if(wep.getclassname() == self.PB_noreloadweapons[i])
					return false;
			}
			// If everything passes, return true
			return true;
		}
		// If it doesn't have both ammo1 and ammo2, return false
		return false;
	}
	
	// Exception list, for weapons that use AmmoType2 but is not a mag
	static const string PB_noreloadweapons[] = {
		"PB_Unmaker","PBX_DemonExt"
	};
}