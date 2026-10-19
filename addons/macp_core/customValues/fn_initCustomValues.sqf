/*
	Author: Mallen

	Description:
		Gets the values required and sorts them into an easy list for client to create actions from

	Parameter(s):
		0: STRING - UID of player requesting

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_initCustomValues;
*/

params [["_requestedUID", "NOTSUPPLIED", [""]]];

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_initCustomValues ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested custom values init with no supplied UID")};

//get the unit we are setting custom values for
_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

//need a unit to set custom values for
if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested custom values init with UID that does not point to a unit")};

//get players profile
_rootCustomValues = macp_currentCampaignDataServer get "players" get _requestedUID get "customValues";

//track seperatly so folders can be created before values
_valuesToCreate = [];
_foldersToCreate = [];

{
	//check if hashmap has a displayformat, if it doesn't its a folder
	_displayFormatChecker = _y getOrDefault ["displayFormat", "NONEFOUND"];

	//to make sure things are unique to mod
	_actionName = ("macp_customValue_" + _x);

	if (_displayFormatChecker isEqualTo "NONEFOUND") then
	{
		//this is a folder
		_foldersToCreate pushBack [_x, "FOLDER", [_actionName]];
	} else {
		//value found
		_visible = _y get "valueVisible";
		_transferable = _y get "valueTransferable";
		_parentFolder = _y get "valueParentFolder";

		_valuesToCreate pushBack [_x, "VALUE", [_actionName, _visible, _transferable, _displayFormatChecker, _parentFolder]];
	};
} forEach _rootCustomValues;

//make sure folders are before values
_foldersToCreate append _valuesToCreate;

//send to client to create
[[_foldersToCreate], macp_core_fnc_receiveCustomValues] remoteExec ["call", _requestedUIDUnit];

