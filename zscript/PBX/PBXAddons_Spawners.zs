enum ePBXAddons_SmartscavFlags{
    ePBXAddons_DisableSmartScavCellPack         = 1 << 0,
    ePBXAddons_DisableSmartScavShellBox         = 1 << 1,
    ePBXAddons_DisableSmartScavRocketBox        = 1 << 2,
    ePBXAddons_DisableSmartScavHighCalBox       = 1 << 3,
    ePBXAddons_DisableSmartScavLowCalBox        = 1 << 4,
    ePBXAddons_DisableSmartScavMedikit          = 1 << 5
}

class PBXAddons_Spawners : EventHandler
{
    override void CheckReplacement(ReplaceEvent e) 
	{
        SmartScavSpawns(e);
        SGLUpgrade(e);
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

    void SGLUpgrade(ReplaceEvent e)
    {
        if(PBXAddons_SettingsFlags & ePBXAddons_DisableSGLUpgrade) return;
        if(e.Replacee.GetClassName() == "PB_SuperGL")
            e.Replacement   = "PBX_SGLEdited";
    }
}

class SGLUpgrade_injector : PBInjector
{
	override void Init(PB_EventHandler handler)
	{
        if(PBXAddons_SettingsFlags & ePBXAddons_DisableSGLUpgrade) return;
		handler.InjectSpawn('PB_UpgradeSpawnerT3', 'SGL_Upgrade', 255, 1);
		handler.InjectSpawn('PB_UpgradeSpawnerT4', 'SGL_Upgrade', 255, 1);
		
		handler.InjectSpawn('PB_RLSpawnerT3', 'SGL_Upgrade', 255, 1);
		handler.InjectSpawn('PB_RLSpawnerT4', 'SGL_Upgrade', 255, 1);
	}
}