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
        if(PBXAddons_SettingsFlags & ePBXAddons_DisableSmartScav) return;
        let item = e.Replacee.GetClassName();
        switch(item)
        {
            case 'PB_CellPack':     if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavCellPack)) e.Replacement    = "Smartscav_Cells";         break;
            case 'PB_ShellBox':     if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavShellBox)) e.Replacement    = "Smartscav_Shells";        break;
            case 'PB_RocketBox':    if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavRocketBox)) e.Replacement   = "Smartscav_Rockets";       break;
            case 'PB_HighCalBox':   if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavHighCalBox)) e.Replacement  = "Smartscav_HighCal";       break;
            case 'PB_LowCalBox':    if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavLowCalBox)) e.Replacement   = "Smartscav_LowCal";        break;
            case 'PB_Medikit':      if(!(PBXAddons_SmartScavFlags & ePBXAddons_DisableSmartScavMedikit)) e.Replacement     = "Smartscav_Medikit";       break;
        }
    }
}