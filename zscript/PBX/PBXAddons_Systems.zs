enum ePBXAddons_SettingsFlags{
    ePBXAddons_DisableSmartScav      = 1 << 0,
    ePBXAddons_DisableHelmetDrops    = 1 << 1,
    ePBXAddons_DamageIndicators      = 1 << 2,
    ePBXAddons_DamageFeedback        = 1 << 3,
    ePBXAddons_BackpackReload        = 1 << 4
}

enum ePBXAddons_GeneralFlags{
    ePBXAddons_Version      = 1 << 0
}

Class PBXAddons_Handler : eventhandler
{
	override void playerentered(playerevent e)
	{
        PB_HelpNotificationsHandler.PB_SendTip("$PBXAddons_Version", "PBXAddons_GeneralFlags", ePBXAddons_Version);
		if(!players[e.playernumber].mo.findinventory("PB_backpackreloadItem"))
			players[e.playernumber].mo.A_giveinventory("PB_backpackreloadItem");
	}
}