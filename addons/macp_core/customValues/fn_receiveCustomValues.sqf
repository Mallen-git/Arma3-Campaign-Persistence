/*
	Author: Mallen

	Description:
		creates actions from the list provided for custom values

	Parameter(s):
		0: ARRAY - a list of all actions to be created

	Returns:
		None

	Examples:
		[_actionsToCreate] call macp_core_fnc_receiveCustomValues;
*/
params [["_actionsToCreate", [], [[]]]];

//only on client
if (not hasInterface) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_clientToldToOpenPersonalVault ran on server, not client")};

//if no actions just leave
if (_actionsToCreate isEqualTo []) exitWith {};

//used to link folder hashmap names to their action names
_folderLookup = createHashMap;

{
	_x params ["_displayName", "_actionType", "_params"];

	if (_actionType isEqualTo "FOLDER") then
	{
		//folder
		_params params ["_actionName"];
		//set folder lookup entry for any values
		_folderLookup set [_displayName, ["ACE_SelfActions", _actionName]];

		//create empty action to act as a fodler for further actions
		_action = [_actionName, _displayName, "", {}, {true;}] call ace_interact_menu_fnc_createAction;
		[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
	} else {
		_params params ["_actionName", "_visible", "_transferable", "_displayFormatChecker", "_parentFolder", "_value"];
		//get action parent, if none put it in root
		_parentFolder = _folderLookup getOrDefault [_parentFolder, ["ACE_SelfActions"]];

		//if not visible lets exit this action
		if (not _visible) then {continue;};

		_action = [_actionName, "?", "", {}, {true}, {}, [_displayName, _displayFormatChecker], [0,0,0], 2, [false,false,false,false,false],{
			params ["_target", "_player", "_params", "_actionData"];
			_params params ["_displayName", "_displayFormatChecker"];

			//get current value as of clients knowledge
			_value = macp_currentCampaignDataClient get "players" get (getPlayerUID player) get "customValues" get _displayName get "value";
			//this should be updated in tandem to server knowledge from anyone modifying the data, recieveing the data in the function is simply too network intensive

			_actualDisplayName = format [_displayFormatChecker, _value];

			// Modify the action - index 1 is the display name, 2 is the icon...
			_actionData set [1, _actualDisplayName];
		}] call ace_interact_menu_fnc_createAction;
		[player, 1, _parentFolder, _action] call ace_interact_menu_fnc_addActionToObject;
	};
} forEach _actionsToCreate;

//find a way to put transferable values onto other players
