/*
	Author: Mallen

	Description:
		Check the string is a valid array of strings (UIDs may not be valid, not my problem)

	Parameter(s):
		0: STRING - The value provided by the player

	Returns:
		Boolean

	Examples:
		[_value] call macp_core_fnc_validUIDArray;
*/

params[["_input", "", [""]]];

//regex my beloved
_input regexMatch '^\s*\[\s*(?:"[^"]*"\s*(?:,\s*"[^"]*"\s*)*)?\]\s*$';
