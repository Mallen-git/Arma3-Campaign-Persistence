/*
	Author: Mallen

	Description:
		Sends the requesting remotexec the latest campaign data

	Parameter(s):
		0: BOOLEAN - Whether the data should be saved to profilespace or not on return

	Returns:
		None

	Examples:
		[false] call macp_core_fnc_askForUpdatedData;
*/
params [["_commitData", false, [false]]];

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_askForUpdatedData ran on client, not server")};

if (not isRemoteExecuted) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_askForUpdatedData was not remote executed, what is the point?")};

[[macp_currentCampaignDataServer, _commitData], macp_core_fnc_recieveUpdatedData] remoteExec ["call", remoteExecutedOwner];
