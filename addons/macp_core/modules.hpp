class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;
			class EditCodeMulti5;
			class Combo;
			class Checkbox;
			class CheckboxNumber;
			class ModuleDescription;
			class Units;
		};

		class ModuleDescription
		{
			class AnyBrain;
		};
	};
	class macp_campaignManager : Module_F
	{
		author = "Mallen";
		category = "Effects";
		displayName = "MACP - Campaign Manager";
		icon = "\A3\modules_f\data\portraitStrategicMapOpen_ca.paa";
		scope = 2;
		scopeCurator = 1;

		function = "macp_core_fnc_init";
		functionPriority = 1;
		isGlobal = 1;						// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;				// 1 for module waiting until all synced triggers are activated
		isDisposable = 1;					// 1 if modules is to be disabled once it is activated (i.e. repeated trigger activation will not work)
		is3DEN = 1;							// 1 to run init function in Eden Editor as well

		class Attributes : AttributesBase
		{
			class ComboCampaignKey
			{
				control = "MACP_comboCampaignKey";
				property = "macp_campaignManager_campaignData";
				displayName = "Campaign Data";
				tooltip = "Key used tie campaign missions together";
				expression = "_this setVariable ['macp_campaignData',_value];";

			};
		};
	};
};
