class SmartScavAmmoBase : CustomInventory
{
	int IsAmmoFull(Actor toucher, class<PB_Ammo> type, int amount)
	{
		if (!toucher || !type) return 0;

		let ammoDefault = GetDefaultByType(type);
		if (!ammoDefault) return 0;

		let inv = toucher.FindInventory(type);
		int current = inv ? inv.Amount : 0;
		int maxCap = ammoDefault.MaxAmount;

		if (inv)
		{
			maxCap = inv.MaxAmount;
		}
		else if (toucher.FindInventory("PB_Backpack"))
		{
			maxCap = ammoDefault.BackpackMaxAmount;
		}

		if (current >= maxCap)
		{
			return 0;
		}

		if (current + amount > maxCap)
		{
			return 1;
		}

		return 2;
	}

	void HandleAmmoTouch(Actor toucher, class<PB_Ammo> type, int amount)
	{
		if (!toucher || !toucher.player || toucher.health <= 0) return;

		int ammoAmount = IsAmmoFull(toucher, type, amount);
		if (ammoAmount == 0)
		{
			SetStateLabel("DoNothing");
			return;
		}

		bNoInteraction = true;
		if(ammoAmount == 1){
			SetStateLabel("SpawnPartial");
			return;
		} 
		else{
			SetStateLabel("PickupFull");
			return;
		}
	}
}

// SMART CELLS ==========================================================================================
class Smartscav_Cells : SmartScavAmmoBase
{
	Default
	{
		Radius 1;
		+DONTGIB
	}
	
	override void Touch(Actor toucher)
	{
		super.Touch(toucher);
		HandleAmmoTouch(toucher, "PB_Cell", 100);
	}
	
