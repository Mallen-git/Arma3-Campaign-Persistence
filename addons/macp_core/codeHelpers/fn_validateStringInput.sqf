/*
	Author: Mallen

	Description:
		Validates the string provided is correctly formatted campaign data

	Parameter(s):
		0: STRING - The string to validate

	Returns:
		Output Hashmap OR error string

	Examples:
		[_input] call macp_core_fnc_validateStringInput;
*/
params[["_input", "", [""]]];


_correctDataChecking = createHashMapFromArray [
	["key", ["STRING"]],
	["players", ["HASHMAP"]],
	["ver", ["ARRAY", 3, "SCALAR"]],
	["defaultKit", ["ARRAY", 10, "KIT"]],
	["previousInventorys", ["HASHMAP"]],
	["previousInventory", ["ARRAY", 10, "KIT"]],
	["storageReason", ["STRING"]],
	["currentInventory", ["ARRAY", 10, "KIT"]],
	["lastUsedName", ["STRING"]],
	["personalVault", ["ARRAY", 4, "VAULT"]]
];

_correctDataLocation = createHashMapFromArray [
	["root", ["key", "players", "ver", "defaultKit"]],
	["players", ["ALLHASHMAPS", "playerProfile"]],
	["playerProfile", ["previousInventorys", "currentInventory", "lastUsedName", "personalVault"]],
	["previousInventorys", ["ALLHASHMAPS", "prevInv"]],
	["prevInv", ["previousInventory", "storageReason"]]
];


_characters = _input splitString "";

_firstBracketHit = false;
_bracketBudget = 1;
_inString = false;
_inNumber = false;
_expectingItem = true;
_expectingComma = false;
_previousUsefulCharacter = "[";

_errorFound = "None";

