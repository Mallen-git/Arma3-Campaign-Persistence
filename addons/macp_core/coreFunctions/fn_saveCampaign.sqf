/*
	Author: Mallen

	Description:
		Saves the campaign to profile namespace

	Parameter(s):
		0: STRING - (Optional, default current key) the key to save the campaign to

	Returns:
		None

	Examples:
		["customKey"] call macp_core_fnc_saveCampaign;
*/

params [["_providedKey", "NOTSUPPLIED", [""]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_saveCampaign ran on client, not server")};

_currentKey = missionNamespace getVariable ["macp_campaignKey", "MACPDEFAULT"];

if (_providedKey isNotEqualTo "NOTSUPPLIED") then
{
	_currentKey = _providedKey;
};

if (isNil "macp_currentCampaignData") exitWith {diag_log (text "MACP - ERROR: Tried to save campaign data but no current campaign was found")};

_allCampaignData = profileNamespace getVariable ["macp_allCampaignData", createHashMap];

_allCampaignData set [_currentKey, macp_currentCampaignData];

profileNamespace setVariable ["macp_allCampaignData", _allCampaignData];
saveProfileNamespace;

