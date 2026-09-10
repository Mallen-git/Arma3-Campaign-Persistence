/*
	Author: Mallen

	Description:
		Opens campaign management tool and starts needed EHs

	Parameter(s):
		0: ARRAY - (Optional, default []) Change where the campaign manager opens to, by default home directory

	Returns:
		None

	Examples:
		[] call macp_core_fnc_openCampaignManager;
*/

params [["_customFilePath", objNull, [[]]]];

_display = (findDisplay 313) createDisplay "macp_campaignManagerToolDialog";

if (_customFilePath isNotEqualTo objNull) then
{
	_display setVariable ['macp_filePath', _customFilePath];
};

[_display] call macp_core_fnc_updateFileBrowser;
