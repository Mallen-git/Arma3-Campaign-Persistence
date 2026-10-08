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

//used to check the value of an entry is the correct type and length for arrays
_correctDataChecking = createHashMapFromArray [
	["key", ["STRING"]],
	["players", ["HASHMAP"]],
	["ver", ["ARRAY", 3, "SCALAR"]],
	["defaultKit", ["ARRAY", 10, "KIT"]],
	["defaultEngineerLevel", ["SCALAR"]],
	["defaultMedicalLevel", ["SCALAR"]],
	["defaultEODStatus", ["BOOL"]],
	["previousInventorys", ["HASHMAP"]],
	["previousInventory", ["ARRAY", 10, "KIT"]],
	["storageReason", ["STRING"]],
	["currentInventory", ["ARRAY", 10, "KIT"]],
	["lastUsedName", ["STRING"]],
	["personalVault", ["ARRAY", 4, "VAULT"]],
	["playerEngineerLevel", ["SCALAR"]],
	["playerMedicalLevel", ["SCALAR"]],
	["playerEODStatus", ["BOOL"]],
	["medicalStatus", ["STRING"]]
];

//used to make sure each hashmap has the correct items in it
_correctDataLocation = createHashMapFromArray [
	["root", ["key", "players", "ver", "defaultKit", "defaultEngineerLevel", "defaultMedicalLevel", "defaultEODStatus"]],
	["players", ["ALLHASHMAPS", "playerProfile"]],
	["playerProfile", ["previousInventorys", "currentInventory", "lastUsedName", "personalVault", "playerEngineerLevel", "playerMedicalLevel", "playerEODStatus", "medicalStatus"]],
	["previousInventorys", ["ALLHASHMAPS", "prevInv"]],
	["prevInv", ["previousInventory", "storageReason"]]
];

//used to identify which keys are full of only hashmaps regardless of name
_hashmapIdentifiers = createHashMapFromArray [
	["players", true],
	["previousInventorys", true]
];

//setup variables for string checking
_characters = _input splitString "";

_firstBracketHit = false;
_bracketBudget = 1;
_inString = false;
_inNumber = false;
_expectingItem = true;
_expectingComma = false;
_inTruth = false;
_inFalse = false;
_previousUsefulCharacter = "[";

_falsePrevCharacters = createHashMapFromArray [["a", "f"], ["l", "a"], ["s", "l"]];
_truePrevCharacters = createHashMapFromArray [["r", "t"], ["u", "r"]];

_errorFound = "None";

