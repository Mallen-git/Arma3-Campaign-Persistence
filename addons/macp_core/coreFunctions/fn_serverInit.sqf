/*
	Author: Mallen

	Description:
		Starts up server services etc as needed

	Parameter(s):
		0: MODULE - The module containing the raw campaign data

	Returns:
		None

	Examples:
		[_module] call macp_core_fnc_serverInit;
*/
params [
	["_logic", objNull, [objNull]]
];

//only run on server
if (not isServer) exitWith {};

//get all campaign data saved on server
_allCampaignData = profileNamespace getVariable ["macp_serverAllCampaignData", createHashMap];

//get the raw campaign data assigned to variable
_rawCampaignData = _logic getVariable ["macp_campaignData", "NOCAMPAIGNSFOUNDRIP"];

//if no campaign data found throw error and tell clients not to continue init
if (_rawCampaignData isEqualTo "NOCAMPAIGNSFOUNDRIP") exitWith {diag_log (text "MACP - ERROR: No raw campaign data found, persistance is not active");};

macp_currentCampaignDataServer = _rawCampaignData;

[[macp_currentCampaignDataServer], macp_core_fnc_clientInit] remoteExec ["call", 0, true];

//check if we have the current key already saved on the server
_key = macp_currentCampaignDataServer get "key";
_autosavedCampaignData = _allCampaignData getOrDefault [_key, macp_currentCampaignDataServer];

//if it is, save it as a backup incase data was lost on client and this is a recovery effort
if (_autosavedCampaignData isNotEqualTo macp_currentCampaignDataServer) then
{
	_allCampaignData set [(_key + ".backup"), _autosavedCampaignData];
};

_allCampaignData set [_key, macp_currentCampaignDataServer];

macp_personalVaultLists = createHashMap;

//when mission is ended make sure all data is saved and distributed to clients
addMissionEventHandler ["Ended", {
	call macp_core_fnc_saveAllKitsAndVaults;
}];

//when a player disconnects create a snapshot of their loadout
addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	[_uid, _unit] call macp_core_fnc_saveToCurrentInventory;
	[_uid, "DISCONNECT", _unit] call macp_core_fnc_saveToPreviousInventorys;
	false;
}];

//autosave after 5 seconds of grace at mission start (so we dont accidentally save the editor kit)
[{
	[{
		call macp_core_fnc_saveAllKitsAndVaults;
	}, macp_autoSaveTime] call CBA_fnc_addPerFrameHandler;
}, [], 4.2649] call CBA_fnc_waitAndExecute;

//if player is server then autosave isnt needed, simply link the data correctly and go from there
if (hasInterface) then
{
	_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
	_allCampaignData set [_key, macp_currentCampaignDataServer];
	saveProfileNamespace;
};

//when an admin logs in or logs out tell them to either show or hide the admin menu
addMissionEventHandler ["OnUserAdminStateChanged", {
	params ["_networkId", "_loggedIn", "_votedIn"];
	_userInfo = getUserInfo _networkId;
	_machineNetworkID = _userInfo select 1;
	if (_loggedIn) then
	{
		[[], macp_core_fnc_showAdminMenu] remoteExec ["call", _machineNetworkID];
	} else {
		[[], macp_core_fnc_hideAdminMenu] remoteExec ["call", _machineNetworkID];
	};
}];

