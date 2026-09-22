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

createDialog ["macp_adminMenu", true];
