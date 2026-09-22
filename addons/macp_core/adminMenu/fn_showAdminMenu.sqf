/*
	Author: Mallen

	Description:
		Creates the admin menu links in the map and in zues interact

	Parameter(s):
		None

	Returns:
		None

	Examples:
		call macp_core_fnc_showAdminMenu;
*/

if (player diarySubjectExists "macp_adminMenu") exitWith {};

player createDiarySubject ["macp_adminMenu", "MACP - Admin Menu"];
player createDiaryRecord ["macp_adminMenu", ["Admin Menu Link", "Click <execute expression='[] call macp_core_fnc_openAdminMenu;'>HERE</execute> to access admin menu!"]];

_statement = {
  [] call macp_core_fnc_openAdminMenu;
};
_action = ["macp_openAdminMenu", "MACP - Admin Menu", "", _statement, {true}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;
