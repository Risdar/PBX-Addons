// THE EDITED LMG IS IN DECORATE SO I PUT IN THE DECORATE LUMP

class LMGUpgraded : Inventory {default{inventory.maxamount 1;}}

class LMG_Upgrade : PB_UpgradeItem
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
		Inventory.Pickupsound "LLIDOP";
		Inventory.PickupMessage "$PBXAddons_LMGUpgrade_Pickup";
		Tag "$PBXAddons_LMGUpgrade_Tag";
		Scale 0.52;
		FloatBobStrength 0.5;
	}
	States
	{
	Spawn:
		LMPU A -1;
		Stop;

	Pickup:
		TNT1 A 0 A_JumpIf(!FindInventory("PBX_LMGEdited") || !FindInventory("LMGUpgraded") || CountInv("PB_HighCalMag") < GetAmmoCapacity("PB_HighCalMag"),1);
		fail;
		TNT1 A 0 {
			A_SetInventory("LMGUpgraded", 1);
			A_GiveInventory("PBX_LMGEdited", 1);
			A_SetWeaponTag("PBX_LMGEdited","$PBXAddons_LMGUpgrade_Tag2");
		}
		Stop;
	}
}

// So the PBX Core can draw it correctly
class PBXHUDService_EditedLMG : service
{
    override Object GetObjectUI(String request,String stringArg,int intArg,double doubleArg,Object objectArg)
    {
        if(request != "PBX_HUD") return null;
        let weapon = PB_WeaponBase(objectArg); // Get a pointer to the weapon here so you can do stuff with the weapon
        if(!weapon) return null;

        if(weapon.GetClassName() != 'PBX_LMGEdited')return null;

        let data = PBXHUDData(new("PBXHUDData"));
        if (!data) return null;
        data.Handled = true;
        data.SkipAutoDraw = false;

        data.Image1 = "";
        data.Image2 = "";       // Weapon Mode Icon
        data.Image3 = "";       // Weapon Mode 2 Icon (For example the CryoRifle has 2 modes at the same time)

        data.Offset1 = (3, 23);   // Weapon Icon Position
        data.Offset2 = (0,0);   // Weapon Mode Icon Position

        data.Scale1 = 0.8;      // Weapon Icon Scale
        data.Scale2 = 1.0;      // Weapon Mode Icon Scale

        return data;
    }
}