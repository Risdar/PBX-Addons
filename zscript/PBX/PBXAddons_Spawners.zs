class PBXAddons_Spawners : EventHandler
{
    override void CheckReplacement(ReplaceEvent e) 
	{
        SmartScavSpawns(e);
        WeaponUpgradeSpawns(e);
    }

    void SmartScavSpawns(ReplaceEvent e)
    {
        if(PBXAddons_SettingsFlags & ePBXAddons_DisableSmartScav) return;
        switch(e.Replacee.GetClassName())
        {
            case 'PB_CellPack':     if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavCellPack)) e.Replacement    = "Smartscav_Cells";         break;
            case 'PB_ShellBox':     if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavShellBox)) e.Replacement    = "Smartscav_Shells";        break;
            case 'PB_RocketBox':    if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavRocketBox)) e.Replacement   = "Smartscav_Rockets";       break;
            case 'PB_HighCalBox':   if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavHighCalBox)) e.Replacement  = "Smartscav_HighCal";       break;
            case 'PB_LowCalBox':    if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavLowCalBox)) e.Replacement   = "Smartscav_LowCal";        break;
            case 'PB_Medikit':      if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavMedikit)) e.Replacement     = "Smartscav_Medikit";       break;
        }
    }

    void WeaponUpgradeSpawns(ReplaceEvent e)
    {
        if(PBXAddons_SettingsFlags & ePBXAddons_DisableWeaponUpgrade) return;
        switch(e.Replacee.GetClassName())
        {
            case 'PB_SuperGL': if(!(PBXAddons_WeaponUpgradesFlags & ePBXAddons_DisableSGLUpgrade)) e.Replacement  = "PBX_SGLEdited";  break;
            case 'PB_LMG':     if(!(PBXAddons_WeaponUpgradesFlags & ePBXAddons_DisableLMGUpgrade)) e.Replacement  = "PBX_LMGEdited";  break;
        }
    }
}

class SGLUpgrade_injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
        if(PBXAddons_SettingsFlags & ePBXAddons_DisableWeaponUpgrade) return;

        if(!(PBXAddons_WeaponUpgradesFlags & ePBXAddons_DisableSGLUpgrade))
        {
            handler.InjectSpawn('PB_UpgradeSpawnerT3', 'SGL_Upgrade', 255, 1);
            handler.InjectSpawn('PB_UpgradeSpawnerT4', 'SGL_Upgrade', 255, 1);
            
            handler.InjectSpawn('PB_RLSpawnerT3', 'SGL_Upgrade', 255, 1);
            handler.InjectSpawn('PB_RLSpawnerT4', 'SGL_Upgrade', 255, 1);
        }

        if(!(PBXAddons_WeaponUpgradesFlags & ePBXAddons_DisableLMGUpgrade))
        {
            handler.InjectSpawn('PB_UpgradeSpawnerT4', 'LMG_Upgrade', 255, 1);
		    handler.InjectSpawn('PB_MGSpawnerT4', 'LMG_Upgrade', 255, 1);
        }
		
	}
}