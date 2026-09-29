/*
	Author: Mallen

	Description:
		Sends the requesting remotexec the latest campaign data

	Parameter(s):
		0: HASHMAP - All current campaign data
		1: BOOLEAN - Whether the data should be saved to profilespace or not

	Returns:
		None

	Examples:
		[macp_currentCampaignDataServer, true] call macp_core_fnc_askForUpdatedData;
*/
params [["_recievedData", "NOTSUPPLIED", [createHashMap]], ["_commitData", false, [false]]];

//always on server
if (not hasInterface) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_askForUpdatedData ran on server, not client")};

if (_recievedData isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Tried to recieve updated data but no data was supplied")};

//save data to global variable on local
macp_currentCampaignDataClient = _recievedData;

//should data be commited to disk?
if (_commitData) then
{
	_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
	_key = _recievedData get "key";
	_allCampaignData set [_key, _recievedData];
	saveProfileNamespace;
};

//tell anything waiting on updated data that it has been recieved
["macp_recievedUpdatedData", []] call CBA_fnc_localEvent;
