class PBX_SGLEdited : PB_SuperGL
{
    Default
    {
        PB_WeaponBase.WheelInfo "PBX_SGLWheelEdited";
    }

    States
    {
        WeaponSpecial:
            TNT1 A 0 {
				A_SetInventory("CantWeaponSpecial",1);
				A_SetInventory("GoWeaponSpecialAbility",0);
			}
            TNT1 A 0 PB_PreHandleSGLWheelEdited();
            goto super::WeaponSpecial;
    }

    action state PB_PreHandleSGLWheelEdited()
    {
        if(findinventory("SelectSGL_No"))
        {
            A_Print("$PBXAddons_SGLUpgrade_NoUpgrade");
            A_SetInventory("SelectSGL_No",0);
            return resolvestate("ready");
        }
        return resolvestate(null);
    }
}

class SGLUpgraded : Inventory {default{inventory.maxamount 1;}}
class SelectSGL_No : Inventory {default{inventory.maxamount 1;}}

class SGL_Upgrade : PB_UpgradeItem
{
	Default
	{
		//$Title SGL Upgrade
		//$Category Project Brutality - Weapon Upgrades
		//Game Doom;
		//SpawnID 9410
		Height 24;
		//-COUNTITEM
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
		Inventory.Pickupsound "misc/rockboxa";
		Inventory.PickupMessage "$PBXAddons_SGLUpgrade_Tag";
		Tag "$PBXAddons_SGLUpgrade_Tag";
		Scale 0.52;
		FloatBobStrength 0.5;
	}
	States
	{
	Spawn:
		BSGL A -1;
		Stop;

	Pickup:
		TNT1 A 0 A_JumpIf(!FindInventory("PB_SuperGL") || !FindInventory("SGLUpgraded") || CountInv("PB_RocketAmmo") < GetAmmoCapacity("PB_RocketAmmo"),1);
		fail;
		TNT1 A 0 {
			A_SetInventory("SGLUpgraded", 1);
			A_GiveInventory("PB_SuperGL", 1);
			A_SetWeaponTag("PB_SuperGL","$PB_SGL_TAG");
		}
		Stop;
	}
}

Class PBX_SGLWheelEdited : wheelinfocontainer
{
	override int GetSPCount(actor requester)
	{
        return 5;
	}
	
	override void GetSpecials(in out array <PB_SpecialWheel_Mode> spw, actor requester)
	{
		if(!spw || !requester)
			return;
			
		vector2 iconScale = (0.5, 0.5);
			
		PB_SpecialWheel_Mode grenade_impact = new ("PB_SpecialWheel_Mode");
		grenade_impact.img = "graphics/pywheel/grenade_impact.png";
		grenade_impact.Alias = "$PB_SGL_WHEEL_IMPACT";
		grenade_impact.tokentogive = "GrenadeTypeImpact";
		grenade_impact.scalex = iconscale.x;
		grenade_impact.scaley = iconscale.y;
		
		
		PB_SpecialWheel_Mode grenade_sticky = new ("PB_SpecialWheel_Mode");
		grenade_sticky.img = "graphics/pywheel/grenade_sticky.png";
		grenade_sticky.Alias = "$PB_SGL_WHEEL_STICKY";
		grenade_sticky.tokentogive = "GrenadeTypeSticky";
		grenade_sticky.scalex = iconscale.x;
		grenade_sticky.scaley = iconscale.y;
		
		spw.Push(grenade_impact);
		spw.Push(grenade_sticky);

		if(requester.FindInventory("SGLUpgraded"))
		{
			PB_SpecialWheel_Mode grenade_incendiary = new ("PB_SpecialWheel_Mode");
			grenade_incendiary.img = "graphics/pywheel/grenade_incendiary.png";
			grenade_incendiary.Alias = "$PB_SGL_WHEEL_INCENDIARY";
			grenade_incendiary.tokentogive = "GrenadeTypeIncendiary";
			grenade_incendiary.scalex = iconscale.x;
			grenade_incendiary.scaley = iconscale.y;
			
			PB_SpecialWheel_Mode grenade_cryo = new ("PB_SpecialWheel_Mode");
			grenade_cryo.img = "graphics/pywheel/grenade_cryo.png";
			grenade_cryo.Alias = "$PB_SGL_WHEEL_CRYO";
			grenade_cryo.tokentogive = "GrenadeTypeCryo";
			grenade_cryo.scalex = iconscale.x;
			grenade_cryo.scaley = iconscale.y;
			
			PB_SpecialWheel_Mode grenade_acid = new ("PB_SpecialWheel_Mode");
			grenade_acid.img = "graphics/pywheel/grenade_acid.png";
			grenade_acid.Alias = "$PB_SGL_WHEEL_ACID";
			grenade_acid.tokentogive = "GrenadeTypeAcid";
			grenade_acid.scalex = iconscale.x;
			grenade_acid.scaley = iconscale.y;
			
			spw.Push(grenade_acid);
			spw.Push(grenade_cryo);
			spw.Push(grenade_incendiary);
		}
		else
		{
			PB_SpecialWheel_Mode grenade_no = new ("PB_SpecialWheel_Mode");
			grenade_no.img = "graphics/WeaponWheel/grenade_no.png";
			grenade_no.Alias = "$PB_NOTAVAILABLE";
			grenade_no.tokentogive = "SelectSGL_No";
			grenade_no.scalex = iconscale.x;
			grenade_no.scaley = iconscale.y;
			
			spw.Push(grenade_no);
	
			PB_SpecialWheel_Mode grenade_no2 = new ("PB_SpecialWheel_Mode");
			grenade_no2.img = "graphics/WeaponWheel/grenade_no.png";
			grenade_no2.Alias = "$PB_NOTAVAILABLE";
			grenade_no2.tokentogive = "SelectSGL_No";
			grenade_no2.scalex = iconscale.x;
			grenade_no2.scaley = iconscale.y;
			
			spw.Push(grenade_no);

			PB_SpecialWheel_Mode grenade_no3 = new ("PB_SpecialWheel_Mode");
			grenade_no3.img = "graphics/WeaponWheel/grenade_no.png";
			grenade_no3.Alias = "$PB_NOTAVAILABLE";
			grenade_no3.tokentogive = "SelectSGL_No";
			grenade_no3.scalex = iconscale.x;
			grenade_no3.scaley = iconscale.y;
			
			spw.Push(grenade_no);
		}
	}
}

