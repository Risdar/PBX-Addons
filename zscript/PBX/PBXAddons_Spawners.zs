class PBXAddons_Spawners : EventHandler
{
    override void CheckReplacement(ReplaceEvent e) 
	{
        if(!(PBXAddons_SettingsFlags & ePBXAddons_DisableSmartScav)) return;
        let item = e.Replacee.GetClassName();
        switch(item)
        {
            case 'PB_CellPack':     e.Replacee = "Smartscav_Cells";         break;
            case 'PB_ShellBox':     e.Replacee = "Smartscav_Shells";        break;
            case 'PB_RocketBox':    e.Replacee = "Smartscav_Rockets";       break;
            case 'PB_HighCalBox':   e.Replacee = "Smartscav_HighCal";       break;
            case 'PB_LowCalBox':    e.Replacee = "Smartscav_LowCal";        break;
            case 'PB_Medikit':      e.Replacee = "Smartscav_Medikit";       break;
        }
    }
}