class CfgFactionClasses
{
	class NO_CATEGORY;
	class macp_standardCategory: NO_CATEGORY
	{
		displayName = "MACP - Campaign Persistance";
	};
};

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
		category = "macp_standardCategory";
		displayName = "MACP - Campaign Manager";
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\box_ca.paa";
		scope = 2;
		scopeCurator = 1;

		function = "macp_core_fnc_init";
		functionPriority = 1;
		isGlobal = 2;						// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 0;				// 1 for module waiting until all synced triggers are activated
		isDisposable = 1;					// 1 if modules is to be disabled once it is activated (i.e. repeated trigger activation will not work)
		is3DEN = 0;							// 1 to run init function in Eden Editor as well

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
	class macp_restrictPersonalVault : Module_F
	{
		author = "Mallen";
		category = "macp_standardCategory";
		displayName = "MACP - Restrict Personal Vault";
		scope = 2;
		scopeCurator = 2;

		function = "macp_core_fnc_restrictPersonalVaultModule";
		functionPriority = 1;
		isGlobal = 2;						// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;				// 1 for module waiting until all synced triggers are activated
		isDisposable = 1;					// 1 if modules is to be disabled once it is activated (i.e. repeated trigger activation will not work)
		is3DEN = 0;							// 1 to run init function in Eden Editor as well

		canSetArea = 1;						// Allows for setting the area values in the Attributes menu in 3DEN
		canSetAreaShape = 1;				// Allows for setting "Rectangle" or "Ellipse" in Attributes menu in 3DEN
		canSetAreaHeight = 1;				// Allows for setting height or Z value in Attributes menu in 3DEN
		class AttributeValues
		{
			// This section allows you to set the default values for the attributes menu in 3DEN
			size3[] = { 100, 100, 100 };		// 3D size (x-axis radius, y-axis radius, z-axis radius)
			isRectangle = 0;				// Sets if the default shape should be a rectangle or ellipse
		};
	};
};
