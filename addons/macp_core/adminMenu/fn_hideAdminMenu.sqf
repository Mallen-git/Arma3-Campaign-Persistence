/*
	Author: Mallen

	Description:
		Deletes the admin menu links in the map and in zues interact

	Parameter(s):
		None

	Returns:
		None

	Examples:
		call macp_core_fnc_hideAdminMenu;
*/

if (player diarySubjectExists "macp_adminMenu") then
{
	player removeDiarySubject "macp_adminMenu";
	[["ACE_ZeusActions", "macp_openAdminMenu"]] call ace_interact_menu_fnc_removeActionFromZeus;
};


