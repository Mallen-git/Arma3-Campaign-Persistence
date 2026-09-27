params [
	["_logic", objNull, [objNull]]
];

//only run on server
if (isServer) then {
	//get all campaign data saved on server
	_allCampaignData = profileNamespace getVariable ["macp_serverAllCampaignData", createHashMap];

	//get the raw campaign data assigned to variable
	_rawCampaignData = _logic getVariable ["macp_campaignData", "NOCAMPAIGNSFOUNDRIP"];

	//if no campaign data found throw error and tell clients not to continue init
	if (_rawCampaignData isEqualTo "NOCAMPAIGNSFOUNDRIP") exitWith
	{
		diag_log (text "MACP - ERROR: No raw campaign data found, persistance is not active");
		macp_failedInit = true;
		publicVariable "macp_failedInit";
	};

	//we have data, tell clients to continue init as requested
	macp_failedInit = false;
	publicVariable "macp_failedInit";

	macp_currentCampaignData = _rawCampaignData;

	//check if we have the current key already saved on the server
	_key = macp_currentCampaignData get "key";
	_autosavedCampaignData = _allCampaignData getOrDefault [_key, macp_currentCampaignData];

	//if it is, save it as a backup incase data was lost on client and this is a recovery effort
	if (_autosavedCampaignData isNotEqualTo macp_currentCampaignData) then
	{
		_allCampaignData set [(_key + ".backup"), _autosavedCampaignData];
	};

	_allCampaignData set [_key, macp_currentCampaignData];

	macp_personalVaultLists = createHashMap;

	//when mission is ended make sure all data is saved and distributed to clients
	addMissionEventHandler ["Ended", {
		call macp_core_fnc_saveAllKitsAndVaults;
		publicVariable "macp_currentCampaignData";
	}];

	//when a player disconnects create a snapshot of their loadout
	addMissionEventHandler ["HandleDisconnect", {
		params ["_unit", "_id", "_uid", "_name"];
		[_uid, _unit] call macp_core_fnc_saveToCurrentInventory;
		[_uid, "DISCONNECT", _unit] call macp_core_fnc_saveToPreviousInventorys;
		false;
	}];

	//autosave after 5 seconds of grace at mission start (so we don't accidentally save the editor kit)
	[{
		[{
			call macp_core_fnc_saveAllKitsAndVaults;
			publicVariable "macp_currentCampaignData";
			saveProfileNamespace;
		}, macp_autoSaveTime] call CBA_fnc_addPerFrameHandler;
	}, [], 4.2649] call CBA_fnc_waitAndExecute;

	//if player is server then autosave isn't needed, simply link the data correctly and go from there
	if (hasInterface) then
	{
		_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
		_allCampaignData set [_key, macp_currentCampaignData];
		saveProfileNamespace;
	};

	//when an admin logs in or logs out tell them to either show or hide the admin menu
	addMissionEventHandler ["OnUserAdminStateChanged", {
		params ["_networkId", "_loggedIn", "_votedIn"];
		_userInfo = getUserInfo _networkId;
		_machineNetworkID = _userInfo select 1;
		if (_loggedIn) then
		{
			[[], macp_core_fnc_showAdminMenu] remoteExec ['call', _machineNetworkID];
		} else {
			[[], macp_core_fnc_hideAdminMenu] remoteExec ['call', _machineNetworkID];
		};
	}];
};

//if not a dedi server don't need to pickup loadouts
if (not hasInterface) exitWith {};

[{
	//wait until we get response from server before init
	not (isNil "macp_failedInit");
}, {
	//we failed init on server, abandon init
	if (macp_failedInit) exitWith {diag_log (text "MACP - ERROR: No raw campaign data found, persistance is not active");};

	//used to check if player is respawning on start (don't give default kit)
	mcap_initialRespawn = false;

	//create player profile if it doesn't exist
	[[getPlayerUID player], macp_core_fnc_createPlayerProfile] remoteExec ['call', 2];

	//request server to give me loadout i should have
	[[getPlayerUID player], macp_core_fnc_provideCurrentLoadout] remoteExec ['call', 2];

	//init personal vault
	[[getPlayerUID player], macp_core_fnc_initPersonalVault] remoteExec ['call', 2];

	//if admin, show admin menu
	if (((call BIS_fnc_admin) > 0) or isServer) then
	{
		[] call macp_core_fnc_showAdminMenu;
	};

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
			if (macp_defaultKit) then
			{
				[[getPlayerUID player], macp_core_fnc_provideDefaultLoadout] remoteExec ['call', 2];
			};
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

	//whenever server sends us an updated campaign data decide what to do with it
	"macp_currentCampaignData" addPublicVariableEventHandler {
		_value = _this select 1;
		_saveValue = false;

		//depending on CBA settings choice either save or don't save
		switch (macp_saveChoice) do
		{
			//only admin
			case 1: {_saveValue = ((call BIS_fnc_admin) > 0);};

			//admin and UIDs
			case 2: {
				_saveValue = ((call BIS_fnc_admin) > 0);
				if ([macp_saveUIDs] call macp_core_fnc_validUIDArray) then
				{
					_array = parseSimpleArray macp_saveUIDs;
					if ((getPlayerUID player) in _array) then
					{
						_saveValue = true;
					};
				};
			};

			//Everyone
			case 3: {_saveValue = true;};

			//also only admin
			default {_saveValue = ((call BIS_fnc_admin) > 0);};
		};

		if (not _saveValue) exitWith {};

		//save the campaign data for the next mission
		_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
		_key = _value get "key";
		_allCampaignData set [_key, _value];
		saveProfileNamespace;
	};
}, [], 10, {
	//we have somehow timed out, this means the server has not inited in 10 seconds, server must be either overloaded or crashed, shouldn't happen but is a failsafe
	diag_log (text "MACP - ERROR: Server failed to init within 10 seconds, presuming catastrophic failure");
}] call CBA_fnc_waitUntilAndExecute;
