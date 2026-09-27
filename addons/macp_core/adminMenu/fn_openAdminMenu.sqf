/*
	Author: Mallen

	Description:
		opens the admin menu

	Parameter(s):
		None

	Returns:
		None

	Examples:
		call macp_core_fnc_openAdminMenu;
*/

//close map so we're back on the main display
if (visibleMap) then {openMap false;};

//open menu as dialog to force controls on it
createDialog ["macp_adminMenu", true];
