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
            TNT1 A 0 {
				if(findinventory("SelectSGL_No"))
				{
					A_Print("$PBXAddons_SGLUpgrade_NoUpgrade");
					A_SetInventory("SelectSGL_No",0);
					return resolvestate("ready");
				}
				return resolvestate(null);
			}
            goto super::WeaponSpecial;
    }
}

// So the PBX Core can draw it correctly
class PBXHUDService_EditedSGL : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_SGLEdited')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

		let sgl = PB_SuperGL(weapon);
		if(!sgl) return null;

		static const string sglIcons[] = {
			"graphics/pywheel/grenade_impact.png", "graphics/pywheel/grenade_sticky.png", 
			"graphics/pywheel/grenade_acid.png", "graphics/pywheel/grenade_incendiary.png", 
			"graphics/pywheel/grenade_cryo.png"
		};

		int sglgren = clamp(sgl.GrenadeMode, 0, sglIcons.Size() - 1);

        data.Image1 = "";
        data.Image2 = sglIcons[sglgren];
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (-5, 13);   // Weapon Icon Position
        data.Offset2 = (3,-18);   // Weapon Mode Icon Position

        data.Scale1 = 0.9;   // Weapon Icon Scale
        data.Scale2 = 0.3;      // Weapon Mode Icon Scale

        return data;
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
		Inventory.PickupMessage "$PBXAddons_SGLUpgrade_Pickup";
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
		TNT1 A 0 A_JumpIf(!FindInventory("PBX_SGLEdited") || !FindInventory("SGLUpgraded") || CountInv("PB_RocketAmmo") < GetAmmoCapacity("PB_RocketAmmo"),1);
		fail;
		TNT1 A 0 {
			A_SetInventory("SGLUpgraded", 1);
			A_GiveInventory("PBX_SGLEdited", 1);
			A_SetWeaponTag("PBX_SGLEdited","$PBXAddons_SGLUpgrade_Tag2");
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

