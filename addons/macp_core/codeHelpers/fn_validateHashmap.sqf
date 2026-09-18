/*
	Author: Mallen

	Description:
		Check if array provided can be a valid hashmap or not

	Parameter(s):
		0: ARRAY - The array to check if it can be a hashmap

	Returns:
		Boolean

	Examples:
		[_array] call macp_core_fnc_validateHashmap;
*/
params[["_input", [], [[]]]];

_validArray = true;

{
	if (typeName _x isNotEqualTo "ARRAY") then
	{
		_validArray = false;
		break;
	};
	_count = count _x;
	if (_count isNotEqualTo 2) then
	{
		_validArray = false;
		break;
	};
} forEach _input;

_validArray;