	States
	{
	Spawn:
		YELP ABCDEFGHIJ 2;
		loop;
    DoNothing:
        "####" "#" 1; 
        Fail;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("SmartScav_CellPack");
		Stop;
	SpawnPartial:
		TNT1 A 0;
		YELP F 15;
		YELP F 10 {
			A_SpawnItemEx("PB_Cell",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_Cell",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_Cell",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		YELP F 8 {
			A_SpawnItemEx("PB_Cell",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_Cell",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		YELP F 70;
		YELP F 5 A_FadeOut(0.1);
		Stop;
	}
}

class SmartScav_CellPack : PB_Cell
{
	Default
	{
		//$Category Project Brutality - Ammunition
		//$Sprite YELPF0
		//Scale 0.4;
		Inventory.Amount 100;
		Inventory.PickupSound "misc/bulkcell_PickUp";
		PB_Ammo.ammotype "cellpack";
	}
}
// SMART SHELLS ==========================================================================================
class Smartscav_Shells : SmartScavAmmoBase
{
	Default
	{
		Radius 1;
		+DONTGIB
	}
	
	override void Touch(Actor toucher)
	{
		super.Touch(toucher);
		HandleAmmoTouch(toucher, "PB_Shell", 12);
	}
	States
	{
	Spawn:
		SB0X A -1;
		Stop;
	DoNothing:
        "####" "#" 1; 
        Fail;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("SmartScav_ShellBox");
		Stop;
	SpawnPartial:
		SB0X A 15;
		SB0X A 10 {
			A_SpawnItemEx("PB_Shell",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_Shell",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		SB0X A 8 A_SpawnItemEx("PB_Shell",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		SB0X A 70;
		SB0X A 5 A_FadeOut(0.1);
		Stop;
	}
}

class SmartScav_ShellBox : PB_Shell
{
	Default
	{
		//$Category Project Brutality - Ammunition
		//$Sprite SBOXA0
		//Scale 0.25;
		Inventory.Amount 12;
		Inventory.PickupSound "misc/shellbox_PickUp";
		PB_Ammo.ammotype "shellbox";
	}
}
// SMART ROCKETS ==========================================================================================
class Smartscav_Rockets : SmartScavAmmoBase
{
	Default
	{
		Radius 1;
		+DONTGIB
	}
	
	override void Touch(Actor toucher)
	{
		super.Touch(toucher);
		HandleAmmoTouch(toucher, "PB_RocketAmmo", 6);
	}
	States
	{
	Spawn:
		BR0K A -1;
		Stop;
	DoNothing:
        "####" "#" 1; 
        Fail;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("SmartScav_RocketBox");
		Stop;
	SpawnPartial:
		BR0K A 15;
		BR0K A 10 {
			A_SpawnItemEx("PB_RocketAmmo",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_RocketAmmo",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_RocketAmmo",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		BR0K A 8 {
			A_SpawnItemEx("PB_RocketAmmo",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_RocketAmmo",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_RocketAmmo",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		BR0K A 70;
		BR0K A 5 A_FadeOut(0.1);
		Stop;
	}
}

class SmartScav_RocketBox : PB_RocketAmmo
{
	Default
	{
		//$Title Box of Explosives
		//$Category Project Brutality - Ammunition
		//$Sprite BR0KA0
		//Scale 0.4;
		Inventory.Amount 6;
		Inventory.PickupSound "misc/rockboxa";
		PB_Ammo.AmmoType "expbox";
	}
}
// SMART HIGHCAL ==========================================================================================
class Smartscav_HighCal : SmartScavAmmoBase
{
	Default
	{
		Radius 1;
		+DONTGIB
	}
	
	override void Touch(Actor toucher)
	{
		super.Touch(toucher);
		HandleAmmoTouch(toucher, "PB_HighCalMag", 60);
	}

	States
	{
	Spawn:
		AMM0 A -1;
		Stop;
	DoNothing:
      	"####" "#" 1; 
        Fail;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("SmartScav_HighCalBox");
		Stop;
	SpawnPartial:
		AMM0 A 15;
		AMM0 A 10 {
			A_SpawnItemEx("PB_HighCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_HighCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		AMM0 A 8 {
			A_SpawnItemEx("PB_HighCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_HighCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		AMM0 A 70;
		AMM0 A 5 A_FadeOut(0.1);
		Stop;
	}
}

class SmartScav_HighCalBox : PB_HighCalMag
{
	Default
	{
		//$Category Project Brutality - Ammunition
		//$Sprite AMM0A0
		//Scale 0.15;
		Inventory.Amount 60;
		Inventory.PickupSound "CBOXPKUP";
		PB_Ammo.ammotype "highcalbox";
	}
}
// SMART LOWCAL ==========================================================================================
class Smartscav_LowCal : SmartScavAmmoBase
{
	Default
	{
		Radius 1;
		+DONTGIB
	}
	
	override void Touch(Actor toucher)
	{
		super.Touch(toucher);
		HandleAmmoTouch(toucher, "PB_LowCalMag", 60);
	}

	States
	{
	Spawn:
		AMOK A -1;
		Stop;
	DoNothing:
        "####" "#" 1; 
        Fail;
	PickupFull:
		TNT1 A 0 A_SpawnItemEx("SmartScav_LowCalBox");
		Stop;
	SpawnPartial:
		AMOK A 15;
		AMOK A 10 {
			A_SpawnItemEx("PB_LowCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_LowCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_LowCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		AMOK A 8 {
			A_SpawnItemEx("PB_LowCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_LowCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
			A_SpawnItemEx("PB_LowCalMag",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		}
		AMOK A 70;
		AMOK A 5 A_FadeOut(0.1);
		Stop;
	}
}

class SmartScav_LowCalBox : PB_LowCalMag
{
	Default
	{
		//$Category Project Brutality - Ammunition
		//$Sprite AMOKA0
		Inventory.Amount 60;
		Inventory.PickupSound "CBOXPKUP";
		PB_Ammo.ammotype "lowcalbox";
	}
}
// SMART MEDIKIT ==========================================================================================
class Smartscav_Medikit : CustomInventory
{
	Default
	{
		Radius 1;
		+DONTGIB
	}
	
	override void Touch(Actor toucher)
	{
		if (!toucher || !toucher.player || toucher.health <= 0) return;

		int maxHP = toucher.GetMaxHealth(true);
		int currentHP = toucher.health;

		// If the player already has max hp
		if (currentHP >= maxHP) return;

		if (currentHP < 75)
		{
			SetStateLabel("SpawnKit");
		}
		else if (currentHP < maxHP)
		{
			SetStateLabel("SpawnStims");
		}
	}
	
	States
	{
	Spawn:
		MED1 A -1;
		Stop;
	SpawnKit:
		TNT1 A 0 A_SpawnItemEx("SmartScav_MediPack");
		Stop;
	SpawnStims:
		MED1 A 10;
		// A Medikit (25 HP) breaks into 2 Stims (10 HP each)
		MED1 A 5 A_SpawnItemEx("PB_Stimpack",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		MED1 A 5 A_SpawnItemEx("PB_Stimpack",0,0,0,frandom(2,4),0,frandom(2,4),random(1,360));
		MED1 A 70;
		MED1 A 5 A_FadeOut(0.1);
		Stop;
	}
}

class SmartScav_MediPack : PB_Health
{
	Default
	{
		//$Category Project Brutality - Health and Armor
		//$Sprite MED1A0
		Tag "Medikit";
		Inventory.Amount 25;
		Inventory.PickupSound "misc/L_HP_pickup";
		Inventory.PickupMessage "Medikit (+%a HP)";
		Health.LowMessage 25, "Medikit (+%a much needed HP)";
		//Scale .30;
	}

	States
	{
		Spawn:
			MED1 A -1;
			stop;
	}
}