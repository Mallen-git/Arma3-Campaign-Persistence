params [
	["_logic", objNull, [objNull]]
];

if (isServer) then {
	_allCampaignData = profileNamespace getVariable ["macp_serverAllCampaignData", createHashMap];

	_rawCampaignData = _logic getVariable ["macp_campaignData", "NONEFOUND"];

	if (_rawCampaignData isEqualTo "NONEFOUND") exitWith {diag_log (text "MACP - ERROR: No raw campaign data found, persistance is not active")};

	//campaign data format:
	/*
		"key" - String
		"players" - Hashmap
			playerUID - Hashmap
				"lastUsedName" - String
				"currentInventory" - Loadout Array
				"previousInventorys" - Hashmap
					dateTime - Loadout Array
				"personalVault" - Array
		"defaultKit" - Loadout Array
	*/

	//key identifys a hashmap, value identifys if hashmap values are also hashmaps
	_hashmapIdentifiers = createHashMapFromArray [["players", true], ["previousInventorys", false]];

	//load and validate data
	//array should have been validated at edeneditor save, this is a safe operation
	_arraydCampaignData = parseSimpleArray _rawCampaignData;

	_currentCampaignData = createHashMapFromArray _arraydCampaignData;

	[_hashmapIdentifiers, _currentCampaignData, false] call macp_core_fnc_investigateHashmap;

	macp_currentCampaignData = _currentCampaignData;

	_key = macp_currentCampaignData get "key";
	_autosavedCampaignData = _allCampaignData getOrDefault [_key, macp_currentCampaignData];

	if (_autosavedCampaignData isNotEqualTo macp_currentCampaignData) then
	{
		_allCampaignData set [(_key + ".backup"), _autosavedCampaignData];
	};

	_allCampaignData set [_key, macp_currentCampaignData];

	macp_personalVaultLists = createHashMap;

	addMissionEventHandler ["Ended", {
		call macp_core_fnc_saveAllKitsAndVaults;
		publicVariable "macp_currentCampaignData";
	}];

	addMissionEventHandler ["HandleDisconnect", {
		params ["_unit", "_id", "_uid", "_name"];
		[_uid, _unit] call macp_core_fnc_saveToCurrentInventory;
		[_uid, "DISCONNECT", _unit] call macp_core_fnc_saveToPreviousInventorys;
		false;
	}];

	//autosave every 30s after 5 seconds of grace at mission start (so we don't accidentally save the editor kit)
	[{
		[{
			call macp_core_fnc_saveAllKitsAndVaults;
			publicVariable "macp_currentCampaignData";
			saveProfileNamespace;
		}, 30] call CBA_fnc_addPerFrameHandler;
	}, [], 4.2649] call CBA_fnc_waitAndExecute;

	//if player is server then autosave isn't needed, simply link the data correctly and go from there
	if (hasInterface) then
	{
		_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
		_allCampaignData set [_key, macp_currentCampaignData];
		saveProfileNamespace;
	};
};

//if not the server don't need to pickup loadouts
if (not hasInterface) exitWith {};

mcap_initialRespawn = false;

//create player profile if it doesn't exist
[[getPlayerUID player], macp_core_fnc_createPlayerProfile] remoteExec ['call', 2];

//request server to give me loadout i should have
[[getPlayerUID player], macp_core_fnc_provideCurrentLoadout] remoteExec ['call', 2];

//init personal vault
[[getPlayerUID player], macp_core_fnc_initPersonalVault] remoteExec ['call', 2];

//add ace interaction to open Personal Vault
_condition =
{
	_result = false;
	if (isNil "macp_restrictPersonalVaultAreas") then
	{
		_result = true;
	} else {
		{
			_area = _x getVariable ["objectArea",[0,0,0,false,0]];
			//x,y,rot,whether its a rectangle,z

			_areaPos = getPosASL _x;
			_areaPos = ASLToAGL _areaPos;

			_playerPos = getPosASL _player;
			_playerPos = ASLToAGL _playerPos;
			_arguments = [_areaPos];
			_arguments append _area;
			if (_playerPos inArea _arguments) then
			{
				_result = true;
			}
		} forEach macp_restrictPersonalVaultAreas;
	};
  ([_player, _target, []] call ace_common_fnc_canInteractWith) and (isNull objectParent _player) and (_result)
};
_statement =
{
  [[getPlayerUID player], macp_core_fnc_accessPersonalVault] remoteExec ['call', 2];
};
_action = ["openPersonalVault", "Open Personal Vault", "\a3\ui_f\data\igui\cfg\simpletasks\types\Container_ca.paa", _statement, _condition] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

//set kit to default on respawn
player addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];
	if (mcap_initialRespawn) then
	{
		mcap_initialRespawn = false;
		[[getPlayerUID player], macp_core_fnc_provideCurrentLoadout] remoteExec ['call', 2];
	} else {
		[[getPlayerUID player], macp_core_fnc_provideDefaultLoadout] remoteExec ['call', 2];
	};
}];

//save kit to previous inventorys when killed
player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects", "_shot", "_real"];
	if (time > 2) then
	{
		[{
			params ["_unit"];
			[[getPlayerUID player, "DEATH", _unit], macp_core_fnc_saveToPreviousInventorys] remoteExec ['call', 2];
		}, [_unit], 0.1] call CBA_fnc_waitAndExecute;
	} else {
		mcap_initialRespawn = true;
	};
}];

"macp_currentCampaignData" addPublicVariableEventHandler {
	_value = _this select 1;

	//if player is admin save the data, it is presumed data will always want to be saved if you're the admin
	_admin = call BIS_fnc_admin;
	if (_admin isEqualTo 0) exitWith {};

	_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
	_key = _value get "key";
	_allCampaignData set [_key, _value];
	saveProfileNamespace;
};