{
	if (_x isEqualTo " ") then {continue;};
	_previousUsefulCharacterUsing = _previousUsefulCharacter;
	_previousUsefulCharacter = _x;

	if (_bracketBudget <= 0) then
	{
		_errorFound = "Input closes more brackets than it has opened at character " + str(_forEachIndex + 1);
		break;
	};

	if (not _firstBracketHit) then
	{
		if (_x isEqualTo "[") then
		{
			_firstBracketHit = true;
			continue;
		};
		if (_x isEqualTo " ") then
		{
			continue;
		};
		_errorFound = "Input does not start with an open square bracket";
		break;
	};

	//check if we're in a string, if we are we don't care whats in here
	if (_inString) then
	{
		if (_x isEqualTo '"') then
		{
			_inString = false;
			_expectingComma = true;
			continue;
		} else {
			continue;
		};
	};

	if (_inNumber) then
	{
		if (_x in ["0","1","2","3","4","5","6","7","8","9"]) then
		{
			continue;
		} else {
			_inNumber = false;
			_expectingComma = true;
			_expectingItem = false;
		};
	};


	if (_expectingComma) then
	{
		if (_x isEqualTo "]") then
		{
			_bracketBudget = _bracketBudget - 1;
			continue;
		};
		if (_x isEqualTo ",") then
		{
			_expectingComma = false;
			_expectingItem = true;
			continue;
		};
		_errorFound = "Comma or closed square bracket expected at character " + str(_forEachIndex + 1) + ", found """ + _x + """ instead";
		break;
	};

	if (_expectingItem) then
	{
		if (_x isEqualTo "[") then
		{
			_bracketBudget = _bracketBudget + 1;
			continue;
		};
		if ((_x isEqualTo "]") and (_previousUsefulCharacterUsing isEqualTo "[")) then
		{
			_bracketBudget = _bracketBudget - 1;
			_expectingComma = true;
			_expectingItem = false;
			continue;
		};
		if (_x isEqualTo '"') then
		{
			_expectingComma = false;
			_expectingItem = false;
			_inString = true;
			continue;
		};
		if (_x in ["0","1","2","3","4","5","6","7","8","9"]) then
		{
			_inNumber = true;
			continue;
		};
		_errorFound = "Array, String, or Number expected at character " + str(_forEachIndex + 1) + ", found """ + _x + """ instead";
		break;
	};
} forEach _characters;
if (_errorFound isEqualTo "None") then
{
	if (_bracketBudget > 0) then
	{
		_errorFound = "Input has unclosed brackets at last character";
	};
	if (_bracketBudget < 0) then
	{
		_errorFound = "Input closes more brackets than it has opened at last character";
	};
};

if (_errorFound isNotEqualTo "None") exitWith {_errorFound;};

//string found is good, put it into an array
_workingArray = parseSimpleArray _input;

_hashmapIdentifiers = createHashMapFromArray [["players", true], ["previousInventorys", false]];
if (not ([_workingArray] call macp_core_fnc_validateHashmap)) exitWith {"Input data is not in the form of a hashmap";};
_workingHashMap = createHashMapFromArray _workingArray;

[_hashmapIdentifiers, _workingHashMap, false] call macp_core_fnc_investigateHashmap;

macp_globalErrorCode = "";

_checkHashCorrect = {
	params["_checkHashCorrect", "_correctDataChecking", "_correctDataLocation", "_currentHashmap", "_levelName"];

	test = _this;
	_expectedItems = _correctDataLocation get _levelName;

	_wildcardHashmap = false;
	if ((_expectedItems select 0) isEqualTo "ALLHASHMAPS") then
	{
		_wildcardHashmap = true;
	};

	{
		if (_wildcardHashmap) then
		{
			_workingLevelName = _expectedItems select 1;
			if ((typeName _y) isNotEqualTo "HASHMAP") exitWith {macp_globalErrorCode = ('"' + _x + '" should be a hashmap, it is actually a ' + (typeName _y));true;};
			_result = [_checkHashCorrect, _correctDataChecking, _correctDataLocation, _y, _workingLevelName] call _checkHashCorrect;
			if (_result) exitWith {true;};
		};

		if (not (_x in _expectedItems)) exitWith {macp_globalErrorCode = ('"' + _x + '" should not be in hashmap ' + _levelName);true;};

		_expectedItems deleteAt (_expectedItems find _x);

		_keyDataType = _correctDataChecking getOrDefault [_x, "NONEFOUND"];
		if (_keyDataType isEqualTo "NONEFOUND") exitWith {macp_globalErrorCode = ('cannot find the correct data type for "' + _x + '"');true;};

		_typeName = _keyDataType select 0;
		if ((typeName _y) isNotEqualTo _typeName) exitWith {macp_globalErrorCode = ('"' + _x + '" should be a ' + _typeName + ', it is actually a ' + (typeName _y));true;};

		switch (_typeName) do
		{
			case "HASHMAP": {
				_result = [_checkHashCorrect, _correctDataChecking, _correctDataLocation, _y, _x] call _checkHashCorrect;
				if (_result) exitWith {true;};
			};
			case "STRING": {};
			case "ARRAY": {
				_size = _keyDataType select 1;
				if ((count _y) isNotEqualTo _size) exitWith {macp_globalErrorCode = ('"' + _x + '" should be an array with size' + str(_size) + ' it is actually size ' + str(count _y));true;};
			};
			default {if (true) exitWith {macp_globalErrorCode = ('"' + _x + '" is not a Hashmap, String, or Array, it should be one of these');true;};};
		};
	} forEach _currentHashmap;

	if (not _wildcardHashmap) then
	{
		if (count _expectedItems isNotEqualTo 0) exitWith {macp_globalErrorCode = ('Hashmap "' + _levelName + '" is missing keys: ' + str(_expectedItems));true;};
	};

	false;
};

_result = [_checkHashCorrect, _correctDataChecking, _correctDataLocation, _workingHashMap, "root"] call _checkHashCorrect;
if (_result) exitWith {macp_globalErrorCode;};

macp_globalErrorCode = nil;
_workingHashMap;
