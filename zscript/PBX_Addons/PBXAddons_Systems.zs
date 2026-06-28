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
	override void playerentered(playerevent e)
	{
        let pm = players[e.PlayerNumber].mo;
		if(!pm) return;

        if (level.MapName == "TITLEMAP") return;

        PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PB_backpackreloadItem', diffCheck:false);
        PBXCore_Handler.TryGiveInventory(pm,whatToGive:'PBXAddons_TipsManager', diffCheck:false);

	}

    // Checks if the Ulitmate Visor mod is loaded and disables PBXAddons hit feedback
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
	override bool HandlePickup(Inventory item)
	{
		string addonHelpCvar = "PBXAddons_HelpFlags";

        switch(item.getClassName())
        {
            default:
                break;

            case 'PBX_SGLEdited':
            {
                Array<String> tips;
                tips.Push("$PBXAddons_SGLEdited_Tip1");
                tips.Push("$PBXAddons_SGLEdited_Tip2");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips,addonHelpCvar,ePBXAddons_SGLUpgradeTip);
            }
            break;

            case 'PBX_LMGEdited':
            {
                Array<String> tips;
                tips.Push("$PBXAddons_LMGEdited_Tip1");
                tips.Push("$PBXAddons_LMGEdited_Tip2");
                PBXCore_TipsManager.SendTipArrayIfNeeded(tips,addonHelpCvar,ePBXAddons_LMGUpgradeTip);
            }
            break;


        }

		return super.HandlePickup(item);
	}
}