//iterate through input character by character, regex does not function due to recursive arrays being present and Armas regex engine not being able to handle it
{
	//if item is whitespace continue (toSimpleArray can handle this)
	if (_x isEqualTo " ") then {continue;};

	//save this character as the last one checked
	_previousUsefulCharacterUsing = _previousUsefulCharacter;
	_previousUsefulCharacter = _x;

	//if weve closed more brackets than we opened something went wrong, throw error
	if (_bracketBudget <= 0) then
	{
		_errorFound = "Input closes more brackets than it has opened at character " + str(_forEachIndex + 1);
		break;
	};

	//make sure we start with an open bracket, if we dont throw an error
	if (not _firstBracketHit) then
	{
		if (_x isEqualTo "[") then
		{
			_firstBracketHit = true;
			continue;
		};
		_errorFound = "Input does not start with an open square bracket";
		break;
	};

	//check if were in a string, if we are we don"t care whats in here
	if (_inString) then
	{
		//escape string if a double quote is found
		if (_x isEqualTo """") then
		{
			//if next character is also a doublequote this is an inline double quote, lets pretend we are awaiting the next string
			if (_characters select (_forEachIndex + 1) isEqualTo """") then
			{
				_inString = false;
				_expectingItem = true;
				continue;
			} else {
				_inString = false;
				_expectingComma = true;
				continue;
			};
		} else {
			continue;
		};
	};

	//if we are currently writing a number we can keep watching that number until it is finished by a comma
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

	//we are expecting a comma or an end bracket as the item in the array is finished
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

	//we are expecting an item in the array as a comma has just passed or an open bracket has just passed
	if (_expectingItem) then
	{
		//if its an open bracket thats fine, just increase bracket budget
		if (_x isEqualTo "[") then
		{
			_bracketBudget = _bracketBudget + 1;
			continue;
		};

		//check if its an empty array
		if ((_x isEqualTo "]") and (_previousUsefulCharacterUsing isEqualTo "[")) then
		{
			_bracketBudget = _bracketBudget - 1;
			_expectingComma = true;
			_expectingItem = false;
			continue;
		};

		//its a string, start tracking that
		if (_x isEqualTo """") then
		{
			_expectingComma = false;
			_expectingItem = false;
			_inString = true;
			continue;
		};

		//its a number, start tracking that
		if (_x in ["0","1","2","3","4","5","6","7","8","9"]) then
		{
			_inNumber = true;
			continue;
		};

		//its true, start tracking that
		if (_x isEqualTo "f") then
		{
			_expectingComma = false;
			_expectingItem = false;
			_inFalse = true;
			continue;
		};

		//its false, start tracking that
		if (_x isEqualTo "t") then
		{
			_expectingComma = false;
			_expectingItem = false;
			_inTruth = true;
			continue;
		};

		//not a string, array, or number, could fail if other variable types are used
		_errorFound = "Array, String, or Number expected at character " + str(_forEachIndex + 1) + ", found """ + _x + """ instead";
		break;
	};

	if (_inFalse) then
	{
		_shouldBeLastChar = _falsePrevCharacters getOrDefault [_x, "BAD"];
		if (_shouldBeLastChar isNotEqualTo _previousUsefulCharacterUsing) then
		{
			if (_x isNotEqualTo "e") then
			{
				_errorFound = "The text ""false"" is expected, it is mispelled at character " + str(_forEachIndex + 1);
				break;
			} else {
				_inFalse = false;
				_expectingComma = true;
			};
		};
	};

	if (_inTruth) then
	{
		_shouldBeLastChar = _truePrevCharacters getOrDefault [_x, "BAD"];
		if (_shouldBeLastChar isNotEqualTo _previousUsefulCharacterUsing) then
		{
			if (_x isNotEqualTo "e") then
			{
				_errorFound = "The text ""true"" is expected, it is mispelled at character " + str(_forEachIndex + 1);
				break;
			} else {
				_inTruth = false;
				_expectingComma = true;
			};
		};
	};
} forEach _characters;

//if no errors were found make sure every bracket has been closed exactly
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

//if error found get out of there and show user
if (_errorFound isNotEqualTo "None") exitWith {_errorFound;};

//string found is good, put it into an array
_workingArray = parseSimpleArray _input;

//check array is a valid hashmap, if yes create that hashmap
if (not ([_workingArray] call macp_core_fnc_validateHashmap)) exitWith {"Input data is not in the form of a hashmap";};
_workingHashMap = createHashMapFromArray _workingArray;

//fill out the hashmap with child hashmaps
[_hashmapIdentifiers, _workingHashMap, false] call macp_core_fnc_investigateHashmap;

//upgrade save if it is needed
[_workingHashMap] call macp_core_fnc_checkAndUpgradeSave;

//setup an error code that can be accessed anywhere in the following recursive function
macp_globalErrorCode = "";

_checkHashCorrect = {
	params["_checkHashCorrect", "_correctDataChecking", "_correctDataLocation", "_currentHashmap", "_levelName"];
	privateAll;

	//get all items expected in this hashmap
	_expectedItemsTemp = _correctDataLocation get _levelName;
	_expectedItems = +_expectedItemsTemp;

	//if all values are hashmaps set the wildcard variable to true
	_wildcardHashmap = false;
	if ((_expectedItems select 0) isEqualTo "ALLHASHMAPS") then
	{
		_wildcardHashmap = true;
	};

	_errorDetected = false;

	//for each of the current hashmap
	{
		//if all values are hashmaps
		if (_wildcardHashmap) then
		{
			//if value is not a hashmap thats an issue
			if ((typeName _y) isNotEqualTo "HASHMAP") then {macp_globalErrorCode = ("""" + _x + """ should be a hashmap, it is actually a " + (typeName _y));_errorDetected = true;break;};

			//next working level is stored in the expected items variable, grab it
			_workingLevelName = _expectedItems select 1;
			_result = [_checkHashCorrect, _correctDataChecking, _correctDataLocation, _y, _workingLevelName] call _checkHashCorrect;

			//if recursion found an error also throw an error and end early
			if (_result) then {_errorDetected = true;break;};
			continue;
		};

		//if key not in the expected items its unexpected and can be thrown
		if (not (_x in _expectedItems)) then {macp_globalErrorCode = ("""" + _x + """ should not be in hashmap " + _levelName);_errorDetected = true;break;};

		//delete key from expected items to detect if something is missing from this level
		_expectedItems deleteAt (_expectedItems find _x);

		//get the correct datatype expected for keys value, if none found throw an error
		_keyDataType = _correctDataChecking getOrDefault [_x, "NONEFOUND"];
		if (_keyDataType isEqualTo "NONEFOUND") then {macp_globalErrorCode = ("cannot find the correct data type for """ + _x + """");_errorDetected = true;break;};

		//make sure value type is as expected, or error
		_typeName = _keyDataType select 0;
		if ((typeName _y) isNotEqualTo _typeName) then {macp_globalErrorCode = ("""" + _x + """ should be a " + _typeName + ", it is actually a " + (typeName _y));_errorDetected = true;break;};

		switch (_typeName) do
		{
			//if its a hashmap do some recursion
			case "HASHMAP": {
				_result = [_checkHashCorrect, _correctDataChecking, _correctDataLocation, _y, _x] call _checkHashCorrect;
				if (_result) then {_errorDetected = true;break;};
			};

			case "STRING": {};

			case "SCALAR": {};

			case "BOOL": {};

			//if its an array make sure its size is correct, if its not this will be caught and thrown
			case "ARRAY": {
				_size = _keyDataType select 1;
				if ((count _y) isNotEqualTo _size) then {macp_globalErrorCode = ("""" + _x + """ should be an array with size" + str(_size) + " it is actually size " + str(count _y));_errorDetected = true;break;};
			};

			//if none of the above somethings wrong
			default {macp_globalErrorCode = ("""" + _x + """ is not a Hashmap, String, or Array, it should be one of these");_errorDetected = true;break;};
		};
	} forEach _currentHashmap;

	if ((not _wildcardHashmap) and (not _errorDetected)) then
	{
		//make sure all expected items have been found, if not throw an error
		if (count _expectedItems isNotEqualTo 0) exitWith {macp_globalErrorCode = ("Hashmap """ + _levelName + """ is missing keys: " + str(_expectedItems));true;};
	};

	//no errors, exit with false to signify that
	_errorDetected;
};

//check data position and value type, if theres an error output the error code
_result = [_checkHashCorrect, _correctDataChecking, _correctDataLocation, _workingHashMap, "root"] call _checkHashCorrect;

//clean up global variable that is no longer needed
_temp = macp_globalErrorCode;
macp_globalErrorCode = nil;

//if there was an error show to player
if (_result) exitWith {_temp;};

_workingHashMap;
