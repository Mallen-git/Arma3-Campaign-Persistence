class CfgFunctions
{
	class macp_core
	{
		class functions
		{
			file = "macp_core\coreFunctions";
			class init {};
			class provideCurrentLoadout {};
			class saveCampaign {};
			class provideDefaultLoadout {};
			class saveAllKitsAndVaults {};
			class saveToPreviousInventorys {};
			class saveToCurrentInventory {};
		};
		class personalVault
		{
			file = "macp_core\personalVaultFunctions";
			class initPersonalVault {};
			class savePersonalVault {};
			class closePersonalVault {};
			class clientToldToOpenPersonalVault {};
			class accessPersonalVault {};
		};
	};
};
