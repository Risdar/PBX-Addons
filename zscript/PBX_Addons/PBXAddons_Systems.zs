enum ePBXAddons_SettingsFlags{
    ePBXAddons_DisableSmartScav      = 1 << 0,
    ePBXAddons_DisableHelmetDrops    = 1 << 1,
    ePBXAddons_DamageIndicators      = 1 << 2,
    ePBXAddons_DamageFeedback        = 1 << 3,
    ePBXAddons_DisableBackpackReload = 1 << 4,
    ePBXAddons_DisableWeaponUpgrade  = 1 << 5
}

enum ePBXAddons_Flags{
    // Smart Scav Flags
    ePBXAddons_DisableSmartScavCellPack     = 1 << 0,
    ePBXAddons_DisableSmartScavShellBox     = 1 << 1,
    ePBXAddons_DisableSmartScavRocketBox    = 1 << 2,
    ePBXAddons_DisableSmartScavHighCalBox   = 1 << 3,
    ePBXAddons_DisableSmartScavLowCalBox    = 1 << 4,
    ePBXAddons_DisableSmartScavMedikit      = 1 << 5,
    // Damage Feedback
    ePBXAddons_DisableText                  = 1 << 0,
    ePBXAddons_DisableSound                 = 1 << 1,
    // Weapon Upgrades
    ePBXAddons_DisableSGLUpgrade            = 1 << 0,
    ePBXAddons_DisableLMGUpgrade            = 1 << 1
}

enum ePBXAddons_TipFlags{
    ePBXAddons_SmartScavTip          = 1 << 0,
    ePBXAddons_SGLUpgradeTip         = 1 << 1,
    ePBXAddons_LMGUpgradeTip         = 1 << 2
}

Class PBXAddons_Handler : eventhandler
{
    PlayerPawn pm;

	override void playerentered(playerevent e)
	{
        pm = players[e.PlayerNumber].mo;
		if(!pm) return;

        if (level.MapName == "TITLEMAP") return;

        TryGiveInventory(whatToGive:'PB_backpackreloadItem', diffCheck:false);
        TryGiveInventory(whatToGive:'PBXAddons_TipsManager', diffCheck:false);

        PB_HelpNotificationsHandler.PB_SendTip("$PBXAddons_Version", "PBXCore_ThrowawayFlag", 0 << 0);
        
	}

    void TryGiveInventory(name hasInventory = "", name whatToGive = "", int giveAmount = 1, bool diffCheck = true)
	{
		// Only give the inventory if the player still doesnt have the item
		// this way its only given once and wont be given every map change
		if (pm.CountInv(diffCheck ? hasInventory : whatToGive) < 1) 
		{
			pm.GiveInventory(whatToGive, giveAmount);
		}
	}

    // Checks if the Ulitmate Visor mod is loaded and disables PBXAddons hit feedback regardless
    override void WorldLoaded (WorldEvent e)
    {
        string uvClassName = "UV_HudVisorDraw";
        let handler = EventHandler.Find(uvClassName);
        if(handler)
        {
            CVAR.FindCVar('isUltimateVisorLoaded').SetBool(true);
        }
        else
        {
            CVAR.FindCVar('isUltimateVisorLoaded').SetBool(false);
        }
    }
}

class PBXAddons_TipsManager : inventory
{
	Default
	{
		// These are just some useful values for an inventory token
		// that make sure it can't be taken away or dropped:
		inventory.maxamount 1;
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.PERSISTENTPOWER
	}

	private void SendTipArrayIfNeeded(Array<String> tipStrings, int tipFlag)
	{
		if(!PB_HelpNotificationsHandler.CheckTipEvent(tipFlag, CVar.GetCvar("PBXAddons_HelpFlags")))
		{
			PB_HelpNotificationsHandler.PB_SendTipArray(tipStrings, "PBXAddons_HelpFlags", tipFlag);
		}
	}

	override bool HandlePickup(Inventory item)
	{
		string weaponHelpCvar = "PBXWeapons_WeaponHelpFlags";

        switch(item.getClassName())
        {
            default:
                break;

            case 'PBX_SGLEdited':
            {
                Array<String> tips;
                tips.Push("$PBXAddons_SGLEdited_Tip1");
                tips.Push("$PBXAddons_SGLEdited_Tip2");
                SendTipArrayIfNeeded(tips, ePBXAddons_SGLUpgradeTip);
            }
            break;

             case 'PBX_LMGEdited':
            {
                Array<String> tips;
                tips.Push("$PBXAddons_LMGEdited_Tip1");
                tips.Push("$PBXAddons_LMGEdited_Tip2");
                SendTipArrayIfNeeded(tips, ePBXAddons_LMGUpgradeTip);
            }
            break;


        }

		return super.HandlePickup(item);
	}
}