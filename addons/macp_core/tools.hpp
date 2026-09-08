class display3DEN
{
	class Controls
	{
		class MenuStrip : ctrlMenuStrip
		{
			class Items
			{
				class Tools
				{
					items[] += { "macp_campaignManagerTool" }; // += must be used; you want to expand the array, not override it!
				};

				class macp_campaignManagerTool
				{
					text = "MACP Campaign Manager"; // Item text
					picture = ""; // Item picture
					action = "[] call macp_core_fnc_openCampaignManager;"; // Expression called upon clicking; ideally, it should call your custom function
					opensNewWindow = 1;// Adds '...' to the name of the menu entry, indicating the user that a new window will be opened.
				};
			};
		};
	};
};
