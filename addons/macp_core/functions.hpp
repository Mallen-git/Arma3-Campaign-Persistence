class CfgFunctions
{
	class macp_core
	{
		class core
		{
			file = "macp_core\coreFunctions";
			class init {};
			class provideCurrentLoadout {};
			class provideDefaultLoadout {};
			class saveAllKitsAndVaults {};
			class saveToPreviousInventorys {};
			class saveToCurrentInventory {};
			class createPlayerProfile {};
		};
		class codeHelpers
		{
			file = "macp_core\codeHelpers";
			class investigateHashmap {};
			class validateHashmap {};
			class validateStringInput {};
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
		class eden
		{
			file = "macp_core\edenFunctions";
			class openCampaignManager {};
			class createPreviewCam {};
			class destroyPreviewCam {};
			class updateFileBrowser {};
			class updateFilePath {};
			class buttonDeletePressed {};
			class buttonEditPressed {};
			class buttonNewPressed {};
			class buttonExportPressed {};
			class buttonImportPressed {};
			class restrictPersonalVaultModule {};
			class updateModuleAttributes {};
		};
	};
};
