/*
	Author: Mallen

	Description:
		looks at campaign data and checks the version, if it needs to be updated do so via child scripts

	Parameter(s):
		0: HASHMAP - (Optional, default is all campaign data stored) Hashmap of campaign data

	Returns:
		None

	Examples:
		[_hashmap] call macp_core_fnc_checkAndUpgradeSave;
*/
params[["_saveFile", "NONEPROVIDED", [createHashMap]]];

//check whether savefile is empty, if yes get all save files
_workingSaves = createHashMapFromArray [["default", _saveFile]];
if (_saveFile isEqualTo "NONEPROVIDED") then
{
	_workingSaves = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
};

{
	_workingSave = _y;
	_currentVersion = _workingSave getOrDefault ["ver", "NONEFOUND"];

	//no save version found? get outta here
	if (_currentVersion isEqualTo "NONEFOUND") exitWith {diag_log (text "MACP - ERROR: Save file upgrade requested but save file has no version")};

	_currentSaveFileVersion = [1,3,0];

	//the hashmap is up to date, we can leave
	if (_currentVersion isEqualTo _currentSaveFileVersion) exitWith {};

	//if array is the wrong size thats an issue
	if ((count _currentSaveFileVersion) isNotEqualTo (count _currentVersion)) exitWith {diag_log (text "MACP - ERROR: Save file upgrade requested but save files version has too many elements")};

	//make sure everything in the array is a number
	_notInts = false;
	{
		if (typeName _x isNotEqualTo "SCALAR") then
		{
			_notInts = true;
			break;
		};
	} forEach _currentVersion;

	if (_notInts) exitWith {diag_log (text "MACP - ERROR: Save file upgrade requested but save files version does not contain only numbers")};

	//check if the version is actually higher than the current mod version
	_tooNew = false;
	_foundBig = false;

	{
		if ((_x > (_currentSaveFileVersion select _forEachIndex)) and (not _foundBig)) then
		{
			_tooNew = true;
			break;
		};
		if (_x < (_currentSaveFileVersion select _forEachIndex)) then
		{
			_foundBig = true;
		};
	} forEach _currentVersion;

	if (_tooNew) exitWith {diag_log (text "MACP - ERROR: Save file upgrade requested but save files version is newer than the current mod version")};

	//error checking done, lets do this

	if (_currentVersion isEqualTo [1,0,1]) then {_currentVersion = [1,3,0]; [_workingSave] call macp_core_fnc_upgrade101To130;};
	_changedVersion = _workingSave get "ver";
	if (_currentVersion isNotEqualTo _changedVersion) exitWith {diag_log (text "MACP - ERROR: Save file upgrade failed, could not upgrade 1.0.1 to 1.3.0")};

} forEach _workingSaves;
